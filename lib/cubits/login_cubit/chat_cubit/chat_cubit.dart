import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_app/cubits/login_cubit/chat_cubit/chat_state.dart';

import '../../../constants.dart';
import '../../../models/message.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitialState());
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessageCollectionReference);

  void sendMessage({required String message, required String email}) {
    messages.add(
      {
        kMessageKey: message,
        kMessageSendTime: DateTime.now(),
        'id': email
      },
    );
  }

  void getMessage(){
    messages.orderBy(kMessageSendTime, descending: true).snapshots().listen((event) {
      List<UserMessage> messageList = [];
      for (var doc in event.docs) {
        messageList.add(
          UserMessage.fromJson(doc),
        );
        print('Success');
        emit(ChatSuccessState(messageList: messageList));
      }
    }
    );
  }

}
