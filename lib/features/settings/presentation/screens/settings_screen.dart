import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/animated_background.dart';
import '../../../../core/presentation/widgets/glass_container.dart';
import '../../../../core/presentation/widgets/gradient_button.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsNotifierProvider);

    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // タイトル
                  Text(
                    'SETTINGS',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 40,
                      color: Colors.white,
                      shadows: [
                        const Shadow(
                          color: AppColors.primary,
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 設定パネル
                  GlassContainer(
                    padding: const EdgeInsets.all(24),
                    child: settingsAsync.when(
                      data: (settings) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _VolumeSlider(
                            label: 'BGM Volume',
                            value: settings.bgmVolume,
                            onChanged: (value) {
                              ref
                                  .read(settingsNotifierProvider.notifier)
                                  .setBgmVolume(value);
                            },
                          ),
                          const SizedBox(height: 24),
                          _VolumeSlider(
                            label: 'SE Volume',
                            value: settings.seVolume,
                            onChanged: (value) {
                              ref
                                  .read(settingsNotifierProvider.notifier)
                                  .setSeVolume(value);
                            },
                          ),
                        ],
                      ),
                      loading: () => const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                      error: (err, stack) => Center(
                        child: Text(
                          'Error: $err',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 戻るボタン
                  GradientButton(
                    child: const Text('BACK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    width: 120,
                    height: 50,
                    gradientColors: const [Colors.grey, Colors.blueGrey],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VolumeSlider extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const _VolumeSlider({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.volume_mute, color: Colors.white70, size: 20),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: Colors.white24,
                  thumbColor: Colors.white,
                  overlayColor: AppColors.primary.withOpacity(0.2),
                  trackHeight: 4.0,
                ),
                child: Slider(
                  value: value,
                  onChanged: onChanged,
                ),
              ),
            ),
            const Icon(Icons.volume_up, color: Colors.white70, size: 20),
          ],
        ),
      ],
    );
  }
}
