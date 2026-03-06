import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:mailroom_tracker_client/mailroom_tracker_client.dart';
import '../globals.dart';
import '../widgets/ui_components.dart';

// ==========================================
// SHIPMENT DETAIL VIEW
// ==========================================
class ShipmentDetailView extends StatefulWidget {
  final int shipmentId;
  final VoidCallback onBack;

  const ShipmentDetailView(
      {super.key, required this.shipmentId, required this.onBack});

  @override
  State<ShipmentDetailView> createState() => _ShipmentDetailViewState();
}

class _ShipmentDetailViewState extends State<ShipmentDetailView> {
  bool _isEditing = false;
  bool _isSaving = false;
  bool _isMagicWandLoading = false;

  final FocusNode _locationFocusNode = FocusNode();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _trackingCtrl = TextEditingController();
  final TextEditingController _locationCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();
  final TextEditingController _recipNameCtrl = TextEditingController();
  final TextEditingController _recipDeptCtrl = TextEditingController();
  final TextEditingController _recipOrtCtrl = TextEditingController();
  final TextEditingController _recipEmailCtrl = TextEditingController();

  Shipment? _currentShipment;

  @override
  void dispose() {
    _locationFocusNode.dispose();
    _nameCtrl.dispose();
    _trackingCtrl.dispose();
    _locationCtrl.dispose();
    _noteCtrl.dispose();
    _recipNameCtrl.dispose();
    _recipDeptCtrl.dispose();
    _recipOrtCtrl.dispose();
    _recipEmailCtrl.dispose();
    super.dispose();
  }

  void _startEditing(Shipment shipment) {
    final parsed = parseRecipientDetails(shipment.recipientText ?? '');
    _recipNameCtrl.text = parsed['name']!;
    _recipDeptCtrl.text = parsed['abteilung']!;
    _recipOrtCtrl.text = parsed['ort']!;
    _recipEmailCtrl.text = parsed['email']!;
    _nameCtrl.text = shipment.identifier;
    _trackingCtrl.text = shipment.trackingNumber ?? '';
    _locationCtrl.text = shipment.storageLocation ?? '';
    _noteCtrl.text = shipment.note ?? '';
    setState(() => _isEditing = true);
  }

  Future<void> _lookupEmployee() async {
    final queryName = _recipNameCtrl.text.trim();
    if (queryName.isEmpty) return;
    setState(() => _isMagicWandLoading = true);
    try {
      final resultText =
          await client.shipment.resolveEmployeeDetails(queryName);
      if (resultText != null) {
        final parsed = parseRecipientDetails(resultText);
        setState(() {
          _recipNameCtrl.text = parsed['name']!;
          _recipDeptCtrl.text = parsed['abteilung']!;
          _recipOrtCtrl.text = parsed['ort']!;
          _recipEmailCtrl.text = parsed['email']!;
        });
        if (mounted) {
          ShadToaster.of(context)
              .show(const ShadToast(title: Text('✨ Mitarbeiter gefunden')));
        }
      } else {
        if (mounted) {
          ShadToaster.of(context)
              .show(const ShadToast(title: Text('❌ Nicht gefunden')));
        }
      }
    } catch (e) {
      debugPrint("Magic Wand Fehler: $e");
    } finally {
      setState(() => _isMagicWandLoading = false);
    }
  }

  Future<void> _saveChanges() async {
    if (_currentShipment == null) return;
    setState(() => _isSaving = true);
    try {
      final old = _currentShipment!;
      final userName = currentUserSignal.value?.name ?? 'Unbekannt';
      final now = DateTime.now().toString().substring(0, 16);

      String assembledText = '${_recipNameCtrl.text}\n';
      if (_recipDeptCtrl.text.contains('👉') ||
          _recipDeptCtrl.text.contains('❌')) {
        final split = _recipDeptCtrl.text.split('\n');
        assembledText += '${split[0]}\n';
        assembledText += split.length > 1
            ? '🏢 ${split[1]} | ${_recipOrtCtrl.text}\n'
            : '🏢 Unbekannt | ${_recipOrtCtrl.text}\n';
      } else {
        assembledText += '🏢 ${_recipDeptCtrl.text} | ${_recipOrtCtrl.text}\n';
      }
      assembledText += '✉️ ${_recipEmailCtrl.text}';

      List<String> changes = [];
      if (old.identifier != _nameCtrl.text) changes.add("Bezeichnung geändert");
      if (old.recipientText != assembledText) {
        changes.add("Empfänger Details aktualisiert");
      }
      if (old.trackingNumber != _trackingCtrl.text) {
        changes.add("Tracking-Nummer geändert");
      }
      if (old.storageLocation != _locationCtrl.text) {
        changes.add("Ablageort geändert");
      }
      if (old.note != _noteCtrl.text) changes.add("Interne Notiz aktualisiert");

      if (changes.isNotEmpty) {
        old.auditLog = "[$now] by $userName\n- ${changes.join('\n- ')}\n\n${old.auditLog ?? ""}";
      }

      old.identifier = _nameCtrl.text;
      old.recipientText = assembledText;
      old.trackingNumber = _trackingCtrl.text;
      old.storageLocation = _locationCtrl.text;
      old.note = _noteCtrl.text;

      await client.shipment.updateShipmentDetails(old);
      setState(() => _isEditing = false);
      if (mounted) {
        ShadToaster.of(context)
            .show(const ShadToast(title: Text('✅ Änderungen gespeichert')));
      }
    } catch (e) {
      debugPrint("Speicher-Fehler: $e");
    } finally {
      setState(() => _isSaving = false);
    }
  }

  // ==========================================
  // ACTIONS
  // ==========================================
  void _actionStorePackage(Shipment shipment) {
    _startEditing(shipment);
    Future.delayed(const Duration(milliseconds: 100), () {
      _locationFocusNode.requestFocus();
    });
  }

  void _actionHandoverPackage(Shipment shipment) {
    handoverShipmentSignal.value = shipment;
  }

  // ==========================================
  // WIDGET BUILDER METHODS
  // ==========================================
  Widget _buildField(String label, String value,
      {TextEditingController? controller,
      bool showMagicWand = false,
      FocusNode? focusNode}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          if (_isEditing && controller != null)
            Row(
              children: [
                Expanded(
                    child: ShadInput(
                        controller: controller,
                        focusNode: focusNode,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12))),
                if (showMagicWand)
                  Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: IconButton(
                          onPressed:
                              _isMagicWandLoading ? null : _lookupEmployee,
                          icon: _isMagicWandLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.purple))
                              : const Icon(Icons.auto_fix_high,
                                  color: Colors.purple),
                          tooltip: 'Mitarbeiter suchen'))
              ],
            )
          else
            Text(value.isNotEmpty ? value : '-',
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87)),
        ],
      ),
    );
  }

  List<Widget> _buildAuditTrail(String? auditLog, String status,
      DateTime scannedAt, DateTime? deliveredAt) {
    List<Widget> trail = [];
    bool isDelivered = status == 'delivered';
    trail.add(buildTimelineItem(
        title: isDelivered
            ? 'Status changed to Delivered'
            : 'Shipment in processing',
        subtitle: isDelivered && deliveredAt != null
            ? '${deliveredAt.toString().substring(0, 16)} · Handed over'
            : 'Aktueller Status',
        isLatest: true));

    if (auditLog != null && auditLog.isNotEmpty) {
      final logEntries =
          auditLog.split('\n\n').where((e) => e.trim().isNotEmpty);
      for (var entry in logEntries) {
        final lines = entry.split('\n');
        if (lines.isEmpty) continue;
        final headerInfo = lines[0].replaceAll('[', '').replaceAll(']', '');
        final changes = lines.length > 1
            ? lines.sublist(1).map((e) => e.replaceAll('- ', '')).join(', ')
            : 'Details geändert';
        trail.add(buildTimelineItem(
            title: changes, subtitle: headerInfo, isLatest: false));
      }
    }
    trail.add(buildTimelineItem(
        title: 'Shipment logged',
        subtitle: '${scannedAt.toString().substring(0, 16)} · System',
        isLatest: false,
        isLast: true));
    return trail;
  }

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      _currentShipment = shipmentsSignal.value
          .cast<Shipment?>()
          .firstWhere((s) => s?.id == widget.shipmentId, orElse: () => null);
      if (_currentShipment == null) {
        return const Scaffold(
            body: Center(child: Text('Sendung nicht gefunden.')));
      }

      final shipment = _currentShipment!;
      final isDelivered = shipment.status == 'delivered';
      final parsedRecipient =
          parseRecipientDetails(shipment.recipientText ?? '');

      return LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 900;

          final photoCard = buildCard(
              child: Row(
            children: [
              Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(shipment.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image, color: Colors.grey)))),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_isEditing)
                      ShadInput(
                          controller: _nameCtrl,
                          placeholder: const Text('Bezeichnung'))
                    else
                      Text(
                          '${shipment.trackingNumber ?? ""} ${shipment.identifier}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(
                        'Captured today at ${shipment.storageLocation ?? "Poststelle"}',
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13)),
                  ],
                ),
              )
            ],
          ));

          final recipientCard = buildCard(
              title: 'EMPFÄNGER DETAILS',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildField('Name', parsedRecipient['name']!,
                      controller: _recipNameCtrl, showMagicWand: true),
                  _buildField('Abteilung', parsedRecipient['abteilung']!,
                      controller: _recipDeptCtrl),
                  _buildField('Ort', parsedRecipient['ort']!,
                      controller: _recipOrtCtrl),
                  _buildField('Email', parsedRecipient['email']!,
                      controller: _recipEmailCtrl),
                ],
              ));

          final trackingCard = buildCard(
              title: 'TRACKING DETAILS',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildField(
                      'Shipment ID / Barcode', shipment.trackingNumber ?? '-',
                      controller: _trackingCtrl),
                  _buildField('Aktueller Standort',
                      shipment.storageLocation ?? 'Main Desk',
                      controller: _locationCtrl,
                      focusNode: _locationFocusNode),
                  _buildField('Carrier', 'Unbekannt (Auto-Detect)'),
                  _buildField('Type', 'Parcel'),
                ],
              ));

          final notesCard = buildCard(
              title: 'INTERNAL NOTES',
              actionWidget: !_isEditing
                  ? GestureDetector(
                      onTap: () => _startEditing(shipment),
                      child: const Row(children: [
                        Icon(Icons.edit, size: 14, color: Colors.blue),
                        SizedBox(width: 4),
                        Text('Edit Notes',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 13))
                      ]))
                  : null,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8)),
                child: _isEditing
                    ? ShadInput(
                        controller: _noteCtrl,
                        maxLines: 3,
                        placeholder:
                            const Text('Interne Notiz hier eintragen...'))
                    : Text(
                        (shipment.note != null && shipment.note!.isNotEmpty)
                            ? shipment.note!
                            : 'Keine interne Notiz vorhanden.',
                        style: const TextStyle(
                            fontSize: 14, height: 1.4, color: Colors.black87)),
              ));

          final auditCard = buildCard(
              title: 'AUDIT TRAIL',
              child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                      children: _buildAuditTrail(
                          shipment.auditLog,
                          shipment.status,
                          shipment.scannedAt,
                          shipment.deliveredAt))));

          final signatureCard =
              isDelivered && shipment.signatureImageUrl != null
                  ? buildCard(
                      title: 'EMPFÄNGER UNTERSCHRIFT',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: double.infinity,
                              height: 120,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.shade300,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Image.network(
                                  shipment.signatureImageUrl!,
                                  fit: BoxFit.contain)),
                          const SizedBox(height: 16),
                          Text('Übernommen von',
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(
                              '${shipment.deliveredBy} · ${shipment.deliveredAt.toString().substring(0, 16)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ))
                  : const SizedBox.shrink();

          final actionButtons = !isDelivered
              ? Row(
                  children: [
                    Expanded(
                        child: ShadButton.outline(
                            onPressed: () => _actionStorePackage(shipment),
                            child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.inventory_2_outlined, size: 18),
                                  SizedBox(width: 8),
                                  Text('Hinterlegen')
                                ]))),
                    const SizedBox(width: 16),
                    Expanded(
                        child: ShadButton(
                            backgroundColor: Colors.blue.shade700,
                            onPressed: () =>
                                _actionHandoverPackage(shipment),
                            child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.draw, size: 18),
                                  SizedBox(width: 8),
                                  Text('Übernehmen')
                                ]))),
                  ],
                )
              : const SizedBox.shrink();

          return Scaffold(
            backgroundColor: const Color(0xFFF5F5F7),
            appBar: AppBar(
              backgroundColor:
                  isDesktop ? Colors.white : const Color(0xFFFDE047),
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black87),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: widget.onBack,
              ),
              title: Row(
                children: [
                  if (isDesktop)
                    const Text('Sendung Details',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))
                  else
                    Flexible(
                        child: Text(
                            _isEditing
                                ? 'Bearbeiten'
                                : (shipment.trackingNumber ??
                                    shipment.identifier),
                            style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                            overflow: TextOverflow.ellipsis)),
                  if (!isDesktop && !_isEditing) ...[
                    const SizedBox(width: 8),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color:
                                    isDelivered ? Colors.green : Colors.blue)),
                        child: Text(isDelivered ? 'Delivered' : 'Processing',
                            style: TextStyle(
                                color: isDelivered ? Colors.green : Colors.blue,
                                fontSize: 11,
                                fontWeight: FontWeight.bold)))
                  ]
                ],
              ),
              actions: [
                if (!_isEditing)
                  IconButton(
                      icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: isDesktop
                                  ? Border.all(color: Colors.blue, width: 1.5)
                                  : null),
                          child: Icon(Icons.edit,
                              size: 16,
                              color: isDesktop ? Colors.blue : Colors.black87)),
                      onPressed: () => _startEditing(shipment))
                else ...[
                  if (_isSaving)
                    const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.black87, strokeWidth: 2)))
                  else
                    IconButton(
                        icon: const Icon(Icons.check,
                            color: Colors.green, size: 28),
                        onPressed: _saveChanges),
                  IconButton(
                      icon:
                          const Icon(Icons.close, color: Colors.red, size: 28),
                      onPressed: () => setState(() => _isEditing = false)),
                ],
                const SizedBox(width: 16),
              ],
            ),
            body: isDesktop
                ? SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(shipment.trackingNumber ?? shipment.identifier,
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                            const SizedBox(width: 12),
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        color: isDelivered
                                            ? Colors.green
                                            : Colors.blue)),
                                child: Text(
                                    isDelivered ? 'Delivered' : 'Processing',
                                    style: TextStyle(
                                        color: isDelivered
                                            ? Colors.green
                                            : Colors.blue,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)))
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 5,
                                child: Column(children: [
                                  photoCard,
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(child: recipientCard),
                                        const SizedBox(width: 16),
                                        Expanded(child: trackingCard)
                                      ]),
                                  notesCard,
                                  if (!isDelivered)
                                    Padding(
                                        padding: const EdgeInsets.only(top: 16),
                                        child: actionButtons)
                                ])),
                            const SizedBox(width: 24),
                            Expanded(
                                flex: 3,
                                child: Column(
                                    children: [auditCard, signatureCard])),
                          ],
                        )
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          photoCard,
                          recipientCard,
                          trackingCard,
                          notesCard,
                          if (!isDelivered)
                            Padding(
                                padding: const EdgeInsets.only(bottom: 24),
                                child: actionButtons),
                          auditCard,
                          signatureCard,
                          const SizedBox(height: 30)
                        ]),
                  ),
          );
        },
      );
    });
  }
}
