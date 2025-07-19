#pragma once

class ATM {
public:
    ATM(int initialBalance);
    bool withdraw(int amount);
    int getBalance() const;
private:
    int balance;
};
