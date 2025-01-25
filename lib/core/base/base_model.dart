abstract class BaseModel {
  /// Convert the model instance to JSON.
  Map<String, dynamic> toJson();

  /// Factory method to create a model instance from JSON.
  /// This needs to be overridden in subclasses.
  factory BaseModel.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError(
        "BaseModel.fromJson must be implemented in the subclass.");
  }

  /// Compare two models for equality based on their JSON representations.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    return other is BaseModel &&
        toJson().toString() == other.toJson().toString();
  }

  /// Generate a hash code based on the JSON representation.
  @override
  int get hashCode => toJson().toString().hashCode;

  /// Create a deep copy of the model by serializing and deserializing it.
  BaseModel clone() {
    return BaseModel.fromJson(toJson());
  }
}
