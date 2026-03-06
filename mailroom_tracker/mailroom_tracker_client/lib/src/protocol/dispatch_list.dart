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

abstract class DispatchList implements _i1.SerializableModel {
  DispatchList._({
    this.id,
    required this.createdAt,
    required this.status,
  });

  factory DispatchList({
    int? id,
    required DateTime createdAt,
    required String status,
  }) = _DispatchListImpl;

  factory DispatchList.fromJson(Map<String, dynamic> jsonSerialization) {
    return DispatchList(
      id: jsonSerialization['id'] as int?,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      status: jsonSerialization['status'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  DateTime createdAt;

  String status;

  /// Returns a shallow copy of this [DispatchList]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DispatchList copyWith({
    int? id,
    DateTime? createdAt,
    String? status,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'createdAt': createdAt.toJson(),
      'status': status,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DispatchListImpl extends DispatchList {
  _DispatchListImpl({
    int? id,
    required DateTime createdAt,
    required String status,
  }) : super._(
          id: id,
          createdAt: createdAt,
          status: status,
        );

  /// Returns a shallow copy of this [DispatchList]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DispatchList copyWith({
    Object? id = _Undefined,
    DateTime? createdAt,
    String? status,
  }) {
    return DispatchList(
      id: id is int? ? id : this.id,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}
