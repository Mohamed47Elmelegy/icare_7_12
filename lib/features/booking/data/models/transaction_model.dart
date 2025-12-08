import 'dart:convert';

import 'package:icare/features/booking/domain/entities/transaction.dart';

class TransactionModel extends TransactionEntity{
  const TransactionModel({required super.id, required super.userID, required super.title, required super.transDetails, required super.providerID});

  static List<TransactionModel> transactionListFromJson(String str) =>
      List<TransactionModel>.from(
          json.decode(str).map((x) => TransactionModel.fromJson(x)));

  static TransactionModel fromJson(Map<String, dynamic> jsonObject) {
    return TransactionModel(
      id: jsonObject['id'],
      userID: jsonObject['user_id'],
      providerID: jsonObject['provider_id'],
      title: jsonObject['title'],
      transDetails: jsonObject['transaction_details'] ?? "",
    );
  }
}