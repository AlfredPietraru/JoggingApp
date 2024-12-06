import 'package:equatable/equatable.dart';

class FriendRequest extends Equatable {
  final String senderId;
  final String receiverId;
  final DateTime timeOfSending;
  final String greetingMessage;
  final bool notificationSend;

  const FriendRequest({
    required this.notificationSend,
    required this.timeOfSending,
    required this.greetingMessage,
    required this.senderId,
    required this.receiverId,
  });

  FriendRequest copyWith({
    String? senderId,
    String? receiverId,
    DateTime? timeOfSending,
    String? greetingMessage,
    bool? notificationSend,
  }) {
    return FriendRequest(
        notificationSend: notificationSend ?? this.notificationSend,
        timeOfSending: timeOfSending ?? this.timeOfSending,
        greetingMessage: greetingMessage ?? this.greetingMessage,
        senderId: senderId ?? this.senderId,
        receiverId: receiverId ?? this.receiverId);
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'timeOfSending': timeOfSending.toIso8601String(),
      'greetingMessage': greetingMessage,
      'notificationSend': notificationSend,
    };
  }

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      timeOfSending: DateTime.parse(json['timeOfSending'] as String),
      greetingMessage: json['greetingMessage'] as String,
      notificationSend: json['notificationSend'] as bool,
    );
  }

  @override
  List<Object?> get props =>
      [senderId, receiverId, notificationSend, timeOfSending, greetingMessage];
}
