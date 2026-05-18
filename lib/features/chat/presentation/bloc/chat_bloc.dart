import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icare/features/chat/data/data_sources/chat_client.dart';
import 'package:icare/features/chat/data/models/chat_model.dart';
import 'package:icare/features/chat/presentation/bloc/chat_event.dart';
import 'package:icare/features/chat/presentation/bloc/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatClient _chatClient = ChatClient();
  Stream<QuerySnapshot<Map<String, dynamic>>>? chatRoomList;
  List<MessageModel> currentChatMessagesList = [];
  Stream<QuerySnapshot>? chats;
  bool enableSearch = false;
  String chatTxtSearch = "";
  int chatRoomLength = 0;
  int currentCategoryIndex = 0;

  ChatBloc() : super(ChatInitialState()) {
    on<FetchAllChatLitEvent>((event, emit) async {
      await getAllRoomChatList(event, emit);
    });

    on<SendNewMsgEvent>((SendNewMsgEvent event, emit) async {
      await sendNewMsg(event, emit);
      await getAllRoomChatList(
          FetchAllChatLitEvent(roomID: event.roomID.toString()), emit);
    });

    on<EnableChatSearchEvent>((event, emit) {
      enableSearch = !enableSearch;
      emit(ChatSuccessfullyState());
    });

    on<UpdateChatSearchTxtEvent>((event, emit) {
      searchChatList(event, emit);
    });

    on<UpdateChatSeenEvent>((event, emit) async {
      await updateChatSeen(event, emit);
    });
  }

  static ChatBloc get(BuildContext context) => BlocProvider.of(context);

  searchChatList(event, emit) async {
    emit(ChatSuccessfullyState());
  }

  getAllRoomChatList(event, emit) async {
    emit(ChatLoadingState());
    try {
      chats = await _chatClient.getAllRoomChats(event.roomID.toString().trim());
      emit(ChatSuccessfullyState());
    } catch (e) {
      emit(ChatErrorState(errors: e.toString()));
    }
  }

  sendNewMsg(SendNewMsgEvent event, emit) async {
    emit(ChatLoadingState());
    try {
      bool res = await _chatClient.sendNewMsg(
          event.model!, event.roomID.toString().trim(), event.catID);
      if (res) {
        emit(ChatSuccessfullyState());
      } else {
        emit(const ChatErrorState(errors: "an error occurred"));
      }
    } catch (e) {
      emit(ChatErrorState(errors: e.toString()));
    }
  }

  // sendNotification({required String token,required String title,required String msg,required String advisorID})async {
  //   bool res = await _notificationsClient.sendPushNotification(token: token, title: title, msg: msg);
  //   if(res)await _notificationsClient.saveNotification(NotificationModel(userID: advisorID, title: title, msg: msg, date: DateTime.now().toString(), time: SmallFun.formatTimeToHMPMorAM(DateTime.now())));
  // }

  /// update message as seen while opening chat room screen
  updateChatSeen(event, emit) async {
    emit(ChatLoadingState());
    try {
      bool res = await _chatClient.updateChatRoom(event.roomID, event.roomData);
      if (res) {
        emit(ChatSuccessfullyState());
      } else {
        emit(const ChatErrorState(errors: "an error occurred"));
      }
    } catch (e) {
      emit(ChatErrorState(errors: e.toString()));
    }
  }
}
