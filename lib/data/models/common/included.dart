// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Included<T> {
  final String type;
  final String identifier;
  final T attributes;

  Included({
    required this.type,
    required this.identifier,
    required this.attributes,
  });

  Included<T> copyWith({
    String? type,
    String? identifier,
    T? attributes,
  }) {
    return Included<T>(
      type: type ?? this.type,
      identifier: identifier ?? this.identifier,
      attributes: attributes ?? this.attributes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'identifier': identifier,
      'attributes': (attributes as dynamic).toMap(),
    };
  }

  factory Included.fromMap(
    Map<String, dynamic> map,
    T Function(Map<String, dynamic>) fromMapFn,
  ) {
    return Included<T>(
      type: map['type'] as String,
      identifier: map['identifier'] as String,
      attributes: fromMapFn(map['attributes'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Included.fromJson(
    String source,
    T Function(Map<String, dynamic>) fromMapFn,
  ) =>
      Included.fromMap(json.decode(source) as Map<String, dynamic>, fromMapFn);

  @override
  String toString() =>
      'Included(type: $type, identifier: $identifier, attributes: $attributes)';

  @override
  bool operator ==(covariant Included<T> other) {
    if (identical(this, other)) return true;

    return other.type == type &&
        other.identifier == identifier &&
        other.attributes == attributes;
  }

  @override
  int get hashCode => type.hashCode ^ identifier.hashCode ^ attributes.hashCode;
}
