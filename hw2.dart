void main() {
  String name = "Liya";
  double balance = 100000.0;

  checkBalance(
    name: name,
    balance: balance,
  );

  print("");

  balance = deposit(
    currentBalance: balance,
    amount: 50000.0,
  );

  print("");

  balance = withdraw(
    name: name,
    currentBalance: balance,
    amount: 20000.0,
    pinCode: 1234,
  );

  print("");

  balance = withdraw(
    name: name,
    currentBalance: balance,
    amount: 2000.0,
    pinCode: 1111,
  );

  print("");

  balance = withdraw(
    name: name,
    currentBalance: balance,
    amount: 1000.0,
  );

  print("");

  balance = withdraw(
    name: name,
    currentBalance: balance,
    amount: 50000.0,
    pinCode: 1234,
  );

  print("");

  checkBalance(
    name: name,
    balance: balance,
  );
}


void checkBalance({
  required String name,
  required double balance,
}) =>
    print("$name, your current balance is: $balance USD");


double deposit({
  required double currentBalance,
  double? amount,
}) {
  double depositAmount = amount ?? 0.0;

  if (depositAmount <= 0) {
    print("Deposit failed: invalid amount");
    return currentBalance;
  }

  double newBalance = currentBalance + depositAmount;

  print("Deposit successful!");
  print("Deposited: $depositAmount USD");
  print("New balance: $newBalance USD");

  return newBalance;
}


double withdraw({
  required String name,
  required double currentBalance,
  double? amount,
  int? pinCode,
}) {
  
  int enteredPin = pinCode ?? 0000;

  if (enteredPin != 1234) {
    print("Transaction declined for $name");
    print("Error: Incorrect PIN");
    return currentBalance;
  }

  double withdrawAmount = amount ?? 0.0;

  if (withdrawAmount <= 0) {
    print("Transaction declined");
    print("Error: Invalid withdrawal amount");
    return currentBalance;
  }

  if (withdrawAmount > currentBalance) {
    print("Transaction declined");
    print("Error: Insufficient funds");
    return currentBalance;
  }

  double newBalance = currentBalance - withdrawAmount;

  print("Withdrawal successful!");
  print("Withdrawn: $withdrawAmount USD");
  print("Remaining balance: $newBalance USD");

  return newBalance;
}