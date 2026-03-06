import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:mailroom_tracker_client/mailroom_tracker_client.dart';
import '../globals.dart';
import '../widgets/spotlight_search.dart';
import '../widgets/navigation.dart';
import 'new_shipment_view.dart';
import 'shipment_detail_view.dart';
import 'handover_screens.dart';

// ==========================================
// 1. MASTER LAYOUT (SPA WRAPPER)
// ==========================================
class ManagementDashboardScreen extends StatefulWidget {
  const ManagementDashboardScreen({super.key});

  @override
  State<ManagementDashboardScreen> createState() =>
      _ManagementDashboardScreenState();
}

class _ManagementDashboardScreenState extends State<ManagementDashboardScreen> {
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadShipments();
    initializeWebSocket();
  }

  Future<void> _loadShipments() async {
    try {
      final shipments = await client.shipment.getAllShipments();
      shipmentsSignal.clear();
      shipmentsSignal.addAll(shipments);
    } catch (e) {
      debugPrint("Lade-Fehler: $e");
    }
  }

  List<Shipment> get _filteredShipments {
    final all = shipmentsSignal.value;
    List<Shipment> filtered;
    switch (_selectedTabIndex) {
      case 1:
        filtered = all.where((s) => s.status != 'delivered').toList();
      case 2:
        filtered = all.where((s) => false).toList();
      case 3:
        filtered = all.where((s) => s.status == 'delivered').toList();
      default:
        filtered = all.toList();
    }
    filtered.sort((a, b) => b.scannedAt.compareTo(a.scannedAt));
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 900;

        return Scaffold(
          backgroundColor: isDesktop ? Colors.white : const Color(0xFFF5F5F7),
          bottomNavigationBar: isDesktop ? null : const MailroomBottomNav(),
          body: Row(
            children: [
              if (isDesktop) const MailroomSidebar(),
              Expanded(
                child: AnimatedBuilder(
                    animation: Listenable.merge(
                        [selectedShipmentIdSignal, isCreatingNewSignal, handoverShipmentSignal]),
                    builder: (context, child) {
                      if (handoverShipmentSignal.value != null) {
                        return SignatureCaptureScreen(
                          shipment: handoverShipmentSignal.value!,
                          onBack: () => handoverShipmentSignal.value = null,
                        );
                      }

                      if (isCreatingNewSignal.value) {
                        return NewShipmentView(
                            onBack: () => isCreatingNewSignal.value = false);
                      }

                      if (selectedShipmentIdSignal.value != null) {
                        return ShipmentDetailView(
                          shipmentId: selectedShipmentIdSignal.value!,
                          onBack: () => selectedShipmentIdSignal.value = null,
                        );
                      }

                      return _buildDashboardList(isDesktop);
                    }),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildDashboardList(bool isDesktop) {
    return Scaffold(
      backgroundColor: isDesktop ? Colors.white : const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: isDesktop ? 32 : 16,
        title:
            isDesktop ? _buildDesktopHeaderTitle() : _buildMobileHeaderTitle(),
      ),
      body: Watch((context) {
        final shipments = _filteredShipments;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 32 : 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isDesktop) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Letzten Sendungen',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87)),
                        ShadButton(
                            size: ShadButtonSize.sm,
                            backgroundColor: Colors.blue.shade700,
                            onPressed: () =>
                                isCreatingNewSignal.value = true,
                            child: const Row(children: [
                              Icon(Icons.add, size: 16),
                              SizedBox(width: 4),
                              Text('Neu')
                            ])),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: _buildMobileTabs()),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDesktopTabs(),
                        ShadButton(
                            size: ShadButtonSize.sm,
                            backgroundColor: Colors.blue.shade700,
                            onPressed: () =>
                                isCreatingNewSignal.value = true,
                            child: const Row(children: [
                              Icon(Icons.add, size: 16),
                              SizedBox(width: 6),
                              Text('Neue Sendung')
                            ])),
                      ],
                    ),
                  ]
                ],
              ),
            ),
            Expanded(
              child: shipments.isEmpty
                  ? const Center(
                      child: Text('Keine Sendungen in dieser Kategorie.'))
                  : isDesktop
                      ? _buildDesktopTable(shipments)
                      : _buildMobileList(shipments),
            ),
          ],
        );
      }),
    );
  }

  // ---------- Header Helper ----------
  Widget _buildDesktopHeaderTitle() {
    return Row(
      children: [
        if (MediaQuery.of(context).size.width <= 900)
          const Text('Mailroom',
              style: TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.bold)),
        if (MediaQuery.of(context).size.width > 900)
          const Text('Shipments',
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
        const Spacer(),
        GestureDetector(
          onTap: () => showSpotlightSearch(context),
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search, size: 22, color: Colors.blueGrey.shade400),
              const SizedBox(width: 8),
              Text('Suche',
                  style: TextStyle(
                      color: Colors.blueGrey.shade400,
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const SizedBox(width: 40),
        const SizedBox(width: 16),
        const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=47')),
      ],
    );
  }

  Widget _buildMobileHeaderTitle() {
    return Row(
      children: [
        Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: const Color(0xFFFDE047),
                borderRadius: BorderRadius.circular(4)),
            child:
                const Icon(Icons.inventory_2, color: Colors.black87, size: 18)),
        const SizedBox(width: 12),
        const Text('Mailroom',
            style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5)),
        const Spacer(),
        const CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=47')),
      ],
    );
  }

  Widget _buildDesktopTabs() {
    return Row(children: [
      _buildTabItem('All', 0, true),
      _buildTabItem('Open', 1, true),
      _buildTabItem('Overdue', 2, true),
      _buildTabItem('Completed', 3, true)
    ]);
  }

  Widget _buildMobileTabs() {
    return Row(children: [
      _buildTabItem('Alle', 0, false),
      _buildTabItem('Offen', 1, false),
      _buildTabItem('Überfällig', 2, false),
      _buildTabItem('Abgeschlossen', 3, false)
    ]);
  }

  Widget _buildTabItem(String label, int index, bool isDesktop) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Container(
        margin: const EdgeInsets.only(right: 24),
        padding: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: isSelected
                        ? const Color(0xFFFDE047)
                        : Colors.transparent,
                    width: 3))),
        child: Text(label,
            style: TextStyle(
                color: isSelected ? Colors.black87 : Colors.grey.shade500,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: isDesktop ? 15 : 14)),
      ),
    );
  }

  // ---------- Listen Helper ----------
  Widget _buildDesktopTable(List<Shipment> shipments) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Text('ID',
                      style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                          fontWeight: FontWeight.w600))),
              Expanded(
                  flex: 4,
                  child: Text('Recipient',
                      style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                          fontWeight: FontWeight.w600))),
              Expanded(
                  flex: 3,
                  child: Text('Department',
                      style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                          fontWeight: FontWeight.w600))),
              Expanded(
                  flex: 2,
                  child: Text('Type',
                      style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                          fontWeight: FontWeight.w600))),
              Expanded(
                  flex: 2,
                  child: Text('Status',
                      style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                          fontWeight: FontWeight.w600))),
              const SizedBox(width: 40),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200)),
          child: Column(
            children: shipments.asMap().entries.map((entry) {
              final shipment = entry.value;
              final parsed =
                  parseRecipientDetails(shipment.recipientText ?? '');
              final isDelivered = shipment.status == 'delivered';

              return InkWell(
                onTap: () => selectedShipmentIdSignal.value = shipment.id!,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: entry.key == shipments.length - 1
                                  ? Colors.transparent
                                  : Colors.grey.shade100))),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Text(
                              shipment.trackingNumber ?? 'SHP-${shipment.id}',
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontFamily: 'monospace'))),
                      Expanded(
                          flex: 4,
                          child: Row(children: [
                            CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.blueGrey.shade100,
                                child: Text(getInitials(parsed['name']!),
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey))),
                            const SizedBox(width: 12),
                            Text(parsed['name']!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87)),
                          ])),
                      Expanded(
                          flex: 3,
                          child: Text(parsed['abteilung']!.split('\n').first,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87))),
                      Expanded(
                          flex: 2,
                          child: Text(shipment.identifier,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87))),
                      Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                  color: isDelivered
                                      ? Colors.green.shade400
                                      : const Color(0xFFFDE047),
                                  borderRadius: BorderRadius.circular(16)),
                              child: Text(
                                  isDelivered ? 'Completed' : 'In Progress',
                                  style: TextStyle(
                                      color: isDelivered
                                          ? Colors.white
                                          : Colors.black87,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )),
                      const Icon(Icons.more_vert, color: Colors.grey, size: 20),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget _buildMobileList(List<Shipment> shipments) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: shipments.length,
      itemBuilder: (context, index) {
        final shipment = shipments[index];
        final parsed = parseRecipientDetails(shipment.recipientText ?? '');
        final isDelivered = shipment.status == 'delivered';

        return GestureDetector(
          onTap: () => selectedShipmentIdSignal.value = shipment.id!,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(shipment.trackingNumber ?? 'SHP-${shipment.id}',
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace')),
                    if (isDelivered)
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                              color: Colors.green.shade400,
                              borderRadius: BorderRadius.circular(12)),
                          child: const Text('Completed',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)))
                  ],
                ),
                const SizedBox(height: 12),
                Text(parsed['name']!,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                const SizedBox(height: 4),
                Text(
                    '${parsed['abteilung']!.split('\n').first} • ${shipment.identifier}',
                    style:
                        TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        'Today, ${shipment.scannedAt.toString().substring(11, 16)}',
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 13)),
                    const Icon(Icons.chevron_right,
                        color: Colors.grey, size: 20),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
