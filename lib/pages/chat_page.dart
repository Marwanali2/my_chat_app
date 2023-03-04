import 'package:flutter/material.dart';
import 'package:my_chat_app/constants.dart';

import '../models/message.dart';
import '../widgets/custom_chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key? key}) : super(key: key);
  static String id = 'ChatPage';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController controller = TextEditingController();

// Create a CollectionReference called users that references the firestore collection  لكن لو هي موجوده فهو بيضيف ليها و خلاص (https://firebase.flutter.dev/docs/firestore/usage)
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessageCollectionReference);
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kMessageSendTime, descending: true).snapshots(),
      //snapshots() type is Stream<QuerySnapshot>
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // print( snapshot.data!.docs[0]['user_message']);
          List<UserMessage> userMessages = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            userMessages.add(
              UserMessage.fromJson(snapshot.data!.docs[i]),
            ); // add document keys in the UserMessages list to access all messages from the user

          }
          return Scaffold(
              appBar: AppBar(
                backgroundColor: kPrimaryColor,
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(kLogo, height: 60),
                    Text('Chat'),
                  ],
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      controller: _controller,
                      itemCount: userMessages.length,
                      itemBuilder: (context, index) {
                        return userMessages[index].id == email
                            ? ChatBubble(
                                messageUserEntered: userMessages[index],
                              )
                            : FriendChatBubble(
                                messageUserEntered: userMessages[index],
                              );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: controller,
                      onSubmitted: (data) {
                        messages.add(
                          {
                            kMessageKey: data,
                            kMessageSendTime: DateTime.now(),
                            'id': email
                          }, // messages is collection -- data is document
                        );
                        controller
                            .clear(); // علشان لما نبعت الرسالة تتشال من التيكست فيلد و اكتب غيرها
                        _controller.animateTo(
                          0,
                          duration: Duration(seconds: 1),
                          curve: Curves.fastOutSlowIn,
                        );
                      },
                      decoration: InputDecoration(
                        hintText: "Message...",
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.send),
                        ),
                        border: buildOutlineInputBorder(),
                        enabledBorder: buildOutlineInputBorder(),
                        focusedBorder: buildOutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ));
        } else {
          return Text('Loading...');
        }
      },
    );
  }

  OutlineInputBorder buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(
        color: kPrimaryColor,
      ),
    );
  }
}
