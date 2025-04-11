// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:expense_manager/data/models/common/meta.dart';

class ApiResponse<D, T> {
  final D data;
  final Meta meta;
  final bool isDataList;

  ApiResponse({
    required this.data,
    required this.meta,
    this.isDataList = true,
  });

  ApiResponse<D, T> copyWith({
    D? data,
    Meta? meta,
  }) {
    return ApiResponse<D, T>(
      data: data ?? this.data,
      meta: meta ?? this.meta,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': _dataToMap(data),
      'meta': meta.toMap(),
    };
  }

  dynamic _dataToMap(dynamic data) {
    if (isDataList) {
      return data.map((e) => (e as dynamic).toMap()).toList();
    } else {
      return (data as dynamic).toMap();
    }
  }

  factory ApiResponse.fromMap(
      Map<String, dynamic> map, T Function(Map<String, dynamic> map) fromMapFn,
      {bool isDataList = true}) {
    dynamic parsedData;
    if (map['data'] is List && isDataList) {
      parsedData = List.from(map['data'])
          .map((item) => fromMapFn(item as Map<String, dynamic>))
          .toList();
    } else {
      parsedData = fromMapFn((map['data'] as Map<String, dynamic>));
    }

    return ApiResponse<D, T>(
      data: parsedData as D,
      meta: Meta.fromMap(map['meta'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ApiResponse.fromJson(
          String source, T Function(Map<String, dynamic> map) fromMapFn) =>
      ApiResponse.fromMap(
          json.decode(source) as Map<String, dynamic>, fromMapFn);

  @override
  String toString() => 'ApiResponse(data: $data, meta: $meta)';

  @override
  bool operator ==(covariant ApiResponse<D, T> other) {
    if (identical(this, other)) return true;

    return other.data == data && other.meta == meta;
  }

  @override
  int get hashCode => data.hashCode ^ meta.hashCode;
}
