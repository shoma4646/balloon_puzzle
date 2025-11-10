import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ローカルストレージサービスのプロバイダー
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

/// ローカルストレージサービス
class StorageService {
  static const String _keyHighScorePrefix = 'high_score_stage_';
  static const String _keyHighComboPrefix = 'high_combo_stage_';
  static const String _keyVolume = 'volume';
  static const String _keyTutorialCompleted = 'tutorial_completed';

  SharedPreferences? _prefs;

  /// SharedPreferencesのインスタンスを取得
  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// ハイスコアを取得
  Future<int> getHighScore(int stageNumber) async {
    final prefs = await _preferences;
    return prefs.getInt('$_keyHighScorePrefix$stageNumber') ?? 0;
  }

  /// ハイスコアを保存
  Future<void> setHighScore(int stageNumber, int score) async {
    final prefs = await _preferences;
    await prefs.setInt('$_keyHighScorePrefix$stageNumber', score);
  }

  /// 最高コンボ数を取得
  Future<int> getHighCombo(int stageNumber) async {
    final prefs = await _preferences;
    return prefs.getInt('$_keyHighComboPrefix$stageNumber') ?? 0;
  }

  /// 最高コンボ数を保存
  Future<void> setHighCombo(int stageNumber, int combo) async {
    final prefs = await _preferences;
    await prefs.setInt('$_keyHighComboPrefix$stageNumber', combo);
  }

  /// 音量を取得（0.0-1.0）
  Future<double> getVolume() async {
    final prefs = await _preferences;
    return prefs.getDouble(_keyVolume) ?? 0.7;
  }

  /// 音量を保存
  Future<void> setVolume(double volume) async {
    final prefs = await _preferences;
    await prefs.setDouble(_keyVolume, volume);
  }

  /// チュートリアル完了フラグを取得
  Future<bool> getTutorialCompleted() async {
    final prefs = await _preferences;
    return prefs.getBool(_keyTutorialCompleted) ?? false;
  }

  /// チュートリアル完了フラグを保存
  Future<void> setTutorialCompleted(bool completed) async {
    final prefs = await _preferences;
    await prefs.setBool(_keyTutorialCompleted, completed);
  }

  /// すべてのデータをクリア
  Future<void> clearAll() async {
    final prefs = await _preferences;
    await prefs.clear();
  }
}
