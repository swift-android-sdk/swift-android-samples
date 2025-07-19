import ATMPackage
import Foundation

print("🏧 ATM CLI 🏧")
var atm = ATMWrapper(initialBalance: 1000)
print("Current balance: \(atm.getBalance())")

for arg in CommandLine.arguments.dropFirst() {
    guard let amount = Int32(arg) else {
        fatalError("argument not a number: \(arg)")
    }
    if atm.withdraw(amount: amount) {
        print("✅ Withdrawn \(amount). New balance: \(atm.getBalance())")
    } else {
        print("❌ Insufficient funds.")
    }
}
