import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // prevents instantiation, this is a static-only class

  // ── Backgrounds ────────────────────────────────────────────────
  static const Color background = Color(0xFF0E0F1A); // app scaffold background
  static const Color surface = Color(0xFF1A1C2E); // cards, sheets, dialogs
  static const Color surfaceElevated = Color(
    0xFF22243A,
  ); // elevated cards (e.g. modals over surface)

  // ── Brand / accent ────────────────────────────────────────────
  static const Color primary = Color(
    0xFF6366F1,
  ); // buttons, active states, links
  static const Color primaryPressed = Color(0xFF4F46E5); // pressed/hover state
  static const Color primaryMuted = Color(
    0xFF2A2B4A,
  ); // subtle backgrounds for chips/badges using primary

  // ── Text ──────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF1F1F6); // headings, main content
  static const Color textSecondary = Color(
    0xFF9A9CB8,
  ); // subtext, captions, metadata
  static const Color textTertiary = Color(
    0xFF6B6D8A,
  ); // placeholders, disabled text, hints

  // ── Borders / dividers ────────────────────────────────────────
  static const Color border = Color(0xFF2A2D45); // card borders, dividers
  static const Color borderFocused = primary; // input border when focused

  // ── Status colors ─────────────────────────────────────────────
  static const Color success = Color(
    0xFF34D399,
  ); // verified badge, ratings, success states
  static const Color successMuted = Color(
    0xFF14291F,
  ); // success background (chips, tags)

  static const Color warning = Color(0xFFFBBF24); // star ratings
  static const Color warningMuted = Color(0xFF2E2410);

  static const Color error = Color(
    0xFFF87171,
  ); // validation errors, failed states
  static const Color errorMuted = Color(0xFF2E1717);

  static const Color info = Color(0xFF60A5FA); // informational badges/tooltips
  static const Color infoMuted = Color(0xFF16233D);

  // ── Category accent colors ──────────────────────────────────────
  // Used for note-type icon backgrounds (PDF icon tiles) to visually
  // differentiate cards in a list, like in the home feed mockups.
  static const Color accentCoral = Color(0xFFF87171);
  static const Color accentCoralMuted = Color(0xFF2E1B1B);

  static const Color accentTeal = Color(0xFF2DD4BF);
  static const Color accentTealMuted = Color(0xFF132A28);

  static const Color accentAmber = Color(0xFFFBBF24);
  static const Color accentAmberMuted = Color(0xFF2E2410);
}
