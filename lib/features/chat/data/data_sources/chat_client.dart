import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icare/features/account/data/data_sources/account_data_source.dart';
import 'package:icare/features/chat/data/models/chat_model.dart';

class ChatClient {
//Future<Stream<QuerySnapshot<Map<String, dynamic>>>>
  getAllAdvisorChatRooms() async {
    var res = FirebaseFirestore.instance.collection("chatRoom").where('users',
        arrayContainsAny: [
          FirebaseAuth.instance.currentUser!.uid,
          "public"
        ]).snapshots();
    res.first.then((value) {
      // debugPrint("getAllAdvisorChatRooms: ${value.docs.toList()}");
    });
    return res;
  }

  getAllUserChatRooms() async {
    var res = FirebaseFirestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    res.first.then((value) {
      // debugPrint("getAllUserChatRooms: ${value.docs.toList()}");
    });
    return res;
  }

  Future<bool> addNewChatRoom(
      String roomID, Map<String, dynamic> roomData) async {
    bool res = true;
    try {
      await FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(roomID)
          .set(roomData)
          .catchError((e) {
        debugPrint("catchError: $e");
        res = false;
      });
    } catch (e) {
      debugPrint("addNewChatRoom: $e");
      res = false;
    }
    return res;
  }

  Future<bool> updateChatRoom(
      String roomID, Map<String, dynamic> roomData) async {
    bool res = true;
    try {
      await FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(roomID)
          .update(roomData)
          .catchError((e) {
        debugPrint("catchError: $e");
        res = false;
      });
    } catch (e) {
      debugPrint("updateChatRoom: $e");
      res = false;
    }
    return res;
  }

  /// if catID != null so this message room is public
  Future<bool> sendNewMsg(
      MessageModel model, String roomID, String? catID) async {
    bool res = true;
    var msg = model.text.toString().trim();
    Map<String, dynamic> chatMessageMap = {
      "seen": "",
      "senderID": "${model.senderID}",
      "senderName": "${model.senderName}",
      "receiverId": "${model.receiverID}",
      "receiverName": "${model.receiverName}",
      "message": msg,
      "time": DateTime.now().toString(),
    };
    try {
      Future<DocumentReference> docRef = FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(roomID.toString().trim())
          .collection("chats")
          .add(chatMessageMap)
          .catchError((e) {
        res = false;
        debugPrint("sendNewMsgCatchError: $e");
        throw "";
      });
      await docRef.then((value) {
        FirebaseFirestore.instance
            .collection("chatRoom")
            .doc(roomID.toString().trim())
            .collection("chats")
            .doc(value.id)
            .update({"documentID": value.id.toString()});
      });
      var users = [
        "${model.receiverID}",
        "${model.receiverName}",
        "${model.senderID}",
        "${model.senderName}",
      ];
      var roomData = {
        'lastMsg': "$msg msg ${model.senderID}",
        'chatRoomId': roomID,
        'time': DateTime.now().toString(),
        "users": users
      };
      if (catID != null) {
        roomData = {
          'catID': catID,
          'lastMsg': "$msg msg ${model.senderID}",
          'chatRoomId': roomID,
          'time': DateTime.now().toString(),
          "users": users
        };
      }
      FirebaseFirestore.instance
          .doc('chatRoom/$roomID')
          .get()
          .then((exist) async {
        if (!exist.exists) {
          bool res = await addNewChatRoom(roomID, roomData);
          if (res) debugPrint("chatRoomInsertedSuccessfully...");
        } else {
          bool res = await updateChatRoom(roomID, roomData);
          if (res) debugPrint("chatRoomUpdatedSuccessfully...");
        }
      });
      UserServiceRemoteDataSource.sendNotification(data: {
        'msg': msg,
        'user_id': model.receiverID,
        // 'roomID': roomID,
        // 'senderName': model.senderName,
        // 'type': 'chat'
      });
    } catch (e) {
      debugPrint("addCategoryErrorClient: $e");
      res = false;
    }
    return res;
  }

  Future<Stream<QuerySnapshot<Object?>>> getAllRoomChats(String roomID) async {
    late Stream<QuerySnapshot> snapshots;
    try {
      snapshots = FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(roomID)
          .collection("chats")
          .orderBy('time', descending: true)
          .snapshots();

      // debugPrint("getAllRoomChats..");
    } catch (e) {
      debugPrint("getAllUsersErrorClient: $e");
    }
    return snapshots;
  }
}
