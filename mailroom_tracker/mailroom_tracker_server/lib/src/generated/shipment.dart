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

abstract class Shipment
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Shipment._({
    this.id,
    required this.identifier,
    required this.direction,
    required this.type,
    required this.status,
    this.trackingNumber,
    this.recipientText,
    this.recipientId,
    required this.isDamaged,
    required this.imageUrl,
    this.signatureImageUrl,
    required this.scannedAt,
    this.deliveredAt,
    this.note,
    this.createdBy,
    this.deliveredBy,
    this.storageLocation,
    this.auditLog,
  });

  factory Shipment({
    int? id,
    required String identifier,
    required String direction,
    required String type,
    required String status,
    String? trackingNumber,
    String? recipientText,
    int? recipientId,
    required bool isDamaged,
    required String imageUrl,
    String? signatureImageUrl,
    required DateTime scannedAt,
    DateTime? deliveredAt,
    String? note,
    String? createdBy,
    String? deliveredBy,
    String? storageLocation,
    String? auditLog,
  }) = _ShipmentImpl;

  factory Shipment.fromJson(Map<String, dynamic> jsonSerialization) {
    return Shipment(
      id: jsonSerialization['id'] as int?,
      identifier: jsonSerialization['identifier'] as String,
      direction: jsonSerialization['direction'] as String,
      type: jsonSerialization['type'] as String,
      status: jsonSerialization['status'] as String,
      trackingNumber: jsonSerialization['trackingNumber'] as String?,
      recipientText: jsonSerialization['recipientText'] as String?,
      recipientId: jsonSerialization['recipientId'] as int?,
      isDamaged: jsonSerialization['isDamaged'] as bool,
      imageUrl: jsonSerialization['imageUrl'] as String,
      signatureImageUrl: jsonSerialization['signatureImageUrl'] as String?,
      scannedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['scannedAt']),
      deliveredAt: jsonSerialization['deliveredAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['deliveredAt']),
      note: jsonSerialization['note'] as String?,
      createdBy: jsonSerialization['createdBy'] as String?,
      deliveredBy: jsonSerialization['deliveredBy'] as String?,
      storageLocation: jsonSerialization['storageLocation'] as String?,
      auditLog: jsonSerialization['auditLog'] as String?,
    );
  }

  static final t = ShipmentTable();

  static const db = ShipmentRepository._();

  @override
  int? id;

  String identifier;

  String direction;

  String type;

  String status;

  String? trackingNumber;

  String? recipientText;

  int? recipientId;

  bool isDamaged;

  String imageUrl;

  String? signatureImageUrl;

  DateTime scannedAt;

  DateTime? deliveredAt;

  String? note;

  String? createdBy;

  String? deliveredBy;

  String? storageLocation;

  String? auditLog;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Shipment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Shipment copyWith({
    int? id,
    String? identifier,
    String? direction,
    String? type,
    String? status,
    String? trackingNumber,
    String? recipientText,
    int? recipientId,
    bool? isDamaged,
    String? imageUrl,
    String? signatureImageUrl,
    DateTime? scannedAt,
    DateTime? deliveredAt,
    String? note,
    String? createdBy,
    String? deliveredBy,
    String? storageLocation,
    String? auditLog,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'identifier': identifier,
      'direction': direction,
      'type': type,
      'status': status,
      if (trackingNumber != null) 'trackingNumber': trackingNumber,
      if (recipientText != null) 'recipientText': recipientText,
      if (recipientId != null) 'recipientId': recipientId,
      'isDamaged': isDamaged,
      'imageUrl': imageUrl,
      if (signatureImageUrl != null) 'signatureImageUrl': signatureImageUrl,
      'scannedAt': scannedAt.toJson(),
      if (deliveredAt != null) 'deliveredAt': deliveredAt?.toJson(),
      if (note != null) 'note': note,
      if (createdBy != null) 'createdBy': createdBy,
      if (deliveredBy != null) 'deliveredBy': deliveredBy,
      if (storageLocation != null) 'storageLocation': storageLocation,
      if (auditLog != null) 'auditLog': auditLog,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'identifier': identifier,
      'direction': direction,
      'type': type,
      'status': status,
      if (trackingNumber != null) 'trackingNumber': trackingNumber,
      if (recipientText != null) 'recipientText': recipientText,
      if (recipientId != null) 'recipientId': recipientId,
      'isDamaged': isDamaged,
      'imageUrl': imageUrl,
      if (signatureImageUrl != null) 'signatureImageUrl': signatureImageUrl,
      'scannedAt': scannedAt.toJson(),
      if (deliveredAt != null) 'deliveredAt': deliveredAt?.toJson(),
      if (note != null) 'note': note,
      if (createdBy != null) 'createdBy': createdBy,
      if (deliveredBy != null) 'deliveredBy': deliveredBy,
      if (storageLocation != null) 'storageLocation': storageLocation,
      if (auditLog != null) 'auditLog': auditLog,
    };
  }

  static ShipmentInclude include() {
    return ShipmentInclude._();
  }

  static ShipmentIncludeList includeList({
    _i1.WhereExpressionBuilder<ShipmentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShipmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShipmentTable>? orderByList,
    ShipmentInclude? include,
  }) {
    return ShipmentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Shipment.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Shipment.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ShipmentImpl extends Shipment {
  _ShipmentImpl({
    int? id,
    required String identifier,
    required String direction,
    required String type,
    required String status,
    String? trackingNumber,
    String? recipientText,
    int? recipientId,
    required bool isDamaged,
    required String imageUrl,
    String? signatureImageUrl,
    required DateTime scannedAt,
    DateTime? deliveredAt,
    String? note,
    String? createdBy,
    String? deliveredBy,
    String? storageLocation,
    String? auditLog,
  }) : super._(
          id: id,
          identifier: identifier,
          direction: direction,
          type: type,
          status: status,
          trackingNumber: trackingNumber,
          recipientText: recipientText,
          recipientId: recipientId,
          isDamaged: isDamaged,
          imageUrl: imageUrl,
          signatureImageUrl: signatureImageUrl,
          scannedAt: scannedAt,
          deliveredAt: deliveredAt,
          note: note,
          createdBy: createdBy,
          deliveredBy: deliveredBy,
          storageLocation: storageLocation,
          auditLog: auditLog,
        );

  /// Returns a shallow copy of this [Shipment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Shipment copyWith({
    Object? id = _Undefined,
    String? identifier,
    String? direction,
    String? type,
    String? status,
    Object? trackingNumber = _Undefined,
    Object? recipientText = _Undefined,
    Object? recipientId = _Undefined,
    bool? isDamaged,
    String? imageUrl,
    Object? signatureImageUrl = _Undefined,
    DateTime? scannedAt,
    Object? deliveredAt = _Undefined,
    Object? note = _Undefined,
    Object? createdBy = _Undefined,
    Object? deliveredBy = _Undefined,
    Object? storageLocation = _Undefined,
    Object? auditLog = _Undefined,
  }) {
    return Shipment(
      id: id is int? ? id : this.id,
      identifier: identifier ?? this.identifier,
      direction: direction ?? this.direction,
      type: type ?? this.type,
      status: status ?? this.status,
      trackingNumber:
          trackingNumber is String? ? trackingNumber : this.trackingNumber,
      recipientText:
          recipientText is String? ? recipientText : this.recipientText,
      recipientId: recipientId is int? ? recipientId : this.recipientId,
      isDamaged: isDamaged ?? this.isDamaged,
      imageUrl: imageUrl ?? this.imageUrl,
      signatureImageUrl: signatureImageUrl is String?
          ? signatureImageUrl
          : this.signatureImageUrl,
      scannedAt: scannedAt ?? this.scannedAt,
      deliveredAt: deliveredAt is DateTime? ? deliveredAt : this.deliveredAt,
      note: note is String? ? note : this.note,
      createdBy: createdBy is String? ? createdBy : this.createdBy,
      deliveredBy: deliveredBy is String? ? deliveredBy : this.deliveredBy,
      storageLocation:
          storageLocation is String? ? storageLocation : this.storageLocation,
      auditLog: auditLog is String? ? auditLog : this.auditLog,
    );
  }
}

class ShipmentTable extends _i1.Table<int?> {
  ShipmentTable({super.tableRelation}) : super(tableName: 'shipment') {
    identifier = _i1.ColumnString(
      'identifier',
      this,
    );
    direction = _i1.ColumnString(
      'direction',
      this,
    );
    type = _i1.ColumnString(
      'type',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    trackingNumber = _i1.ColumnString(
      'trackingNumber',
      this,
    );
    recipientText = _i1.ColumnString(
      'recipientText',
      this,
    );
    recipientId = _i1.ColumnInt(
      'recipientId',
      this,
    );
    isDamaged = _i1.ColumnBool(
      'isDamaged',
      this,
    );
    imageUrl = _i1.ColumnString(
      'imageUrl',
      this,
    );
    signatureImageUrl = _i1.ColumnString(
      'signatureImageUrl',
      this,
    );
    scannedAt = _i1.ColumnDateTime(
      'scannedAt',
      this,
    );
    deliveredAt = _i1.ColumnDateTime(
      'deliveredAt',
      this,
    );
    note = _i1.ColumnString(
      'note',
      this,
    );
    createdBy = _i1.ColumnString(
      'createdBy',
      this,
    );
    deliveredBy = _i1.ColumnString(
      'deliveredBy',
      this,
    );
    storageLocation = _i1.ColumnString(
      'storageLocation',
      this,
    );
    auditLog = _i1.ColumnString(
      'auditLog',
      this,
    );
  }

  late final _i1.ColumnString identifier;

  late final _i1.ColumnString direction;

  late final _i1.ColumnString type;

  late final _i1.ColumnString status;

  late final _i1.ColumnString trackingNumber;

  late final _i1.ColumnString recipientText;

  late final _i1.ColumnInt recipientId;

  late final _i1.ColumnBool isDamaged;

  late final _i1.ColumnString imageUrl;

  late final _i1.ColumnString signatureImageUrl;

  late final _i1.ColumnDateTime scannedAt;

  late final _i1.ColumnDateTime deliveredAt;

  late final _i1.ColumnString note;

  late final _i1.ColumnString createdBy;

  late final _i1.ColumnString deliveredBy;

  late final _i1.ColumnString storageLocation;

  late final _i1.ColumnString auditLog;

  @override
  List<_i1.Column> get columns => [
        id,
        identifier,
        direction,
        type,
        status,
        trackingNumber,
        recipientText,
        recipientId,
        isDamaged,
        imageUrl,
        signatureImageUrl,
        scannedAt,
        deliveredAt,
        note,
        createdBy,
        deliveredBy,
        storageLocation,
        auditLog,
      ];
}

class ShipmentInclude extends _i1.IncludeObject {
  ShipmentInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Shipment.t;
}

class ShipmentIncludeList extends _i1.IncludeList {
  ShipmentIncludeList._({
    _i1.WhereExpressionBuilder<ShipmentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Shipment.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Shipment.t;
}

class ShipmentRepository {
  const ShipmentRepository._();

  /// Returns a list of [Shipment]s matching the given query parameters.
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
  Future<List<Shipment>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShipmentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShipmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShipmentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Shipment>(
      where: where?.call(Shipment.t),
      orderBy: orderBy?.call(Shipment.t),
      orderByList: orderByList?.call(Shipment.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Shipment] matching the given query parameters.
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
  Future<Shipment?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShipmentTable>? where,
    int? offset,
    _i1.OrderByBuilder<ShipmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShipmentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Shipment>(
      where: where?.call(Shipment.t),
      orderBy: orderBy?.call(Shipment.t),
      orderByList: orderByList?.call(Shipment.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Shipment] by its [id] or null if no such row exists.
  Future<Shipment?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Shipment>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Shipment]s in the list and returns the inserted rows.
  ///
  /// The returned [Shipment]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Shipment>> insert(
    _i1.Session session,
    List<Shipment> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Shipment>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Shipment] and returns the inserted row.
  ///
  /// The returned [Shipment] will have its `id` field set.
  Future<Shipment> insertRow(
    _i1.Session session,
    Shipment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Shipment>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Shipment]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Shipment>> update(
    _i1.Session session,
    List<Shipment> rows, {
    _i1.ColumnSelections<ShipmentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Shipment>(
      rows,
      columns: columns?.call(Shipment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Shipment]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Shipment> updateRow(
    _i1.Session session,
    Shipment row, {
    _i1.ColumnSelections<ShipmentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Shipment>(
      row,
      columns: columns?.call(Shipment.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Shipment]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Shipment>> delete(
    _i1.Session session,
    List<Shipment> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Shipment>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Shipment].
  Future<Shipment> deleteRow(
    _i1.Session session,
    Shipment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Shipment>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Shipment>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ShipmentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Shipment>(
      where: where(Shipment.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShipmentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Shipment>(
      where: where?.call(Shipment.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
