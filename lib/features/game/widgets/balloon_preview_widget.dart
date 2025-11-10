import 'package:flutter/material.dart';
import '../../../models/balloon_type.dart';
import '../../../shared/constants/app_colors.dart';

/// 次の風船プレビューウィジェット
class BalloonPreviewWidget extends StatelessWidget {
  final List<BalloonType> nextBalloons;

  const BalloonPreviewWidget({
    super.key,
    required this.nextBalloons,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.overlayDark.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'NEXT',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textGray,
              fontWeight: FontWeight.bold,
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
    final size = 40.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: balloonType.color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          balloonType.level.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
            shadows: const [
              Shadow(
                color: Colors.black45,
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
