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

abstract class Employee
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = EmployeeTable();

  static const db = EmployeeRepository._();

  @override
  int? id;

  String name;

  String department;

  bool isAbsent;

  int? substituteId;

  String? email;

  String? officeNumber;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static EmployeeInclude include() {
    return EmployeeInclude._();
  }

  static EmployeeIncludeList includeList({
    _i1.WhereExpressionBuilder<EmployeeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmployeeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmployeeTable>? orderByList,
    EmployeeInclude? include,
  }) {
    return EmployeeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Employee.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Employee.t),
      include: include,
    );
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

class EmployeeTable extends _i1.Table<int?> {
  EmployeeTable({super.tableRelation}) : super(tableName: 'employee') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    department = _i1.ColumnString(
      'department',
      this,
    );
    isAbsent = _i1.ColumnBool(
      'isAbsent',
      this,
    );
    substituteId = _i1.ColumnInt(
      'substituteId',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    officeNumber = _i1.ColumnString(
      'officeNumber',
      this,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnString department;

  late final _i1.ColumnBool isAbsent;

  late final _i1.ColumnInt substituteId;

  late final _i1.ColumnString email;

  late final _i1.ColumnString officeNumber;

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        department,
        isAbsent,
        substituteId,
        email,
        officeNumber,
      ];
}

class EmployeeInclude extends _i1.IncludeObject {
  EmployeeInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Employee.t;
}

class EmployeeIncludeList extends _i1.IncludeList {
  EmployeeIncludeList._({
    _i1.WhereExpressionBuilder<EmployeeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Employee.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Employee.t;
}

class EmployeeRepository {
  const EmployeeRepository._();

  /// Returns a list of [Employee]s matching the given query parameters.
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
  Future<List<Employee>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmployeeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmployeeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmployeeTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Employee>(
      where: where?.call(Employee.t),
      orderBy: orderBy?.call(Employee.t),
      orderByList: orderByList?.call(Employee.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Employee] matching the given query parameters.
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
  Future<Employee?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmployeeTable>? where,
    int? offset,
    _i1.OrderByBuilder<EmployeeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmployeeTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Employee>(
      where: where?.call(Employee.t),
      orderBy: orderBy?.call(Employee.t),
      orderByList: orderByList?.call(Employee.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Employee] by its [id] or null if no such row exists.
  Future<Employee?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Employee>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Employee]s in the list and returns the inserted rows.
  ///
  /// The returned [Employee]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Employee>> insert(
    _i1.Session session,
    List<Employee> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Employee>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Employee] and returns the inserted row.
  ///
  /// The returned [Employee] will have its `id` field set.
  Future<Employee> insertRow(
    _i1.Session session,
    Employee row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Employee>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Employee]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Employee>> update(
    _i1.Session session,
    List<Employee> rows, {
    _i1.ColumnSelections<EmployeeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Employee>(
      rows,
      columns: columns?.call(Employee.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Employee]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Employee> updateRow(
    _i1.Session session,
    Employee row, {
    _i1.ColumnSelections<EmployeeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Employee>(
      row,
      columns: columns?.call(Employee.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Employee]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Employee>> delete(
    _i1.Session session,
    List<Employee> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Employee>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Employee].
  Future<Employee> deleteRow(
    _i1.Session session,
    Employee row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Employee>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Employee>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EmployeeTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Employee>(
      where: where(Employee.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmployeeTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Employee>(
      where: where?.call(Employee.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
