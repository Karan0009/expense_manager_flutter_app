// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:expense_manager/core/helpers/utils.dart';
import 'package:expense_manager/data/models/category/sub_category.dart';

class UserTransaction {
  final String userId;
  final String amount;
  final String recipientName;
  final int subCatId;
  final DateTime? transactionDatetime;
  final SubCategory subCategory;
  UserTransaction({
    required this.userId,
    required this.amount,
    required this.recipientName,
    required this.subCatId,
    required this.transactionDatetime,
    required this.subCategory,
  });

  UserTransaction copyWith({
    String? userId,
    String? amount,
    String? recipientName,
    int? subCatId,
    DateTime? transactionDatetime,
    SubCategory? subCategory,
  }) {
    return UserTransaction(
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      recipientName: recipientName ?? this.recipientName,
      subCatId: subCatId ?? this.subCatId,
      transactionDatetime: transactionDatetime ?? this.transactionDatetime,
      subCategory: subCategory ?? this.subCategory,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'amount': amount,
      'recipientName': recipientName,
      'subCatId': subCatId,
      'transactionDatetime': transactionDatetime,
      'subCategory': subCategory.toMap(),
    };
  }

  factory UserTransaction.fromMap(Map<String, dynamic> map) {
    final transactionDatetime = DateTime.tryParse(map['transaction_datetime']);
    final subCatId = AppUtils.safeParseInt(map['sub_cat_id']);
    return UserTransaction(
      userId: map['user_id'] as String,
      amount: map['amount'] as String,
      recipientName: map['recipient_name'] as String,
      subCatId: subCatId ?? 0,
      transactionDatetime: transactionDatetime,
      subCategory:
          SubCategory.fromMap(map['sub_category'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserTransaction.fromJson(String source) =>
      UserTransaction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserTransaction(userId: $userId, amount: $amount, recipientName: $recipientName, subCatId: $subCatId, transactionDatetime: $transactionDatetime, subCategory: $subCategory)';
  }

  @override
  bool operator ==(covariant UserTransaction other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.amount == amount &&
        other.recipientName == recipientName &&
        other.subCatId == subCatId &&
        other.transactionDatetime == transactionDatetime &&
        other.subCategory == subCategory;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        amount.hashCode ^
        recipientName.hashCode ^
        subCatId.hashCode ^
        transactionDatetime.hashCode ^
        subCategory.hashCode;
  }
}
