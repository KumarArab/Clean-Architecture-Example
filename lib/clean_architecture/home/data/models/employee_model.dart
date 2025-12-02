import 'package:cleanarchexample/clean_architecture/home/domain/entities/employee.dart';

class EmployeeModel extends Employee {
  const EmployeeModel({
    super.id,
    super.userId,
    super.title,
    super.body,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    int? parseToInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return EmployeeModel(
      id: parseToInt(json['id']),
      userId: parseToInt(json['userId']),
      title: json['title'] as String?,
      body: json['body'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
    };
  }

  /// Parses a list of JSON objects into a list of EmployeeModel instances
  static List<EmployeeModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => EmployeeModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Creates a copy of this EmployeeModel with the given fields replaced
  EmployeeModel copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EmployeeModel &&
        other.id == id &&
        other.userId == userId &&
        other.title == title &&
        other.body == body;
  }

  @override
  int get hashCode {
    return Object.hash(id, userId, title, body);
  }

  @override
  String toString() {
    return 'EmployeeModel(id: $id, userId: $userId, title: $title, body: $body)';
  }
}
