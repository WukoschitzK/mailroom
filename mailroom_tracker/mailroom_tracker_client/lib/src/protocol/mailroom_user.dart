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

abstract class MailroomUser implements _i1.SerializableModel {
  MailroomUser._({
    this.id,
    required this.name,
    required this.pin,
    required this.role,
    required this.location,
  });

  factory MailroomUser({
    int? id,
    required String name,
    required String pin,
    required String role,
    required String location,
  }) = _MailroomUserImpl;

  factory MailroomUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return MailroomUser(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      pin: jsonSerialization['pin'] as String,
      role: jsonSerialization['role'] as String,
      location: jsonSerialization['location'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String pin;

  String role;

  String location;

  /// Returns a shallow copy of this [MailroomUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MailroomUser copyWith({
    int? id,
    String? name,
    String? pin,
    String? role,
    String? location,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'pin': pin,
      'role': role,
      'location': location,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MailroomUserImpl extends MailroomUser {
  _MailroomUserImpl({
    int? id,
    required String name,
    required String pin,
    required String role,
    required String location,
  }) : super._(
          id: id,
          name: name,
          pin: pin,
          role: role,
          location: location,
        );

  /// Returns a shallow copy of this [MailroomUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MailroomUser copyWith({
    Object? id = _Undefined,
    String? name,
    String? pin,
    String? role,
    String? location,
  }) {
    return MailroomUser(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      pin: pin ?? this.pin,
      role: role ?? this.role,
      location: location ?? this.location,
    );
  }
}
