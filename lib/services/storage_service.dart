import 'dart:convert';
import 'dart:async';

import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/job_entry.dart';
import '../models/tip_entry.dart';
import '../models/tip_model.dart';
import 'firebase_service.dart';
import 'hive_service.dart';
import 'sync_service.dart';

const String _jobsKey = 'job_entries';

/// Persists [TipEntry] values as a JSON array string in [SharedPreferences].
class StorageService {
  StorageService();

  final HiveService _hiveService = HiveService.instance;

  Future<List<TipEntry>> loadTips() async {
    final List<TipEntry> tips = _hiveService
        .loadTips()
        .map((TipModel t) => t.toTipEntry())
        .toList();
    // Enforce newest-first order at service boundary as well.
    tips.sort((TipEntry a, TipEntry b) {
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

  Future<void> saveTips(List<TipEntry> tips) async {
    await _hiveService.saveTips(
      tips
          .map((TipEntry t) => TipModel.fromTipEntry(t, synced: false))
          .toList(growable: false),
    );
    unawaited(SyncService.instance.syncTips());
  }

  Future<List<TipEntry>> addTip(TipEntry newTip) async {
    await _hiveService.saveTip(TipModel.fromTipEntry(newTip, synced: false));
    unawaited(SyncService.instance.syncTips());
    return loadTips();
  }

  Future<List<TipEntry>> deleteTip(String id) async {
    await _hiveService.deleteTip(id);
    return loadTips();
  }

  Future<List<TipEntry>> updateTip(TipEntry updatedTip) async {
    await _hiveService.saveTip(
      TipModel.fromTipEntry(updatedTip, synced: false),
    );
    unawaited(SyncService.instance.syncTips());
    return loadTips();
  }

  Future<void> clearTips() async {
    await _hiveService.clearTips();
  }

  Future<List<JobEntry>> loadJobs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_jobsKey);
    if (raw == null || raw.isEmpty) {
      return <JobEntry>[];
    }
    final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((dynamic e) => JobEntry.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveJobs(List<JobEntry> jobs) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(
      jobs.map((JobEntry j) => j.toMap()).toList(),
    );
    await prefs.setString(_jobsKey, encoded);
    for (final JobEntry job in jobs) {
      unawaited(FirebaseService.instance.uploadJob(job));
    }
  }

  Future<void> addJob(JobEntry job) async {
    final List<JobEntry> jobs = await loadJobs();
    await saveJobs(<JobEntry>[...jobs, job]);
    unawaited(FirebaseService.instance.uploadJob(job));
  }

  Future<void> updateJob(JobEntry updatedJob) async {
    final List<JobEntry> jobs = await loadJobs();
    final List<JobEntry> next = jobs
        .map((JobEntry j) => j.id == updatedJob.id ? updatedJob : j)
        .toList(growable: false);
    await saveJobs(next);
    unawaited(FirebaseService.instance.uploadJob(updatedJob));
  }

  Future<void> deleteJob(String jobId) async {
    final List<JobEntry> jobs = await loadJobs();
    final List<JobEntry> next = jobs
        .where((JobEntry j) => j.id != jobId)
        .toList(growable: false);
    await saveJobs(next);
    unawaited(FirebaseService.instance.deleteJob(jobId));
  }

  Future<void> clearJobs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_jobsKey);
  }

  /// Wipes Hive tips storage (rebuilds the box) and clears jobs. For recovery
  /// when local cache is corrupted.
  Future<void> resetLocalStorageAfterCorruption() async {
    await _hiveService.wipeTipsStorageAndReopen();
    await clearJobs();
  }

  /// CSV with columns Date, Amount, Notes for export/sharing.
  String tipsToExportCsv(List<TipEntry> tips) {
    final DateFormat dateFormat = DateFormat('MMM dd, yyyy');
    final List<List<String>> rows = <List<String>>[
      <String>['Date', 'Amount', 'Notes'],
      ...tips.map(
        (TipEntry t) => <String>[
          dateFormat.format(t.date.toLocal()),
          t.amount.toStringAsFixed(2),
          t.notes ?? '',
        ],
      ),
    ];
    return const ListToCsvConverter().convert(rows);
  }
}
