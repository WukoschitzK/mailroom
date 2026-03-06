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
import 'greeting.dart' as _i2;
import 'dispatch_list.dart' as _i3;
import 'employee.dart' as _i4;
import 'mailroom_user.dart' as _i5;
import 'shipment.dart' as _i6;
import 'shipment_update_event.dart' as _i7;
import 'package:mailroom_tracker_client/src/protocol/shipment.dart' as _i8;
export 'greeting.dart';
export 'dispatch_list.dart';
export 'employee.dart';
export 'mailroom_user.dart';
export 'shipment.dart';
export 'shipment_update_event.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i2.Greeting) {
      return _i2.Greeting.fromJson(data) as T;
    }
    if (t == _i3.DispatchList) {
      return _i3.DispatchList.fromJson(data) as T;
    }
    if (t == _i4.Employee) {
      return _i4.Employee.fromJson(data) as T;
    }
    if (t == _i5.MailroomUser) {
      return _i5.MailroomUser.fromJson(data) as T;
    }
    if (t == _i6.Shipment) {
      return _i6.Shipment.fromJson(data) as T;
    }
    if (t == _i7.ShipmentUpdateEvent) {
      return _i7.ShipmentUpdateEvent.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Greeting?>()) {
      return (data != null ? _i2.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.DispatchList?>()) {
      return (data != null ? _i3.DispatchList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.Employee?>()) {
      return (data != null ? _i4.Employee.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.MailroomUser?>()) {
      return (data != null ? _i5.MailroomUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Shipment?>()) {
      return (data != null ? _i6.Shipment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.ShipmentUpdateEvent?>()) {
      return (data != null ? _i7.ShipmentUpdateEvent.fromJson(data) : null)
          as T;
    }
    if (t == List<_i8.Shipment>) {
      return (data as List).map((e) => deserialize<_i8.Shipment>(e)).toList()
          as T;
    }
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.Greeting) {
      return 'Greeting';
    }
    if (data is _i3.DispatchList) {
      return 'DispatchList';
    }
    if (data is _i4.Employee) {
      return 'Employee';
    }
    if (data is _i5.MailroomUser) {
      return 'MailroomUser';
    }
    if (data is _i6.Shipment) {
      return 'Shipment';
    }
    if (data is _i7.ShipmentUpdateEvent) {
      return 'ShipmentUpdateEvent';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i2.Greeting>(data['data']);
    }
    if (dataClassName == 'DispatchList') {
      return deserialize<_i3.DispatchList>(data['data']);
    }
    if (dataClassName == 'Employee') {
      return deserialize<_i4.Employee>(data['data']);
    }
    if (dataClassName == 'MailroomUser') {
      return deserialize<_i5.MailroomUser>(data['data']);
    }
    if (dataClassName == 'Shipment') {
      return deserialize<_i6.Shipment>(data['data']);
    }
    if (dataClassName == 'ShipmentUpdateEvent') {
      return deserialize<_i7.ShipmentUpdateEvent>(data['data']);
    }
    return super.deserializeByClassName(data);
  }
}
