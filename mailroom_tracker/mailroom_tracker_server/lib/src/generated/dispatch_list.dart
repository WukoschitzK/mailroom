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

abstract class DispatchList
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = DispatchListTable();

  static const db = DispatchListRepository._();

  @override
  int? id;

  DateTime createdAt;

  String status;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'createdAt': createdAt.toJson(),
      'status': status,
    };
  }

  static DispatchListInclude include() {
    return DispatchListInclude._();
  }

  static DispatchListIncludeList includeList({
    _i1.WhereExpressionBuilder<DispatchListTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DispatchListTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DispatchListTable>? orderByList,
    DispatchListInclude? include,
  }) {
    return DispatchListIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DispatchList.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DispatchList.t),
      include: include,
    );
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

class DispatchListTable extends _i1.Table<int?> {
  DispatchListTable({super.tableRelation})
      : super(tableName: 'dispatch_lists') {
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
  }

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnString status;

  @override
  List<_i1.Column> get columns => [
        id,
        createdAt,
        status,
      ];
}

class DispatchListInclude extends _i1.IncludeObject {
  DispatchListInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => DispatchList.t;
}

class DispatchListIncludeList extends _i1.IncludeList {
  DispatchListIncludeList._({
    _i1.WhereExpressionBuilder<DispatchListTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DispatchList.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => DispatchList.t;
}

class DispatchListRepository {
  const DispatchListRepository._();

  /// Returns a list of [DispatchList]s matching the given query parameters.
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
  Future<List<DispatchList>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DispatchListTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DispatchListTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DispatchListTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<DispatchList>(
      where: where?.call(DispatchList.t),
      orderBy: orderBy?.call(DispatchList.t),
      orderByList: orderByList?.call(DispatchList.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [DispatchList] matching the given query parameters.
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
  Future<DispatchList?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DispatchListTable>? where,
    int? offset,
    _i1.OrderByBuilder<DispatchListTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DispatchListTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<DispatchList>(
      where: where?.call(DispatchList.t),
      orderBy: orderBy?.call(DispatchList.t),
      orderByList: orderByList?.call(DispatchList.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [DispatchList] by its [id] or null if no such row exists.
  Future<DispatchList?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<DispatchList>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [DispatchList]s in the list and returns the inserted rows.
  ///
  /// The returned [DispatchList]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<DispatchList>> insert(
    _i1.Session session,
    List<DispatchList> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<DispatchList>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [DispatchList] and returns the inserted row.
  ///
  /// The returned [DispatchList] will have its `id` field set.
  Future<DispatchList> insertRow(
    _i1.Session session,
    DispatchList row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DispatchList>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DispatchList]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DispatchList>> update(
    _i1.Session session,
    List<DispatchList> rows, {
    _i1.ColumnSelections<DispatchListTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DispatchList>(
      rows,
      columns: columns?.call(DispatchList.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DispatchList]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DispatchList> updateRow(
    _i1.Session session,
    DispatchList row, {
    _i1.ColumnSelections<DispatchListTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DispatchList>(
      row,
      columns: columns?.call(DispatchList.t),
      transaction: transaction,
    );
  }

  /// Deletes all [DispatchList]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DispatchList>> delete(
    _i1.Session session,
    List<DispatchList> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DispatchList>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [DispatchList].
  Future<DispatchList> deleteRow(
    _i1.Session session,
    DispatchList row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DispatchList>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<DispatchList>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<DispatchListTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DispatchList>(
      where: where(DispatchList.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DispatchListTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DispatchList>(
      where: where?.call(DispatchList.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
