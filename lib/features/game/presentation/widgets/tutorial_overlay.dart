import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/glass_container.dart';
import '../../../../core/presentation/widgets/gradient_button.dart';

/// ゲームの操作説明を表示するオーバーレイ
class TutorialOverlay extends StatelessWidget {
  final VoidCallback onClose;

  const TutorialOverlay({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.6),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: GlassContainer(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(24),
            borderRadius: 20,
            color: AppColors.glassWhite.withOpacity(0.1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'あそびかた',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textWhite,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                _buildTutorialItem(
                  icon: Icons.touch_app,
                  title: 'タップして落とす',
                  description: '画面をタップすると、その位置に風船が落ちてきます。',
                ),
                const SizedBox(height: 16),
                _buildTutorialItem(
                  icon: Icons.merge_type,
                  title: '同じ風船をくっつける',
                  description: '同じ種類の風船がぶつかると、合体して大きくなります。',
                ),
                const SizedBox(height: 16),
                _buildTutorialItem(
                  icon: Icons.arrow_upward,
                  title: '上まで積まないように',
                  description: '風船が上のラインを超えるとゲームオーバーです。',
                ),
                const SizedBox(height: 32),
                GradientButton(
                  onPressed: onClose,
                  width: 200,
                  height: 50,
                  child: const Text(
                    'ゲームスタート',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTutorialItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textWhite,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textWhite.withOpacity(0.8),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
