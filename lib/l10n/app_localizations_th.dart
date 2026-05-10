// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'MyTip Tracker';

  @override
  String get onboardingSkip => 'ข้าม';

  @override
  String get onboardingContinue => 'ดำเนินการต่อ';

  @override
  String get onboardingWelcomeTitle => 'ยินดีต้อนรับ';

  @override
  String get onboardingWelcomeBody => 'ติดตามทุกเคล็ดลับและควบคุมรายได้ของคุณ';

  @override
  String get onboardingDemoToday => '\$ 245.00 วันนี้';

  @override
  String get onboardingJobsTitle => 'งานหลายงานและรายงานระดับมืออาชีพ';

  @override
  String get onboardingJobsBody =>
      'จัดการงานแต่ละงานด้วยการ์ดที่ชัดเจนและส่งออกข้อมูลสรุปในรูปแบบ PDF';

  @override
  String get onboardingMockCafeTitle => 'คาเฟ่ชิฟท์';

  @override
  String get onboardingMockCafeSub => 'จันทร์ - ศุกร์';

  @override
  String get onboardingMockRestaurantTitle => 'ร้านอาหารไนท์';

  @override
  String get onboardingMockRestaurantSub => 'ศุกร์ - อาทิตย์';

  @override
  String get onboardingProfessionalReports => 'รายงานระดับมืออาชีพ';

  @override
  String get onboardingPreviewPdf => 'ดูตัวอย่าง PDF';

  @override
  String get languageTitle => 'ภาษา';

  @override
  String get languageEnglish => 'ภาษาอังกฤษ';

  @override
  String get languageFrench => 'ฝรั่งเศส';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageSystemDefault => 'ค่าเริ่มต้นของระบบ';

  @override
  String get navHome => 'บ้าน';

  @override
  String get navHistory => 'ประวัติศาสตร์';

  @override
  String get navProfile => 'ประวัติโดยย่อ';

  @override
  String get greetingMorning => 'สวัสดีตอนเช้า!';

  @override
  String get greetingAfternoon => 'สวัสดีตอนบ่าย!';

  @override
  String get greetingEvening => 'สวัสดีตอนเย็น!';

  @override
  String get labelToday => 'วันนี้';

  @override
  String get dailySummary => 'สรุปรายวัน';

  @override
  String get totalEarnings => 'รายได้รวม';

  @override
  String get recentEntries => 'รายการล่าสุด';

  @override
  String get noTipsYet => 'ยังไม่มีคำแนะนำ เพิ่มอันหนึ่งด้วยปุ่มด้านบน';

  @override
  String get customQuickLabel => 'กำหนดเอง';

  @override
  String get customQuickSubtitle => 'แก้ไข \$10 · \$20 · \$50';

  @override
  String get addTip => '+ เพิ่มเคล็ดลับ';

  @override
  String get tipSaved => 'บันทึกเคล็ดลับแล้ว';

  @override
  String get quickButtonsUpdated => 'อัปเดตปุ่มด่วนแล้ว';

  @override
  String get jobSaved => 'บันทึกงานแล้ว';

  @override
  String get tipDeletedUndo => 'เคล็ดลับถูกลบ (เลิกทำ)';

  @override
  String get undo => 'เลิกทำ';

  @override
  String get deleteAllDataTitle => 'ลบข้อมูลทั้งหมดใช่ไหม';

  @override
  String get deleteAllDataBody =>
      'การดำเนินการนี้จะลบเคล็ดลับที่บันทึกไว้ทั้งหมดอย่างถาวร';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get deleteAll => 'ลบทั้งหมด';

  @override
  String get allDataDeleted => 'ลบข้อมูลทั้งหมดแล้ว';

  @override
  String get noTipsToExport => 'ยังไม่มีคำแนะนำในการส่งออก';

  @override
  String get noTipsForPeriod => 'ไม่พบเคล็ดลับสำหรับช่วงเวลาที่เลือก';

  @override
  String get csvExported => 'ส่งออก CSV เรียบร้อยแล้ว';

  @override
  String get exportUnavailable => 'การส่งออกไม่พร้อมใช้งานบนแพลตฟอร์มนี้';

  @override
  String get pdfReportReady => 'รายงาน PDF พร้อมที่จะแบ่งปัน';

  @override
  String get pdfExportUnavailable =>
      'การส่งออก PDF ไม่พร้อมใช้งานบนแพลตฟอร์มนี้';

  @override
  String get thanksFeedback => 'ขอบคุณสำหรับคำติชมของคุณ!';

  @override
  String get exportCsvTitle => 'ส่งออก CSV';

  @override
  String get exportRangeToday => 'วันนี้';

  @override
  String get exportRangeWeek => 'สัปดาห์นี้';

  @override
  String get exportRangeMonth => 'เดือนนี้';

  @override
  String get exportRangeCustom => 'ช่วงที่กำหนดเอง';

  @override
  String get export => 'ส่งออก';

  @override
  String get rateApp => 'ให้คะแนนแอป';

  @override
  String get contactUs => 'ติดต่อเรา';

  @override
  String get deleteThisTip => 'ลบเคล็ดลับนี้ใช่ไหม';

  @override
  String get delete => 'ลบ';

  @override
  String get historyTitle => 'ประวัติศาสตร์';

  @override
  String get reportPdfTooltip => 'รายงาน PDF';

  @override
  String get filters => 'ตัวกรอง';

  @override
  String get entries => 'รายการ';

  @override
  String get filterToday => 'วันนี้';

  @override
  String get filterWeek => 'สัปดาห์';

  @override
  String get filterMonth => 'เดือน';

  @override
  String get filterYear => 'ปี';

  @override
  String get noDataFound => 'ไม่พบข้อมูล';

  @override
  String get noIncomeRecorded =>
      'ไม่มีการบันทึกรายได้สำหรับวันนี้ แตะปุ่ม + เพื่อเพิ่ม!';

  @override
  String get statsSection => 'สถิติ';

  @override
  String get totalTipsLabel => 'เคล็ดลับทั้งหมด:';

  @override
  String get totalEarningsLabel => 'รายได้รวม:';

  @override
  String get averageDayLabel => 'เฉลี่ย/วัน:';

  @override
  String get bestDayLabel => 'วันที่ดีที่สุด:';

  @override
  String get avgHourlyRateLabel => 'อัตราเฉลี่ยต่อชั่วโมง:';

  @override
  String get settingsSection => 'การตั้งค่า';

  @override
  String get jobs => 'งาน';

  @override
  String get quickButtons => 'ปุ่มด่วน';

  @override
  String get exportCsv => 'ส่งออก CSV';

  @override
  String get backupTips => 'บันทึกข้อมูลของคุณ / สำรองเคล็ดลับของคุณ';

  @override
  String get pdfReports => 'รายงาน PDF';

  @override
  String get shareExperience => 'แบ่งปันประสบการณ์ของคุณ';

  @override
  String get deleteAllData => 'ลบข้อมูลทั้งหมด';

  @override
  String get darkMode => 'โหมดมืด';

  @override
  String get supportSection => 'สนับสนุน';

  @override
  String get rateTheApp => 'ให้คะแนนแอป';

  @override
  String get contactUsLabel => 'ติดต่อเรา';

  @override
  String get currency => 'สกุลเงิน';

  @override
  String get roundUp => 'ปัดเศษขึ้น';

  @override
  String get roundUpSubtitle => 'ปัดเศษเป็นจำนวนเต็มเมื่อบันทึกทิป';

  @override
  String get language => 'ภาษา';

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
