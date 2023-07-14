import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat_dream2/app/models/chat_model.dart';
import 'package:flutter/material.dart';

class GetMessagesFuture extends StatelessWidget {
  final String? documentId;

  GetMessagesFuture({this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference chats = FirebaseFirestore.instance.collection('chats');

    return FutureBuilder<DocumentSnapshot>(
      future: chats.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          final chatModel = ChatModel.fromJson(data);
          return Expanded(
              child: Column(
            children: [
              Text(
                chatModel.sender!,
              ),
              Text(
                chatModel.sms!,
              ),
            ],
          )
              // ListView(
              //   children: [
              //     Text(
              //       data['senderId'],
              //     ),
              //     Text(
              //       data['sms'],
              //     ),
              //   ],
              // ),
              );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
