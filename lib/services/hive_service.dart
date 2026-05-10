import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/tip_model.dart';
import 'tips_web_backup.dart';

class HiveService {
  HiveService._();

  static final HiveService instance = HiveService._();

  static const String tipsBoxName = 'tips';

  /// Persists the app version used to detect upgrades / schema changes for Hive.
  static const String _prefsHiveDataVersionKey = 'hive_persisted_app_version';

  late final Box<TipModel> _tipsBox;

  /// If the stored version differs from [currentAppVersion], deletes all Hive
  /// box files on disk so the next open starts clean.
  static Future<void> resetIfVersionChanged(String currentAppVersion) async {
    // On web debug sessions, origin/port can change across runs and make
    // SharedPreferences version tracking unreliable, which would wipe local tips
    // on every reopen. Skip version-based destructive reset for web.
    if (kIsWeb) {
      return;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? stored = prefs.getString(_prefsHiveDataVersionKey);
    if (stored == currentAppVersion) {
      return;
    }
    await Hive.initFlutter();
    await _deleteTipsBoxFromDisk();
    await prefs.setString(_prefsHiveDataVersionKey, currentAppVersion);
  }

  static Future<void> _deleteTipsBoxFromDisk() async {
    if (Hive.isBoxOpen(tipsBoxName)) {
      await Hive.box<TipModel>(tipsBoxName).close();
    }
    try {
      await Hive.deleteBoxFromDisk(tipsBoxName);
    } catch (_) {
      // Box may not exist yet (first install).
    }
  }

  /// Registers [TipModel] adapters. Legacy frames may use on-wire typeId **24**
  /// (older Hive / nested values) while current user ids are stored as id+32.
  static void _registerTipModelAdapters() {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TipModelAdapter());
    }
    if (!Hive.isAdapterRegistered(24)) {
      Hive.registerAdapter(LegacyTipModelAdapter());
    }
    try {
      Hive.registerAdapter<TipModel>(
        LegacyTipModelAdapter(),
        internal: true,
      );
    } on HiveError catch (_) {
      // Already registered in this isolate.
    }
  }

  static Future<void> initialize() async {
    await Hive.initFlutter();
    _registerTipModelAdapters();
    try {
      if (!Hive.isBoxOpen(tipsBoxName)) {
        await Hive.openBox<TipModel>(tipsBoxName);
      }
    } catch (e, st) {
      debugPrint('Hive open failed: $e\n$st');
      // On web, deleting the box wipes IndexedDB and looks like "tips never save".
      if (kIsWeb) {
        rethrow;
      }
      debugPrint('Hive open retry after short delay (mobile/desktop).');
      await Future<void>.delayed(const Duration(milliseconds: 250));
      try {
        if (!Hive.isBoxOpen(tipsBoxName)) {
          await Hive.openBox<TipModel>(tipsBoxName);
        }
        return;
      } catch (e2, st2) {
        debugPrint('Hive open retry failed: $e2\n$st2');
      }
      debugPrint('Wiping tips box and retrying (mobile/desktop only).');
      await _deleteTipsBoxFromDisk();
      await Hive.openBox<TipModel>(tipsBoxName);
    }
  }

  /// Last-resort startup recovery used if app boot still fails after normal
  /// initialize() handling.
  static Future<void> hardResetAndInitialize() async {
    await Hive.initFlutter();
    _registerTipModelAdapters();
    await _deleteTipsBoxFromDisk();
    await Hive.openBox<TipModel>(tipsBoxName);
  }

  Future<void> load() async {
    _tipsBox = Hive.box<TipModel>(tipsBoxName);
    if (kIsWeb) {
      if (_tipsBox.isEmpty) {
        final List<TipModel>? mirror = await tipsWebMirrorRead();
        if (mirror != null && mirror.isNotEmpty) {
          debugPrint(
            'Hive web: IndexedDB empty, restoring ${mirror.length} tips '
            'from localStorage mirror',
          );
          await _tipsBox.putAll(<String, TipModel>{
            for (final TipModel t in mirror) t.id: t,
          });
        }
      }
      await tipsWebMirrorWrite(_tipsBox.values);
    }
  }

  /// Deletes the tips box from disk and opens a new empty box. Use when the UI
  /// detects corruption or unreadable data.
  Future<void> wipeTipsStorageAndReopen() async {
    await Hive.initFlutter();
    _registerTipModelAdapters();
    await tipsWebMirrorClear();
    await _deleteTipsBoxFromDisk();
    await Hive.openBox<TipModel>(tipsBoxName);
    _tipsBox = Hive.box<TipModel>(tipsBoxName);
  }

  List<TipModel> loadTips() {
    final List<TipModel> tips = _tipsBox.values.toList();
    // Newest first for Recent Entries and all consumers.
    tips.sort((TipModel a, TipModel b) {
      final int byDate = b.date.compareTo(a.date);
      if (byDate != 0) return byDate;
      final int? ai = int.tryParse(a.id);
      final int? bi = int.tryParse(b.id);
      if (ai != null && bi != null) {
        return bi.compareTo(ai);
      }
      return b.id.compareTo(a.id);
    });
    return tips;
  }

  List<TipModel> loadUnsyncedTips() {
    return _tipsBox.values
        .where((TipModel t) => !t.synced)
        .toList(growable: false);
  }

  Future<void> saveTip(TipModel tip) async {
    await _tipsBox.put(tip.id, tip);
    await tipsWebMirrorWrite(_tipsBox.values);
  }

  /// Writes [tips] then removes other keys so concurrent [loadTips] never sees
  /// a transient empty box (e.g. while [SyncService] merges after startup).
  Future<void> saveTips(List<TipModel> tips) async {
    final Map<String, TipModel> map = <String, TipModel>{
      for (final TipModel tip in tips) tip.id: tip,
    };
    await _tipsBox.putAll(map);
    for (final dynamic key in _tipsBox.keys.toList()) {
      final String sid = key is String ? key : '$key';
      if (!map.containsKey(sid)) {
        await _tipsBox.delete(key);
      }
    }
    await tipsWebMirrorWrite(_tipsBox.values);
  }

  Future<void> deleteTip(String tipId) async {
    await _tipsBox.delete(tipId);
    await tipsWebMirrorWrite(_tipsBox.values);
  }

  Future<void> clearTips() async {
    await _tipsBox.clear();
    await tipsWebMirrorClear();
  }
}
