enum MessageType { user, ai, emotionUpdate, progressUpdate }

enum EmotionType { happy, sad, angry, calm, excited, stress, despair }

class ChatMessage {
  final String id;
  final MessageType type;
  final String content;
  final DateTime timestamp;
  final EmotionType? emotion;
  final String? emotionConfidence;

  ChatMessage({
    required this.id,
    required this.type,
    required this.content,
    required this.timestamp,
    this.emotion,
    this.emotionConfidence,
  });

  factory ChatMessage.user(String content) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: MessageType.user,
      content: content,
      timestamp: DateTime.now(),
    );
  }

  factory ChatMessage.ai(String content, {EmotionType? emotion}) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: MessageType.ai,
      content: content,
      timestamp: DateTime.now(),
      emotion: emotion,
    );
  }

  factory ChatMessage.emotionUpdate(EmotionType emotion) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: MessageType.emotionUpdate,
      content: 'Emotion: ${_emotionToString(emotion)}, Data Updated',
      timestamp: DateTime.now(),
      emotion: emotion,
    );
  }

  factory ChatMessage.progressUpdate(String content) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: MessageType.progressUpdate,
      content: content,
      timestamp: DateTime.now(),
    );
  }

  static String _emotionToString(EmotionType emotion) {
    switch (emotion) {
      case EmotionType.happy:
        return 'Happy';
      case EmotionType.sad:
        return 'Sad';
      case EmotionType.angry:
        return 'Anger';
      case EmotionType.calm:
        return 'Calm';
      case EmotionType.excited:
        return 'Excited';
      case EmotionType.stress:
        return 'Stress';
      case EmotionType.despair:
        return 'Despair';
    }
  }
}
