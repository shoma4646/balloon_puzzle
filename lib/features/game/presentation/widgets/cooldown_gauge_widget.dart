import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Cooldownゲージウィジェット
class CooldownGaugeWidget extends StatelessWidget {
  final double progress; // 0.0〜1.0

  const CooldownGaugeWidget({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    const gaugeHeight = 8.0;

    return SizedBox(
      height: gaugeHeight,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(gaugeHeight / 2),
          border: Border.all(
            color: Colors.white.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(gaugeHeight / 2),
          child: Stack(
            children: [
              // 進行状況バー
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: progress >= 1.0
                          ? [
                              AppColors.primary,
                              AppColors.success,
                            ]
                          : [
                              Colors.orange.shade300,
                              Colors.orange.shade500,
                            ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
