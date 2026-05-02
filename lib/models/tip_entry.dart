class TipEntry {
  final String id;
  final double amount;
  final DateTime date;
  final String type;
  final String? notes;
  final String? jobId;

  TipEntry({
    required this.id,
    required this.amount,
    required this.date,
    this.type = 'cash',
    this.notes,
    this.jobId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type,
      'notes': notes,
      'jobId': jobId,
    };
  }

  factory TipEntry.fromMap(Map<String, dynamic> map) {
    return TipEntry(
      id: map['id'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
      type: map['type'] as String? ?? 'cash',
      notes: map['notes'] as String? ?? map['note'] as String?,
      jobId: map['jobId'] as String?,
    );
  }
}
