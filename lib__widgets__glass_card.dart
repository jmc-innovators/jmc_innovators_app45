import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Frosted-glass card used everywhere on the site's aurora dark theme:
/// blurred translucent background, subtle gradient border, soft shadow.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final VoidCallback? onTap;
  final Gradient? accentGradient;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 20,
    this.onTap,
    this.accentGradient,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: AppColors.surfaceGlass,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: (accentGradient != null ? AppColors.cyan : Colors.black)
                      .withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Full-width primary action button with a built-in "wonderful loading"
/// state: while [onPressed] awaits, the label cross-fades into a spinner
/// and a subtle shimmer sweeps across the gradient fill. Used for submit /
/// sign-in / download actions throughout the app.
class WonderfulLoadingButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final Future<void> Function() onPressed;
  final Gradient? gradient;
  const WonderfulLoadingButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.gradient,
  });

  @override
  State<WonderfulLoadingButton> createState() => _WonderfulLoadingButtonState();
}

class _WonderfulLoadingButtonState extends State<WonderfulLoadingButton>
    with SingleTickerProviderStateMixin {
  bool _loading = false;
  late final AnimationController _shimmer =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))
        ..repeat();

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  Future<void> _tap() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      await widget.onPressed();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradient = widget.gradient ?? AppColors.aurora;
    return GestureDetector(
      onTap: _tap,
      child: AnimatedBuilder(
        animation: _shimmer,
        builder: (context, child) {
          return Container(
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: _loading
                    ? [
                        gradient.colors.first,
                        Colors.white.withOpacity(0.55),
                        gradient.colors.last,
                      ]
                    : [gradient.colors.first, gradient.colors.last],
                stops: _loading
                    ? [
                        (_shimmer.value - 0.3).clamp(0.0, 1.0),
                        _shimmer.value.clamp(0.0, 1.0),
                        (_shimmer.value + 0.3).clamp(0.0, 1.0),
                      ]
                    : null,
              ),
              boxShadow: [
                BoxShadow(
                  color: gradient.colors.first.withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: _loading
                    ? const SizedBox(
                        key: ValueKey('spinner'),
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.black),
                      )
                    : Row(
                        key: const ValueKey('label'),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(widget.icon, color: Colors.black, size: 18),
                            const SizedBox(width: 8),
                          ],
                          Text(widget.label,
                              style: const TextStyle(
                                  color: Colors.black, fontWeight: FontWeight.w800, fontSize: 15)),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Small pill-style gradient chip, used for category/status tags.
class GradientChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  const GradientChip({super.key, required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: AppColors.aurora,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: Colors.black),
            const SizedBox(width: 4),
          ],
          Text(label,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w700, fontSize: 12)),
        ],
      ),
    );
  }
}
