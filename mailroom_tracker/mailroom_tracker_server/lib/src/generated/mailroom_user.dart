/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class MailroomUser
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = MailroomUserTable();

  static const db = MailroomUserRepository._();

  @override
  int? id;

  String name;

  String pin;

  String role;

  String location;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'pin': pin,
      'role': role,
      'location': location,
    };
  }

  static MailroomUserInclude include() {
    return MailroomUserInclude._();
  }

  static MailroomUserIncludeList includeList({
    _i1.WhereExpressionBuilder<MailroomUserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MailroomUserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MailroomUserTable>? orderByList,
    MailroomUserInclude? include,
  }) {
    return MailroomUserIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MailroomUser.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(MailroomUser.t),
      include: include,
    );
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

class MailroomUserTable extends _i1.Table<int?> {
  MailroomUserTable({super.tableRelation}) : super(tableName: 'mailroom_user') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    pin = _i1.ColumnString(
      'pin',
      this,
    );
    role = _i1.ColumnString(
      'role',
      this,
    );
    location = _i1.ColumnString(
      'location',
      this,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnString pin;

  late final _i1.ColumnString role;

  late final _i1.ColumnString location;

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        pin,
        role,
        location,
      ];
}

class MailroomUserInclude extends _i1.IncludeObject {
  MailroomUserInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => MailroomUser.t;
}

class MailroomUserIncludeList extends _i1.IncludeList {
  MailroomUserIncludeList._({
    _i1.WhereExpressionBuilder<MailroomUserTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MailroomUser.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => MailroomUser.t;
}

class MailroomUserRepository {
  const MailroomUserRepository._();

  /// Returns a list of [MailroomUser]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<MailroomUser>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MailroomUserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MailroomUserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MailroomUserTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<MailroomUser>(
      where: where?.call(MailroomUser.t),
      orderBy: orderBy?.call(MailroomUser.t),
      orderByList: orderByList?.call(MailroomUser.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [MailroomUser] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<MailroomUser?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MailroomUserTable>? where,
    int? offset,
    _i1.OrderByBuilder<MailroomUserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MailroomUserTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<MailroomUser>(
      where: where?.call(MailroomUser.t),
      orderBy: orderBy?.call(MailroomUser.t),
      orderByList: orderByList?.call(MailroomUser.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [MailroomUser] by its [id] or null if no such row exists.
  Future<MailroomUser?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<MailroomUser>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [MailroomUser]s in the list and returns the inserted rows.
  ///
  /// The returned [MailroomUser]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<MailroomUser>> insert(
    _i1.Session session,
    List<MailroomUser> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<MailroomUser>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [MailroomUser] and returns the inserted row.
  ///
  /// The returned [MailroomUser] will have its `id` field set.
  Future<MailroomUser> insertRow(
    _i1.Session session,
    MailroomUser row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<MailroomUser>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [MailroomUser]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<MailroomUser>> update(
    _i1.Session session,
    List<MailroomUser> rows, {
    _i1.ColumnSelections<MailroomUserTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<MailroomUser>(
      rows,
      columns: columns?.call(MailroomUser.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MailroomUser]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MailroomUser> updateRow(
    _i1.Session session,
    MailroomUser row, {
    _i1.ColumnSelections<MailroomUserTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<MailroomUser>(
      row,
      columns: columns?.call(MailroomUser.t),
      transaction: transaction,
    );
  }

  /// Deletes all [MailroomUser]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<MailroomUser>> delete(
    _i1.Session session,
    List<MailroomUser> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<MailroomUser>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [MailroomUser].
  Future<MailroomUser> deleteRow(
    _i1.Session session,
    MailroomUser row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MailroomUser>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<MailroomUser>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<MailroomUserTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<MailroomUser>(
      where: where(MailroomUser.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MailroomUserTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<MailroomUser>(
      where: where?.call(MailroomUser.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
