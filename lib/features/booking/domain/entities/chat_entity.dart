import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String? text, senderID, senderName, receiverID, receiverName, uploadID;
  const MessageEntity(
      {this.text,
      this.senderID,
      this.senderName,
      this.receiverID,
      this.receiverName,
      this.uploadID});

  @override
  List<Object?> get props => [uploadID];
}
