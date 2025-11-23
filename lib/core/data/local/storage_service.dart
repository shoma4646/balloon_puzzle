import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'storage_service.g.dart';

/// ローカルストレージサービスのプロバイダー
@riverpod
StorageService storageService(StorageServiceRef ref) {
  return StorageService();
}

/// ローカルストレージサービス
class StorageService {
  static const String _keyHighScorePrefix = 'high_score_stage_';
  static const String _keyHighComboPrefix = 'high_combo_stage_';
  static const String _keyEndlessHighScore = 'endless_high_score'; // エンドレスモード専用
  static const String _keyBgmVolume = 'bgm_volume';
  static const String _keySeVolume = 'se_volume';
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

  /// エンドレスモードのハイスコアを取得
  Future<int> getEndlessHighScore() async {
    final prefs = await _preferences;
    return prefs.getInt(_keyEndlessHighScore) ?? 0;
  }

  /// エンドレスモードのハイスコアを保存
  Future<void> setEndlessHighScore(int score) async {
    final prefs = await _preferences;
    await prefs.setInt(_keyEndlessHighScore, score);
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

  /// BGM音量を取得（0.0-1.0）
  Future<double> getBgmVolume() async {
    final prefs = await _preferences;
    return prefs.getDouble(_keyBgmVolume) ?? 0.5;
  }

  /// BGM音量を保存
  Future<void> setBgmVolume(double volume) async {
    final prefs = await _preferences;
    await prefs.setDouble(_keyBgmVolume, volume);
  }

  /// SE音量を取得（0.0-1.0）
  Future<double> getSeVolume() async {
    final prefs = await _preferences;
    return prefs.getDouble(_keySeVolume) ?? 0.8;
  }

  /// SE音量を保存
  Future<void> setSeVolume(double volume) async {
    final prefs = await _preferences;
    await prefs.setDouble(_keySeVolume, volume);
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

  /// 初回起動かどうか（チュートリアル未完了なら初回とみなす）
  Future<bool> isFirstLaunch() async {
    final completed = await getTutorialCompleted();
    return !completed;
  }

  /// 初回起動完了（チュートリアル完了）を保存
  Future<void> setFirstLaunchCompleted() async {
    await setTutorialCompleted(true);
  }

  /// すべてのデータをクリア
  Future<void> clearAll() async {
    final prefs = await _preferences;
    await prefs.clear();
  }
}
