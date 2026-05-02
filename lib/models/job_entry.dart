class JobEntry {
  JobEntry({
    required this.id,
    required this.colorKey,
    required this.title,
    this.employer,
    this.hourlyRate,
    required this.workDays,
  });

  final String id;
  /// One of: green, blue, red, orange, purple, pink, teal
  final String colorKey;
  final String title;
  final String? employer;
  final double? hourlyRate;
  /// ISO-style weekdays: 1 = Monday … 7 = Sunday
  final List<int> workDays;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'colorKey': colorKey,
      'title': title,
      'employer': employer,
      'hourlyRate': hourlyRate,
      'workDays': workDays,
    };
  }

  factory JobEntry.fromMap(Map<String, dynamic> map) {
    final dynamic rawDays = map['workDays'];
    final List<int> days = <int>[];
    if (rawDays is List<dynamic>) {
      for (final dynamic d in rawDays) {
        if (d is int) {
          days.add(d);
        } else if (d is num) {
          days.add(d.toInt());
        }
      }
    }
    return JobEntry(
      id: map['id'] as String,
      colorKey: map['colorKey'] as String? ?? 'green',
      title: map['title'] as String,
      employer: map['employer'] as String?,
      hourlyRate: (map['hourlyRate'] as num?)?.toDouble(),
      workDays: days,
    );
  }
}
