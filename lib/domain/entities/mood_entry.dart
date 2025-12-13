class MoodEntry {
  final String id;
  final String userId;
  final String mood; // happy, calm, excited, angry, sad
  final DateTime timestamp;
  final String? notes;

  MoodEntry({
    required this.id,
    required this.userId,
    required this.mood,
    required this.timestamp,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'mood': mood,
      'timestamp': timestamp.toIso8601String(),
      'notes': notes,
    };
  }

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      mood: json['mood'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      notes: json['notes'] as String?,
    );
  }

  MoodEntry copyWith({
    String? id,
    String? userId,
    String? mood,
    DateTime? timestamp,
    String? notes,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mood: mood ?? this.mood,
      timestamp: timestamp ?? this.timestamp,
      notes: notes ?? this.notes,
    );
  }
}
