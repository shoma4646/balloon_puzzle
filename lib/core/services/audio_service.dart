import 'package:flame_audio/flame_audio.dart';

/// 音声再生を管理するサービスクラス
class AudioService {
  static final AudioService _instance = AudioService._internal();

  factory AudioService() => _instance;

  AudioService._internal();

  double _bgmVolume = 0.5;
  double _seVolume = 0.8;
  bool _isBgmPlaying = false;
  String? _currentBgm;
  bool isTestMode = false;

  /// 初期化処理
  Future<void> initialize() async {
    if (isTestMode) return;
    // 音声ファイルのキャッシュ（必要に応じて）
    // await FlameAudio.audioCache.loadAll(['bgm/title.mp3', 'sfx/tap.mp3']);
  }

  /// BGM音量の設定 (0.0 - 1.0)
  void setBgmVolume(double volume) {
    _bgmVolume = volume.clamp(0.0, 1.0);
    if (isTestMode) return;
    if (_isBgmPlaying) {
      FlameAudio.bgm.audioPlayer.setVolume(_bgmVolume);
    }
  }

  /// SE音量の設定 (0.0 - 1.0)
  void setSeVolume(double volume) {
    _seVolume = volume.clamp(0.0, 1.0);
  }

  /// BGMの再生
  Future<void> playBgm(String filename) async {
    if (isTestMode) return;
    if (_currentBgm == filename && _isBgmPlaying) return;

    try {
      if (_isBgmPlaying) {
        await stopBgm();
      }

      _currentBgm = filename;
      // FlameAudio.bgm.play は内部でループ再生を行う
      await FlameAudio.bgm.play(filename, volume: _bgmVolume);
      _isBgmPlaying = true;
    } catch (e) {
      print('Error playing BGM: $e');
    }
  }

  /// BGMの停止
  Future<void> stopBgm() async {
    if (isTestMode) return;
    try {
      await FlameAudio.bgm.stop();
      _isBgmPlaying = false;
      _currentBgm = null;
    } catch (e) {
      print('Error stopping BGM: $e');
    }
  }

  /// BGMの一時停止
  Future<void> pauseBgm() async {
    if (isTestMode) return;
    if (!_isBgmPlaying) return;
    try {
      await FlameAudio.bgm.pause();
      _isBgmPlaying = false;
    } catch (e) {
      print('Error pausing BGM: $e');
    }
  }

  /// BGMの再開
  Future<void> resumeBgm() async {
    if (isTestMode) return;
    if (_isBgmPlaying || _currentBgm == null) return;
    try {
      await FlameAudio.bgm.resume();
      _isBgmPlaying = true;
    } catch (e) {
      print('Error resuming BGM: $e');
    }
  }

  /// SEの再生
  Future<void> playSe(String filename) async {
    if (isTestMode) return;
    if (_seVolume <= 0) return;
    try {
      await FlameAudio.play(filename, volume: _seVolume);
    } catch (e) {
      // SEファイルがない場合のエラーは頻発する可能性があるため、開発中はログに出すが
      // 本番では無視するか、適切なエラーハンドリングを行う
      print('Error playing SE: $e');
    }
  }
}
