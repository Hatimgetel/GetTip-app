import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';
import '../l10n/world_languages.dart';
import '../services/app_settings_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

const String kOnboardingCompleteKey = 'onboarding_complete';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, this.onCompleted, this.onLocaleChanged});

  final Future<void> Function()? onCompleted;
  final Future<void> Function(Locale? locale)? onLocaleChanged;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final AppSettingsService _appSettingsService = AppSettingsService();
  int _currentIndex = 0;
  String _languageCode = 'system';

  List<DropdownMenuItem<String>> _buildLanguageItems(AppLocalizations l10n) {
    return <DropdownMenuItem<String>>[
      DropdownMenuItem<String>(
        value: 'system',
        child: Text('🌐 ${l10n.languageSystemDefault}'),
      ),
      ...kSelectableWorldLanguages.map(
        (AppLanguageOption language) => DropdownMenuItem<String>(
          value: language.code,
          child: Text('${language.flag} ${language.name}'),
        ),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    final Locale? saved = await _appSettingsService.loadSavedLocale();
    if (!mounted) return;
    setState(() {
      if (saved == null) {
        _languageCode = 'system';
      } else {
        _languageCode = saved.languageCode;
      }
    });
  }

  Future<void> _setLanguageCode(String? code) async {
    if (code == null) return;
    if (code == 'system') {
      await widget.onLocaleChanged?.call(null);
    } else {
      await widget.onLocaleChanged?.call(Locale(code));
    }
    if (!mounted) return;
    setState(() => _languageCode = code);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kOnboardingCompleteKey, true);
    if (!mounted) return;
    if (widget.onCompleted != null) {
      await widget.onCompleted!();
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            HomeScreen(storage: StorageService()),
      ),
    );
  }

  Future<void> _onContinue() async {
    if (_currentIndex == 0) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
      return;
    }
    await _finishOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      l10n.languageTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  DropdownButton<String>(
                    value: _languageCode,
                    underline: const SizedBox.shrink(),
                    items: _buildLanguageItems(l10n),
                    onChanged: _setLanguageCode,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _finishOnboarding,
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.brandOrangeDeep,
                ),
                child: Text(
                  l10n.onboardingSkip,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int index) =>
                    setState(() => _currentIndex = index),
                children: const <Widget>[_WelcomePage(), _JobsAndReportsPage()],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                2,
                (int index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == index ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? AppTheme.brandOrange
                        : theme.dividerColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.brandOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    l10n.onboardingContinue,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomePage extends StatelessWidget {
  const _WelcomePage();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final Color onSurface = theme.colorScheme.onSurface;
    final Color secondary =
        theme.textTheme.bodyMedium?.color ?? AppTheme.textSecondary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        children: <Widget>[
          Text(
            l10n.onboardingWelcomeTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: onSurface,
              fontSize: 34,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.onboardingWelcomeBody,
            textAlign: TextAlign.center,
            style: TextStyle(color: secondary, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            AppTheme.brandOrange.withValues(alpha: 0.08),
                            AppTheme.brandOrange.withValues(alpha: 0.02),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 100,
                    color: AppTheme.brandOrange.withValues(alpha: 0.7),
                  ),
                  Positioned(
                    bottom: 30,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.brandOrange.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        l10n.onboardingDemoToday,
                        style: const TextStyle(
                          color: AppTheme.brandOrangeDeep,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JobsAndReportsPage extends StatelessWidget {
  const _JobsAndReportsPage();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final Color onSurface = theme.colorScheme.onSurface;
    final Color secondary =
        theme.textTheme.bodyMedium?.color ?? AppTheme.textSecondary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        children: <Widget>[
          Text(
            l10n.onboardingJobsTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: onSurface,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.onboardingJobsBody,
            textAlign: TextAlign.center,
            style: TextStyle(color: secondary, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Column(
                children: <Widget>[
                  _JobCardMock(
                    title: l10n.onboardingMockCafeTitle,
                    subtitle: l10n.onboardingMockCafeSub,
                    amount: '\$18/hr',
                    color: Colors.green,
                  ),
                  const SizedBox(height: 10),
                  _JobCardMock(
                    title: l10n.onboardingMockRestaurantTitle,
                    subtitle: l10n.onboardingMockRestaurantSub,
                    amount: '\$22/hr',
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 14),
                  const _PdfPreviewMock(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JobCardMock extends StatelessWidget {
  const _JobCardMock({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.color,
  });

  final String title;
  final String subtitle;
  final String amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(backgroundColor: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              color: AppTheme.brandOrangeDeep,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PdfPreviewMock extends StatelessWidget {
  const _PdfPreviewMock();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF5E9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(
                  Icons.picture_as_pdf,
                  color: AppTheme.brandOrangeDeep,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.onboardingProfessionalReports,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const _PdfLine(widthFactor: 0.95),
            const SizedBox(height: 8),
            const _PdfLine(widthFactor: 0.82),
            const SizedBox(height: 8),
            const _PdfLine(widthFactor: 0.88),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                l10n.onboardingPreviewPdf,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.brandOrangeDeep,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PdfLine extends StatelessWidget {
  const _PdfLine({required this.widthFactor});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: 10,
        decoration: BoxDecoration(
          color: const Color(0xFFFFDEB8),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
