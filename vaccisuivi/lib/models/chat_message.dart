import 'package:json_annotation/json_annotation.dart';

part 'chat_message.g.dart';

enum MessageType {
  user,
  bot,
}

@JsonSerializable()
class ChatMessage {
  final String id;
  final String message;
  @JsonKey(name: 'message_type')
  final MessageType type;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.message,
    required this.type,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
} 