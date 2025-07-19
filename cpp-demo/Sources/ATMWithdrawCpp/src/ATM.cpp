#include "ATMWithdrawCpp/ATM.h"

ATM::ATM(int initialBalance) : balance(initialBalance) {}

bool ATM::withdraw(int amount) {
    if (balance >= amount) {
        balance -= amount;
        return true;
    }
    return false;
}

int ATM::getBalance() const {
    return balance;
}
