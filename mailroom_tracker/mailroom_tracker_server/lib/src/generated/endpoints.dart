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
import '../endpoints/auth_endpoint.dart' as _i2;
import '../endpoints/shipment_endpoint.dart' as _i3;
import '../greeting_endpoint.dart' as _i4;
import 'package:mailroom_tracker_server/src/generated/shipment.dart' as _i5;
import 'dart:typed_data' as _i6;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'auth': _i2.AuthEndpoint()
        ..initialize(
          server,
          'auth',
          null,
        ),
      'shipment': _i3.ShipmentEndpoint()
        ..initialize(
          server,
          'shipment',
          null,
        ),
      'greeting': _i4.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['auth'] = _i1.EndpointConnector(
      name: 'auth',
      endpoint: endpoints['auth']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'pin': _i1.ParameterDescription(
              name: 'pin',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['auth'] as _i2.AuthEndpoint).login(
            session,
            params['pin'],
          ),
        ),
        'seedUsers': _i1.MethodConnector(
          name: 'seedUsers',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['auth'] as _i2.AuthEndpoint).seedUsers(session),
        ),
      },
    );
    connectors['shipment'] = _i1.EndpointConnector(
      name: 'shipment',
      endpoint: endpoints['shipment']!,
      methodConnectors: {
        'createShipment': _i1.MethodConnector(
          name: 'createShipment',
          params: {
            'shipment': _i1.ParameterDescription(
              name: 'shipment',
              type: _i1.getType<_i5.Shipment>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['shipment'] as _i3.ShipmentEndpoint).createShipment(
            session,
            params['shipment'],
          ),
        ),
        'getAllShipments': _i1.MethodConnector(
          name: 'getAllShipments',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['shipment'] as _i3.ShipmentEndpoint)
                  .getAllShipments(session),
        ),
        'analyzePackage': _i1.MethodConnector(
          name: 'analyzePackage',
          params: {
            'imageUrl': _i1.ParameterDescription(
              name: 'imageUrl',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'createdBy': _i1.ParameterDescription(
              name: 'createdBy',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'scannedBarcode': _i1.ParameterDescription(
              name: 'scannedBarcode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'storageLocation': _i1.ParameterDescription(
              name: 'storageLocation',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['shipment'] as _i3.ShipmentEndpoint).analyzePackage(
            session,
            params['imageUrl'],
            params['createdBy'],
            params['scannedBarcode'],
            params['storageLocation'],
          ),
        ),
        'saveAnalyzedShipment': _i1.MethodConnector(
          name: 'saveAnalyzedShipment',
          params: {
            'shipment': _i1.ParameterDescription(
              name: 'shipment',
              type: _i1.getType<_i5.Shipment>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['shipment'] as _i3.ShipmentEndpoint)
                  .saveAnalyzedShipment(
            session,
            params['shipment'],
          ),
        ),
        'updateShipmentDetails': _i1.MethodConnector(
          name: 'updateShipmentDetails',
          params: {
            'updatedShipment': _i1.ParameterDescription(
              name: 'updatedShipment',
              type: _i1.getType<_i5.Shipment>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['shipment'] as _i3.ShipmentEndpoint)
                  .updateShipmentDetails(
            session,
            params['updatedShipment'],
          ),
        ),
        'deliverPackage': _i1.MethodConnector(
          name: 'deliverPackage',
          params: {
            'shipmentId': _i1.ParameterDescription(
              name: 'shipmentId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'signatureUrl': _i1.ParameterDescription(
              name: 'signatureUrl',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'deliveredBy': _i1.ParameterDescription(
              name: 'deliveredBy',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['shipment'] as _i3.ShipmentEndpoint).deliverPackage(
            session,
            params['shipmentId'],
            params['signatureUrl'],
            params['deliveredBy'],
          ),
        ),
        'uploadImage': _i1.MethodConnector(
          name: 'uploadImage',
          params: {
            'byteData': _i1.ParameterDescription(
              name: 'byteData',
              type: _i1.getType<_i6.ByteData>(),
              nullable: false,
            ),
            'fileName': _i1.ParameterDescription(
              name: 'fileName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['shipment'] as _i3.ShipmentEndpoint).uploadImage(
            session,
            params['byteData'],
            params['fileName'],
          ),
        ),
        'seedDatabase': _i1.MethodConnector(
          name: 'seedDatabase',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['shipment'] as _i3.ShipmentEndpoint)
                  .seedDatabase(session),
        ),
        'resolveEmployeeDetails': _i1.MethodConnector(
          name: 'resolveEmployeeDetails',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['shipment'] as _i3.ShipmentEndpoint)
                  .resolveEmployeeDetails(
            session,
            params['name'],
          ),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['greeting'] as _i4.GreetingEndpoint).hello(
            session,
            params['name'],
          ),
        )
      },
    );
  }
}
