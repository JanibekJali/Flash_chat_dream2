import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat_dream2/app/models/chat_model.dart';
import 'package:flutter/material.dart';

class StreamWidget extends StatelessWidget {
  const StreamWidget({
    super.key,
    required this.stream,
  });

  final Stream<QuerySnapshot<Object?>> stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return Expanded(
          child: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              final data = document.data()! as Map<String, dynamic>;
              final chatModel = ChatModel.fromJson(data);
              return Column(
                children: [
                  Text(chatModel.userName!),
                  // Text(data['createdAt']),
                  Text(chatModel.sender!),
                  Text(chatModel.sms!),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
