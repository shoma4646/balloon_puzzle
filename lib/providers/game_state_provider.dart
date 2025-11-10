import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_state.dart';
import '../models/game_status.dart';
import '../models/balloon_type.dart';
import '../shared/constants/game_constants.dart';

/// ゲーム状態を管理するプロバイダー
class GameStateNotifier extends StateNotifier<GameState> {
  GameStateNotifier() : super(GameState.initial());

  /// ゲームを開始
  void startGame() {
    state = GameState.initial().copyWith(status: GameStatus.playing);
  }

  /// スコアを更新
  void updateScore(int score) {
    state = state.copyWith(score: score);
  }

  /// コンボを更新
  void updateCombo(int combo) {
    state = state.copyWith(combo: combo);
  }

  /// 経過時間を更新
  void updateElapsedTime(double elapsedTime) {
    state = state.copyWith(elapsedTime: elapsedTime);
  }

  /// マージ回数を増加
  void incrementMergeCount() {
    state = state.copyWith(mergeCount: state.mergeCount + 1);
  }

  /// 一時停止
  void pauseGame() {
    if (state.status == GameStatus.playing) {
      state = state.copyWith(status: GameStatus.paused);
    }
  }

  /// 再開
  void resumeGame() {
    if (state.status == GameStatus.paused) {
      state = state.copyWith(status: GameStatus.playing);
    }
  }

  /// ゲームオーバー
  void gameOver() {
    state = state.copyWith(status: GameStatus.gameOver);
  }

  /// リセット
  void reset() {
    state = GameState.initial();
  }
}

/// ゲーム状態プロバイダー
final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>(
  (ref) => GameStateNotifier(),
);
