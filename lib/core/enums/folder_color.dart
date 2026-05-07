import 'package:flutter/material.dart';

enum FolderColor {
  orange(Color(0xFFFF8A65)),
  green(Color(0xFF4CAF50)),
  blue(Color(0xFF42A5F5)),
  brown(Color(0xFF8D6E63)),
  teal(Color(0xFF4DB6AC)),
  olive(Color(0xFF9E9D24)),
  navy(Color(0xFF5C6BC0));

  final Color color;
  const FolderColor(this.color);

  static List<Color> get colors => FolderColor.values.map((e) => e.color).toList();
}
