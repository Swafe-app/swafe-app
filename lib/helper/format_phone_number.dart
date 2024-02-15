String formatPhoneNumber(String? phoneNumber) {
  if (phoneNumber == null) return '-';

  String firstDigit = phoneNumber.substring(0, 1);
  String remainingDigits = phoneNumber.substring(1);

  List<String> parts = [firstDigit];
  for (int i = 0; i < remainingDigits.length; i += 2) {
    String part = i + 2 <= remainingDigits.length ? remainingDigits.substring(i, i + 2) : remainingDigits.substring(i);
    parts.add(part);
  }

  return parts.join(' ');
}
