import 'package:intl/intl.dart';

String currencySymbolFromCode(String currencyCode) {
  switch (currencyCode) {
    case 'EUR':
      return '€';
    case 'MAD':
      return 'MAD';
    case 'GBP':
      return '£';
    case 'CAD':
      return r'C$';
    case 'AED':
      return 'AED';
    case 'USD':
    default:
      return r'$';
  }
}

String formatMoney(
  double amount, {
  required String currencyCode,
  int decimalDigits = 2,
}) {
  final String symbol = currencySymbolFromCode(currencyCode);
  return NumberFormat.currency(
    symbol: symbol,
    decimalDigits: decimalDigits,
  ).format(amount);
}

String currencyDisplayLabel(String currencyCode) {
  return '${currencyFlagEmoji(currencyCode)} $currencyCode';
}

String currencyFlagEmoji(String currencyCode) {
  final String cc = _countryCodeForCurrency(currencyCode);
  if (cc.length != 2) return '🌐';
  final int first = cc.codeUnitAt(0) - 65 + 0x1F1E6;
  final int second = cc.codeUnitAt(1) - 65 + 0x1F1E6;
  if (first < 0x1F1E6 || second < 0x1F1E6) return '🌐';
  return String.fromCharCode(first) + String.fromCharCode(second);
}

String _countryCodeForCurrency(String currencyCode) {
  switch (currencyCode) {
    case 'EUR':
      return 'EU';
    case 'XCD':
      return 'AG';
    case 'XOF':
      return 'SN';
    case 'XAF':
      return 'CM';
    case 'XPF':
      return 'PF';
    case 'XAU':
    case 'XAG':
    case 'XPT':
    case 'XPD':
    case 'XDR':
    case 'XSU':
    case 'XTS':
    case 'XUA':
      return 'UN';
    default:
      if (currencyCode.length >= 2) {
        return currencyCode.substring(0, 2);
      }
      return 'UN';
  }
}
