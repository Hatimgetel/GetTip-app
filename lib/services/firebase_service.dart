import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/job_entry.dart';
import '../models/tip_model.dart';

class FirebaseService {
  FirebaseService._();

  static final FirebaseService instance = FirebaseService._();

  String? _userId;

  Future<String> getUserId() async {
    if (_userId != null && _userId!.isNotEmpty) {
      return _userId!;
    }
    final User? user = await ensureAnonymousSignedIn();
    if (user == null) {
      throw StateError('Anonymous authentication failed.');
    }
    _userId = user.uid;
    return user.uid;
  }

  Future<User?> ensureAnonymousSignedIn() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      return auth.currentUser;
    }

    // Cold start: Firebase may restore the persisted anonymous session a few
    // ticks after startup. Brief waits avoid replacing the uid unnecessarily.
    for (final Duration pause in <Duration>[
      Duration.zero,
      const Duration(milliseconds: 50),
      const Duration(milliseconds: 150),
      const Duration(milliseconds: 400),
    ]) {
      await Future<void>.delayed(pause);
      if (auth.currentUser != null) {
        return auth.currentUser;
      }
    }

    const int maxAttempts = 3;
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        final UserCredential cred = await auth.signInAnonymously();
        if (cred.user != null) {
          return cred.user;
        }
      } catch (e) {
        debugPrint('Anonymous sign-in attempt ${attempt + 1} failed: $e');
        if (attempt < maxAttempts - 1) {
          await Future<void>.delayed(
            Duration(milliseconds: 400 * (attempt + 1)),
          );
        }
      }
    }

    try {
      await auth.signOut();
    } catch (e) {
      debugPrint('signOut before fresh anonymous sign-in: $e');
    }
    _userId = null;

    try {
      final UserCredential cred = await auth.signInAnonymously();
      return cred.user;
    } catch (e) {
      debugPrint('Anonymous sign-in after sign-out failed: $e');
      return null;
    }
  }

  Future<String> debugPrintCurrentUserPath() async {
    final String userId = await getUserId();
    final String tipsPath = 'users/$userId/tips';
    final String jobsPath = 'users/$userId/jobs';
    debugPrint('Firestore debug path => $tipsPath');
    debugPrint('Firestore debug path => $jobsPath');
    return tipsPath;
  }

  Future<void> uploadTip(TipModel tip) async {
    final String userId = await getUserId();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tips')
        .doc(tip.id)
        .set(tip.toFirestoreMap(), SetOptions(merge: true));
  }

  Future<List<TipModel>> fetchTipsNewestFirst() async {
    final String userId = await getUserId();
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(userId)
        .collection('tips')
        .orderBy('date', descending: true)
        .get();
    final List<TipModel> tips = snapshot.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
          final Map<String, dynamic> map = doc.data();
          return TipModel(
            id: (map['id'] as String?) ?? doc.id,
            amount: (map['amount'] as num?)?.toDouble() ?? 0,
            type: (map['type'] as String?) ?? 'cash',
            note: map['note'] as String?,
            jobId: map['jobId'] as String?,
            date:
                DateTime.tryParse((map['date'] as String?) ?? '') ??
                DateTime.now(),
            synced: true,
          );
        })
        .toList(growable: false);
    // Keep the same deterministic newest-first order as local Hive sorting.
    tips.sort((TipModel a, TipModel b) {
      final int byDate = b.date.compareTo(a.date);
      if (byDate != 0) return byDate;
      return b.id.compareTo(a.id);
    });
    return tips;
  }

  Future<void> uploadJob(JobEntry job) async {
    final String userId = await getUserId();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('jobs')
        .doc(job.id)
        .set(job.toMap(), SetOptions(merge: true));
  }

  Future<void> deleteJob(String jobId) async {
    final String userId = await getUserId();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('jobs')
        .doc(jobId)
        .delete();
  }
}
