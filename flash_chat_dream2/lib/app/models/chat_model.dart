import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChatModel extends Equatable {
  final String? sender;
  final String? senderId;
  final String? sms;
  final String? userName;
  final Timestamp? createdAt;

  ChatModel({
    this.sender,
    this.senderId,
    this.sms,
    this.userName = '',
    this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'sender': sender,
        'senderId': senderId,
        'sms': sms,
        'userName': userName,
        'createdAt': Timestamp.now(),
      };
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      sender: json['sender'],
      senderId: json['senderId'],
      sms: json['sms'],
      userName: json['userName'],
      createdAt: json['createdAt'],
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        sender,
        senderId,
        sms,
        userName,
        createdAt,
      ];
}
