// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Welsh (`cy`).
class AppLocalizationsCy extends AppLocalizations {
  AppLocalizationsCy([String locale = 'cy']) : super(locale);

  @override
  String get appTitle => 'Traciwr MyTip';

  @override
  String get onboardingSkip => 'Sgipio';

  @override
  String get onboardingContinue => 'Parhau';

  @override
  String get onboardingWelcomeTitle => 'Croeso';

  @override
  String get onboardingWelcomeBody =>
      'Dilynwch bob awgrym a chadwch reolaeth ar eich enillion.';

  @override
  String get onboardingDemoToday => '\$245.00 Heddiw';

  @override
  String get onboardingJobsTitle =>
      'Swyddi Lluosog ac Adroddiadau Proffesiynol';

  @override
  String get onboardingJobsBody =>
      'Rheoli pob swydd gyda chardiau glân ac allforio crynodebau parod PDF.';

  @override
  String get onboardingMockCafeTitle => 'Shift Caffi';

  @override
  String get onboardingMockCafeSub => 'Llun - Gwener';

  @override
  String get onboardingMockRestaurantTitle => 'Noson Bwyty';

  @override
  String get onboardingMockRestaurantSub => 'Gwe - Haul';

  @override
  String get onboardingProfessionalReports => 'Adroddiadau Proffesiynol';

  @override
  String get onboardingPreviewPdf => 'Rhagolwg PDF';

  @override
  String get languageTitle => 'Iaith';

  @override
  String get languageEnglish => 'Saesneg';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageSystemDefault => 'System diofyn';

  @override
  String get navHome => 'Cartref';

  @override
  String get navHistory => 'Hanes';

  @override
  String get navProfile => 'Proffil';

  @override
  String get greetingMorning => 'Bore Da!';

  @override
  String get greetingAfternoon => 'Prynhawn Da!';

  @override
  String get greetingEvening => 'Noson dda!';

  @override
  String get labelToday => 'Heddiw';

  @override
  String get dailySummary => 'Crynodeb Dyddiol';

  @override
  String get totalEarnings => 'Cyfanswm Enillion';

  @override
  String get recentEntries => 'Cofnodion diweddar';

  @override
  String get noTipsYet =>
      'Dim awgrymiadau eto. Ychwanegwch un gyda\'r botymau uchod.';

  @override
  String get customQuickLabel => 'Custom';

  @override
  String get customQuickSubtitle => 'Golygu \$10 · \$20 · \$50';

  @override
  String get addTip => '+ Ychwanegu Awgrym';

  @override
  String get tipSaved => 'Awgrym wedi\'i gadw';

  @override
  String get quickButtonsUpdated => 'Botymau cyflym wedi\'u diweddaru';

  @override
  String get jobSaved => 'Arbedodd Job';

  @override
  String get tipDeletedUndo => 'Awgrym wedi\'i ddileu (Dadwneud)';

  @override
  String get undo => 'Dadwneud';

  @override
  String get deleteAllDataTitle => 'Dileu\'r holl ddata?';

  @override
  String get deleteAllDataBody =>
      'Bydd hyn yn dileu\'r holl awgrymiadau sydd wedi\'u cadw yn barhaol.';

  @override
  String get cancel => 'Canslo';

  @override
  String get deleteAll => 'Dileu popeth';

  @override
  String get allDataDeleted => 'Yr holl ddata wedi\'i ddileu';

  @override
  String get noTipsToExport => 'Dim awgrymiadau i allforio eto.';

  @override
  String get noTipsForPeriod =>
      'Ni chanfuwyd unrhyw awgrymiadau ar gyfer cyfnod penodol.';

  @override
  String get csvExported => 'CSV wedi\'i allforio yn llwyddiannus';

  @override
  String get exportUnavailable => 'Nid yw allforio ar gael ar y platfform hwn.';

  @override
  String get pdfReportReady => 'Adroddiad PDF yn barod i\'w rannu';

  @override
  String get pdfExportUnavailable =>
      'Nid yw allforio PDF ar gael ar y platfform hwn.';

  @override
  String get thanksFeedback => 'Diolch am eich adborth!';

  @override
  String get exportCsvTitle => 'Allforio CSV';

  @override
  String get exportRangeToday => 'Heddiw';

  @override
  String get exportRangeWeek => 'Yr Wythnos hon';

  @override
  String get exportRangeMonth => 'Y Mis hwn';

  @override
  String get exportRangeCustom => 'Ystod Custom';

  @override
  String get export => 'Allforio';

  @override
  String get rateApp => 'Cyfradd app';

  @override
  String get contactUs => 'Cysylltwch â ni';

  @override
  String get deleteThisTip => 'Dileu\'r awgrym hwn?';

  @override
  String get delete => 'Dileu';

  @override
  String get historyTitle => 'Hanes';

  @override
  String get reportPdfTooltip => 'Adroddiad PDF';

  @override
  String get filters => 'Hidlau';

  @override
  String get entries => 'Cofnodion';

  @override
  String get filterToday => 'Heddiw';

  @override
  String get filterWeek => 'Wythnos';

  @override
  String get filterMonth => 'Mis';

  @override
  String get filterYear => 'Blwyddyn';

  @override
  String get noDataFound => 'Heb Ddarganfod Data';

  @override
  String get noIncomeRecorded =>
      'Dim incwm wedi\'i gofnodi ar gyfer y diwrnod hwn. Tapiwch y botwm + i ychwanegu un!';

  @override
  String get statsSection => 'STATS';

  @override
  String get totalTipsLabel => 'Cyfanswm awgrymiadau:';

  @override
  String get totalEarningsLabel => 'Cyfanswm enillion:';

  @override
  String get averageDayLabel => 'Cyfartaledd/diwrnod:';

  @override
  String get bestDayLabel => 'Diwrnod gorau:';

  @override
  String get avgHourlyRateLabel => 'Cyfradd fesul awr Cyf:';

  @override
  String get settingsSection => 'GOSODIADAU';

  @override
  String get jobs => 'Swyddi';

  @override
  String get quickButtons => 'Botymau cyflym';

  @override
  String get exportCsv => 'Allforio CSV';

  @override
  String get backupTips =>
      'Arbedwch eich data / Gwneud copi wrth gefn o\'ch awgrymiadau';

  @override
  String get pdfReports => 'Adroddiadau PDF';

  @override
  String get shareExperience => 'Rhannwch Eich Profiad';

  @override
  String get deleteAllData => 'Dileu\'r holl ddata';

  @override
  String get darkMode => 'Modd tywyll';

  @override
  String get supportSection => 'CEFNOGAETH';

  @override
  String get rateTheApp => 'Graddiwch yr app';

  @override
  String get contactUsLabel => 'Cysylltwch â ni';

  @override
  String get currency => 'Arian cyfred';

  @override
  String get roundUp => 'Talgrynnu';

  @override
  String get roundUpSubtitle =>
      'Talgrynnu symiau i rifau cyfan wrth arbed awgrymiadau';

  @override
  String get language => 'Iaith';

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
