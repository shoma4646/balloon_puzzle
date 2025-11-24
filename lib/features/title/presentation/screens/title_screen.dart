import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/local/storage_service.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/stage_configs.dart';
import '../../../../core/presentation/widgets/animated_background.dart';
import '../../../../core/presentation/widgets/glass_container.dart';
import '../../../../core/presentation/widgets/gradient_button.dart';
import '../../../game/presentation/screens/game_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';

/// タイトル画面
class TitleScreen extends ConsumerWidget {
  const TitleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // タイトルロゴ
                    const _TitleLogo(),
                    const SizedBox(height: 60),

                    // ハイスコア表示
                    FutureBuilder<int>(
                      future: ref
                          .read(storageServiceProvider)
                          .getEndlessHighScore(),
                      builder: (context, snapshot) {
                        final highScore = snapshot.data ?? 0;
                        return GlassContainer(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'HIGH SCORE',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color:
                                          AppColors.textWhite.withOpacity(0.8),
                                      letterSpacing: 2.0,
                                    ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                highScore.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                  fontSize: 48,
                                  shadows: [
                                    const Shadow(
                                      color: AppColors.primary,
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 60),

                    // STARTボタン
                    GradientButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const GameScreen(
                              stageData: StageConfigs.endless,
                            ),
                          ),
                        );
                      },
                      height: 64,
                      gradientColors: const [
                        AppColors.primary,
                        AppColors.secondary,
                      ],
                      child: const Text('GAME START'),
                    ),

                    const SizedBox(height: 20),

                    // 設定ボタン
                    GlassContainer(
                      height: 56,
                      borderRadius: 30,
                      color: AppColors.glassWhite.withOpacity(0.1),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.settings,
                                  color: AppColors.textWhite),
                              const SizedBox(width: 8),
                              Text(
                                'SETTINGS',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: AppColors.textWhite,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleLogo extends StatelessWidget {
  const _TitleLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Floating Balloons Icon
        const SizedBox(
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 0,
                top: 20,
                child: _GlowingBalloon(color: AppColors.balloonCyan, size: 60),
              ),
              Positioned(
                right: 0,
                top: 10,
                child:
                    _GlowingBalloon(color: AppColors.balloonPurple, size: 70),
              ),
              Positioned(
                top: 0,
                child: _GlowingBalloon(color: AppColors.balloonRed, size: 80),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Balloon\nPuzzle',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: 56,
            height: 1.0,
            shadows: [
              const Shadow(
                color: AppColors.primary,
                offset: Offset(0, 4),
                blurRadius: 10,
              ),
              Shadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 8),
                blurRadius: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GlowingBalloon extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowingBalloon({
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(0.8),
            color,
          ],
          center: const Alignment(-0.3, -0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.6),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.8),
              Colors.transparent,
              Colors.transparent,
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
      ),
    );
  }
}
