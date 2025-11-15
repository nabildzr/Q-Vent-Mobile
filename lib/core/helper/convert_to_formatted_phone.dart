String convertToFormattedPhone(String phoneNumber) {
  if (phoneNumber.isEmpty) return '';

  //remove any existing formatting
  String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

  // check if it's an Indonesian number
  if (cleanNumber.startsWith('62') && cleanNumber.length >= 10) {
    // format: +62 xxx-xxxx-xxxx
    String countryCode = '+62';
    String remaining = cleanNumber.substring(2);

    if (remaining.length >= 9) {
      String part1 = remaining.substring(0, 3);
      String part2 = remaining.substring(3, 7);
      String part3 = remaining.substring(7);

      return '$countryCode $part1-$part2-$part3';
    }
  }

  // return original if format doesn't match
  return phoneNumber;
}
