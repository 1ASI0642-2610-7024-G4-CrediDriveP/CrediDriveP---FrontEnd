import 'package:flutter/material.dart';

/// Paleta de colores basada en el diseño Figma de CrediDriveP
abstract class AppColors {
  // ── Primarios ──────────────────────────────────────────────
  static const Color primary = Color(0xFF1A56FF);
  static const Color primaryLight = Color(0xFFE8EEFF);
  static const Color primaryDark = Color(0xFF1240CC);

  // ── Fondo ──────────────────────────────────────────────────
  static const Color background = Color(0xFFF4F6FB);
  static const Color surface = Color(0xFFFFFFFF);

  // ── Texto ──────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);

  // ── Estados ────────────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);

  // ── Bordes ─────────────────────────────────────────────────
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderFocus = Color(0xFF1A56FF);

  // ── Navbar ─────────────────────────────────────────────────
  static const Color navbarBg = Color(0xFFFFFFFF);
  static const Color navbarActive = Color(0xFF1A56FF);
  static const Color navbarInactive = Color(0xFF9CA3AF);

  // ── Overlay ────────────────────────────────────────────────
  static const Color overlay = Color(0x801A1A2E);
}
