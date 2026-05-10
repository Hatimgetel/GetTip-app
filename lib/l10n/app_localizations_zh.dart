// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '我的提示追踪器';

  @override
  String get onboardingSkip => '跳过';

  @override
  String get onboardingContinue => '继续';

  @override
  String get onboardingWelcomeTitle => '欢迎';

  @override
  String get onboardingWelcomeBody => '追踪每一条小费并掌控您的收入。';

  @override
  String get onboardingDemoToday => '今天 245.00 美元';

  @override
  String get onboardingJobsTitle => '多项工作和专业报告';

  @override
  String get onboardingJobsBody => '使用干净的卡片管理每项工作并导出 PDF 格式的摘要。';

  @override
  String get onboardingMockCafeTitle => '咖啡馆班次';

  @override
  String get onboardingMockCafeSub => '周一至周五';

  @override
  String get onboardingMockRestaurantTitle => '餐厅之夜';

  @override
  String get onboardingMockRestaurantSub => '周五至周日';

  @override
  String get onboardingProfessionalReports => '专业报告';

  @override
  String get onboardingPreviewPdf => '预览 PDF';

  @override
  String get languageTitle => '语言';

  @override
  String get languageEnglish => '英语';

  @override
  String get languageFrench => '法国人';

  @override
  String get languageArabic => '巴黎';

  @override
  String get languageSystemDefault => '系统默认';

  @override
  String get navHome => '家';

  @override
  String get navHistory => '历史';

  @override
  String get navProfile => '轮廓';

  @override
  String get greetingMorning => '早上好！';

  @override
  String get greetingAfternoon => '下午好！';

  @override
  String get greetingEvening => '晚上好！';

  @override
  String get labelToday => '今天';

  @override
  String get dailySummary => '每日总结';

  @override
  String get totalEarnings => '总盈利';

  @override
  String get recentEntries => '最近的条目';

  @override
  String get noTipsYet => '还没有提示。使用上面的按钮添加一个。';

  @override
  String get customQuickLabel => '风俗';

  @override
  String get customQuickSubtitle => '编辑 \$10 · \$20 · \$50';

  @override
  String get addTip => '+ 添加提示';

  @override
  String get tipSaved => '小费已保存';

  @override
  String get quickButtonsUpdated => '更新了快速按钮';

  @override
  String get jobSaved => '工作已保存';

  @override
  String get tipDeletedUndo => '提示已删除（撤消）';

  @override
  String get undo => '撤消';

  @override
  String get deleteAllDataTitle => '删除所有数据？';

  @override
  String get deleteAllDataBody => '这将永久删除所有保存的提示。';

  @override
  String get cancel => '取消';

  @override
  String get deleteAll => '全部删除';

  @override
  String get allDataDeleted => '所有数据已删除';

  @override
  String get noTipsToExport => '尚无导出提示。';

  @override
  String get noTipsForPeriod => '未找到选定时间段内的提示。';

  @override
  String get csvExported => 'CSV 导出成功';

  @override
  String get exportUnavailable => '此平台不支持导出。';

  @override
  String get pdfReportReady => 'PDF 报告可供分享';

  @override
  String get pdfExportUnavailable => '此平台不支持 PDF 导出。';

  @override
  String get thanksFeedback => '感谢您的反馈！';

  @override
  String get exportCsvTitle => '导出 CSV';

  @override
  String get exportRangeToday => '今天';

  @override
  String get exportRangeWeek => '本星期';

  @override
  String get exportRangeMonth => '本月';

  @override
  String get exportRangeCustom => '定制范围';

  @override
  String get export => '出口';

  @override
  String get rateApp => '评价应用程序';

  @override
  String get contactUs => '联系我们';

  @override
  String get deleteThisTip => '删除这个提示吗？';

  @override
  String get delete => '删除';

  @override
  String get historyTitle => '历史';

  @override
  String get reportPdfTooltip => '报告 PDF';

  @override
  String get filters => '过滤器';

  @override
  String get entries => '参赛作品';

  @override
  String get filterToday => '今天';

  @override
  String get filterWeek => '星期';

  @override
  String get filterMonth => '月';

  @override
  String get filterYear => '年';

  @override
  String get noDataFound => '没有找到数据';

  @override
  String get noIncomeRecorded => '这一天没有收入记录。点击+按钮添加一个！';

  @override
  String get statsSection => '统计数据';

  @override
  String get totalTipsLabel => '总提示：';

  @override
  String get totalEarningsLabel => '总收入：';

  @override
  String get averageDayLabel => '平均/天：';

  @override
  String get bestDayLabel => '最好的一天：';

  @override
  String get avgHourlyRateLabel => '平均每小时费率：';

  @override
  String get settingsSection => '设置';

  @override
  String get jobs => '工作机会';

  @override
  String get quickButtons => '快捷按钮';

  @override
  String get exportCsv => '导出 CSV';

  @override
  String get backupTips => '保存您的数据/备份您的提示';

  @override
  String get pdfReports => 'PDF报告';

  @override
  String get shareExperience => '分享您的经验';

  @override
  String get deleteAllData => '删除所有数据';

  @override
  String get darkMode => '深色模式';

  @override
  String get supportSection => '支持';

  @override
  String get rateTheApp => '评价应用程序';

  @override
  String get contactUsLabel => '联系我们';

  @override
  String get currency => '货币';

  @override
  String get roundUp => '围捕';

  @override
  String get roundUpSubtitle => '保存小费时四舍五入为整数';

  @override
  String get language => '语言';

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
