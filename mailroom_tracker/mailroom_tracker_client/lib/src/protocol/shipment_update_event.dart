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
import 'shipment.dart' as _i2;

abstract class ShipmentUpdateEvent implements _i1.SerializableModel {
  ShipmentUpdateEvent._({
    required this.shipment,
    required this.action,
  });

  factory ShipmentUpdateEvent({
    required _i2.Shipment shipment,
    required String action,
  }) = _ShipmentUpdateEventImpl;

  factory ShipmentUpdateEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return ShipmentUpdateEvent(
      shipment: _i2.Shipment.fromJson(
          (jsonSerialization['shipment'] as Map<String, dynamic>)),
      action: jsonSerialization['action'] as String,
    );
  }

  _i2.Shipment shipment;

  String action;

  /// Returns a shallow copy of this [ShipmentUpdateEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ShipmentUpdateEvent copyWith({
    _i2.Shipment? shipment,
    String? action,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'shipment': shipment.toJson(),
      'action': action,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ShipmentUpdateEventImpl extends ShipmentUpdateEvent {
  _ShipmentUpdateEventImpl({
    required _i2.Shipment shipment,
    required String action,
  }) : super._(
          shipment: shipment,
          action: action,
        );

  /// Returns a shallow copy of this [ShipmentUpdateEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ShipmentUpdateEvent copyWith({
    _i2.Shipment? shipment,
    String? action,
  }) {
    return ShipmentUpdateEvent(
      shipment: shipment ?? this.shipment.copyWith(),
      action: action ?? this.action,
    );
  }
}
