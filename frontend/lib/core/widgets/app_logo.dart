import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.compact = false,
    this.height,
  });

  final bool compact;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final resolvedHeight = height ?? (compact ? 28.0 : 32.0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: resolvedHeight,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 10),
        Text(
          'TibebArchive',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: compact ? 18 : 20,
            color: const Color(0xFFE0A300),
          ),
        ),
      ],
    );
  }
}
