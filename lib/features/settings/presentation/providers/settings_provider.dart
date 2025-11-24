import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/data/local/storage_service.dart';

import '../../../../core/services/audio_service.dart';

part 'settings_provider.g.dart';

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  Future<SettingsState> build() async {
    final storage = ref.read(storageServiceProvider);
    final bgmVolume = await storage.getBgmVolume();
    final seVolume = await storage.getSeVolume();

    // AudioServiceに初期値を設定
    final audioService = AudioService();
    audioService.setBgmVolume(bgmVolume);
    audioService.setSeVolume(seVolume);

    return SettingsState(
      bgmVolume: bgmVolume,
      seVolume: seVolume,
    );
  }

  Future<void> setBgmVolume(double volume) async {
    final storage = ref.read(storageServiceProvider);
    await storage.setBgmVolume(volume);

    // AudioServiceに反映
    AudioService().setBgmVolume(volume);

    state = AsyncValue.data(state.value!.copyWith(bgmVolume: volume));
  }

  Future<void> setSeVolume(double volume) async {
    final storage = ref.read(storageServiceProvider);
    await storage.setSeVolume(volume);

    // AudioServiceに反映
    AudioService().setSeVolume(volume);

    state = AsyncValue.data(state.value!.copyWith(seVolume: volume));
  }
}

class SettingsState {
  final double bgmVolume;
  final double seVolume;

  SettingsState({
    required this.bgmVolume,
    required this.seVolume,
  });

  SettingsState copyWith({
    double? bgmVolume,
    double? seVolume,
  }) {
    return SettingsState(
      bgmVolume: bgmVolume ?? this.bgmVolume,
      seVolume: seVolume ?? this.seVolume,
    );
  }
}
