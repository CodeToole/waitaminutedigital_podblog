import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Cyber-editorial category badge (e.g. ARCHITECTURE, POST-MORTEM, SHIPPED).
class BadgeTag extends StatelessWidget {
  final String label;
  final bool isSmall;

  const BadgeTag({
    super.key,
    required this.label,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.badgeColor(label);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 12,
        vertical: isSmall ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.spaceMono(
          color: color,
          fontSize: isSmall ? 10 : 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
