import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/message.dart';
class ChatBubble extends StatelessWidget {
   UserMessage messageUserEntered;
    ChatBubble({
     required this.messageUserEntered,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
          padding: const EdgeInsets.only(left: 10,right: 30,top: 40,bottom: 40),
         // alignment: Alignment.centerLeft,
          margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
          decoration: const BoxDecoration(
            color: kPrimaryColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              //bottomRight: ,
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child:  Text(
            messageUserEntered.message,
            style: const TextStyle(color: Colors.white),
          )
      ),
    );
  }
}

class FriendChatBubble extends StatelessWidget {
  UserMessage messageUserEntered;
  FriendChatBubble({
    required this.messageUserEntered,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
          padding: const EdgeInsets.only(left: 10,right: 30,top: 40,bottom: 40),
          // alignment: Alignment.centerLeft,
          margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
          decoration: const BoxDecoration(
            color: Color(0xff126C8D),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
             // bottomLeft: ,
              bottomRight:Radius.circular(30),
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child:  Text(
            messageUserEntered.message,
            style: const TextStyle(color: Colors.white),
          )
      ),
    );
  }
}