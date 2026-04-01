import 'package:flutter/material.dart';

class SouloWordmark extends StatelessWidget {
  const SouloWordmark({
    super.key,
    this.lightVariant = false,
    this.wordHeight = 56,
    this.gap = 4,
    this.alignment = CrossAxisAlignment.start,
  });

  final bool lightVariant;
  final double wordHeight;
  final double gap;
  final CrossAxisAlignment alignment;

  String get _suffix => lightVariant ? 'light' : 'dark';

  Widget _buildWord(String name) {
    return Image.asset(
      'assets/branding/${name}_$_suffix.png',
      height: wordHeight,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: alignment,
      children: [
        _buildWord('soulo'),
        SizedBox(height: gap),
        _buildWord('play'),
      ],
    );
  }
}
