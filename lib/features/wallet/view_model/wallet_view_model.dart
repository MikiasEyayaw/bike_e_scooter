class WalletViewModel {
  double balance = 250.00;

  void topUp(double amount) {
    balance += amount;
  }
}
