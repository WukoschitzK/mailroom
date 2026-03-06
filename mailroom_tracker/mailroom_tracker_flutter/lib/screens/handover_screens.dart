import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:signature/signature.dart';
import 'dart:typed_data';
import 'package:mailroom_tracker_client/mailroom_tracker_client.dart';
import '../globals.dart';

class SignatureCaptureScreen extends StatefulWidget {
  final Shipment shipment;
  final VoidCallback onBack;
  const SignatureCaptureScreen({super.key, required this.shipment, required this.onBack});

  @override
  State<SignatureCaptureScreen> createState() => _SignatureCaptureScreenState();
}

class _SignatureCaptureScreenState extends State<SignatureCaptureScreen> {
  final SignatureController _signatureController = SignatureController(penStrokeWidth: 3, penColor: Colors.black, exportBackgroundColor: Colors.white);

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  Future<void> _submitSignature() async {
    if (_signatureController.isEmpty) return;
    isScanningSignal.value = true;
    try {
      final signatureBytes = await _signatureController.toPngBytes();
      if (signatureBytes == null) return;

      final byteData = ByteData.view(signatureBytes.buffer);
      final fileName = 'signatur_${widget.shipment.id}_${DateTime.now().millisecondsSinceEpoch}.png';
      final uploadedSignatureUrl = await client.shipment.uploadImage(byteData, fileName);

      if (uploadedSignatureUrl != null && widget.shipment.id != null) {
        await client.shipment.deliverPackage(widget.shipment.id!, uploadedSignatureUrl, currentUserSignal.value?.name ?? 'Unbekannt');
        if (mounted) {
          ShadToaster.of(context).show(const ShadToast(title: Text('✅ Übergabe erfolgreich')));
          handoverShipmentSignal.value = null;
          selectedShipmentIdSignal.value = widget.shipment.id;
        }
      }
    } catch (e) { debugPrint("Fehler: $e"); }
    finally { isScanningSignal.value = false; }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: widget.onBack,
        ),
        title: const Text('Übergabe bestätigen', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Empfänger: ${widget.shipment.recipientText}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400, width: 2), borderRadius: BorderRadius.circular(12)), child: ClipRRect(borderRadius: BorderRadius.circular(10), child: Signature(controller: _signatureController, height: 300, backgroundColor: Colors.white))),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShadButton.outline(onPressed: () => _signatureController.clear(), child: const Text('Neu zeichnen')),
                Watch((context) => ShadButton(onPressed: isScanningSignal.value ? null : _submitSignature, child: isScanningSignal.value ? const CircularProgressIndicator() : const Text('✅ Bestätigen'))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
