import 'package:flutter/material.dart';

class CompanyLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const CompanyLogo({super.key, this.size = 40, this.showText = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconSize = size * 0.55;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1a73e8), Color(0xFF0d47a1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(size * 0.22),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1a73e8).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Icon(Icons.business_center, size: iconSize, color: Colors.white),
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 6),
          Text(
            'PT. Karya Inovasi Digital',
            style: TextStyle(
              fontSize: size * 0.22,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          Text(
            'Sistem Manajemen Perusahaan',
            style: TextStyle(
              fontSize: size * 0.15,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ],
    );
  }
}

class CompanyLogoHorizontal extends StatelessWidget {
  final double size;
  final bool showSubtitle;

  const CompanyLogoHorizontal({super.key, this.size = 36, this.showSubtitle = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1a73e8), Color(0xFF0d47a1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(size * 0.22),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1a73e8).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(Icons.business_center, size: size * 0.55, color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'PT. Karya Inovasi Digital',
              style: TextStyle(
                fontSize: size * 0.35,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            if (showSubtitle)
              Text(
                'Sistem Manajemen Perusahaan',
                style: TextStyle(
                  fontSize: size * 0.22,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
