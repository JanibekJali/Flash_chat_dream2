import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final bool? isMe;
  final String? email;
  final String? text;

  const MessageBubble({
    Key? key,
    @required this.isMe,
    this.email,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isMe!
          ? const EdgeInsets.only(left: 150.0)
          : const EdgeInsets.only(right: 150.0),
      child: Container(
        child: Center(
          child: Column(
            crossAxisAlignment:
                isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                email!,
                style: TextStyle(fontSize: 12.0, color: Colors.blueAccent),
              ),
              Material(
                borderRadius: isMe!
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                      )
                    : const BorderRadius.only(
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                elevation: 5.0,
                color: isMe! ? Colors.deepOrange : Colors.white,
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    text!,
                    style: TextStyle(
                      color: isMe! ? Colors.white : Colors.black54,
                      fontSize: 14.0,
                    ),
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
