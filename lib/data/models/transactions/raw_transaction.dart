// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:expense_manager/core/helpers/utils.dart';

class RawTransaction {
  final String userId;
  final String rawTransactionType;
  final String rawTransactionData;
  String? id;
  String? extractedText;
  int? transactionId;
  String? remark;
  dynamic meta;
  String? status;
  RawTransaction({
    required this.userId,
    required this.rawTransactionType,
    required this.rawTransactionData,
    this.id,
    this.extractedText,
    this.transactionId,
    this.remark,
    this.meta,
    this.status,
  });

  RawTransaction copyWith({
    String? userId,
    String? rawTransactionType,
    String? rawTransactionData,
    String? id,
    String? extractedText,
    int? transactionId,
    String? remark,
    dynamic meta,
    String? status,
  }) {
    return RawTransaction(
      userId: userId ?? this.userId,
      rawTransactionType: rawTransactionType ?? this.rawTransactionType,
      rawTransactionData: rawTransactionData ?? this.rawTransactionData,
      id: id ?? this.id,
      extractedText: extractedText ?? this.extractedText,
      transactionId: transactionId ?? this.transactionId,
      remark: remark ?? this.remark,
      meta: meta ?? this.meta,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'rawTransactionType': rawTransactionType,
      'rawTransactionData': rawTransactionData,
      'id': id,
      'extractedText': extractedText,
      'transactionId': transactionId,
      'remark': remark,
      'meta': meta,
      'status': status,
    };
  }

  factory RawTransaction.fromMap(Map<String, dynamic> map) {
    final parsedTransactionId = AppUtils.safeParseInt(map['transaction_id']);

    return RawTransaction(
      userId: map['user_id'] as String,
      rawTransactionType: map['raw_transaction_type'] as String,
      rawTransactionData: map['raw_transaction_data'] as String,
      id: map['id'] != null ? map['id'] as String : null,
      extractedText: map['extracted_text'] != null
          ? map['extracted_text'] as String
          : null,
      transactionId: parsedTransactionId,
      remark: map['remark'] != null ? map['remark'] as String : null,
      meta: map['meta'] as dynamic,
      status: map['status'] != null ? map['status'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RawTransaction.fromJson(String source) =>
      RawTransaction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RawTransaction(userId: $userId, rawTransactionType: $rawTransactionType, rawTransactionData: $rawTransactionData, id: $id, extractedText: $extractedText, transactionId: $transactionId, remark: $remark, meta: $meta, status: $status)';
  }

  @override
  bool operator ==(covariant RawTransaction other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.rawTransactionType == rawTransactionType &&
        other.rawTransactionData == rawTransactionData &&
        other.id == id &&
        other.extractedText == extractedText &&
        other.transactionId == transactionId &&
        other.remark == remark &&
        other.meta == meta &&
        other.status == status;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        rawTransactionType.hashCode ^
        rawTransactionData.hashCode ^
        id.hashCode ^
        extractedText.hashCode ^
        transactionId.hashCode ^
        remark.hashCode ^
        meta.hashCode ^
        status.hashCode;
  }
}
