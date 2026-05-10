import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/tip_model.dart';

/// Web-only: mirrors tips to [SharedPreferences] (localStorage). Hive uses
/// IndexedDB separately; if the box comes back empty after refresh, we restore
/// from this mirror so tips are not lost.
const String kTipsWebMirrorPrefsKey = 'tips_web_mirror_v1';

Future<void> tipsWebMirrorWrite(Iterable<TipModel> tips) async {
  if (!kIsWeb) return;
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<TipModel> list = tips.toList();
  if (list.isEmpty) {
    await prefs.remove(kTipsWebMirrorPrefsKey);
    return;
  }
  final String encoded = jsonEncode(
    list
        .map(
          (TipModel m) => <String, dynamic>{
            'id': m.id,
            'amount': m.amount,
            'type': m.type,
            'note': m.note,
            'jobId': m.jobId,
            'date': m.date.toIso8601String(),
            'synced': m.synced,
          },
        )
        .toList(),
  );
  await prefs.setString(kTipsWebMirrorPrefsKey, encoded);
}

Future<List<TipModel>?> tipsWebMirrorRead() async {
  if (!kIsWeb) return null;
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? raw = prefs.getString(kTipsWebMirrorPrefsKey);
  if (raw == null || raw.isEmpty) return null;
  try {
    final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
    return list.map((dynamic e) {
      final Map<String, dynamic> map = e as Map<String, dynamic>;
      return TipModel(
        id: map['id'] as String,
        amount: (map['amount'] as num).toDouble(),
        type: map['type'] as String? ?? 'cash',
        note: map['note'] as String?,
        jobId: map['jobId'] as String?,
        date: DateTime.tryParse(map['date'] as String? ?? '') ??
            DateTime.now(),
        synced: map['synced'] as bool? ?? false,
      );
    }).toList();
  } catch (_) {
    return null;
  }
}

Future<void> tipsWebMirrorClear() async {
  if (!kIsWeb) return;
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(kTipsWebMirrorPrefsKey);
}
