import 'package:flutter/widgets.dart';

/// Icon data for the Mana font by Andrew Gioia.
/// Codepoints from https://mana.andrewgioia.com/icons.html
/// Full reference: docs/ManaFontReference.md
class ManaIcons {
  ManaIcons._();

  static const String _fontFamily = 'Mana';

  // Mana symbols
  static const IconData white = IconData(0xe600, fontFamily: _fontFamily);
  static const IconData blue = IconData(0xe601, fontFamily: _fontFamily);
  static const IconData black = IconData(0xe602, fontFamily: _fontFamily);
  static const IconData red = IconData(0xe603, fontFamily: _fontFamily);
  static const IconData green = IconData(0xe604, fontFamily: _fontFamily);
  static const IconData colorless = IconData(0xe904, fontFamily: _fontFamily);

  // Other symbols
  static const IconData acorn = IconData(0xe929, fontFamily: _fontFamily);
}
