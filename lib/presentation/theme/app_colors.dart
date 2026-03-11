import 'package:flutter/material.dart';

/// SkyCrew design system color palette.
///
/// Based on a minimalist Japanese UI aesthetic — calm, clear, focused.
abstract class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------------
  // Brand
  // ---------------------------------------------------------------------------

  /// Matcha Green — primary brand colour.
  static const primary = Color(0xFF4F6F52);

  /// Soft Green-Gray — secondary.
  static const secondary = Color(0xFFD1D5C9);

  /// Muted Sage — tertiary accent.
  static const tertiary = Color(0xFF8FA897);

  // ---------------------------------------------------------------------------
  // Semantic
  // ---------------------------------------------------------------------------

  /// Muted Red — error/warning.
  static const error = Color(0xFF9F3A38);

  /// Amber — warning / expiring soon.
  static const warning = Color(0xFFB97D3A);

  /// Muted Green — success/valid.
  static const success = Color(0xFF3A7A4A);

  // ---------------------------------------------------------------------------
  // Surface / Background
  // ---------------------------------------------------------------------------

  /// Warm Off-White — default background.
  static const background = Color(0xFFF6F7F2);

  /// Slightly darker background for cards.
  static const surface = Color(0xFFFFFFFF);

  /// Surface variant for secondary containers.
  static const surfaceVariant = Color(0xFFF0F2EC);

  // ---------------------------------------------------------------------------
  // Border / Divider
  // ---------------------------------------------------------------------------

  /// Default outline/divider colour.
  static const outline = Color(0xFFE1E4DA);

  // ---------------------------------------------------------------------------
  // Text
  // ---------------------------------------------------------------------------

  static const textPrimary = Color(0xFF1E2420);
  static const textSecondary = Color(0xFF6A7367);
  static const textHint = Color(0xFFAAB0A5);
  static const textOnPrimary = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------------------
  // Dark theme variants
  // ---------------------------------------------------------------------------

  static const darkBackground = Color(0xFF1A1F1B);
  static const darkSurface = Color(0xFF242B25);
  static const darkOutline = Color(0xFF3A4040);
  static const darkTextPrimary = Color(0xFFE8EDE5);
  static const darkTextSecondary = Color(0xFF8FA897);
}
