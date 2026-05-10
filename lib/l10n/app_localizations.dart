import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_af.dart';
import 'app_localizations_ak.dart';
import 'app_localizations_am.dart';
import 'app_localizations_ar.dart';
import 'app_localizations_as.dart';
import 'app_localizations_ay.dart';
import 'app_localizations_az.dart';
import 'app_localizations_be.dart';
import 'app_localizations_bg.dart';
import 'app_localizations_bm.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_bs.dart';
import 'app_localizations_ca.dart';
import 'app_localizations_co.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_cy.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_dv.dart';
import 'app_localizations_ee.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_eo.dart';
import 'app_localizations_es.dart';
import 'app_localizations_et.dart';
import 'app_localizations_eu.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_fy.dart';
import 'app_localizations_ga.dart';
import 'app_localizations_gd.dart';
import 'app_localizations_gl.dart';
import 'app_localizations_gn.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_ha.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_ht.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_hy.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ig.dart';
import 'app_localizations_is.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_jv.dart';
import 'app_localizations_ka.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_km.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ku.dart';
import 'app_localizations_ky.dart';
import 'app_localizations_la.dart';
import 'app_localizations_lb.dart';
import 'app_localizations_ln.dart';
import 'app_localizations_lo.dart';
import 'app_localizations_lt.dart';
import 'app_localizations_lv.dart';
import 'app_localizations_mg.dart';
import 'app_localizations_mi.dart';
import 'app_localizations_mk.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mn.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_mt.dart';
import 'app_localizations_my.dart';
import 'app_localizations_ne.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_no.dart';
import 'app_localizations_ny.dart';
import 'app_localizations_om.dart';
import 'app_localizations_or.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_ps.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_qu.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_rw.dart';
import 'app_localizations_sd.dart';
import 'app_localizations_si.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_sl.dart';
import 'app_localizations_sm.dart';
import 'app_localizations_sn.dart';
import 'app_localizations_so.dart';
import 'app_localizations_sq.dart';
import 'app_localizations_sr.dart';
import 'app_localizations_st.dart';
import 'app_localizations_su.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_sw.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';
import 'app_localizations_tg.dart';
import 'app_localizations_th.dart';
import 'app_localizations_ti.dart';
import 'app_localizations_tk.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_ts.dart';
import 'app_localizations_tt.dart';
import 'app_localizations_ug.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_uz.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_xh.dart';
import 'app_localizations_yi.dart';
import 'app_localizations_yo.dart';
import 'app_localizations_zh.dart';
import 'app_localizations_zu.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('af'),
    Locale('ak'),
    Locale('am'),
    Locale('ar'),
    Locale('as'),
    Locale('ay'),
    Locale('az'),
    Locale('be'),
    Locale('bg'),
    Locale('bm'),
    Locale('bn'),
    Locale('bs'),
    Locale('ca'),
    Locale('co'),
    Locale('cs'),
    Locale('cy'),
    Locale('da'),
    Locale('de'),
    Locale('dv'),
    Locale('ee'),
    Locale('el'),
    Locale('en'),
    Locale('eo'),
    Locale('es'),
    Locale('et'),
    Locale('eu'),
    Locale('fa'),
    Locale('fi'),
    Locale('fr'),
    Locale('fy'),
    Locale('ga'),
    Locale('gd'),
    Locale('gl'),
    Locale('gn'),
    Locale('gu'),
    Locale('ha'),
    Locale('he'),
    Locale('hi'),
    Locale('hr'),
    Locale('ht'),
    Locale('hu'),
    Locale('hy'),
    Locale('id'),
    Locale('ig'),
    Locale('is'),
    Locale('it'),
    Locale('ja'),
    Locale('jv'),
    Locale('ka'),
    Locale('kk'),
    Locale('km'),
    Locale('kn'),
    Locale('ko'),
    Locale('ku'),
    Locale('ky'),
    Locale('la'),
    Locale('lb'),
    Locale('ln'),
    Locale('lo'),
    Locale('lt'),
    Locale('lv'),
    Locale('mg'),
    Locale('mi'),
    Locale('mk'),
    Locale('ml'),
    Locale('mn'),
    Locale('mr'),
    Locale('ms'),
    Locale('mt'),
    Locale('my'),
    Locale('ne'),
    Locale('nl'),
    Locale('no'),
    Locale('ny'),
    Locale('om'),
    Locale('or'),
    Locale('pa'),
    Locale('pl'),
    Locale('ps'),
    Locale('pt'),
    Locale('qu'),
    Locale('ro'),
    Locale('ru'),
    Locale('rw'),
    Locale('sd'),
    Locale('si'),
    Locale('sk'),
    Locale('sl'),
    Locale('sm'),
    Locale('sn'),
    Locale('so'),
    Locale('sq'),
    Locale('sr'),
    Locale('st'),
    Locale('su'),
    Locale('sv'),
    Locale('sw'),
    Locale('ta'),
    Locale('te'),
    Locale('tg'),
    Locale('th'),
    Locale('ti'),
    Locale('tk'),
    Locale('tr'),
    Locale('ts'),
    Locale('tt'),
    Locale('ug'),
    Locale('uk'),
    Locale('ur'),
    Locale('uz'),
    Locale('vi'),
    Locale('xh'),
    Locale('yi'),
    Locale('yo'),
    Locale('zh'),
    Locale('zu'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Get Tip'**
  String get appTitle;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinue;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Track every tip and stay in control of your earnings.'**
  String get onboardingWelcomeBody;

  /// No description provided for @onboardingDemoToday.
  ///
  /// In en, this message translates to:
  /// **'\$ 245.00 Today'**
  String get onboardingDemoToday;

  /// No description provided for @onboardingJobsTitle.
  ///
  /// In en, this message translates to:
  /// **'Multiple Jobs & Professional Reports'**
  String get onboardingJobsTitle;

  /// No description provided for @onboardingJobsBody.
  ///
  /// In en, this message translates to:
  /// **'Manage each job with clean cards and export PDF-ready summaries.'**
  String get onboardingJobsBody;

  /// No description provided for @onboardingMockCafeTitle.
  ///
  /// In en, this message translates to:
  /// **'Cafe Shift'**
  String get onboardingMockCafeTitle;

  /// No description provided for @onboardingMockCafeSub.
  ///
  /// In en, this message translates to:
  /// **'Mon - Fri'**
  String get onboardingMockCafeSub;

  /// No description provided for @onboardingMockRestaurantTitle.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Night'**
  String get onboardingMockRestaurantTitle;

  /// No description provided for @onboardingMockRestaurantSub.
  ///
  /// In en, this message translates to:
  /// **'Fri - Sun'**
  String get onboardingMockRestaurantSub;

  /// No description provided for @onboardingProfessionalReports.
  ///
  /// In en, this message translates to:
  /// **'Professional Reports'**
  String get onboardingProfessionalReports;

  /// No description provided for @onboardingPreviewPdf.
  ///
  /// In en, this message translates to:
  /// **'Preview PDF'**
  String get onboardingPreviewPdf;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @languageSystemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystemDefault;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning!'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon!'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening!'**
  String get greetingEvening;

  /// No description provided for @labelToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get labelToday;

  /// No description provided for @dailySummary.
  ///
  /// In en, this message translates to:
  /// **'Daily Summary'**
  String get dailySummary;

  /// No description provided for @totalEarnings.
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get totalEarnings;

  /// No description provided for @recentEntries.
  ///
  /// In en, this message translates to:
  /// **'Recent entries'**
  String get recentEntries;

  /// No description provided for @noTipsYet.
  ///
  /// In en, this message translates to:
  /// **'No tips yet. Add one with the buttons above.'**
  String get noTipsYet;

  /// No description provided for @customQuickLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customQuickLabel;

  /// No description provided for @customQuickSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Edit \$10 · \$20 · \$50'**
  String get customQuickSubtitle;

  /// No description provided for @addTip.
  ///
  /// In en, this message translates to:
  /// **'+ Add Tip'**
  String get addTip;

  /// No description provided for @tipSaved.
  ///
  /// In en, this message translates to:
  /// **'Tip saved'**
  String get tipSaved;

  /// No description provided for @quickButtonsUpdated.
  ///
  /// In en, this message translates to:
  /// **'Quick buttons updated'**
  String get quickButtonsUpdated;

  /// No description provided for @jobSaved.
  ///
  /// In en, this message translates to:
  /// **'Job saved'**
  String get jobSaved;

  /// No description provided for @tipDeletedUndo.
  ///
  /// In en, this message translates to:
  /// **'Tip deleted (Undo)'**
  String get tipDeletedUndo;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @deleteAllDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete all data?'**
  String get deleteAllDataTitle;

  /// No description provided for @deleteAllDataBody.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove all saved tips.'**
  String get deleteAllDataBody;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get deleteAll;

  /// No description provided for @allDataDeleted.
  ///
  /// In en, this message translates to:
  /// **'All data deleted'**
  String get allDataDeleted;

  /// No description provided for @noTipsToExport.
  ///
  /// In en, this message translates to:
  /// **'No tips to export yet.'**
  String get noTipsToExport;

  /// No description provided for @noTipsForPeriod.
  ///
  /// In en, this message translates to:
  /// **'No tips found for selected period.'**
  String get noTipsForPeriod;

  /// No description provided for @csvExported.
  ///
  /// In en, this message translates to:
  /// **'CSV exported successfully'**
  String get csvExported;

  /// No description provided for @exportUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Export is not available on this platform.'**
  String get exportUnavailable;

  /// No description provided for @pdfReportReady.
  ///
  /// In en, this message translates to:
  /// **'PDF report ready to share'**
  String get pdfReportReady;

  /// No description provided for @pdfExportUnavailable.
  ///
  /// In en, this message translates to:
  /// **'PDF export is not available on this platform.'**
  String get pdfExportUnavailable;

  /// No description provided for @thanksFeedback.
  ///
  /// In en, this message translates to:
  /// **'Thanks for your feedback!'**
  String get thanksFeedback;

  /// No description provided for @exportCsvTitle.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportCsvTitle;

  /// No description provided for @exportRangeToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get exportRangeToday;

  /// No description provided for @exportRangeWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get exportRangeWeek;

  /// No description provided for @exportRangeMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get exportRangeMonth;

  /// No description provided for @exportRangeCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom Range'**
  String get exportRangeCustom;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate app'**
  String get rateApp;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactUs;

  /// No description provided for @deleteThisTip.
  ///
  /// In en, this message translates to:
  /// **'Delete this tip?'**
  String get deleteThisTip;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @reportPdfTooltip.
  ///
  /// In en, this message translates to:
  /// **'Report PDF'**
  String get reportPdfTooltip;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @entries.
  ///
  /// In en, this message translates to:
  /// **'Entries'**
  String get entries;

  /// No description provided for @filterToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get filterToday;

  /// No description provided for @filterWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get filterWeek;

  /// No description provided for @filterMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get filterMonth;

  /// No description provided for @filterYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get filterYear;

  /// No description provided for @noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No Data Found'**
  String get noDataFound;

  /// No description provided for @noIncomeRecorded.
  ///
  /// In en, this message translates to:
  /// **'No income recorded for this day. Tap the + button to add one!'**
  String get noIncomeRecorded;

  /// No description provided for @statsSection.
  ///
  /// In en, this message translates to:
  /// **'STATS'**
  String get statsSection;

  /// No description provided for @totalTipsLabel.
  ///
  /// In en, this message translates to:
  /// **'Total tips:'**
  String get totalTipsLabel;

  /// No description provided for @totalEarningsLabel.
  ///
  /// In en, this message translates to:
  /// **'Total earnings:'**
  String get totalEarningsLabel;

  /// No description provided for @averageDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Average/day:'**
  String get averageDayLabel;

  /// No description provided for @bestDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Best day:'**
  String get bestDayLabel;

  /// No description provided for @avgHourlyRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Avg hourly rate:'**
  String get avgHourlyRateLabel;

  /// No description provided for @settingsSection.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settingsSection;

  /// No description provided for @jobs.
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get jobs;

  /// No description provided for @quickButtons.
  ///
  /// In en, this message translates to:
  /// **'Quick buttons'**
  String get quickButtons;

  /// No description provided for @exportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportCsv;

  /// No description provided for @backupTips.
  ///
  /// In en, this message translates to:
  /// **'Save your data / Backup your tips'**
  String get backupTips;

  /// No description provided for @pdfReports.
  ///
  /// In en, this message translates to:
  /// **'PDF Reports'**
  String get pdfReports;

  /// No description provided for @shareExperience.
  ///
  /// In en, this message translates to:
  /// **'Share Your Experience'**
  String get shareExperience;

  /// No description provided for @deleteAllData.
  ///
  /// In en, this message translates to:
  /// **'Delete all data'**
  String get deleteAllData;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @supportSection.
  ///
  /// In en, this message translates to:
  /// **'SUPPORT'**
  String get supportSection;

  /// No description provided for @rateTheApp.
  ///
  /// In en, this message translates to:
  /// **'Rate the app'**
  String get rateTheApp;

  /// No description provided for @contactUsLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactUsLabel;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @roundUp.
  ///
  /// In en, this message translates to:
  /// **'Round Up'**
  String get roundUp;

  /// No description provided for @roundUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Round amounts to whole numbers when saving tips'**
  String get roundUpSubtitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'{feature} coming soon'**
  String comingSoon(String feature);

  /// No description provided for @currencySet.
  ///
  /// In en, this message translates to:
  /// **'Currency set to {code}'**
  String currencySet(String code);

  /// No description provided for @exportFrom.
  ///
  /// In en, this message translates to:
  /// **'From: {date}'**
  String exportFrom(String date);

  /// No description provided for @exportTo.
  ///
  /// In en, this message translates to:
  /// **'To: {date}'**
  String exportTo(String date);

  /// No description provided for @weekOf.
  ///
  /// In en, this message translates to:
  /// **'Week of {date}'**
  String weekOf(String date);

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionLabel(String version);

  /// No description provided for @tipsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 tips} =1{1 tip} other{{count} tips}}'**
  String tipsCount(int count);

  /// No description provided for @hourlyRateFormat.
  ///
  /// In en, this message translates to:
  /// **'{rate}/hr'**
  String hourlyRateFormat(String rate);

  /// No description provided for @dataLoadFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your data'**
  String get dataLoadFailedTitle;

  /// No description provided for @dataLoadFailedBody.
  ///
  /// In en, this message translates to:
  /// **'Local storage may be corrupted. You can reset the app database (tips and jobs on this device) to recover.'**
  String get dataLoadFailedBody;

  /// No description provided for @resetApp.
  ///
  /// In en, this message translates to:
  /// **'Reset App'**
  String get resetApp;

  /// No description provided for @resetAppConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset local storage?'**
  String get resetAppConfirmTitle;

  /// No description provided for @resetAppConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This removes all tips and jobs stored on this device and rebuilds the database. Use this if the app stays blank or crashes.'**
  String get resetAppConfirmBody;

  /// No description provided for @resetAppSuccess.
  ///
  /// In en, this message translates to:
  /// **'Local storage was reset'**
  String get resetAppSuccess;

  /// No description provided for @resetAppFailed.
  ///
  /// In en, this message translates to:
  /// **'Reset failed'**
  String get resetAppFailed;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @noJobsYet.
  ///
  /// In en, this message translates to:
  /// **'No jobs yet. Add your first job.'**
  String get noJobsYet;

  /// No description provided for @deleteJobTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete job?'**
  String get deleteJobTitle;

  /// No description provided for @deleteJobBody.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{jobTitle}\"? Existing tips will stay saved.'**
  String deleteJobBody(String jobTitle);

  /// No description provided for @customizeQuickButtonsTitle.
  ///
  /// In en, this message translates to:
  /// **'Customize Quick Buttons'**
  String get customizeQuickButtonsTitle;

  /// No description provided for @tipNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Tip {index}'**
  String tipNumberLabel(int index);

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @noteUnderTipLabel.
  ///
  /// In en, this message translates to:
  /// **'Note under this Tip'**
  String get noteUnderTipLabel;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @invalidAmounts.
  ///
  /// In en, this message translates to:
  /// **'Amounts must be valid numbers > 0'**
  String get invalidAmounts;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @titleIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get titleIsRequired;

  /// No description provided for @enterValidHourlyRate.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid hourly rate or leave it empty.'**
  String get enterValidHourlyRate;

  /// No description provided for @editJob.
  ///
  /// In en, this message translates to:
  /// **'Edit Job'**
  String get editJob;

  /// No description provided for @addJobTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Job'**
  String get addJobTitle;

  /// No description provided for @colorRequired.
  ///
  /// In en, this message translates to:
  /// **'Color *'**
  String get colorRequired;

  /// No description provided for @titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title *'**
  String get titleRequired;

  /// No description provided for @employerOptional.
  ///
  /// In en, this message translates to:
  /// **'Employer (Optional)'**
  String get employerOptional;

  /// No description provided for @hourlyRateOptional.
  ///
  /// In en, this message translates to:
  /// **'Hourly Rate (Optional)'**
  String get hourlyRateOptional;

  /// No description provided for @workDaysOptional.
  ///
  /// In en, this message translates to:
  /// **'Work Days (Optional)'**
  String get workDaysOptional;

  /// No description provided for @updateJob.
  ///
  /// In en, this message translates to:
  /// **'Update Job'**
  String get updateJob;

  /// No description provided for @saveJob.
  ///
  /// In en, this message translates to:
  /// **'Save Job'**
  String get saveJob;

  /// No description provided for @saveToPhone.
  ///
  /// In en, this message translates to:
  /// **'Save to phone'**
  String get saveToPhone;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @saveFileInDownloads.
  ///
  /// In en, this message translates to:
  /// **'Save {fileType} in Downloads'**
  String saveFileInDownloads(String fileType);

  /// No description provided for @openAppsToShareFile.
  ///
  /// In en, this message translates to:
  /// **'Open apps to share this {fileType}'**
  String openAppsToShareFile(String fileType);

  /// No description provided for @noJobDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'No job found'**
  String get noJobDialogTitle;

  /// No description provided for @noJobDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Please create a job first.'**
  String get noJobDialogMessage;

  /// No description provided for @noJobDialogCreateJob.
  ///
  /// In en, this message translates to:
  /// **'Create job'**
  String get noJobDialogCreateJob;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'af',
    'ak',
    'am',
    'ar',
    'as',
    'ay',
    'az',
    'be',
    'bg',
    'bm',
    'bn',
    'bs',
    'ca',
    'co',
    'cs',
    'cy',
    'da',
    'de',
    'dv',
    'ee',
    'el',
    'en',
    'eo',
    'es',
    'et',
    'eu',
    'fa',
    'fi',
    'fr',
    'fy',
    'ga',
    'gd',
    'gl',
    'gn',
    'gu',
    'ha',
    'he',
    'hi',
    'hr',
    'ht',
    'hu',
    'hy',
    'id',
    'ig',
    'is',
    'it',
    'ja',
    'jv',
    'ka',
    'kk',
    'km',
    'kn',
    'ko',
    'ku',
    'ky',
    'la',
    'lb',
    'ln',
    'lo',
    'lt',
    'lv',
    'mg',
    'mi',
    'mk',
    'ml',
    'mn',
    'mr',
    'ms',
    'mt',
    'my',
    'ne',
    'nl',
    'no',
    'ny',
    'om',
    'or',
    'pa',
    'pl',
    'ps',
    'pt',
    'qu',
    'ro',
    'ru',
    'rw',
    'sd',
    'si',
    'sk',
    'sl',
    'sm',
    'sn',
    'so',
    'sq',
    'sr',
    'st',
    'su',
    'sv',
    'sw',
    'ta',
    'te',
    'tg',
    'th',
    'ti',
    'tk',
    'tr',
    'ts',
    'tt',
    'ug',
    'uk',
    'ur',
    'uz',
    'vi',
    'xh',
    'yi',
    'yo',
    'zh',
    'zu',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'af':
      return AppLocalizationsAf();
    case 'ak':
      return AppLocalizationsAk();
    case 'am':
      return AppLocalizationsAm();
    case 'ar':
      return AppLocalizationsAr();
    case 'as':
      return AppLocalizationsAs();
    case 'ay':
      return AppLocalizationsAy();
    case 'az':
      return AppLocalizationsAz();
    case 'be':
      return AppLocalizationsBe();
    case 'bg':
      return AppLocalizationsBg();
    case 'bm':
      return AppLocalizationsBm();
    case 'bn':
      return AppLocalizationsBn();
    case 'bs':
      return AppLocalizationsBs();
    case 'ca':
      return AppLocalizationsCa();
    case 'co':
      return AppLocalizationsCo();
    case 'cs':
      return AppLocalizationsCs();
    case 'cy':
      return AppLocalizationsCy();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'dv':
      return AppLocalizationsDv();
    case 'ee':
      return AppLocalizationsEe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'eo':
      return AppLocalizationsEo();
    case 'es':
      return AppLocalizationsEs();
    case 'et':
      return AppLocalizationsEt();
    case 'eu':
      return AppLocalizationsEu();
    case 'fa':
      return AppLocalizationsFa();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'fy':
      return AppLocalizationsFy();
    case 'ga':
      return AppLocalizationsGa();
    case 'gd':
      return AppLocalizationsGd();
    case 'gl':
      return AppLocalizationsGl();
    case 'gn':
      return AppLocalizationsGn();
    case 'gu':
      return AppLocalizationsGu();
    case 'ha':
      return AppLocalizationsHa();
    case 'he':
      return AppLocalizationsHe();
    case 'hi':
      return AppLocalizationsHi();
    case 'hr':
      return AppLocalizationsHr();
    case 'ht':
      return AppLocalizationsHt();
    case 'hu':
      return AppLocalizationsHu();
    case 'hy':
      return AppLocalizationsHy();
    case 'id':
      return AppLocalizationsId();
    case 'ig':
      return AppLocalizationsIg();
    case 'is':
      return AppLocalizationsIs();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'jv':
      return AppLocalizationsJv();
    case 'ka':
      return AppLocalizationsKa();
    case 'kk':
      return AppLocalizationsKk();
    case 'km':
      return AppLocalizationsKm();
    case 'kn':
      return AppLocalizationsKn();
    case 'ko':
      return AppLocalizationsKo();
    case 'ku':
      return AppLocalizationsKu();
    case 'ky':
      return AppLocalizationsKy();
    case 'la':
      return AppLocalizationsLa();
    case 'lb':
      return AppLocalizationsLb();
    case 'ln':
      return AppLocalizationsLn();
    case 'lo':
      return AppLocalizationsLo();
    case 'lt':
      return AppLocalizationsLt();
    case 'lv':
      return AppLocalizationsLv();
    case 'mg':
      return AppLocalizationsMg();
    case 'mi':
      return AppLocalizationsMi();
    case 'mk':
      return AppLocalizationsMk();
    case 'ml':
      return AppLocalizationsMl();
    case 'mn':
      return AppLocalizationsMn();
    case 'mr':
      return AppLocalizationsMr();
    case 'ms':
      return AppLocalizationsMs();
    case 'mt':
      return AppLocalizationsMt();
    case 'my':
      return AppLocalizationsMy();
    case 'ne':
      return AppLocalizationsNe();
    case 'nl':
      return AppLocalizationsNl();
    case 'no':
      return AppLocalizationsNo();
    case 'ny':
      return AppLocalizationsNy();
    case 'om':
      return AppLocalizationsOm();
    case 'or':
      return AppLocalizationsOr();
    case 'pa':
      return AppLocalizationsPa();
    case 'pl':
      return AppLocalizationsPl();
    case 'ps':
      return AppLocalizationsPs();
    case 'pt':
      return AppLocalizationsPt();
    case 'qu':
      return AppLocalizationsQu();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'rw':
      return AppLocalizationsRw();
    case 'sd':
      return AppLocalizationsSd();
    case 'si':
      return AppLocalizationsSi();
    case 'sk':
      return AppLocalizationsSk();
    case 'sl':
      return AppLocalizationsSl();
    case 'sm':
      return AppLocalizationsSm();
    case 'sn':
      return AppLocalizationsSn();
    case 'so':
      return AppLocalizationsSo();
    case 'sq':
      return AppLocalizationsSq();
    case 'sr':
      return AppLocalizationsSr();
    case 'st':
      return AppLocalizationsSt();
    case 'su':
      return AppLocalizationsSu();
    case 'sv':
      return AppLocalizationsSv();
    case 'sw':
      return AppLocalizationsSw();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
    case 'tg':
      return AppLocalizationsTg();
    case 'th':
      return AppLocalizationsTh();
    case 'ti':
      return AppLocalizationsTi();
    case 'tk':
      return AppLocalizationsTk();
    case 'tr':
      return AppLocalizationsTr();
    case 'ts':
      return AppLocalizationsTs();
    case 'tt':
      return AppLocalizationsTt();
    case 'ug':
      return AppLocalizationsUg();
    case 'uk':
      return AppLocalizationsUk();
    case 'ur':
      return AppLocalizationsUr();
    case 'uz':
      return AppLocalizationsUz();
    case 'vi':
      return AppLocalizationsVi();
    case 'xh':
      return AppLocalizationsXh();
    case 'yi':
      return AppLocalizationsYi();
    case 'yo':
      return AppLocalizationsYo();
    case 'zh':
      return AppLocalizationsZh();
    case 'zu':
      return AppLocalizationsZu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
