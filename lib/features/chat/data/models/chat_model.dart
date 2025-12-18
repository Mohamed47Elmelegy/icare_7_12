class MessageModel {
  String? text, senderID, senderName, receiverID, receiverName, uploadID;
  MessageModel(
      {this.text,
      this.senderID,
      this.senderName,
      this.receiverID,
      this.receiverName,
      this.uploadID});
}

class ChatRoom {
  String? id;
  String? advisorName, advisorID;
  String? userName, userID;
  List<MessageModel>? chatList;

  ChatRoom({this.id, this.advisorName, this.advisorID, this.chatList});
}
