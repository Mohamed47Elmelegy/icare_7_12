import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final int id;
  final int userID;
  final int providerID;
  final String title;
  final String transDetails;

  const TransactionEntity(
      {required this.id,
      required this.userID,
      required this.providerID,
      required this.title,
      required this.transDetails});

  @override
  List<Object?> get props => [id, userID, providerID];
}
