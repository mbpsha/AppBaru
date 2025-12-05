import 'package:flutter/material.dart';

class AdminSidebarClean extends StatelessWidget {
  final double width;
  final ValueChanged<int>? onItemSelected;
  final int selectedIndex;

  const AdminSidebarClean({
    Key? key,
    this.width = 240,
    this.onItemSelected,
    this.selectedIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE8FCEC), Color(0xFFF3FFF9)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'ADMIN PANEL',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 6),
            _buildMenuItem(context, Icons.dashboard, 'Dashboard', 0),
            _buildMenuItem(context, Icons.people, 'Users', 1),
            _buildMenuItem(context, Icons.shopping_bag, 'Products', 2),
            _buildMenuItem(context, Icons.payment, 'Payments', 3),
            _buildMenuItem(context, Icons.receipt_long, 'Orders', 4),
            _buildMenuItem(context, Icons.article, 'News', 5),
            const Spacer(),
            _buildMenuItem(context, Icons.logout, 'Logout', 6),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
  ) {
    final bool active = index == selectedIndex;
    return InkWell(
      onTap: () => onItemSelected?.call(index),
      child: Container(
        color: active
            ? Colors.green[400]!.withOpacity(0.12)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: active ? Colors.green : Colors.black54),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.green[800] : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
