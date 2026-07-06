import 'package:flutter/material.dart';

/// Alinma brand palette — hex values pixel-sampled from the official brand
/// assets (banklogo) and app screens. Mirrors WadhahApp/AlinmaColors.swift.
abstract final class AlinmaColors {
  static const primary = Color(0xFF0C2342); // Brand navy (logo background)
  static const background = Color(0xFF0B1F32); // Screen background
  static const card = Color(0xFF122B40); // Cards / containers
  static const cardElevated = Color(0xFF1A3B50); // Icon tiles inside cards
  static const accent = Color(0xFFE65C00); // Alinma orange (CTAs, active tab)
  static const copper = Color(0xFFD17D58); // Wadhah pill / avatar circle
  static const userBubble = Color(0xFF1E63D0); // Chat: user message blue
  static const assistantBubble = Color(0xFFF4EDE6); // Chat: assistant off-white
  static const assistantInk = Color(0xFF2A2A2A); // Chat: text on off-white
  static const pointsLavender45 = Color(0x738B7BC7); // Loyalty badge @45%
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0x8CFFFFFF); // white @55%

  static const double cornerRadius = 16;
}
