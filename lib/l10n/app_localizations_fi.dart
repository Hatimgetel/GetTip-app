// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'MyTip Tracker';

  @override
  String get onboardingSkip => 'Ohita';

  @override
  String get onboardingContinue => 'Jatkaa';

  @override
  String get onboardingWelcomeTitle => 'Tervetuloa';

  @override
  String get onboardingWelcomeBody =>
      'Seuraa jokaista vinkkiä ja pysy tulojesi hallinnassa.';

  @override
  String get onboardingDemoToday => '245,00 \$ tänään';

  @override
  String get onboardingJobsTitle => 'Useita töitä ja ammattiraportteja';

  @override
  String get onboardingJobsBody =>
      'Hallitse jokaista työtä puhtailla korteilla ja vie PDF-valmiit yhteenvedot.';

  @override
  String get onboardingMockCafeTitle => 'Cafe Shift';

  @override
  String get onboardingMockCafeSub => 'ma-pe';

  @override
  String get onboardingMockRestaurantTitle => 'Ravintola-ilta';

  @override
  String get onboardingMockRestaurantSub => 'pe - su';

  @override
  String get onboardingProfessionalReports => 'Ammattimaiset raportit';

  @override
  String get onboardingPreviewPdf => 'Esikatsele PDF';

  @override
  String get languageTitle => 'Kieli';

  @override
  String get languageEnglish => 'englanti';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageSystemDefault => 'Järjestelmän oletus';

  @override
  String get navHome => 'Kotiin';

  @override
  String get navHistory => 'Historia';

  @override
  String get navProfile => 'Profiili';

  @override
  String get greetingMorning => 'Hyvää huomenta!';

  @override
  String get greetingAfternoon => 'Hyvää iltapäivää!';

  @override
  String get greetingEvening => 'Hyvää iltaa!';

  @override
  String get labelToday => 'Tänään';

  @override
  String get dailySummary => 'Päivittäinen yhteenveto';

  @override
  String get totalEarnings => 'Kokonaistulot';

  @override
  String get recentEntries => 'Viimeaikaiset merkinnät';

  @override
  String get noTipsYet =>
      'Ei vielä vinkkejä. Lisää yksi yllä olevilla painikkeilla.';

  @override
  String get customQuickLabel => 'Mukautettu';

  @override
  String get customQuickSubtitle => 'Muokkaa \$10 · \$20 · \$50';

  @override
  String get addTip => '+ Lisää vinkki';

  @override
  String get tipSaved => 'Vihje tallennettu';

  @override
  String get quickButtonsUpdated => 'Pikapainikkeet päivitetty';

  @override
  String get jobSaved => 'Työ tallennettu';

  @override
  String get tipDeletedUndo => 'Vihje poistettu (Kumoa)';

  @override
  String get undo => 'Kumoa';

  @override
  String get deleteAllDataTitle => 'Poistetaanko kaikki tiedot?';

  @override
  String get deleteAllDataBody =>
      'Tämä poistaa pysyvästi kaikki tallennetut vinkit.';

  @override
  String get cancel => 'Peruuttaa';

  @override
  String get deleteAll => 'Poista kaikki';

  @override
  String get allDataDeleted => 'Kaikki tiedot poistettu';

  @override
  String get noTipsToExport => 'Ei vielä vinkkejä vientiin.';

  @override
  String get noTipsForPeriod => 'Valitulle ajanjaksolle ei löytynyt vinkkejä.';

  @override
  String get csvExported => 'CSV-vienti onnistui';

  @override
  String get exportUnavailable =>
      'Vienti ei ole käytettävissä tällä alustalla.';

  @override
  String get pdfReportReady => 'PDF-raportti valmis jaettavaksi';

  @override
  String get pdfExportUnavailable =>
      'PDF-vienti ei ole käytettävissä tällä alustalla.';

  @override
  String get thanksFeedback => 'Kiitos palautteestasi!';

  @override
  String get exportCsvTitle => 'Vie CSV';

  @override
  String get exportRangeToday => 'Tänään';

  @override
  String get exportRangeWeek => 'Tällä viikolla';

  @override
  String get exportRangeMonth => 'Tässä kuussa';

  @override
  String get exportRangeCustom => 'Mukautettu valikoima';

  @override
  String get export => 'Viedä';

  @override
  String get rateApp => 'Arvioi sovellus';

  @override
  String get contactUs => 'Ota yhteyttä';

  @override
  String get deleteThisTip => 'Poistetaanko tämä vinkki?';

  @override
  String get delete => 'Poistaa';

  @override
  String get historyTitle => 'Historia';

  @override
  String get reportPdfTooltip => 'Raportti PDF';

  @override
  String get filters => 'Suodattimet';

  @override
  String get entries => 'merkinnät';

  @override
  String get filterToday => 'Tänään';

  @override
  String get filterWeek => 'Viikko';

  @override
  String get filterMonth => 'Kuukausi';

  @override
  String get filterYear => 'vuosi';

  @override
  String get noDataFound => 'Tietoja ei löytynyt';

  @override
  String get noIncomeRecorded =>
      'Tälle päivälle ei ole kirjattu tuloja. Lisää yksi napauttamalla +-painiketta!';

  @override
  String get statsSection => 'TILASTOT';

  @override
  String get totalTipsLabel => 'Vinkkejä yhteensä:';

  @override
  String get totalEarningsLabel => 'Kokonaistulot:';

  @override
  String get averageDayLabel => 'Keskiarvo/päivä:';

  @override
  String get bestDayLabel => 'Paras päivä:';

  @override
  String get avgHourlyRateLabel => 'Keskimääräinen tuntihinta:';

  @override
  String get settingsSection => 'ASETUKSET';

  @override
  String get jobs => 'Työpaikat';

  @override
  String get quickButtons => 'Pikapainikkeet';

  @override
  String get exportCsv => 'Vie CSV';

  @override
  String get backupTips => 'Tallenna tietosi / Varmuuskopioi vinkit';

  @override
  String get pdfReports => 'PDF-raportit';

  @override
  String get shareExperience => 'Jaa kokemuksesi';

  @override
  String get deleteAllData => 'Poista kaikki tiedot';

  @override
  String get darkMode => 'Tumma tila';

  @override
  String get supportSection => 'TUKEA';

  @override
  String get rateTheApp => 'Arvioi sovellus';

  @override
  String get contactUsLabel => 'Ota yhteyttä';

  @override
  String get currency => 'Valuutta';

  @override
  String get roundUp => 'Pyöristää ylöspäin';

  @override
  String get roundUpSubtitle =>
      'Vihjeitä tallennettaessa pyöristetään kokonaislukuja';

  @override
  String get language => 'Kieli';

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
