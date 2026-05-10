// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'МойТип Трекер';

  @override
  String get onboardingSkip => 'Пропускать';

  @override
  String get onboardingContinue => 'Продолжать';

  @override
  String get onboardingWelcomeTitle => 'Добро пожаловать';

  @override
  String get onboardingWelcomeBody =>
      'Отслеживайте все чаевые и контролируйте свои доходы.';

  @override
  String get onboardingDemoToday => '\$ 245,00 Сегодня';

  @override
  String get onboardingJobsTitle =>
      'Несколько вакансий и профессиональные отчеты';

  @override
  String get onboardingJobsBody =>
      'Управляйте каждым заданием с помощью чистых карточек и экспортируйте сводки в формате PDF.';

  @override
  String get onboardingMockCafeTitle => 'Кафе Смена';

  @override
  String get onboardingMockCafeSub => 'Пн - Пт';

  @override
  String get onboardingMockRestaurantTitle => 'Ночь ресторана';

  @override
  String get onboardingMockRestaurantSub => 'Пт - Вс';

  @override
  String get onboardingProfessionalReports => 'Профессиональные отчеты';

  @override
  String get onboardingPreviewPdf => 'Предварительный просмотр PDF';

  @override
  String get languageTitle => 'Язык';

  @override
  String get languageEnglish => 'Английский';

  @override
  String get languageFrench => 'Франсэ';

  @override
  String get languageArabic => 'عربية';

  @override
  String get languageSystemDefault => 'Система по умолчанию';

  @override
  String get navHome => 'Дом';

  @override
  String get navHistory => 'История';

  @override
  String get navProfile => 'Профиль';

  @override
  String get greetingMorning => 'Доброе утро!';

  @override
  String get greetingAfternoon => 'Добрый день!';

  @override
  String get greetingEvening => 'Добрый вечер!';

  @override
  String get labelToday => 'Сегодня';

  @override
  String get dailySummary => 'Ежедневная сводка';

  @override
  String get totalEarnings => 'Общий доход';

  @override
  String get recentEntries => 'Последние записи';

  @override
  String get noTipsYet =>
      'Советов пока нет. Добавьте его с помощью кнопок выше.';

  @override
  String get customQuickLabel => 'Обычай';

  @override
  String get customQuickSubtitle =>
      'Изменить 10 долларов США – 20 долларов США — 50 долларов США.';

  @override
  String get addTip => '+ Добавить совет';

  @override
  String get tipSaved => 'Совет сохранен.';

  @override
  String get quickButtonsUpdated => 'Обновлены быстрые кнопки';

  @override
  String get jobSaved => 'Вакансия сохранена';

  @override
  String get tipDeletedUndo => 'Совет удален (Отменить)';

  @override
  String get undo => 'Отменить';

  @override
  String get deleteAllDataTitle => 'Удалить все данные?';

  @override
  String get deleteAllDataBody =>
      'Это приведет к безвозвратному удалению всех сохраненных советов.';

  @override
  String get cancel => 'Отмена';

  @override
  String get deleteAll => 'Удалить все';

  @override
  String get allDataDeleted => 'Все данные удалены';

  @override
  String get noTipsToExport => 'Советов по экспорту пока нет.';

  @override
  String get noTipsForPeriod => 'Советы за выбранный период не найдены.';

  @override
  String get csvExported => 'CSV успешно экспортирован';

  @override
  String get exportUnavailable => 'Экспорт недоступен на этой платформе.';

  @override
  String get pdfReportReady => 'Отчет в формате PDF готов к публикации';

  @override
  String get pdfExportUnavailable =>
      'Экспорт PDF недоступен на этой платформе.';

  @override
  String get thanksFeedback => 'Спасибо за ваш отзыв!';

  @override
  String get exportCsvTitle => 'Экспортировать CSV';

  @override
  String get exportRangeToday => 'Сегодня';

  @override
  String get exportRangeWeek => 'На этой неделе';

  @override
  String get exportRangeMonth => 'В этом месяце';

  @override
  String get exportRangeCustom => 'Пользовательский диапазон';

  @override
  String get export => 'Экспорт';

  @override
  String get rateApp => 'Оцените приложение';

  @override
  String get contactUs => 'Связаться с нами';

  @override
  String get deleteThisTip => 'Удалить этот совет?';

  @override
  String get delete => 'Удалить';

  @override
  String get historyTitle => 'История';

  @override
  String get reportPdfTooltip => 'Отчет PDF';

  @override
  String get filters => 'Фильтры';

  @override
  String get entries => 'Записи';

  @override
  String get filterToday => 'Сегодня';

  @override
  String get filterWeek => 'Неделя';

  @override
  String get filterMonth => 'Месяц';

  @override
  String get filterYear => 'Год';

  @override
  String get noDataFound => 'Данные не найдены';

  @override
  String get noIncomeRecorded =>
      'Доходов за этот день не зафиксировано. Нажмите кнопку +, чтобы добавить его!';

  @override
  String get statsSection => 'СТАТИСТИКА';

  @override
  String get totalTipsLabel => 'Всего советов:';

  @override
  String get totalEarningsLabel => 'Общий доход:';

  @override
  String get averageDayLabel => 'В среднем/день:';

  @override
  String get bestDayLabel => 'Лучший день:';

  @override
  String get avgHourlyRateLabel => 'Средняя почасовая ставка:';

  @override
  String get settingsSection => 'НАСТРОЙКИ';

  @override
  String get jobs => 'Вакансии';

  @override
  String get quickButtons => 'Быстрые кнопки';

  @override
  String get exportCsv => 'Экспортировать CSV';

  @override
  String get backupTips =>
      'Сохраните свои данные / сделайте резервную копию своих советов';

  @override
  String get pdfReports => 'PDF-отчеты';

  @override
  String get shareExperience => 'Поделитесь своим опытом';

  @override
  String get deleteAllData => 'Удалить все данные';

  @override
  String get darkMode => 'Темный режим';

  @override
  String get supportSection => 'ПОДДЕРЖИВАТЬ';

  @override
  String get rateTheApp => 'Оцените приложение';

  @override
  String get contactUsLabel => 'Связаться с нами';

  @override
  String get currency => 'Валюта';

  @override
  String get roundUp => 'Округлять';

  @override
  String get roundUpSubtitle =>
      'При сохранении советов округляйте суммы до целых чисел.';

  @override
  String get language => 'Язык';

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
