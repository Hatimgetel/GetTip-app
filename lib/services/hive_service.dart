import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/tip_model.dart';

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

  static Future<void> initialize() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TipModelAdapter());
    }
    try {
      if (!Hive.isBoxOpen(tipsBoxName)) {
        await Hive.openBox<TipModel>(tipsBoxName);
      }
    } catch (e, st) {
      debugPrint('Hive open failed, wiping box and retrying: $e\n$st');
      await _deleteTipsBoxFromDisk();
      await Hive.openBox<TipModel>(tipsBoxName);
    }
  }

  /// Last-resort startup recovery used if app boot still fails after normal
  /// initialize() handling.
  static Future<void> hardResetAndInitialize() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TipModelAdapter());
    }
    await _deleteTipsBoxFromDisk();
    await Hive.openBox<TipModel>(tipsBoxName);
  }

  Future<void> load() async {
    _tipsBox = Hive.box<TipModel>(tipsBoxName);
  }

  /// Deletes the tips box from disk and opens a new empty box. Use when the UI
  /// detects corruption or unreadable data.
  Future<void> wipeTipsStorageAndReopen() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TipModelAdapter());
    }
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
  }

  Future<void> saveTips(List<TipModel> tips) async {
    final Map<String, TipModel> map = <String, TipModel>{
      for (final TipModel tip in tips) tip.id: tip,
    };
    await _tipsBox.clear();
    await _tipsBox.putAll(map);
  }

  Future<void> deleteTip(String tipId) async {
    await _tipsBox.delete(tipId);
  }

  Future<void> clearTips() async {
    await _tipsBox.clear();
  }
}
