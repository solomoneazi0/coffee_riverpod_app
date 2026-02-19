import 'package:flutter/material.dart';

class NavigationMenu extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const NavigationMenu({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _NavItem(
                icon: Icons.home,
                label: 'Home',
                isActive: selectedIndex == 0,
                onTap: () => onChanged(0),
              ),
              _NavItem(
                icon: Icons.shopping_bag_outlined,
                label: 'Wishlist',
                isActive: selectedIndex == 1,
                onTap: () => onChanged(1),
              ),
              _NavItem(
                icon: Icons.person_outline,
                label: 'Profile',
                isActive: selectedIndex == 2,
                onTap: () => onChanged(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String? label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        width: isActive ? 130 : 74,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0D3122) : const Color(0xFFE6EFEA),
          // borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : const Color(0xFF0D3122),
              ),
              if (isActive && label != null) ...[
                const SizedBox(width: 8),
                Text(
                  label!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
