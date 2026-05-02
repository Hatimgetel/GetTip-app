// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Get Tip';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get onboardingWelcomeTitle => 'Welcome';

  @override
  String get onboardingWelcomeBody =>
      'Track every tip and stay in control of your earnings.';

  @override
  String get onboardingDemoToday => '\$ 245.00 Today';

  @override
  String get onboardingJobsTitle => 'Multiple Jobs & Professional Reports';

  @override
  String get onboardingJobsBody =>
      'Manage each job with clean cards and export PDF-ready summaries.';

  @override
  String get onboardingMockCafeTitle => 'Cafe Shift';

  @override
  String get onboardingMockCafeSub => 'Mon - Fri';

  @override
  String get onboardingMockRestaurantTitle => 'Restaurant Night';

  @override
  String get onboardingMockRestaurantSub => 'Fri - Sun';

  @override
  String get onboardingProfessionalReports => 'Professional Reports';

  @override
  String get onboardingPreviewPdf => 'Preview PDF';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageSystemDefault => 'System default';

  @override
  String get navHome => 'Home';

  @override
  String get navHistory => 'History';

  @override
  String get navProfile => 'Profile';

  @override
  String get greetingMorning => 'Good Morning!';

  @override
  String get greetingAfternoon => 'Good Afternoon!';

  @override
  String get greetingEvening => 'Good Evening!';

  @override
  String get labelToday => 'Today';

  @override
  String get dailySummary => 'Daily Summary';

  @override
  String get totalEarnings => 'Total Earnings';

  @override
  String get recentEntries => 'Recent entries';

  @override
  String get noTipsYet => 'No tips yet. Add one with the buttons above.';

  @override
  String get customQuickLabel => 'Custom';

  @override
  String get customQuickSubtitle => 'Edit \$10 · \$20 · \$50';

  @override
  String get addTip => '+ Add Tip';

  @override
  String get tipSaved => 'Tip saved';

  @override
  String get quickButtonsUpdated => 'Quick buttons updated';

  @override
  String get jobSaved => 'Job saved';

  @override
  String get tipDeletedUndo => 'Tip deleted (Undo)';

  @override
  String get undo => 'Undo';

  @override
  String get deleteAllDataTitle => 'Delete all data?';

  @override
  String get deleteAllDataBody =>
      'This will permanently remove all saved tips.';

  @override
  String get cancel => 'Cancel';

  @override
  String get deleteAll => 'Delete all';

  @override
  String get allDataDeleted => 'All data deleted';

  @override
  String get noTipsToExport => 'No tips to export yet.';

  @override
  String get noTipsForPeriod => 'No tips found for selected period.';

  @override
  String get csvExported => 'CSV exported successfully';

  @override
  String get exportUnavailable => 'Export is not available on this platform.';

  @override
  String get pdfReportReady => 'PDF report ready to share';

  @override
  String get pdfExportUnavailable =>
      'PDF export is not available on this platform.';

  @override
  String get thanksFeedback => 'Thanks for your feedback!';

  @override
  String get exportCsvTitle => 'Export CSV';

  @override
  String get exportRangeToday => 'Today';

  @override
  String get exportRangeWeek => 'This Week';

  @override
  String get exportRangeMonth => 'This Month';

  @override
  String get exportRangeCustom => 'Custom Range';

  @override
  String get export => 'Export';

  @override
  String get rateApp => 'Rate app';

  @override
  String get contactUs => 'Contact us';

  @override
  String get deleteThisTip => 'Delete this tip?';

  @override
  String get delete => 'Delete';

  @override
  String get historyTitle => 'History';

  @override
  String get reportPdfTooltip => 'Report PDF';

  @override
  String get filters => 'Filters';

  @override
  String get entries => 'Entries';

  @override
  String get filterToday => 'Today';

  @override
  String get filterWeek => 'Week';

  @override
  String get filterMonth => 'Month';

  @override
  String get filterYear => 'Year';

  @override
  String get noDataFound => 'No Data Found';

  @override
  String get noIncomeRecorded =>
      'No income recorded for this day. Tap the + button to add one!';

  @override
  String get statsSection => 'STATS';

  @override
  String get totalTipsLabel => 'Total tips:';

  @override
  String get totalEarningsLabel => 'Total earnings:';

  @override
  String get averageDayLabel => 'Average/day:';

  @override
  String get bestDayLabel => 'Best day:';

  @override
  String get avgHourlyRateLabel => 'Avg hourly rate:';

  @override
  String get settingsSection => 'SETTINGS';

  @override
  String get jobs => 'Jobs';

  @override
  String get quickButtons => 'Quick buttons';

  @override
  String get exportCsv => 'Export CSV';

  @override
  String get backupTips => 'Save your data / Backup your tips';

  @override
  String get pdfReports => 'PDF Reports';

  @override
  String get shareExperience => 'Share Your Experience';

  @override
  String get deleteAllData => 'Delete all data';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get supportSection => 'SUPPORT';

  @override
  String get rateTheApp => 'Rate the app';

  @override
  String get contactUsLabel => 'Contact us';

  @override
  String get currency => 'Currency';

  @override
  String get roundUp => 'Round Up';

  @override
  String get roundUpSubtitle =>
      'Round amounts to whole numbers when saving tips';

  @override
  String get language => 'Language';

  @override
  String comingSoon(String feature) {
    return '$feature coming soon';
  }

  @override
  String currencySet(String code) {
    return 'Currency set to $code';
  }

  @override
  String exportFrom(String date) {
    return 'From: $date';
  }

  @override
  String exportTo(String date) {
    return 'To: $date';
  }

  @override
  String weekOf(String date) {
    return 'Week of $date';
  }

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String tipsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tips',
      one: '1 tip',
      zero: '0 tips',
    );
    return '$_temp0';
  }

  @override
  String hourlyRateFormat(String rate) {
    return '$rate/hr';
  }

  @override
  String get dataLoadFailedTitle => 'Couldn\'t load your data';

  @override
  String get dataLoadFailedBody =>
      'Local storage may be corrupted. You can reset the app database (tips and jobs on this device) to recover.';

  @override
  String get resetApp => 'Reset App';

  @override
  String get resetAppConfirmTitle => 'Reset local storage?';

  @override
  String get resetAppConfirmBody =>
      'This removes all tips and jobs stored on this device and rebuilds the database. Use this if the app stays blank or crashes.';

  @override
  String get resetAppSuccess => 'Local storage was reset';

  @override
  String get resetAppFailed => 'Reset failed';

  @override
  String get done => 'Done';

  @override
  String get noJobsYet => 'No jobs yet. Add your first job.';

  @override
  String get deleteJobTitle => 'Delete job?';

  @override
  String deleteJobBody(String jobTitle) {
    return 'Delete \"$jobTitle\"? Existing tips will stay saved.';
  }

  @override
  String get customizeQuickButtonsTitle => 'Customize Quick Buttons';

  @override
  String tipNumberLabel(int index) {
    return 'Tip $index';
  }

  @override
  String get amountLabel => 'Amount';

  @override
  String get noteUnderTipLabel => 'Note under this Tip';

  @override
  String get reset => 'Reset';

  @override
  String get invalidAmounts => 'Amounts must be valid numbers > 0';

  @override
  String get save => 'Save';

  @override
  String get titleIsRequired => 'Title is required';

  @override
  String get enterValidHourlyRate =>
      'Enter a valid hourly rate or leave it empty.';

  @override
  String get editJob => 'Edit Job';

  @override
  String get addJobTitle => 'Add Job';

  @override
  String get colorRequired => 'Color *';

  @override
  String get titleRequired => 'Title *';

  @override
  String get employerOptional => 'Employer (Optional)';

  @override
  String get hourlyRateOptional => 'Hourly Rate (Optional)';

  @override
  String get workDaysOptional => 'Work Days (Optional)';

  @override
  String get updateJob => 'Update Job';

  @override
  String get saveJob => 'Save Job';

  @override
  String get saveToPhone => 'Save to phone';

  @override
  String get share => 'Share';

  @override
  String saveFileInDownloads(String fileType) {
    return 'Save $fileType in Downloads';
  }

  @override
  String openAppsToShareFile(String fileType) {
    return 'Open apps to share this $fileType';
  }
}
