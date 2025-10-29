import 'package:flutter/material.dart';

class AppColors {
  // Primary colors from your design
  static const Color primary = Color(0xFFDC143C); // Crimson red
  static const Color background = Color(0xFF2A1A1F); // Dark burgundy background
  static const Color cardBackground = Color(0xFF3D2A30); // Lighter card background
  
  // Text colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0B0B0);
  
  // Accent colors
  static const Color accent = Color(0xFF8B00FF); // Purple accent
  static const Color liveIndicator = Color(0xFFFF0000); // Red for live badge
  
  // Gradient colors
  static const List<Color> storyGradient = [
    Color(0xFFDC143C),
    Color(0xFF8B00FF),
  ];
  
  static const List<Color> bannerGradient = [
    Color(0xFFDC143C),
    Color(0xFF8B00FF),
  ];
}