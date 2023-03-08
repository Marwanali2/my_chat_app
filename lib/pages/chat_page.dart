import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_app/constants.dart';
import 'package:my_chat_app/cubits/login_cubit/chat_cubit/chat_cubit.dart';
import 'package:my_chat_app/cubits/login_cubit/chat_cubit/chat_state.dart';

import '../models/message.dart';
import '../widgets/custom_chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatelessWidget {
  ChatPage({Key? key}) : super(key: key);
  static String id = 'ChatPage';

  List<UserMessage> messageList = [];

  TextEditingController controller = TextEditingController();

// Create a CollectionReference called users that references the firestore collection  لكن لو هي موجوده فهو بيضيف ليها و خلاص (https://firebase.flutter.dev/docs/firestore/usage)
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    String? email = ModalRoute
        .of(context)!
        .settings
        .arguments as String;
/* return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kMessageSendTime, descending: true).snapshots(),
      //snapshots() type is Stream<QuerySnapshot>
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // print( snapshot.data!.docs[0]['user_message']);
          List<UserMessage> messageList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messageList.add(
              UserMessage.fromJson(snapshot.data!.docs[i]),
            ); // add document keys in the UserMessages list to access all messages from the user

          }*/
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
              child: BlocConsumer<ChatCubit,ChatState>(
                listener: (context, state) {
                  if(state is ChatSuccessState){
                    messageList=state.messageList;
                  }
                },
                builder: (context, state) =>  ListView.builder(
                  reverse: true,
                  controller: _controller,
                  itemCount: messageList.length,
                  itemBuilder: (context, index) {
                    return messageList[index].id == email
                        ? ChatBubble(
                      messageUserEntered: messageList[index],
                    )
                        : FriendChatBubble(
                      messageUserEntered: messageList[index],
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller,
                onSubmitted: (data) {
                 /* messages.add(
                    {
                      kMessageKey: data,
                      kMessageSendTime: DateTime.now(),
                      'id': email
                    }, // messages is collection -- data is document
                  );*/
                  BlocProvider.of<ChatCubit>(context).sendMessage(message: data, email: email);
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
  }
}

OutlineInputBorder buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(
        color: kPrimaryColor,
      ),
    );
  }
