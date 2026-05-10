import 'package:hive/hive.dart';

import 'tip_entry.dart';

class TipModel {
  TipModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.note,
    required this.jobId,
    required this.date,
    required this.synced,
  });

  final String id;
  final double amount;
  final String type;
  final String? note;
  final String? jobId;
  final DateTime date;
  final bool synced;

  TipModel copyWith({
    String? id,
    double? amount,
    String? type,
    String? note,
    String? jobId,
    DateTime? date,
    bool? synced,
  }) {
    return TipModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      note: note ?? this.note,
      jobId: jobId ?? this.jobId,
      date: date ?? this.date,
      synced: synced ?? this.synced,
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return <String, dynamic>{
      'id': id,
      'amount': amount,
      'type': type,
      'note': note,
      'jobId': jobId,
      'date': date.toIso8601String(),
      'synced': synced,
    };
  }

  factory TipModel.fromTipEntry(TipEntry entry, {required bool synced}) {
    return TipModel(
      id: entry.id,
      amount: entry.amount,
      type: entry.type,
      note: entry.notes,
      jobId: entry.jobId,
      date: entry.date,
      synced: synced,
    );
  }

  TipEntry toTipEntry() {
    return TipEntry(
      id: id,
      amount: amount,
      date: date,
      type: type,
      notes: note,
      jobId: jobId,
    );
  }
}

class TipModelAdapter extends TypeAdapter<TipModel> {
  @override
  final int typeId = 1;

  @override
  TipModel read(BinaryReader reader) {
    final String id = reader.readString();
    final double amount = reader.readDouble();
    final String type = reader.readString();
    final String? note = reader.read() as String?;
    final dynamic fifth = reader.read();
    final dynamic sixth = reader.read();
    if (fifth is String && _looksLikeIsoDate(fifth)) {
      return TipModel(
        id: id,
        amount: amount,
        type: type,
        note: note,
        jobId: null,
        date: DateTime.parse(fifth),
        synced: sixth is bool ? sixth : false,
      );
    }
    return TipModel(
      id: id,
      amount: amount,
      type: type,
      note: note,
      jobId: fifth as String?,
      date: DateTime.parse(
        (sixth as String?) ?? DateTime.now().toIso8601String(),
      ),
      synced: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, TipModel obj) {
    writer.writeString(obj.id);
    writer.writeDouble(obj.amount);
    writer.writeString(obj.type);
    writer.write(obj.note);
    writer.write(obj.jobId);
    writer.writeString(obj.date.toIso8601String());
    writer.writeBool(obj.synced);
  }

  bool _looksLikeIsoDate(String value) {
    return value.contains('T') && value.contains('-');
  }
}

/// Legacy adapter kept to read old persisted Hive records that were written
/// with typeId 24 in previous builds.
class LegacyTipModelAdapter extends TipModelAdapter {
  @override
  final int typeId = 24;
}
