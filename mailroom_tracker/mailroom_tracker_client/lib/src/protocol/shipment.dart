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

abstract class Shipment implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
