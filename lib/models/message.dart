import '../constants.dart';

class UserMessage{

  final String message;
  final String id;
  UserMessage(this.message,this.id);

  factory UserMessage.fromJson(jsonData){
    return UserMessage(jsonData[kMessageKey],jsonData['id']);
  }

}