// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appTitle => 'Get Tip';

  @override
  String get onboardingSkip => 'Kihagyás';

  @override
  String get onboardingContinue => 'Folytatás';

  @override
  String get onboardingWelcomeTitle => 'Üdvözöljük';

  @override
  String get onboardingWelcomeBody =>
      'Kövesse nyomon minden tippet, és irányítsa bevételeit.';

  @override
  String get onboardingDemoToday => '245,00 \$ ma';

  @override
  String get onboardingJobsTitle => 'Több állás és szakmai jelentések';

  @override
  String get onboardingJobsBody =>
      'Kezelje az egyes feladatokat tiszta kártyákkal, és exportáljon PDF-kompatibilis összefoglalókat.';

  @override
  String get onboardingMockCafeTitle => 'Cafe Shift';

  @override
  String get onboardingMockCafeSub => 'H-P';

  @override
  String get onboardingMockRestaurantTitle => 'Étterem este';

  @override
  String get onboardingMockRestaurantSub => 'P - V';

  @override
  String get onboardingProfessionalReports => 'Szakmai jelentések';

  @override
  String get onboardingPreviewPdf => 'PDF előnézete';

  @override
  String get languageTitle => 'Nyelv';

  @override
  String get languageEnglish => 'angol';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageSystemDefault => 'Rendszer alapértelmezett';

  @override
  String get navHome => 'Otthon';

  @override
  String get navHistory => 'Történelem';

  @override
  String get navProfile => 'Profil';

  @override
  String get greetingMorning => 'Jó reggelt!';

  @override
  String get greetingAfternoon => 'Jó napot!';

  @override
  String get greetingEvening => 'Jó estét!';

  @override
  String get labelToday => 'Ma';

  @override
  String get dailySummary => 'Napi összefoglaló';

  @override
  String get totalEarnings => 'Összes bevétel';

  @override
  String get recentEntries => 'Legutóbbi bejegyzések';

  @override
  String get noTipsYet =>
      'Még nincsenek tippek. Adjon hozzá egyet a fenti gombokkal.';

  @override
  String get customQuickLabel => 'Szokás';

  @override
  String get customQuickSubtitle => 'Szerkesztés \$10 · \$20 · \$50';

  @override
  String get addTip => '+ Tipp hozzáadása';

  @override
  String get tipSaved => 'Tipp mentve';

  @override
  String get quickButtonsUpdated => 'A gyorsgombok frissítve';

  @override
  String get jobSaved => 'Munka mentve';

  @override
  String get tipDeletedUndo => 'Tipp törölve (Visszavonás)';

  @override
  String get undo => 'Visszavonás';

  @override
  String get deleteAllDataTitle => 'Törli az összes adatot?';

  @override
  String get deleteAllDataBody =>
      'Ezzel véglegesen eltávolítja az összes mentett tippet.';

  @override
  String get cancel => 'Mégse';

  @override
  String get deleteAll => 'Az összes törlése';

  @override
  String get allDataDeleted => 'Minden adat törölve';

  @override
  String get noTipsToExport => 'Még nincs tipp az exportáláshoz.';

  @override
  String get noTipsForPeriod => 'Nem található tipp a kiválasztott időszakban.';

  @override
  String get csvExported => 'A CSV exportálása sikeres volt';

  @override
  String get exportUnavailable =>
      'Az exportálás nem érhető el ezen a platformon.';

  @override
  String get pdfReportReady => 'PDF jelentés készen áll a megosztásra';

  @override
  String get pdfExportUnavailable =>
      'A PDF-exportálás nem érhető el ezen a platformon.';

  @override
  String get thanksFeedback => 'Köszönjük visszajelzését!';

  @override
  String get exportCsvTitle => 'CSV exportálása';

  @override
  String get exportRangeToday => 'Ma';

  @override
  String get exportRangeWeek => 'Ezen a héten';

  @override
  String get exportRangeMonth => 'Ebben a hónapban';

  @override
  String get exportRangeCustom => 'Egyedi tartomány';

  @override
  String get export => 'Export';

  @override
  String get rateApp => 'Értékelje az alkalmazást';

  @override
  String get contactUs => 'Vegye fel velünk a kapcsolatot';

  @override
  String get deleteThisTip => 'Törli ezt a tippet?';

  @override
  String get delete => 'Töröl';

  @override
  String get historyTitle => 'Történelem';

  @override
  String get reportPdfTooltip => 'Jelentés PDF';

  @override
  String get filters => 'Szűrők';

  @override
  String get entries => 'Bejegyzések';

  @override
  String get filterToday => 'Ma';

  @override
  String get filterWeek => 'Hét';

  @override
  String get filterMonth => 'Hónap';

  @override
  String get filterYear => 'Év';

  @override
  String get noDataFound => 'Nem található adat';

  @override
  String get noIncomeRecorded =>
      'Ezen a napon nincs bevétel. Érintse meg a + gombot egy hozzáadásához!';

  @override
  String get statsSection => 'STATISZTIKA';

  @override
  String get totalTipsLabel => 'Összes tipp:';

  @override
  String get totalEarningsLabel => 'Összes bevétel:';

  @override
  String get averageDayLabel => 'Átlag/nap:';

  @override
  String get bestDayLabel => 'Legjobb nap:';

  @override
  String get avgHourlyRateLabel => 'Átlagos óradíj:';

  @override
  String get settingsSection => 'BEÁLLÍTÁSOK';

  @override
  String get jobs => 'Állások';

  @override
  String get quickButtons => 'Gyors gombok';

  @override
  String get exportCsv => 'CSV exportálása';

  @override
  String get backupTips =>
      'Mentse el adatait / készítsen biztonsági másolatot tippjeiről';

  @override
  String get pdfReports => 'PDF jelentések';

  @override
  String get shareExperience => 'Ossza meg tapasztalatait';

  @override
  String get deleteAllData => 'Törölje az összes adatot';

  @override
  String get darkMode => 'Sötét mód';

  @override
  String get supportSection => 'TÁMOGATÁS';

  @override
  String get rateTheApp => 'Értékelje az alkalmazást';

  @override
  String get contactUsLabel => 'Vegye fel velünk a kapcsolatot';

  @override
  String get currency => 'Valuta';

  @override
  String get roundUp => 'Felhajt';

  @override
  String get roundUpSubtitle =>
      'A kerekítések egész számok a tippek mentésekor';

  @override
  String get language => 'Nyelv';

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

  @override
  String get noJobDialogTitle => 'No job found';

  @override
  String get noJobDialogMessage => 'Please create a job first.';

  @override
  String get noJobDialogCreateJob => 'Create job';
}
