String formatAccountNumber(String? accountNumber) {
  if (accountNumber == null || accountNumber.isEmpty) return '';

  int length = accountNumber.length;
  if (length <= 2) return accountNumber;

  int remainingLength = length - 2;
  List<String> groups = [];

  for (int i = 0; i < remainingLength; i++) {
    if (i % 3 == 0 && i != 0) {
      groups.add(' ');
    }
    groups.add('•');
  }

  return '${groups.join()} ${accountNumber.substring(length - 2)}';
}

