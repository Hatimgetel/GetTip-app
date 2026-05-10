import 'dart:async';

import 'delete_old_hive_data_io.dart'
    if (dart.library.html) 'delete_old_hive_data_stub.dart' as delete_old_hive;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'services/app_settings_service.dart';
import 'services/firebase_service.dart';
import 'services/hive_service.dart';
import 'services/storage_service.dart';
import 'services/sync_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Optional legacy Hive folder cleanup (mobile/desktop); no-op on web.
  await delete_old_hive.deleteOldHiveDataBeforeInit();

  try {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (!kIsWeb) {
      await HiveService.resetIfVersionChanged(packageInfo.version);
    }
    await HiveService.initialize();
    await HiveService.instance.load();
  } catch (e, st) {
    debugPrint('Primary Hive bootstrap failed: $e\n$st');
    // Never wipe IndexedDB on web from here: any thrown error would delete all
    // local tips on every unlucky reload (user sees $0 after reopen).
    if (!kIsWeb) {
      await HiveService.hardResetAndInitialize();
      await HiveService.instance.load();
    } else {
      debugPrint('Web: retrying Hive bootstrap without wiping IndexedDB...');
      try {
        await HiveService.initialize();
        await HiveService.instance.load();
      } catch (e2, st2) {
        debugPrint(
          'Web Hive still failing after retry — clearing tips box so the app '
          'can start (storage was unreadable): $e2\n$st2',
        );
        try {
          await HiveService.hardResetAndInitialize();
          await HiveService.instance.load();
        } catch (e3, st3) {
          debugPrint('Fatal Hive on web after reset: $e3\n$st3');
          rethrow;
        }
      }
    }
  }

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool onboardingComplete =
      prefs.getBool(kOnboardingCompleteKey) ?? false;
  final AppSettingsService appSettingsService = AppSettingsService();
  final bool darkModeEnabled = await appSettingsService.loadDarkModeEnabled();
  final Locale? savedLocale = await appSettingsService.loadSavedLocale();
  runApp(
    TipTrackerApp(
      onboardingComplete: onboardingComplete,
      initialDarkModeEnabled: darkModeEnabled,
      savedLocale: savedLocale,
    ),
  );

  unawaited(_initializeCloudServices());
}

Future<void> _initializeCloudServices() async {
  await _initializeFirebase();
  try {
    await FirebaseService.instance.debugPrintCurrentUserPath();
    await SyncService.instance.initialize();
    unawaited(SyncService.instance.syncTips());
  } catch (e) {
    debugPrint('Cloud services deferred: $e');
  }
}

Future<void> _initializeFirebase() async {
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).timeout(const Duration(seconds: 8));
    } else {
      await Firebase.initializeApp().timeout(const Duration(seconds: 8));
    }

    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
    );

    if (kIsWeb) {
      await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    }
  } on FirebaseException catch (e) {
    debugPrint('Firebase connection failed (${e.code}): ${e.message}');
    return;
  } catch (e) {
    debugPrint('Unexpected Firebase startup error: $e');
    return;
  }
}

class TipTrackerApp extends StatefulWidget {
  const TipTrackerApp({
    super.key,
    this.onboardingComplete = false,
    this.initialDarkModeEnabled = false,
    this.savedLocale,
  });

  final bool onboardingComplete;
  final bool initialDarkModeEnabled;
  final Locale? savedLocale;

  @override
  State<TipTrackerApp> createState() => _TipTrackerAppState();
}

class _TipTrackerAppState extends State<TipTrackerApp> {
  final AppSettingsService _appSettingsService = AppSettingsService();
  late final StorageService _storageService;
  late bool _darkModeEnabled;
  late bool _onboardingComplete;
  Locale? _localeOverride;

  @override
  void initState() {
    super.initState();
    _storageService = StorageService();
    _darkModeEnabled = widget.initialDarkModeEnabled;
    _onboardingComplete = widget.onboardingComplete;
    _localeOverride = widget.savedLocale;
  }

  Future<void> _setDarkModeEnabled(bool enabled) async {
    setState(() => _darkModeEnabled = enabled);
    await _appSettingsService.saveDarkModeEnabled(enabled);
  }

  Future<void> _setOnboardingComplete() async {
    if (!mounted) return;
    setState(() => _onboardingComplete = true);
  }

  Future<void> _onLocaleChanged(Locale? locale) async {
    await _appSettingsService.saveLocale(locale);
    if (!mounted) return;
    setState(() => _localeOverride = locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (BuildContext context) => 'Get Tip',
      locale: _localeOverride,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      localeListResolutionCallback:
          (List<Locale>? locales, Iterable<Locale> supported) {
            if (_localeOverride != null) {
              return _localeOverride!;
            }
            if (locales == null || locales.isEmpty) {
              return const Locale('en');
            }
            for (final Locale deviceLocale in locales) {
              for (final Locale supportedLocale in supported) {
                if (supportedLocale.languageCode == deviceLocale.languageCode) {
                  return supportedLocale;
                }
              }
            }
            return const Locale('en');
          },
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _darkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: _onboardingComplete
          ? HomeScreen(
              storage: _storageService,
              darkModeEnabled: _darkModeEnabled,
              onDarkModeChanged: _setDarkModeEnabled,
              onLocaleChanged: _onLocaleChanged,
            )
          : OnboardingScreen(
              onCompleted: _setOnboardingComplete,
              onLocaleChanged: _onLocaleChanged,
            ),
    );
  }
}
