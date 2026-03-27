import 'package:flutter/material.dart';

/// Standard MTG mana symbol background colors.
/// See docs/MTG_Colors.md for reference.
class MtgColors {
  MtgColors._();

  // Tile background colors
  static const Color white = Color(0xFFF9FAF4);
  static const Color blue = Color(0xFFAAE0FA);
  static const Color black = Color(0xFFA8A29E);
  static const Color red = Color(0xFFF9AA8F);
  static const Color green = Color(0xFF9BD3AE);
  static const Color colorless = Color(0xFFCBC2BF);

  // Darker variants for large background symbols (lighter for colorless)
  static const Color whiteSymbol = Color(0xFFD4D0B0);
  static const Color blueSymbol = Color(0xFF7BB5D4);
  static const Color blackSymbol = Color(0xFF7A7572);
  static const Color redSymbol = Color(0xFFD08A70);
  static const Color greenSymbol = Color(0xFF6AA07A);
  static const Color colorlessSymbol = Color(0xFFDED8D5);
}
