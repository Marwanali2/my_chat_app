import '../../../models/message.dart';

abstract class ChatState {}

class ChatInitialState extends ChatState {}

class ChatSuccessState extends ChatState {
  List<UserMessage> messageList ;
  ChatSuccessState({required this.messageList});
}
