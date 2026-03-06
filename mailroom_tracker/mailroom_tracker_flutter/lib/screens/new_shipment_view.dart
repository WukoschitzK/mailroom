import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:typed_data';
import 'package:mailroom_tracker_client/mailroom_tracker_client.dart';
import '../globals.dart';

class NewShipmentView extends StatefulWidget {
  final VoidCallback onBack;
  const NewShipmentView({super.key, required this.onBack});

  @override
  State<NewShipmentView> createState() => _NewShipmentViewState();
}

class _NewShipmentViewState extends State<NewShipmentView> {
  bool _isScanning = false;
  bool _isSaving = false;
  String? _scannedImageUrl;

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _trackingCtrl = TextEditingController();
  final TextEditingController _locationCtrl = TextEditingController(text: 'Poststelle'); 
  final TextEditingController _noteCtrl = TextEditingController();
  final TextEditingController _recipNameCtrl = TextEditingController();
  final TextEditingController _recipDeptCtrl = TextEditingController();
  final TextEditingController _recipOrtCtrl = TextEditingController();
  final TextEditingController _recipEmailCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose(); _trackingCtrl.dispose(); _locationCtrl.dispose(); _noteCtrl.dispose();
    _recipNameCtrl.dispose(); _recipDeptCtrl.dispose(); _recipOrtCtrl.dispose(); _recipEmailCtrl.dispose();
    super.dispose();
  }

  // ==========================================
  // KI-SCANNER LOGIK
  // ==========================================
  Future<void> _scanPackage() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1200, imageQuality: 70);
    if (photo == null) return;

    setState(() => _isScanning = true);

    try {
      String detectedBarcode = "KEIN_BARCODE_GEFUNDEN";
      final scannerController = MobileScannerController();
      
      try {
        final capture = await scannerController.analyzeImage(photo.path);
        if (capture != null && capture.barcodes.isNotEmpty) {
          detectedBarcode = capture.barcodes.first.rawValue ?? detectedBarcode;
        }
      } catch (scanError) {
        if (scanError.toString().contains('Simulator')) detectedBarcode = "SIMULATOR_TEST_12345";
      } finally {
        scannerController.dispose();
      }

      final bytes = await photo.readAsBytes();
      final byteData = ByteData.view(bytes.buffer);
      final fileName = 'paket_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final uploadedUrl = await client.shipment.uploadImage(byteData, fileName);

      if (uploadedUrl != null) {
        final currentUser = currentUserSignal.value;
        final analyzedData = await client.shipment.analyzePackage(
            uploadedUrl, currentUser?.name ?? 'Unbekannt', detectedBarcode, _locationCtrl.text);
        
        final parsed = parseRecipientDetails(analyzedData.recipientText ?? '');
        setState(() {
          _scannedImageUrl = uploadedUrl;
          _nameCtrl.text = analyzedData.identifier;
          _trackingCtrl.text = detectedBarcode;
          _recipNameCtrl.text = parsed['name']!;
          _recipDeptCtrl.text = parsed['abteilung']!;
          _recipOrtCtrl.text = parsed['ort']!;
          _recipEmailCtrl.text = parsed['email']!;
        });
        
        if (mounted) ShadToaster.of(context).show(const ShadToast(title: Text('✨ Analyse erfolgreich! Bitte Daten prüfen.')));
      }
    } catch (e) {
      print("🚨 FEHLER: $e");
      if (mounted) ShadToaster.of(context).show(const ShadToast(title: Text('❌ Fehler beim Scannen')));
    } finally {
      setState(() => _isScanning = false);
    }
  }

  // ==========================================
  // SPEICHERN LOGIK
  // ==========================================
  Future<void> _saveNewShipment() async {
    if (_scannedImageUrl == null) {
      ShadToaster.of(context).show(const ShadToast(title: Text('⚠️ Bitte zuerst ein Foto scannen!')));
      return;
    }

    setState(() => _isSaving = true);
    try {
      String assembledText = '${_recipNameCtrl.text}\n';
      assembledText += '🏢 ${_recipDeptCtrl.text} | ${_recipOrtCtrl.text}\n';
      assembledText += '✉️ ${_recipEmailCtrl.text}';

      final newShipment = Shipment(
        identifier: _nameCtrl.text,
        direction: 'incoming',
        type: 'package',
        status: 'scanned',
        trackingNumber: _trackingCtrl.text,
        recipientText: assembledText,
        isDamaged: false,
        imageUrl: _scannedImageUrl!,
        scannedAt: DateTime.now(),
        createdBy: currentUserSignal.value?.name ?? 'Unbekannt',
        storageLocation: _locationCtrl.text,
        note: _noteCtrl.text.isEmpty ? null : _noteCtrl.text,
      );

      final savedShipment = await client.shipment.saveAnalyzedShipment(newShipment);
      
      if (mounted) {
        ShadToaster.of(context).show(const ShadToast(title: Text('✅ Erfolgreich erfasst!')));
        isCreatingNewSignal.value = false;
        selectedShipmentIdSignal.value = savedShipment.id;
      }
    } catch (e) {
      print("Speicher-Fehler: $e");
    } finally {
      setState(() => _isSaving = false);
    }
  }

  // ==========================================
  // UI WIDGETS HELPER
  // ==========================================
  Widget _buildField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          ShadInput(controller: controller, maxLines: maxLines, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12)),
        ],
      ),
    );
  }

  Widget _buildCard({String? title, required Widget child}) {
    return Container(
      width: double.infinity, margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
            const SizedBox(height: 16),
          ],
          child,
        ],
      ),
    );
  }
  
  Widget _buildTimelineItem({required String title, required String subtitle, required bool isLatest, bool isLast = false, bool isPending = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 30,
            child: Column(
              children: [
                Container(
                  width: 20, height: 20, margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isPending ? Colors.grey.shade300 : (isLatest ? Colors.green : const Color(0xFFFFF59D))
                  ),
                  child: (isLatest && !isPending) ? const Icon(Icons.check, size: 14, color: Colors.white) : null
                ),
                if (!isLast) Expanded(child: Container(width: 2, color: Colors.grey.shade300)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: isPending ? Colors.grey.shade500 : Colors.black87)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                ]
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 900;

        // 1. SCAN BUTTON
        final scanBtn = ShadButton(
          width: double.infinity,
          size: ShadButtonSize.lg,
          backgroundColor: Colors.blue.shade700,
          onPressed: _isScanning ? null : _scanPackage,
          child: _isScanning 
            ? const Row(mainAxisAlignment: MainAxisAlignment.center, children: [SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)), SizedBox(width: 12), Text('KI analysiert Bild...', style: TextStyle(fontSize: 16))])
            : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.document_scanner, size: 20), SizedBox(width: 8), Text('📸 Sendung scannen', style: TextStyle(fontSize: 16))]),
        );

        // 2. HEADER KARTEN
        final headerCard = _buildCard(
          child: Row(
            children: [
              Container(
                width: 60, height: 60, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)), 
                child: ClipRRect(borderRadius: BorderRadius.circular(8), child: _scannedImageUrl != null ? Image.network(_scannedImageUrl!, fit: BoxFit.cover) : const Icon(Icons.image, color: Colors.grey))
              ),
              const SizedBox(width: 16),
              Expanded(child: _buildField('Bezeichnung (z.B. Paket)', _nameCtrl)),
            ],
          )
        );

        // 3. EMPFÄNGER
        final recipientCard = _buildCard(
          title: 'EMPFÄNGER DETAILS',
          child: Column(
            children: [
              _buildField('Name', _recipNameCtrl),
              _buildField('Abteilung', _recipDeptCtrl),
              _buildField('Ort', _recipOrtCtrl),
              _buildField('Email', _recipEmailCtrl),
            ],
          )
        );

        // 4. TRACKING
        final trackingCard = _buildCard(
          title: 'TRACKING DETAILS',
          child: Column(
            children: [
              _buildField('Shipment ID / Barcode', _trackingCtrl),
              _buildField('Aktueller Standort', _locationCtrl),
            ],
          )
        );

        // 5. NOTIZ
        final notesCard = _buildCard(
          title: 'INTERNAL NOTES',
          child: _buildField('Interne Notiz hinzufügen...', _noteCtrl, maxLines: 3)
        );

        // 6. PLATZHALTER AUDIT TRAIL
        final dummyAuditCard = _buildCard(
          title: 'AUDIT TRAIL',
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                _buildTimelineItem(
                  title: 'Wartet auf Erfassung',
                  subtitle: 'Bitte scannen oder manuell ausfüllen',
                  isLatest: true,
                  isLast: true,
                  isPending: true,
                )
              ]
            )
          )
        );

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F7),
          appBar: AppBar(
            backgroundColor: isDesktop ? Colors.white : const Color(0xFFFDE047),
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black87),
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black87), onPressed: widget.onBack),
            title: const Text('Neue Sendung erfassen', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
            actions: [
              if (_isSaving) const Padding(padding: EdgeInsets.all(16.0), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black87, strokeWidth: 2)))
              else IconButton(icon: const Icon(Icons.check, color: Colors.green, size: 28), onPressed: _saveNewShipment),
              const SizedBox(width: 16),
            ],
          ),
          
          // ==========================================
          // DER FIX: Kein Center/ConstrainedBox mehr! Volle Breite nutzen!
          // ==========================================
          body: isDesktop 
            ? SingleChildScrollView(
                padding: const EdgeInsets.all(32), // Exakt das gleiche Padding wie im Edit Screen
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LINKE SPALTE (Flex 5)
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          scanBtn,
                          const SizedBox(height: 24),
                          headerCard,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: recipientCard),
                              const SizedBox(width: 16),
                              Expanded(child: trackingCard),
                            ],
                          ),
                          notesCard,
                        ],
                      )
                    ),
                    const SizedBox(width: 24),
                    // RECHTE SPALTE (Flex 3)
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          dummyAuditCard,
                        ],
                      )
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    scanBtn,
                    const SizedBox(height: 24),
                    headerCard,
                    recipientCard,
                    trackingCard,
                    notesCard,
                    dummyAuditCard,
                    const SizedBox(height: 40),
                  ],
                ),
              ),
        );
      }
    );
  }
}