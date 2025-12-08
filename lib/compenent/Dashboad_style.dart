import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';

class dashBoardStyle{
  static final nameColor =GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Color(0xFFFFFFFF),
  );

  // 🔹 Subtitle (like "DIGITAL GOLD")
  static final subHeading = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFFFFD700),
    letterSpacing: 3,
  );

  // 🔹 Feature labels (like "Secure", "Instant")
  static final featureLabel = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,

  );

  // 🔹 Button text (like "Get Started")
  static final buttonText = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF0A0A0A),
  );

  // 🔹 subButton text (like "Get Started")
  static final subInputText = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF0A0A0A),
  );


  // 🔹 Generic title for later pages
  static final pageTitle = GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  // 🔹 Body or paragraph text
  static final bodyText = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Color(0xFFFFFFFF)
  );

  // 🔹 Label text (for text fields, etc.)
  static final labelText = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  // 🔹 Input text style
  static final inputText = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  // 🔹 Quick Invest / Section Titles
  static final sectionTitle = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
      color: Color(0xFFFFFFFF)
  );

  // 🔹 Small link / action text (like "Custom →")
  static final sectionLink = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFFFFD700),
  );

  // 🔹 Investment amount text (₹500 etc.)
  static final investmentAmount = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
      color: Color(0xFFFFFFFF)  );

  // 🔹 Investment gold weight text (0.073g)
  static final investmentGold = GoogleFonts.poppins(
    fontSize: 12,
      color: Color(0xFFFFFFFF)
  );

  // 🔹 Button text for Buy Gold Now
  static final buyButtonText = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFF0A0A0A),
  );

  // 🔹 Explore card title
  static final exploreCardTitle = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
      color: Color(0xFFFFFFFF)
  );

  // 🔹 Explore card subtitle
  static final exploreCardSubtitle = GoogleFonts.poppins(
    fontSize: 11,
    color: Color(0x99FFFFFF), // equivalent to Colors.white60
  );

}