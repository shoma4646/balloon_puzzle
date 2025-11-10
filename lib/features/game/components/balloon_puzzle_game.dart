import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import '../../../models/balloon_type.dart';
import '../../../models/stage_data.dart';
import '../../../shared/constants/game_constants.dart';
import 'balloon_component.dart';
import 'branch_component.dart';
import 'collision_callbacks.dart';
import 'game_boundary.dart';
import 'sky_background_component.dart';
import 'tree_foliage_component.dart';
import 'tree_trunk_component.dart';

/// 風船パズルゲームのメインクラス
class BalloonPuzzleGame extends Forge2DGame with TapDetector {
  final StageData stageData;
  final Function(int score) onScoreUpdate;
  final VoidCallback onGameOver;

  List<BalloonType> nextBalloonTypes = [];
  int _score = 0;
  double _gameOverTimer = 0.0; // ゲームオーバーまでのタイマー
  bool _isGameOverTriggered = false; // ゲームオーバーが既に発火したか
  double _elapsedTime = 0.0; // ゲーム開始からの経過時間
  double _lastBalloonSpawnTime = -999.0; // 最後に風船を配置した時刻

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

    // カメラの設定
    camera.viewfinder.anchor = Anchor.topLeft;

    // 衝突リスナーを設定
    world.physicsWorld.setContactListener(BalloonContactListener());

    // 次の風船タイプを初期化
    nextBalloonTypes = List.generate(
      GameConstants.balloonPreviewCount,
      (_) => BalloonType.random(),
    );

    // 背景（青空と雲）を追加
    await add(SkyBackgroundComponent(gameSize: size));

    // ゲーム境界を追加
    await add(GameBoundary(size: size));

    // 木の幹を配置
    _setupTreeTrunk();

    // 木の葉を配置
    _setupTreeFoliage();

    // ステージの枝を配置
    _setupBranches();
  }

  /// 木の幹を配置
  void _setupTreeTrunk() {
    // 画面の一番右端に木の幹を配置（一部が見える）
    final trunkX = size.x + 60; // 画面の右端より60ピクセル右（一部だけ見える）
    final trunkHeight = size.y; // 画面の高さ全体

    final trunk = TreeTrunkComponent(
      position: Vector2(trunkX, size.y / 2),
      height: trunkHeight,
      width: 150.0, // さらに太く
    );
    add(trunk);
  }

  /// 木の葉を配置
  void _setupTreeFoliage() {
    // 画面右端（木の幹の位置）に葉を配置（下半分のみ見える）
    final trunkX = size.x + 60; // 木の幹と同じ位置

    final foliage = TreeFoliageComponent(
      treePosition: Vector2(trunkX, -175), // 上半分は画面外に配置
      foliageWidth: 650.0, // 横幅をさらに広く
    );
    add(foliage);
  }

  /// 枝を配置
  void _setupBranches() {
    for (final branchConfig in stageData.branches) {
      final branch = BranchComponent(
        position: Vector2(
          branchConfig.getActualX(size.x),
          branchConfig.getActualY(size.y),
        ),
        length: branchConfig.getActualLength(size.x),
        angle: branchConfig.angle,
      );
      add(branch);
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);

    // タップ位置が画面下部20%の領域内かチェック
    final tapY = info.eventPosition.global.y;
    final screenHeight = size.y;
    final tapAreaStart = screenHeight * 0.8; // 下部20%

    if (tapY >= tapAreaStart) {
      // クールダウンチェック
      final timeSinceLastSpawn = _elapsedTime - _lastBalloonSpawnTime;

      if (timeSinceLastSpawn >= GameConstants.balloonSpawnCooldown) {
        _spawnBalloon(info.eventPosition.global);
        _lastBalloonSpawnTime = _elapsedTime;
        print('✅ Balloon spawned at $_elapsedTime (cooldown: ${timeSinceLastSpawn.toStringAsFixed(2)}s)');
      } else {
        print('❌ Spawn blocked (cooldown: ${timeSinceLastSpawn.toStringAsFixed(2)}s / ${GameConstants.balloonSpawnCooldown}s)');
      }
    }
  }

  /// 風船を生成
  void _spawnBalloon(Vector2 position) {
    if (nextBalloonTypes.isEmpty) return;

    // 次の風船タイプを取得
    final balloonType = nextBalloonTypes.removeAt(0);

    // Forge2Dのワールドがロックされている可能性があるため、次のフレームで生成
    Future.microtask(() {
      // 新しい風船を生成
      final balloon = BalloonComponent(
        position: position,
        balloonType: balloonType,
        onMerge: _onBalloonMerge,
        onPop: _onBalloonPop,
      );

      add(balloon);

      // スコア加算（風船を離すポイント）
      _addScore(balloonType.releasePoint);
    });

    // 次の風船タイプを追加
    nextBalloonTypes.add(BalloonType.random());
  }

  /// 風船がマージされた時の処理
  void _onBalloonMerge(BalloonType fromType, BalloonType toType) {
    // スコア加算
    final score = toType.mergeBonus;
    _addScore(score);
  }

  /// 風船が消えた時の処理（Lv.8風船）
  void _onBalloonPop() {
    const score = GameConstants.maxBalloonPopBonus;
    _addScore(score);
  }

  /// スコアを加算
  void _addScore(int points) {
    _score += points;
    onScoreUpdate(_score);
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
    int balloonCount = 0;

    for (final component in children) {
      if (component is BalloonComponent) {
        balloonCount++;
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

    // ゲームオーバー判定
    checkGameOver(dt);
  }

  /// 現在のスコアを取得
  int get score => _score;

  /// cooldownの進行状況を取得（0.0〜1.0）
  double get cooldownProgress {
    final timeSinceLastSpawn = _elapsedTime - _lastBalloonSpawnTime;
    if (timeSinceLastSpawn >= GameConstants.balloonSpawnCooldown) {
      return 1.0; // 完全にチャージ完了
    }
    return timeSinceLastSpawn / GameConstants.balloonSpawnCooldown;
  }
}
