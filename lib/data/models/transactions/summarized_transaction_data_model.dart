// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class SummarizedTransactionData {
  final String type;
  final Map<String, dynamic> attributes;
  final Map<String, dynamic> relationships;

  SummarizedTransactionData({
    required this.type,
    required this.attributes,
    required this.relationships,
  });

  SummarizedTransactionData copyWith({
    String? type,
    Map<String, dynamic>? attributes,
    Map<String, dynamic>? relationships,
  }) {
    return SummarizedTransactionData(
      type: type ?? this.type,
      attributes: attributes ?? this.attributes,
      relationships: relationships ?? this.relationships,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'attributes': attributes,
      'relationships': relationships,
    };
  }

  factory SummarizedTransactionData.fromMap(Map<String, dynamic> map) {
    return SummarizedTransactionData(
      type: map['type'] as String,
      attributes:
          Map<String, dynamic>.from(map['attributes'] as Map<String, dynamic>),
      relationships: Map<String, dynamic>.from(
          map['relationships'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory SummarizedTransactionData.fromJson(String source) =>
      SummarizedTransactionData.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SummarizedTransactionData(type: $type, attributes: $attributes, relationships: $relationships)';

  @override
  bool operator ==(covariant SummarizedTransactionData other) {
    if (identical(this, other)) return true;

    return other.type == type &&
        mapEquals(other.attributes, attributes) &&
        mapEquals(other.relationships, relationships);
  }

  @override
  int get hashCode =>
      type.hashCode ^ attributes.hashCode ^ relationships.hashCode;
}
