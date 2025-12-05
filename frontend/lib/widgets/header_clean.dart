import 'package:flutter/material.dart';

class AdminHeaderClean extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final VoidCallback? onMenuPressed;
  final bool showMenu;

  const AdminHeaderClean({
    Key? key,
    this.userName = 'Admin',
    this.onMenuPressed,
    this.showMenu = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            if (showMenu)
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: onMenuPressed,
                tooltip: 'Open menu',
              ),

            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/dashboardAdmin/logo-ngundur.png',
                height: 44,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 44,
                  height: 44,
                  color: Colors.green[200],
                  child: const Icon(Icons.local_florist, color: Colors.white),
                ),
              ),
            ),

            const Spacer(),

            Row(
              children: [
                const Text(
                  'Admin',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person, size: 18, color: Colors.black54),
                      const SizedBox(width: 8),
                      Text(
                        userName,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    side: const BorderSide(color: Colors.grey),
                  ),
                  child: const Text(
                    'Log-out',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(68);
}
