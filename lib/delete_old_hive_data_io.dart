import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kLegacyDotHiveCleanupDone = 'legacy_dot_hive_folder_cleanup_v1';

/// One-time removal of a legacy `Documents/.hive` directory from older builds
/// that called [Hive.initFlutter] with a subdirectory.
///
/// Deleting this on **every** launch wiped tips whenever box files lived under
/// `.hive`, which looked like “$0 after reopen until I add a tip” (local empty,
/// then sync merged cloud data back).
Future<void> deleteOldHiveDataBeforeInit() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool(_kLegacyDotHiveCleanupDone) ?? false) {
    return;
  }
  final Directory appDir = await getApplicationDocumentsDirectory();
  final Directory hiveDir = Directory('${appDir.path}/.hive');
  if (await hiveDir.exists()) {
    await hiveDir.delete(recursive: true);
  }
  await prefs.setBool(_kLegacyDotHiveCleanupDone, true);
}
