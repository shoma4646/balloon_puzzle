import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import 'glass_container.dart';

/// グラスモーフィズムデザインのダイアログ
class GlassDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;

  const GlassDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: GlassContainer(
        padding: const EdgeInsets.all(24),
        borderRadius: 24,
        // border: Border.all(
        //   color: Colors.white.withOpacity(0.3),
        //   width: 1.5,
        // ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // タイトル
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textWhite,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(1, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // コンテンツ
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textWhite,
              ),
              child: content,
            ),

            if (actions != null) ...[
              const SizedBox(height: 32),
              // アクションボタン
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: actions!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
