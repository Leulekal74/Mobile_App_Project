import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 26 : 32,
          height: compact ? 26 : 32,
          decoration: BoxDecoration(
            color: AppColors.brandYellow,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Icon(Icons.auto_awesome_mosaic_rounded,
                size: 18, color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'TibebArchive',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: compact ? 18 : 20,
            color: AppColors.brandYellowDeep,
          ),
        ),
      ],
    );
  }
}