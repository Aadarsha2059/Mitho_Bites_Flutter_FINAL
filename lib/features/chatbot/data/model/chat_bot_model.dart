class ChatBotModel {
  final String question;
  final String answer;

  const ChatBotModel({
    required this.question,
    required this.answer,
  });
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime? timestamp;

  const ChatMessage({
    required this.text,
    required this.isUser,
    this.timestamp,
  });
} 