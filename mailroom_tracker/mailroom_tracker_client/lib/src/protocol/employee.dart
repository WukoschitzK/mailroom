/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class Employee implements _i1.SerializableModel {
  Employee._({
    this.id,
    required this.name,
    required this.department,
    required this.isAbsent,
    this.substituteId,
    this.email,
    this.officeNumber,
  });

  factory Employee({
    int? id,
    required String name,
    required String department,
    required bool isAbsent,
    int? substituteId,
    String? email,
    String? officeNumber,
  }) = _EmployeeImpl;

  factory Employee.fromJson(Map<String, dynamic> jsonSerialization) {
    return Employee(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      department: jsonSerialization['department'] as String,
      isAbsent: jsonSerialization['isAbsent'] as bool,
      substituteId: jsonSerialization['substituteId'] as int?,
      email: jsonSerialization['email'] as String?,
      officeNumber: jsonSerialization['officeNumber'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String department;

  bool isAbsent;

  int? substituteId;

  String? email;

  String? officeNumber;

  /// Returns a shallow copy of this [Employee]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Employee copyWith({
    int? id,
    String? name,
    String? department,
    bool? isAbsent,
    int? substituteId,
    String? email,
    String? officeNumber,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'department': department,
      'isAbsent': isAbsent,
      if (substituteId != null) 'substituteId': substituteId,
      if (email != null) 'email': email,
      if (officeNumber != null) 'officeNumber': officeNumber,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmployeeImpl extends Employee {
  _EmployeeImpl({
    int? id,
    required String name,
    required String department,
    required bool isAbsent,
    int? substituteId,
    String? email,
    String? officeNumber,
  }) : super._(
          id: id,
          name: name,
          department: department,
          isAbsent: isAbsent,
          substituteId: substituteId,
          email: email,
          officeNumber: officeNumber,
        );

  /// Returns a shallow copy of this [Employee]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Employee copyWith({
    Object? id = _Undefined,
    String? name,
    String? department,
    bool? isAbsent,
    Object? substituteId = _Undefined,
    Object? email = _Undefined,
    Object? officeNumber = _Undefined,
  }) {
    return Employee(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      department: department ?? this.department,
      isAbsent: isAbsent ?? this.isAbsent,
      substituteId: substituteId is int? ? substituteId : this.substituteId,
      email: email is String? ? email : this.email,
      officeNumber: officeNumber is String? ? officeNumber : this.officeNumber,
    );
  }
}
