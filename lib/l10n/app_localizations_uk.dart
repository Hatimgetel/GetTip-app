// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Get Tip';

  @override
  String get onboardingSkip => 'Пропустити';

  @override
  String get onboardingContinue => 'Продовжити';

  @override
  String get onboardingWelcomeTitle => 'Ласкаво просимо';

  @override
  String get onboardingWelcomeBody =>
      'Відстежуйте кожну пораду та контролюйте свої прибутки.';

  @override
  String get onboardingDemoToday => '\$ 245,00 Сьогодні';

  @override
  String get onboardingJobsTitle => 'Кілька завдань і професійні звіти';

  @override
  String get onboardingJobsBody =>
      'Керуйте кожним завданням за допомогою чистих карток і експортуйте підсумки у форматі PDF.';

  @override
  String get onboardingMockCafeTitle => 'Кафе Shift';

  @override
  String get onboardingMockCafeSub => 'Пн - Пт';

  @override
  String get onboardingMockRestaurantTitle => 'Ніч ресторану';

  @override
  String get onboardingMockRestaurantSub => 'Пт - Нд';

  @override
  String get onboardingProfessionalReports => 'Професійні звіти';

  @override
  String get onboardingPreviewPdf => 'Попередній перегляд PDF';

  @override
  String get languageTitle => 'Мова';

  @override
  String get languageEnglish => 'англійська';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageSystemDefault => 'Система за умовчанням';

  @override
  String get navHome => 'додому';

  @override
  String get navHistory => 'історія';

  @override
  String get navProfile => 'Профіль';

  @override
  String get greetingMorning => 'Доброго ранку!';

  @override
  String get greetingAfternoon => 'доброго дня!';

  @override
  String get greetingEvening => 'Добрий вечір!';

  @override
  String get labelToday => 'Сьогодні';

  @override
  String get dailySummary => 'Щоденний підсумок';

  @override
  String get totalEarnings => 'Загальний прибуток';

  @override
  String get recentEntries => 'Останні записи';

  @override
  String get noTipsYet =>
      'Ще немає порад. Додайте один за допомогою кнопок вище.';

  @override
  String get customQuickLabel => 'Custom';

  @override
  String get customQuickSubtitle => 'Редагувати \$10 · \$20 · \$50';

  @override
  String get addTip => '+ Додати підказку';

  @override
  String get tipSaved => 'Пораду збережено';

  @override
  String get quickButtonsUpdated => 'Оновлено швидкі кнопки';

  @override
  String get jobSaved => 'Роботу збережено';

  @override
  String get tipDeletedUndo => 'Пораду видалено (Скасувати)';

  @override
  String get undo => 'Скасувати';

  @override
  String get deleteAllDataTitle => 'Видалити всі дані?';

  @override
  String get deleteAllDataBody => 'Це назавжди видалить усі збережені поради.';

  @override
  String get cancel => 'Скасувати';

  @override
  String get deleteAll => 'Видалити все';

  @override
  String get allDataDeleted => 'Усі дані видалено';

  @override
  String get noTipsToExport => 'Поки немає порад щодо експорту.';

  @override
  String get noTipsForPeriod => 'Не знайдено порад для вибраного періоду.';

  @override
  String get csvExported => 'CSV успішно експортовано';

  @override
  String get exportUnavailable => 'Експорт недоступний на цій платформі.';

  @override
  String get pdfReportReady =>
      'Звіт у форматі PDF готовий для спільного використання';

  @override
  String get pdfExportUnavailable =>
      'Експорт PDF недоступний на цій платформі.';

  @override
  String get thanksFeedback => 'Дякуємо за відгук!';

  @override
  String get exportCsvTitle => 'Експорт CSV';

  @override
  String get exportRangeToday => 'Сьогодні';

  @override
  String get exportRangeWeek => 'Цей тиждень';

  @override
  String get exportRangeMonth => 'Цей місяць';

  @override
  String get exportRangeCustom => 'Спеціальний діапазон';

  @override
  String get export => 'Експорт';

  @override
  String get rateApp => 'Оцініть додаток';

  @override
  String get contactUs => 'Зв\'яжіться з нами';

  @override
  String get deleteThisTip => 'Видалити цю пораду?';

  @override
  String get delete => 'Видалити';

  @override
  String get historyTitle => 'історія';

  @override
  String get reportPdfTooltip => 'Повідомити PDF';

  @override
  String get filters => 'Фільтри';

  @override
  String get entries => 'Записи';

  @override
  String get filterToday => 'Сьогодні';

  @override
  String get filterWeek => 'тиждень';

  @override
  String get filterMonth => 'місяць';

  @override
  String get filterYear => 'рік';

  @override
  String get noDataFound => 'Дані не знайдено';

  @override
  String get noIncomeRecorded =>
      'Дохід за цей день не зареєстровано. Торкніться кнопки +, щоб додати!';

  @override
  String get statsSection => 'СТАТИСТИКА';

  @override
  String get totalTipsLabel => 'Усього порад:';

  @override
  String get totalEarningsLabel => 'Загальний прибуток:';

  @override
  String get averageDayLabel => 'Середнє/день:';

  @override
  String get bestDayLabel => 'Найкращий день:';

  @override
  String get avgHourlyRateLabel => 'Середня погодинна ставка:';

  @override
  String get settingsSection => 'НАЛАШТУВАННЯ';

  @override
  String get jobs => 'Вакансії';

  @override
  String get quickButtons => 'Швидкі кнопки';

  @override
  String get exportCsv => 'Експорт CSV';

  @override
  String get backupTips =>
      'Збережіть свої дані / створіть резервну копію підказок';

  @override
  String get pdfReports => 'PDF звіти';

  @override
  String get shareExperience => 'Поділіться своїм досвідом';

  @override
  String get deleteAllData => 'Видалити всі дані';

  @override
  String get darkMode => 'Темний режим';

  @override
  String get supportSection => 'ПІДТРИМКА';

  @override
  String get rateTheApp => 'Оцініть програму';

  @override
  String get contactUsLabel => 'Зв\'яжіться з нами';

  @override
  String get currency => 'Валюта';

  @override
  String get roundUp => 'Округлити вгору';

  @override
  String get roundUpSubtitle =>
      'Під час збереження підказок округлення означає цілі числа';

  @override
  String get language => 'Мова';

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
