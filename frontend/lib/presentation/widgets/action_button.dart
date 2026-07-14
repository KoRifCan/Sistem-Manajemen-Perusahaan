import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.08)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: isDark ? Colors.grey.shade300 : Colors.grey.shade600),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade300 : Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}
