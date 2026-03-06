import 'package:flutter/material.dart';
import 'package:meilisearch/meilisearch.dart';
import '../globals.dart'; // WICHTIG: Hier ist unser SPA-Signal drin!

class SpotlightSearchDialog extends StatefulWidget {
  const SpotlightSearchDialog({super.key});

  @override
  State<SpotlightSearchDialog> createState() => _SpotlightSearchDialogState();
}

class _SpotlightSearchDialogState extends State<SpotlightSearchDialog> {
  final _searchController = TextEditingController();
  final _meiliClient = MeiliSearchClient('http://localhost:7700', 'meilisearch_geheim_123');
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    setState(() => _isLoading = true);
    try {
      final index = _meiliClient.index('shipments');
      final result = await index.search(query);
      setState(() {
        _searchResults = result.hits.cast<Map<String, dynamic>>();
      });
    } catch (e) {
      print("Suchfehler: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.topCenter, // <-- NEU: Mittig oben andocken
      insetPadding: const EdgeInsets.only(top: 120, left: 20, right: 20, bottom: 20), // <-- NEU: Abstand nach oben
      backgroundColor: Colors.transparent,
      child: Container(
        width: 500, // <-- NEU: Etwas schlanker (vorher 600)
        constraints: const BoxConstraints(maxHeight: 500),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, spreadRadius: 5)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  hintText: 'Suche nach Namen, Abteilung...',
                  border: InputBorder.none,
                  // NEU: Icon-Größe von 32 auf 20 reduziert
                  icon: const Icon(Icons.search, size: 20, color: Colors.blueGrey),
                  // NEU: Lade-Indikator verkleinert, damit er nicht das Feld sprengt
                  suffixIcon: _isLoading 
                      ? Transform.scale(scale: 0.6, child: CircularProgressIndicator(strokeWidth: 3)) 
                      : null,
                ),
                onChanged: _performSearch,
              ),
            ),
            if (_searchResults.isNotEmpty) const Divider(height: 1),
            if (_searchResults.isNotEmpty)
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final hit = _searchResults[index];
                    return ListTile(
                      leading: const Icon(Icons.inventory_2_outlined),
                      title: Text(hit['recipientText']?.toString().split('\n').first ?? hit['identifier']),
                      subtitle: Text(hit['note'] != null && hit['note'].toString().isNotEmpty
                          ? 'Notiz: ${hit['note']}' : 'Status: ${hit['status']}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pop(context); // Dialog zu
                        selectedShipmentIdSignal.value = hit['id']; // SPA-Route zu Detail
                        Navigator.popUntil(context, (route) => route.isFirst); // Zurück zum Dashboard
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

void showSpotlightSearch(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Spotlight',
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, anim1, anim2) => const SpotlightSearchDialog(),
    transitionBuilder: (context, anim1, anim2, child) {
      return FadeTransition(
        opacity: anim1,
        child: SlideTransition(
          position: Tween(begin: const Offset(0, -0.1), end: const Offset(0, 0)).animate(anim1),
          child: child,
        ),
      );
    },
  );
}