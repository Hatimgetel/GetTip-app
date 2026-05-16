import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import 'firebase_service.dart';
import 'hive_service.dart';
import '../models/tip_model.dart';

class SyncService {
  SyncService._();

  static final SyncService instance = SyncService._();

  final HiveService _hiveService = HiveService.instance;
  final FirebaseService _firebaseService = FirebaseService.instance;

  StreamSubscription<dynamic>? _connectivitySubscription;

  /// Serializes overlapping [syncTips] calls so startup sync from [main] and
  /// dashboard reload both wait for the same merge instead of no-oping.
  Future<void> _syncChain = Future<void>.value();

  Future<void> initialize() async {
    _connectivitySubscription ??= Connectivity().onConnectivityChanged.listen((
      dynamic result,
    ) {
      if (_isOnline(result)) {
        syncTips();
      }
    });
  }

  Future<void> syncTips() {
    final Future<void> run = _syncChain = _syncChain
        .catchError((Object _, StackTrace __) {})
        .then((_) => _syncTipsOnce());
    return run;
  }

  Future<void> _syncTipsOnce() async {
    try {
      final user = await _firebaseService.ensureAnonymousSignedIn();
      if (user == null) {
        debugPrint('syncTips skipped: no authenticated user yet');
        return;
      }

      final unsynced = _hiveService.loadUnsyncedTips();
      for (final tip in unsynced) {
        try {
          await _firebaseService
              .uploadTip(tip)
              .timeout(const Duration(seconds: 6));
          await _hiveService.saveTip(tip.copyWith(synced: true));
        } catch (e) {
          // Keep local unsynced copy; retry on next connectivity change.
          debugPrint('Tip sync deferred (${tip.id}): $e');
        }
      }

      // Pull remote changes and merge into Hive (local-first, remote-backup).
      try {
        final List<TipModel> remoteTips = await _firebaseService
            .fetchTipsNewestFirst()
            .timeout(const Duration(seconds: 8));
        // When Firestore has no tips, skip merge entirely. Uploads already use
        // [saveTip]; calling [saveTips] runs a delete pass that can wipe local
        // rows if keys ever disagree (e.g. web IndexedDB key typing).
        if (remoteTips.isNotEmpty) {
          final Map<String, TipModel> localById = <String, TipModel>{
            for (final TipModel tip in _hiveService.loadTips()) tip.id: tip,
          };
          for (final TipModel remote in remoteTips) {
            final TipModel? local = localById[remote.id];
            if (local == null) {
              localById[remote.id] = remote.copyWith(synced: true);
              continue;
            }
            // Never overwrite local unsynced edits with remote.
            if (!local.synced) continue;
            localById[remote.id] = remote.copyWith(synced: true);
          }
          await _hiveService.saveTips(localById.values.toList(growable: false));
        } else {
          debugPrint(
            'syncTips: remote empty — skip merge save (local Hive unchanged)',
          );
        }
      } catch (e) {
        debugPrint('Remote pull deferred: $e');
      }
    } catch (e, st) {
      // Avoid stringifying errors on web (JS interop can throw TypeError).
      debugPrint('syncTips failed (${e.runtimeType})');
      debugPrint('$e');
      debugPrint('$st');
    }
  }

  bool _isOnline(dynamic result) {
    if (result is List<ConnectivityResult>) {
      return result.any((ConnectivityResult r) => r != ConnectivityResult.none);
    }
    if (result is ConnectivityResult) {
      return result != ConnectivityResult.none;
    }
    return false;
  }
}
