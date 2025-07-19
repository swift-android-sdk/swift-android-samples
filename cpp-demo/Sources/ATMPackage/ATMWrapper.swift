import ATMWithdrawCpp

public struct ATMWrapper {
    private var underlying: ATM

    public init(initialBalance: Int32) {
        underlying = ATM(initialBalance)
    }

    public mutating func withdraw(amount: Int32) -> Bool {
        return underlying.withdraw(amount)
    }

    public func getBalance() -> Int32 {
        return underlying.getBalance()
    }
}
