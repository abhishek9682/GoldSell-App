import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DialogStyle {
  // 🔹 Main heading (like "Remove Nominee")
  static final heading = GoogleFonts.poppins(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );

  // 🔹 Sub heading / content text
  static final subHeading = GoogleFonts.poppins(
    color: Colors.white70,
    fontWeight: FontWeight.w500,
    fontSize: 14,
  );

  // 🔹 Button text
  static final buttonText = GoogleFonts.poppins(
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  // 🔹 Cancel button style
  static final cancelButton = TextStyle(
    color: Colors.white60,
    fontFamily: GoogleFonts.poppins().fontFamily,
    fontWeight: FontWeight.w500,
  );

  // 🔹 Common dialog background
  static final dialogBackground = const Color(0xFF1A1A1A);

  // 🔹 Accent color (for warning or confirm actions)
  static final accentColor = const Color(0xFFFFD700);
}
