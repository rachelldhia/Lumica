import 'package:flutter/material.dart';

class TextFormat {
  final bool isBold;
  final bool isItalic;
  final bool isUnderline;
  final bool isStrikethrough;
  final TextAlign alignment;

  const TextFormat({
    this.isBold = false,
    this.isItalic = false,
    this.isUnderline = false,
    this.isStrikethrough = false,
    this.alignment = TextAlign.left,
  });

  TextFormat copyWith({
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
    bool? isStrikethrough,
    TextAlign? alignment,
  }) {
    return TextFormat(
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      isUnderline: isUnderline ?? this.isUnderline,
      isStrikethrough: isStrikethrough ?? this.isStrikethrough,
      alignment: alignment ?? this.alignment,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isBold': isBold,
      'isItalic': isItalic,
      'isUnderline': isUnderline,
      'isStrikethrough': isStrikethrough,
      'alignment': alignment.index,
    };
  }

  factory TextFormat.fromJson(Map<String, dynamic> json) {
    return TextFormat(
      isBold: json['isBold'] ?? false,
      isItalic: json['isItalic'] ?? false,
      isUnderline: json['isUnderline'] ?? false,
      isStrikethrough: json['isStrikethrough'] ?? false,
      alignment: TextAlign.values[json['alignment'] ?? 0],
    );
  }
}
