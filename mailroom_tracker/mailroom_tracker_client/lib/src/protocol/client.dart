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
import 'dart:async' as _i2;
import 'package:mailroom_tracker_client/src/protocol/mailroom_user.dart' as _i3;
import 'package:mailroom_tracker_client/src/protocol/shipment.dart' as _i4;
import 'dart:typed_data' as _i5;
import 'package:mailroom_tracker_client/src/protocol/greeting.dart' as _i6;
import 'protocol.dart' as _i7;

/// {@category Endpoint}
class EndpointAuth extends _i1.EndpointRef {
  EndpointAuth(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'auth';

  _i2.Future<_i3.MailroomUser?> login(String pin) =>
      caller.callServerEndpoint<_i3.MailroomUser?>(
        'auth',
        'login',
        {'pin': pin},
      );

  _i2.Future<void> seedUsers() => caller.callServerEndpoint<void>(
        'auth',
        'seedUsers',
        {},
      );
}

/// {@category Endpoint}
class EndpointShipment extends _i1.EndpointRef {
  EndpointShipment(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'shipment';

  _i2.Future<_i4.Shipment> createShipment(_i4.Shipment shipment) =>
      caller.callServerEndpoint<_i4.Shipment>(
        'shipment',
        'createShipment',
        {'shipment': shipment},
      );

  _i2.Future<List<_i4.Shipment>> getAllShipments() =>
      caller.callServerEndpoint<List<_i4.Shipment>>(
        'shipment',
        'getAllShipments',
        {},
      );

  _i2.Future<_i4.Shipment> analyzePackage(
    String imageUrl,
    String createdBy,
    String scannedBarcode,
    String storageLocation,
  ) =>
      caller.callServerEndpoint<_i4.Shipment>(
        'shipment',
        'analyzePackage',
        {
          'imageUrl': imageUrl,
          'createdBy': createdBy,
          'scannedBarcode': scannedBarcode,
          'storageLocation': storageLocation,
        },
      );

  _i2.Future<_i4.Shipment> saveAnalyzedShipment(_i4.Shipment shipment) =>
      caller.callServerEndpoint<_i4.Shipment>(
        'shipment',
        'saveAnalyzedShipment',
        {'shipment': shipment},
      );

  _i2.Future<_i4.Shipment> updateShipmentDetails(
          _i4.Shipment updatedShipment) =>
      caller.callServerEndpoint<_i4.Shipment>(
        'shipment',
        'updateShipmentDetails',
        {'updatedShipment': updatedShipment},
      );

  _i2.Future<_i4.Shipment> deliverPackage(
    int shipmentId,
    String signatureUrl,
    String deliveredBy,
  ) =>
      caller.callServerEndpoint<_i4.Shipment>(
        'shipment',
        'deliverPackage',
        {
          'shipmentId': shipmentId,
          'signatureUrl': signatureUrl,
          'deliveredBy': deliveredBy,
        },
      );

  _i2.Future<String?> uploadImage(
    _i5.ByteData byteData,
    String fileName,
  ) =>
      caller.callServerEndpoint<String?>(
        'shipment',
        'uploadImage',
        {
          'byteData': byteData,
          'fileName': fileName,
        },
      );

  _i2.Future<void> seedDatabase() => caller.callServerEndpoint<void>(
        'shipment',
        'seedDatabase',
        {},
      );

  _i2.Future<String?> resolveEmployeeDetails(String name) =>
      caller.callServerEndpoint<String?>(
        'shipment',
        'resolveEmployeeDetails',
        {'name': name},
      );
}

/// This is an example endpoint that returns a greeting message through its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i1.EndpointRef {
  EndpointGreeting(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i2.Future<_i6.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i6.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )? onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
          host,
          _i7.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    auth = EndpointAuth(this);
    shipment = EndpointShipment(this);
    greeting = EndpointGreeting(this);
  }

  late final EndpointAuth auth;

  late final EndpointShipment shipment;

  late final EndpointGreeting greeting;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'auth': auth,
        'shipment': shipment,
        'greeting': greeting,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {};
}
