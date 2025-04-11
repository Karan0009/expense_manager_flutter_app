// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:expense_manager/data/models/category/sub_category.dart';
import 'package:expense_manager/data/models/common/included.dart';
import 'package:flutter/foundation.dart';

import 'package:expense_manager/data/models/common/meta.dart';
import 'package:expense_manager/data/models/transactions/summarized_transaction_data_model.dart';

class SummarizedTransactionList {
  final List<SummarizedTransactionData> data;
  final Meta? meta;
  final List<Included<SubCategory>> included;

  SummarizedTransactionList({
    required this.data,
    required this.included,
    this.meta,
  });

  SummarizedTransactionList copyWith({
    List<SummarizedTransactionData>? data,
    List<Included<SubCategory>>? included,
    Meta? meta,
  }) {
    return SummarizedTransactionList(
      data: data ?? this.data,
      included: included ?? this.included,
      meta: meta ?? this.meta,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': data.map((x) => x.toMap()).toList(),
      'meta': meta?.toMap(),
    };
  }

  factory SummarizedTransactionList.fromMap(Map<String, dynamic> map) {
    return SummarizedTransactionList(
        data: List<SummarizedTransactionData>.from(
          (map['data'] as List).map(
            (x) => SummarizedTransactionData.fromMap(x),
          ),
        ),
        meta: map['meta'] != null
            ? Meta.fromMap(map['meta'] as Map<String, dynamic>)
            : null,
        included: List<Included<SubCategory>>.from(
          (map['data'] as List).map(
            (x) => Included<SubCategory>.fromMap(x, SubCategory.fromMap),
          ),
        ));
  }

  String toJson() => json.encode(toMap());

  factory SummarizedTransactionList.fromJson(String source) =>
      SummarizedTransactionList.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SummarizedTransactionList(data: $data, meta: $meta, included, $included)';

  @override
  bool operator ==(covariant SummarizedTransactionList other) {
    if (identical(this, other)) return true;

    return listEquals(other.data, data) &&
        listEquals(other.included, included) &&
        other.meta == meta;
  }

  @override
  int get hashCode => data.hashCode ^ meta.hashCode ^ included.hashCode;
}
