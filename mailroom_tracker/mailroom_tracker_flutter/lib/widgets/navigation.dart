import 'package:flutter/material.dart';
import '../globals.dart';
import 'spotlight_search.dart';

class MailroomSidebar extends StatelessWidget {
  const MailroomSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isCreatingNewSignal,
      builder: (context, isCreatingNew, child) {
        return Container(
          width: 240,
          color: const Color(0xFF1C1C1E),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: const Color(0xFFFDE047), borderRadius: BorderRadius.circular(4)), child: const Icon(Icons.inventory_2, color: Colors.black87, size: 18)),
                  const SizedBox(width: 12),
                  const Text('Mailroom', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                ],
              ),
              const SizedBox(height: 48),
              
              _buildSidebarItem(Icons.dashboard_outlined, 'Dashboard', false, () {}),
              
              // SENDUNGEN (Aktiv, wenn wir NICHT im "Neu"-Modus sind)
              _buildSidebarItem(Icons.inventory_2, 'Sendungen', !isCreatingNew, () {
                isCreatingNewSignal.value = false;
                selectedShipmentIdSignal.value = null; // Zurück zur Liste
              }),
              
              // NEUE SENDUNG (Ersetzt Reports!)
              _buildSidebarItem(Icons.add_circle_outline, 'Neue Sendung', isCreatingNew, () {
                isCreatingNewSignal.value = true;
              }),
              
              _buildSidebarItem(Icons.settings_outlined, 'Settings', false, () {}),
            ],
          ),
        );
      }
    );
  }

  // NEU: Die Methode nimmt jetzt auch einen onTap-Callback entgegen
  Widget _buildSidebarItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(color: isActive ? Colors.white.withOpacity(0.1) : Colors.transparent, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Icon(icon, color: isActive ? const Color(0xFFFDE047) : Colors.grey, size: 20),
            const SizedBox(width: 16),
            Text(label, style: TextStyle(color: isActive ? const Color(0xFFFDE047) : Colors.grey, fontSize: 14, fontWeight: isActive ? FontWeight.w600 : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}

class MailroomBottomNav extends StatelessWidget {
  const MailroomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isCreatingNewSignal,
      builder: (context, isCreatingNew, child) {
        return Container(
          height: 80, 
          color: const Color(0xFF1C1C1E), 
          padding: const EdgeInsets.only(bottom: 20, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMobileNavItem(Icons.inventory_2, 'Sendungen', !isCreatingNew, () {
                isCreatingNewSignal.value = false;
                selectedShipmentIdSignal.value = null; 
              }),
              
              _buildMobileNavItem(Icons.add_circle_outline, 'Neu', isCreatingNew, () {
                isCreatingNewSignal.value = true;
              }),
              
              _buildMobileNavItem(Icons.search, 'Suche', false, () {
                showSpotlightSearch(context);
              }),
              
              _buildMobileNavItem(Icons.settings_outlined, 'Settings', false, () {}),
            ],
          ),
        );
      }
    );
  }

  Widget _buildMobileNavItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque, 
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? const Color(0xFFFDE047) : Colors.grey, size: 24),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: isActive ? const Color(0xFFFDE047) : Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }
}