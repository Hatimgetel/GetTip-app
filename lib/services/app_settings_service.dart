import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/world_languages.dart';

const String kDefaultCurrencyCode = 'USD';
const bool kDefaultRoundUpEnabled = false;

const List<String> kSupportedCurrencyCodes = <String>[
  'AED',
  'AFN',
  'ALL',
  'AMD',
  'ANG',
  'AOA',
  'ARS',
  'AUD',
  'AWG',
  'AZN',
  'BAM',
  'BBD',
  'BDT',
  'BGN',
  'BHD',
  'BIF',
  'BMD',
  'BND',
  'BOB',
  'BOV',
  'BRL',
  'BSD',
  'BTN',
  'BWP',
  'BYN',
  'BZD',
  'CAD',
  'CDF',
  'CHE',
  'CHF',
  'CHW',
  'CLF',
  'CLP',
  'CNY',
  'COP',
  'COU',
  'CRC',
  'CUC',
  'CUP',
  'CVE',
  'CZK',
  'DJF',
  'DKK',
  'DOP',
  'DZD',
  'EGP',
  'ERN',
  'ETB',
  'EUR',
  'FJD',
  'FKP',
  'GBP',
  'GEL',
  'GHS',
  'GIP',
  'GMD',
  'GNF',
  'GTQ',
  'GYD',
  'HKD',
  'HNL',
  'HRK',
  'HTG',
  'HUF',
  'IDR',
  'ILS',
  'INR',
  'IQD',
  'IRR',
  'ISK',
  'JMD',
  'JOD',
  'JPY',
  'KES',
  'KGS',
  'KHR',
  'KMF',
  'KPW',
  'KRW',
  'KWD',
  'KYD',
  'KZT',
  'LAK',
  'LBP',
  'LKR',
  'LRD',
  'LSL',
  'LYD',
  'MAD',
  'MDL',
  'MGA',
  'MKD',
  'MMK',
  'MNT',
  'MOP',
  'MRU',
  'MUR',
  'MVR',
  'MWK',
  'MXN',
  'MXV',
  'MYR',
  'MZN',
  'NAD',
  'NGN',
  'NIO',
  'NOK',
  'NPR',
  'NZD',
  'OMR',
  'PAB',
  'PEN',
  'PGK',
  'PHP',
  'PKR',
  'PLN',
  'PYG',
  'QAR',
  'RON',
  'RSD',
  'RUB',
  'RWF',
  'SAR',
  'SBD',
  'SCR',
  'SDG',
  'SEK',
  'SGD',
  'SHP',
  'SLE',
  'SOS',
  'SRD',
  'SSP',
  'STN',
  'SVC',
  'SYP',
  'SZL',
  'THB',
  'TJS',
  'TMT',
  'TND',
  'TOP',
  'TRY',
  'TTD',
  'TWD',
  'TZS',
  'UAH',
  'UGX',
  'USD',
  'USN',
  'UYI',
  'UYU',
  'UYW',
  'UZS',
  'VED',
  'VES',
  'VND',
  'VUV',
  'WST',
  'XAF',
  'XAG',
  'XAU',
  'XBA',
  'XBB',
  'XBC',
  'XBD',
  'XCD',
  'XDR',
  'XOF',
  'XPD',
  'XPF',
  'XPT',
  'XSU',
  'XTS',
  'XUA',
  'YER',
  'ZAR',
  'ZMW',
  'ZWL',
];

const String _currencyCodeKey = 'currency_code';
const String _roundUpEnabledKey = 'round_up_enabled';
const String _darkModeEnabledKey = 'dark_mode_enabled';
const String _localeCodeKey = 'app_locale_code';
const String _activeJobIdKey = 'active_job_id';

class AppSettingsService {
  Future<String> loadCurrencyCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String code =
        prefs.getString(_currencyCodeKey) ?? kDefaultCurrencyCode;
    if (!kSupportedCurrencyCodes.contains(code)) {
      return kDefaultCurrencyCode;
    }
    return code;
  }

  Future<void> saveCurrencyCode(String code) async {
    if (!kSupportedCurrencyCodes.contains(code)) return;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyCodeKey, code);
  }

  Future<bool> loadRoundUpEnabled() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_roundUpEnabledKey) ?? kDefaultRoundUpEnabled;
  }

  Future<void> saveRoundUpEnabled(bool enabled) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_roundUpEnabledKey, enabled);
  }

  Future<bool> loadDarkModeEnabled() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeEnabledKey) ?? false;
  }

  Future<void> saveDarkModeEnabled(bool enabled) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeEnabledKey, enabled);
  }

  /// Returns null when the user has not chosen a language (follow device locale).
  Future<Locale?> loadSavedLocale() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? code = prefs.getString(_localeCodeKey);
    if (code == null || code.isEmpty) {
      return null;
    }
    if (kWorldLanguageCodes.contains(code)) {
      return Locale(code);
    }
    return null;
  }

  /// Pass null to clear saved locale and use the device language again.
  Future<void> saveLocale(Locale? locale) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_localeCodeKey);
      return;
    }
    if (!kWorldLanguageCodes.contains(locale.languageCode)) {
      return;
    }
    await prefs.setString(_localeCodeKey, locale.languageCode);
  }

  Future<String?> loadActiveJobId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jobId = prefs.getString(_activeJobIdKey);
    if (jobId == null || jobId.isEmpty) return null;
    return jobId;
  }

  Future<void> saveActiveJobId(String? jobId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (jobId == null || jobId.isEmpty) {
      await prefs.remove(_activeJobIdKey);
      return;
    }
    await prefs.setString(_activeJobIdKey, jobId);
  }
}
