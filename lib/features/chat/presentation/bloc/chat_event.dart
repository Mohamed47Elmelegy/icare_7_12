
import 'package:flutter/material.dart';
import 'package:icare/features/chat/data/models/chat_model.dart';

@immutable
abstract class ChatEvent{
  const ChatEvent();
}



class FetchAllChatRoomsEvent extends ChatEvent{
  const FetchAllChatRoomsEvent();
}

class FetchAllChatLitEvent extends ChatEvent{
  final String? roomID;
  const FetchAllChatLitEvent({this.roomID});
}

class SendNewMsgEvent extends ChatEvent{
  final MessageModel? model;
  final String? roomID;
  final String? catID;
  final String? msg;
  const SendNewMsgEvent({required this.model,required this.roomID,required this.catID,required this.msg});
}

class EnableChatSearchEvent extends ChatEvent{
  const EnableChatSearchEvent();
}

class UpdateChatSearchTxtEvent extends ChatEvent{
  final String txt;
  const UpdateChatSearchTxtEvent({required this.txt});
}

class UpdateChatSeenEvent extends ChatEvent{
  final String? roomID;
  final Map<String, dynamic> roomData;
  const UpdateChatSeenEvent({required this.roomID,required this.roomData});
}