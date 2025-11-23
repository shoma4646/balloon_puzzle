import 'package:flutter/material.dart';
import '../../domain/entities/balloon_type.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/glass_container.dart';

/// 次の風船プレビューウィジェット
class BalloonPreviewWidget extends StatelessWidget {
  final List<BalloonType> nextBalloons;

  const BalloonPreviewWidget({
    super.key,
    required this.nextBalloons,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(15),
      borderRadius: 15,
      color: AppColors.glassWhite.withOpacity(0.05),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'NEXT',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textWhite.withOpacity(0.7),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 10),
          ...nextBalloons.map((balloonType) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _BalloonPreviewItem(balloonType: balloonType),
            );
          }),
        ],
      ),
    );
  }
}

class _BalloonPreviewItem extends StatelessWidget {
  final BalloonType balloonType;

  const _BalloonPreviewItem({required this.balloonType});

  @override
  Widget build(BuildContext context) {
    const size = 40.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            balloonType.color.withOpacity(0.8),
            balloonType.color,
          ],
          center: const Alignment(-0.3, -0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: balloonType.color.withOpacity(0.6),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.7),
              Colors.transparent,
              Colors.transparent,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: Center(
          child: Text(
            balloonType.level.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: size * 0.4,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: balloonType.color.withOpacity(0.8),
                  blurRadius: 5,
                ),
                const Shadow(
                  color: Colors.black26,
                  offset: Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
