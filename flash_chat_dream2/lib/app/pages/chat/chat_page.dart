import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_dream2/app/models/chat_model.dart';
import 'package:flash_chat_dream2/app/models/user_model.dart';
import 'package:flash_chat_dream2/app/pages/chat/widgets/future/chat_future.dart';
import 'package:flash_chat_dream2/app/pages/chat/widgets/messages/send_message.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    this.userModel,
    // this.uid,
  }) : super(key: key);

  final UserModel? userModel;
  // final String? uid;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final smsController = TextEditingController();
  final nameController = TextEditingController();
  final chats = FirebaseFirestore.instance.collection('chats');
  bool isMe = false;

  Future<void> addChat(String sms) {
    final chatModel = ChatModel(
      userName: widget.userModel!.name,
      senderId: widget.userModel!.id,
      createdAt: Timestamp.now(),
      sms: sms,
      sender: widget.userModel!.email,
    );
    return chats.add(chatModel.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome to Chat Page')),
      body: Column(
        children: [
          Expanded(child: SizedBox()),
          GetMessagesFuture(
              // documentId: widget.uid,
              ),
          // Expanded(child: SizedBox()),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.red, width: 2.0),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: smsController,
                    onChanged: (value) {
                      setState(() {
                        smsController.text = value;
                      });
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      hintText: 'Type your message here...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    // _textEditingController.clear();
                    FocusScope.of(context).unfocus();

                    await addChat(smsController.text);
                  },
                  child: const Text(
                    'Send',
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
