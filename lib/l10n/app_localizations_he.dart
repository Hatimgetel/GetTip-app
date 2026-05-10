// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appTitle => 'MyTip Tracker';

  @override
  String get onboardingSkip => 'לְדַלֵג';

  @override
  String get onboardingContinue => 'לְהַמשִׁיך';

  @override
  String get onboardingWelcomeTitle => 'קַבָּלַת פָּנִים';

  @override
  String get onboardingWelcomeBody =>
      'עקוב אחר כל טיפ והשאר בשליטה על הרווחים שלך.';

  @override
  String get onboardingDemoToday => '245.00 דולר היום';

  @override
  String get onboardingJobsTitle => 'ריבוי משרות ודוחות מקצועיים';

  @override
  String get onboardingJobsBody =>
      'נהל כל עבודה עם כרטיסים נקיים וייצא סיכומים מוכנים ל-PDF.';

  @override
  String get onboardingMockCafeTitle => 'בית קפה משמרת';

  @override
  String get onboardingMockCafeSub => 'שני - שישי';

  @override
  String get onboardingMockRestaurantTitle => 'ערב מסעדות';

  @override
  String get onboardingMockRestaurantSub => 'שישי - ראשון';

  @override
  String get onboardingProfessionalReports => 'דוחות מקצועיים';

  @override
  String get onboardingPreviewPdf => 'תצוגה מקדימה של PDF';

  @override
  String get languageTitle => 'שָׂפָה';

  @override
  String get languageEnglish => 'אַנגְלִית';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageSystemDefault => 'ברירת המחדל של המערכת';

  @override
  String get navHome => 'בַּיִת';

  @override
  String get navHistory => 'הִיסטוֹרִיָה';

  @override
  String get navProfile => 'פּרוֹפִיל';

  @override
  String get greetingMorning => 'בוקר טוב!';

  @override
  String get greetingAfternoon => 'צהריים טובים!';

  @override
  String get greetingEvening => 'ערב טוב!';

  @override
  String get labelToday => 'הַיוֹם';

  @override
  String get dailySummary => 'סיכום יומי';

  @override
  String get totalEarnings => 'סך הרווחים';

  @override
  String get recentEntries => 'ערכים אחרונים';

  @override
  String get noTipsYet => 'עדיין אין טיפים. הוסף אחד עם הכפתורים למעלה.';

  @override
  String get customQuickLabel => 'מִנְהָג';

  @override
  String get customQuickSubtitle => 'ערוך \$10 · \$20 · \$50';

  @override
  String get addTip => '+ הוסף טיפ';

  @override
  String get tipSaved => 'הטיפ נשמר';

  @override
  String get quickButtonsUpdated => 'כפתורים מהירים עודכנו';

  @override
  String get jobSaved => 'העבודה נשמרה';

  @override
  String get tipDeletedUndo => 'טיפ נמחק (בטל)';

  @override
  String get undo => 'לְבַטֵל';

  @override
  String get deleteAllDataTitle => 'למחוק את כל הנתונים?';

  @override
  String get deleteAllDataBody => 'פעולה זו תסיר לצמיתות את כל הטיפים השמורים.';

  @override
  String get cancel => 'לְבַטֵל';

  @override
  String get deleteAll => 'מחק הכל';

  @override
  String get allDataDeleted => 'כל הנתונים נמחקו';

  @override
  String get noTipsToExport => 'עדיין אין טיפים לייצוא.';

  @override
  String get noTipsForPeriod => 'לא נמצאו טיפים לתקופה שנבחרה.';

  @override
  String get csvExported => 'CSV יוצא בהצלחה';

  @override
  String get exportUnavailable => 'ייצוא אינו זמין בפלטפורמה זו.';

  @override
  String get pdfReportReady => 'דוח PDF מוכן לשיתוף';

  @override
  String get pdfExportUnavailable => 'ייצוא PDF אינו זמין בפלטפורמה זו.';

  @override
  String get thanksFeedback => 'תודה על המשוב שלך!';

  @override
  String get exportCsvTitle => 'ייצא CSV';

  @override
  String get exportRangeToday => 'הַיוֹם';

  @override
  String get exportRangeWeek => 'השבוע';

  @override
  String get exportRangeMonth => 'החודש הזה';

  @override
  String get exportRangeCustom => 'טווח מותאם אישית';

  @override
  String get export => 'יְצוּא';

  @override
  String get rateApp => 'דרג את האפליקציה';

  @override
  String get contactUs => 'צור איתנו קשר';

  @override
  String get deleteThisTip => 'למחוק את הטיפ הזה?';

  @override
  String get delete => 'לִמְחוֹק';

  @override
  String get historyTitle => 'הִיסטוֹרִיָה';

  @override
  String get reportPdfTooltip => 'דווח ב-PDF';

  @override
  String get filters => 'מסננים';

  @override
  String get entries => 'ערכים';

  @override
  String get filterToday => 'הַיוֹם';

  @override
  String get filterWeek => 'שָׁבוּעַ';

  @override
  String get filterMonth => 'חוֹדֶשׁ';

  @override
  String get filterYear => 'שָׁנָה';

  @override
  String get noDataFound => 'לא נמצאו נתונים';

  @override
  String get noIncomeRecorded =>
      'לא נרשמה הכנסה ליום זה. הקש על כפתור + כדי להוסיף אחד!';

  @override
  String get statsSection => 'סטטיסטיקה';

  @override
  String get totalTipsLabel => 'סך הכל טיפים:';

  @override
  String get totalEarningsLabel => 'סך הרווחים:';

  @override
  String get averageDayLabel => 'ממוצע/יום:';

  @override
  String get bestDayLabel => 'היום הכי טוב:';

  @override
  String get avgHourlyRateLabel => 'תעריף ממוצע לשעה:';

  @override
  String get settingsSection => 'הגדרות';

  @override
  String get jobs => 'משרות';

  @override
  String get quickButtons => 'כפתורים מהירים';

  @override
  String get exportCsv => 'ייצא CSV';

  @override
  String get backupTips => 'שמור את הנתונים שלך / גבה את הטיפים שלך';

  @override
  String get pdfReports => 'דוחות PDF';

  @override
  String get shareExperience => 'שתף את החוויה שלך';

  @override
  String get deleteAllData => 'מחק את כל הנתונים';

  @override
  String get darkMode => 'מצב כהה';

  @override
  String get supportSection => 'תְמִיכָה';

  @override
  String get rateTheApp => 'דרג את האפליקציה';

  @override
  String get contactUsLabel => 'צור איתנו קשר';

  @override
  String get currency => 'מַטְבֵּעַ';

  @override
  String get roundUp => 'לֶאֱסוֹף';

  @override
  String get roundUpSubtitle => 'עגל סכומים למספרים שלמים בעת שמירת טיפים';

  @override
  String get language => 'שָׂפָה';

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
