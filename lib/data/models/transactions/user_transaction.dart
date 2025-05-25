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
  final SubCategory? subCategory;
  final int? id;
  UserTransaction({
    required this.userId,
    required this.amount,
    required this.recipientName,
    required this.subCatId,
    required this.transactionDatetime,
    this.subCategory,
    this.id,
  });

  UserTransaction copyWith({
    String? userId,
    String? amount,
    String? recipientName,
    int? subCatId,
    DateTime? transactionDatetime,
    SubCategory? subCategory,
    int? id,
  }) {
    return UserTransaction(
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      recipientName: recipientName ?? this.recipientName,
      subCatId: subCatId ?? this.subCatId,
      transactionDatetime: transactionDatetime ?? this.transactionDatetime,
      subCategory: subCategory ?? this.subCategory,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'amount': amount,
      'recipientName': recipientName,
      'subCatId': subCatId,
      'transactionDatetime': transactionDatetime,
      'subCategory': subCategory?.toMap(),
      'id': id,
    };
  }

  factory UserTransaction.fromMap(Map<String, dynamic> map) {
    final transactionDatetime = DateTime.tryParse(map['transaction_datetime']);
    final subCatId = AppUtils.safeParseInt(map['sub_cat_id']);
    final transactionId = AppUtils.safeParseInt(map['id']);
    return UserTransaction(
      id: transactionId,
      userId: map['user_id'] as String,
      amount: map['amount'] as String,
      recipientName: map['recipient_name'] as String,
      subCatId: subCatId ?? 0,
      transactionDatetime: transactionDatetime,
      subCategory: map['sub_category'] != null
          ? SubCategory.fromMap(map['sub_category'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserTransaction.fromJson(String source) =>
      UserTransaction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserTransaction(id: $id, userId: $userId, amount: $amount, recipientName: $recipientName, subCatId: $subCatId, transactionDatetime: $transactionDatetime, subCategory: $subCategory)';
  }

  @override
  bool operator ==(covariant UserTransaction other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.amount == amount &&
        other.recipientName == recipientName &&
        other.subCatId == subCatId &&
        other.transactionDatetime == transactionDatetime &&
        other.subCategory == subCategory;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        amount.hashCode ^
        recipientName.hashCode ^
        subCatId.hashCode ^
        transactionDatetime.hashCode ^
        subCategory.hashCode;
  }
}
