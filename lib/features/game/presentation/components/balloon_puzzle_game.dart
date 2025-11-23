import 'package:flame/components.dart' hide Vector2;
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' as vm;

import '../../domain/entities/balloon_type.dart';
import '../../../../core/domain/entities/stage_data.dart';
import '../../../../core/constants/game_constants.dart';
import '../../../../core/services/audio_service.dart';
import '../../domain/logic/combo_system.dart';

import 'balloon_component.dart';
import 'cloud_platform_component.dart';
import 'collision_callbacks.dart';
import 'floating_cloud_component.dart';
import 'game_boundary.dart';

/// 風船パズルゲームのメインクラス
class BalloonPuzzleGame extends Forge2DGame with PanDetector {
  final StageData stageData;
  final Function(int score, int combo) onScoreUpdate;
  final VoidCallback onGameOver;

  List<BalloonType> nextBalloonTypes = [];
  int _score = 0;
  double _gameOverTimer = 0.0; // ゲームオーバーまでのタイマー
  bool _isGameOverTriggered = false; // ゲームオーバーが既に発火したか
  double _elapsedTime = 0.0; // ゲーム開始からの経過時間
  double _lastBalloonSpawnTime = -999.0; // 最後に風船を配置した時刻

  // コンボシステム
  final ComboSystem _comboSystem = ComboSystem();

  // ガイドライン用
  Vector2? _aimPosition;
  bool _isAiming = false;

  BalloonPuzzleGame({
    required this.stageData,
    required this.onScoreUpdate,
    required this.onGameOver,
  }) : super(gravity: Vector2(0, GameConstants.gravity)) {
    // nextBalloonTypesを初期化
    nextBalloonTypes = List.generate(
      GameConstants.balloonPreviewCount,
      (_) => BalloonType.random(),
    );
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // BGM再生
    AudioService().playBgm('bgm/game_bgm.mp3');

    // カメラの設定
    camera.viewfinder.anchor = Anchor.topLeft;

    // 衝突リスナーを設定
    world.physicsWorld.setContactListener(BalloonContactListener());

    // 次の風船タイプを初期化
    nextBalloonTypes = List.generate(
      GameConstants.balloonPreviewCount,
      (_) => BalloonType.random(),
    );

    // ゲーム境界を追加
    // GameBoundaryはForge2DのBodyComponentなのでVector2(64)が必要
    // sizeはFlameのVector2(32)なので変換する
    await add(GameBoundary(size: Vector2(size.x, size.y)));

    // ステージの雲の棚を配置
    _setupCloudPlatforms();

    // 流れる装飾を配置
    _setupFloatingDecorations();
  }

  /// 流れる装飾（星や雲）を配置
  void _setupFloatingDecorations() {
    final random = math.Random();

    // 5〜8個の装飾を配置
    final decorationCount = 5 + random.nextInt(4);
    for (var i = 0; i < decorationCount; i++) {
      // ランダムにタイプを選択（星か雲）
      final type = random.nextBool()
          ? FloatingDecorationType.star
          : FloatingDecorationType.cloud;

      // ランダムな初期位置
      final initialX = random.nextDouble() * size.x;
      final initialY = random.nextDouble() * size.y * 0.8; // 画面の上80%

      // ランダムな速度とスケール
      final speed = 10.0 + random.nextDouble() * 15.0;
      final scale = 0.3 + random.nextDouble() * 0.7;

      add(FloatingCloudComponent(
        gameSize: vm.Vector2(size.x, size.y), // FlameのVector2(32)が必要
        initialPosition: vm.Vector2(initialX, initialY), // FlameのVector2(32)が必要
        speed: speed,
        scaleFactor: scale,
        type: type,
      ));
    }
  }

  /// 雲の棚を配置
  void _setupCloudPlatforms() {
    for (final platformConfig in stageData.platforms) {
      final platform = CloudPlatformComponent(
        position: Vector2(
          platformConfig.getActualX(size.x),
          platformConfig.getActualY(size.y),
        ),
        length: platformConfig.getActualLength(size.x),
      );
      add(platform);
    }
  }

  @override
  void onPanStart(DragStartInfo info) {
    super.onPanStart(info);
    _handleInput(info.eventPosition.global);
    _isAiming = true;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    super.onPanUpdate(info);
    _handleInput(info.eventPosition.global);
  }

  // 入力処理共通化
  void _handleInput(Vector2 position) {
    // タップ位置が画面下部20%の領域内かチェック
    final tapY = position.y;
    final screenHeight = size.y;
    final tapAreaStart = screenHeight * 0.8; // 下部20%

    if (tapY >= tapAreaStart) {
      _aimPosition = position;
    } else {
      _aimPosition = null;
    }
  }

  // スポーン可能かチェック
  bool _canSpawnBalloon() {
    final timeSinceLastSpawn = _elapsedTime - _lastBalloonSpawnTime;
    return timeSinceLastSpawn >= GameConstants.balloonSpawnCooldown;
  }

  @override
  void onPanCancel() {
    super.onPanCancel();
    _isAiming = false;
    _aimPosition = null;
  }

  @override
  void onPanEnd(DragEndInfo info) {
    super.onPanEnd(info);

    if (_aimPosition != null && _canSpawnBalloon()) {
      _spawnBalloon(_aimPosition!);
      _lastBalloonSpawnTime = _elapsedTime;
      print('✅ Balloon spawned at $_elapsedTime');
    } else if (_aimPosition != null) {
      print('❌ Spawn blocked (cooldown)');
    }

    _isAiming = false;
    _aimPosition = null;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // ガイドライン描画
    if (_isAiming && _aimPosition != null) {
      final paint = Paint()
        ..color = Colors.white.withOpacity(0.5)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      const dashWidth = 10.0;
      const dashSpace = 10.0;
      double startY = 0; // 画面上端から
      final x = _aimPosition!.x;

      // 画面下端まで破線を描画
      while (startY < size.y) {
        canvas.drawLine(
          Offset(x, startY),
          Offset(x, startY + dashWidth),
          paint,
        );
        startY += dashWidth + dashSpace;
      }

      // 落下予測位置にプレビュー（半透明の円）を表示
      // 次の風船のサイズを取得
      if (nextBalloonTypes.isNotEmpty) {
        final nextType = nextBalloonTypes.first;
        final radius = nextType.radius;

        final previewPaint = Paint()
          ..color = nextType.color.withOpacity(0.3)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset(x, radius), radius, previewPaint);
      }
    }
  }

  /// 風船を生成
  void _spawnBalloon(Vector2 position) {
    if (nextBalloonTypes.isEmpty) return;

    // SE再生
    AudioService().playSe('sfx/spawn.mp3');

    // 次の風船タイプを取得
    final balloonType = nextBalloonTypes.removeAt(0);

    // Forge2Dのワールドがロックされている可能性があるため、次のフレームで生成
    Future.microtask(() {
      // 新しい風船を生成
      // X座標はタップ位置、Y座標は画面上端（または少し下）
      // position.yはタップ位置だが、風船は上から落ちてくるべき
      // なのでY座標を修正する
      final spawnPos = Vector2(position.x, balloonType.radius + 10);

      final balloon = BalloonComponent(
        position: spawnPos,
        balloonType: balloonType,
        onMerge: _onBalloonMerge,
        onPop: _onBalloonPop,
      );

      add(balloon);

      // スコア加算（風船を離すポイント）
      // コンボは適用しない
      _addScore(balloonType.releasePoint);
    });

    // 次の風船タイプを追加（スコアに応じた難易度で生成）
    nextBalloonTypes.add(BalloonType.randomWithDifficulty(_score));
  }

  /// 風船がマージされた時の処理
  void _onBalloonMerge(BalloonType fromType, BalloonType toType) {
    // SE再生
    AudioService().playSe('sfx/merge.mp3');

    // コンボ加算
    _comboSystem.addCombo();

    // スコア加算（コンボボーナス適用）
    final baseScore = toType.mergeBonus;
    final multiplier = _comboSystem.comboMultiplier;
    final finalScore = (baseScore * multiplier).round();

    _addScore(finalScore);

    // コンボログ出力
    if (_comboSystem.comboCount > 1) {
      print(
          'Combo: ${_comboSystem.comboCount} (x${multiplier.toStringAsFixed(1)})');
    }
  }

  /// 風船が消えた時の処理（Lv.8風船）
  void _onBalloonPop() {
    // SE再生
    AudioService().playSe('sfx/pop.mp3');

    // コンボ加算
    _comboSystem.addCombo();

    const baseScore = GameConstants.maxBalloonPopBonus;
    final multiplier = _comboSystem.comboMultiplier;
    final finalScore = (baseScore * multiplier).round();

    _addScore(finalScore);
  }

  /// スコアを加算
  void _addScore(int points) {
    _score += points;
    onScoreUpdate(_score, _comboSystem.comboCount);
  }

  /// ゲームオーバー判定
  void checkGameOver(double dt) {
    if (_isGameOverTriggered) return;

    // ゲームオーバーラインのY座標
    // Forge2Dでは原点が左上、Y座標は下に行くほど大きくなる（画面座標系と同じ）
    // 画面上部2%の位置（Y値が小さい位置）でゲームオーバー
    final gameOverLineY = size.y * (1.0 - GameConstants.gameOverLineRatio);

    // すべての風船をチェック
    bool hasBalloonAboveLine = false;
    double minBalloonY = double.infinity;

    for (final component in children) {
      if (component is BalloonComponent) {
        final balloonY = component.body.position.y;
        if (balloonY < minBalloonY) {
          minBalloonY = balloonY;
        }

        // 風船のY座標がgameOverLineY（画面上部2%）より小さい場合
        if (balloonY <= gameOverLineY) {
          hasBalloonAboveLine = true;
          break;
        }
      }
    }

    // 風船がラインを超えている場合
    if (hasBalloonAboveLine) {
      _gameOverTimer += dt;
      if (_gameOverTimer >= GameConstants.gameOverGracePeriod) {
        _isGameOverTriggered = true;

        // BGM停止とゲームオーバーSE再生
        AudioService().stopBgm();
        AudioService().playSe('sfx/game_over.mp3');

        onGameOver();
      }
    } else {
      _gameOverTimer = 0.0;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 経過時間を更新
    _elapsedTime += dt;

    // コンボシステムの更新
    _comboSystem.update(dt);

    // ゲームオーバー判定
    checkGameOver(dt);
  }

  /// 現在のスコアを取得
  int get score => _score;

  /// 現在のコンボ数を取得
  int get comboCount => _comboSystem.comboCount;

  /// コンボタイマーの進行状況を取得
  double get comboTimerProgress => _comboSystem.timerProgress;

  /// cooldownの進行状況を取得（0.0〜1.0）
  double get cooldownProgress {
    final timeSinceLastSpawn = _elapsedTime - _lastBalloonSpawnTime;
    if (timeSinceLastSpawn >= GameConstants.balloonSpawnCooldown) {
      return 1.0; // 完全にチャージ完了
    }
    return timeSinceLastSpawn / GameConstants.balloonSpawnCooldown;
  }
}
