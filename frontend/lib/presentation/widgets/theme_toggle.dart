import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/providers/settings_provider.dart';

class PremiumThemeToggle extends StatefulWidget {
  final double size;
  const PremiumThemeToggle({super.key, this.size = 40});

  @override
  State<PremiumThemeToggle> createState() => _PremiumThemeToggleState();
}

class _PremiumThemeToggleState extends State<PremiumThemeToggle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsProvider>();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );
    if (settings.isDark) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDark;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isDark) {
            _controller.reverse().then((_) {
              if (mounted) settings.toggleTheme();
            });
          } else {
            _controller.forward().then((_) {
              if (mounted) settings.toggleTheme();
            });
          }
        });
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final progress = _controller.value;
          final isAnimDark = progress > 0.5;
          return Transform.scale(
            scale: 1.0 - (0.15 * progress),
            child: Transform.rotate(
              angle: progress * 1.57,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isAnimDark
                        ? [const Color(0xFF1a1a2e), const Color(0xFF16213e)]
                        : [const Color(0xFFfef3c7), const Color(0xFFfde68a)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(widget.size * 0.3),
                  border: Border.all(
                    color: isAnimDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.amber.withOpacity(0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isAnimDark
                          ? Colors.blue.withOpacity(0.2)
                          : Colors.amber.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    isAnimDark ? Icons.dark_mode : Icons.light_mode,
                    size: widget.size * 0.5,
                    color: isAnimDark ? const Color(0xFFfbbf24) : const Color(0xFFf59e0b),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
