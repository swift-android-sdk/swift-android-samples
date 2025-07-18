/// This example provides a `installSystemCertificates()` function that will
/// locate the standard Android certificate directories and assemble all the contents into
/// a single cacerts.pem file that can be loaded by libcurl, which enables
/// `Foundation.URLSession` to load HTTPS sites.
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
#if canImport(Android)
import Android
#endif

// tell libcurl to use the auto-generated .pem file
try installSystemCertificates()

for arg in CommandLine.arguments.dropFirst() {
    do {
        let url = URL(string: arg)!
        print("Connecting to: \(url)")
        // let data = try await URLSession.shared.data(from: url) // not available on Linux/Android
        let data = try Data(contentsOf: url)
        print("Fetched \(data.count) bytes")
    } catch {
        print("Error: \(error)")
    }
}

/// Collects all the certificate files from the Android certificate store and writes them to a single `cacerts.pem` file that can be used by libcurl.
///
/// See https://android.googlesource.com/platform/frameworks/base/+/8b192b19f264a8829eac2cfaf0b73f6fc188d933%5E%21/#F0
/// See https://github.com/apple/swift-nio-ssl/blob/d1088ebe0789d9eea231b40741831f37ab654b61/Sources/NIOSSL/AndroidCABundle.swift#L30
func installSystemCertificates(fromCertficateFolders certsFolders: [String] = ["/system/etc/security/cacerts", "/apex/com.android.conscrypt/cacerts"]) throws {
    //let cacheFolder = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true) // file:////.cache/ (unwritable)
    let cacheFolder = FileManager.default.temporaryDirectory
    let generatedCacertsURL = cacheFolder.appendingPathComponent("cacerts-\(UUID().uuidString).pem")

    FileManager.default.createFile(atPath: generatedCacertsURL.path, contents: nil)
    let fs = try FileHandle(forWritingTo: generatedCacertsURL)
    defer { try? fs.close() }

    // write a header
    fs.write("""
    ## Bundle of CA Root Certificates
    ## Auto-generated on \(Date())
    ## by aggregating certificates from: \(certsFolders)
    
    """.data(using: .utf8)!)

    // Go through each folder and load each certificate file (ending with ".0"),
    // and smash them together into a single aggreagate file tha curl can load.
    // The .0 files will contain some extra metadata, but libcurl only cares about the
    // -----BEGIN CERTIFICATE----- and -----END CERTIFICATE----- sections,
    // so we can naïvely concatenate them all and libcurl will understand them.
    for certsFolder in certsFolders {
        let certsFolderURL = URL(fileURLWithPath: certsFolder)
        if (try? certsFolderURL.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) != true { continue }
        let certURLs = try FileManager.default.contentsOfDirectory(at: certsFolderURL, includingPropertiesForKeys: [.isRegularFileKey, .isReadableKey])
        for certURL in certURLs {
            // cartificate files have names like "53a1b57a.0"
            if certURL.pathExtension != "0" { continue }
            do {
                if try certURL.resourceValues(forKeys: [.isRegularFileKey]).isRegularFile == false { continue }
                if try certURL.resourceValues(forKeys: [.isReadableKey]).isReadable == false { continue }
                try fs.write(contentsOf: try Data(contentsOf: certURL))
            } catch {
                print("error reading certificate file \(certURL.path): \(error)")
                continue
            }
        }
    }


    //setenv("URLSessionCertificateAuthorityInfoFile", "INSECURE_SSL_NO_VERIFY", 1) // disables all certificate verification
    //setenv("URLSessionCertificateAuthorityInfoFile", "/system/etc/security/cacerts/", 1) // doesn't work for directories
    setenv("URLSessionCertificateAuthorityInfoFile", generatedCacertsURL.path, 1)
}
