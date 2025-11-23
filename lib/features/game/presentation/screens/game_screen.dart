import 'dart:async';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/entities/stage_data.dart';
import '../../../../providers/game_state_provider.dart';
import '../../../../core/data/local/storage_service.dart';

import '../components/balloon_puzzle_game.dart';
import '../widgets/balloon_preview_widget.dart';
import '../widgets/cooldown_gauge_widget.dart';
import '../widgets/game_hud.dart';
import '../widgets/tutorial_overlay.dart';
import '../../../../core/presentation/widgets/animated_background.dart';
import '../../../../core/presentation/widgets/glass_dialog.dart';
import '../../../../core/presentation/widgets/gradient_button.dart';

/// ゲーム画面
class GameScreen extends ConsumerStatefulWidget {
  final StageData stageData;

  const GameScreen({
    super.key,
    required this.stageData,
  });

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  late BalloonPuzzleGame _game;
  Timer? _timer;
  double _elapsedTime = 0;
  int _comboCount = 0;
  Key _gameKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    // ゲームインスタンスを作成
    _game = BalloonPuzzleGame(
      stageData: widget.stageData,
      onScoreUpdate: (score, combo) {
        ref.read(gameStateNotifierProvider.notifier).updateScore(score);
        // コンボ数が変わった場合のみ再描画
        if (_comboCount != combo) {
          setState(() {
            _comboCount = combo;
          });
        }
      },
      onGameOver: () {
        _stopTimer();
        ref.read(gameStateNotifierProvider.notifier).gameOver();
        _showGameOverDialog();
      },
    );

    // ゲームを開始（Futureで遅延実行）
    Future(() async {
      ref.read(gameStateNotifierProvider.notifier).startGame();

      // 初回起動チェック
      final storage = ref.read(storageServiceProvider);
      final isFirstLaunch = await storage.isFirstLaunch();

      if (isFirstLaunch) {
        // 初回の場合はチュートリアルを表示（ゲームは開始しない）
        if (mounted) {
          _showTutorial();
          await storage.setFirstLaunchCompleted();
        }
      } else {
        // 2回目以降は即座にスタート
        _startTimer();
      }
    });
  }

  void _retryGame() {
    setState(() {
      _gameKey = UniqueKey();
      _elapsedTime = 0;
      _comboCount = 0;
      _initializeGame();
    });
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _elapsedTime += 0.05;
      });
      ref
          .read(gameStateNotifierProvider.notifier)
          .updateElapsedTime(_elapsedTime);

      // コンボ数が0に戻っているかチェック（ComboSystemのタイマーでリセットされるため）
      if (_game.comboCount != _comboCount) {
        setState(() {
          _comboCount = _game.comboCount;
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _pauseGame() {
    _stopTimer();
    _game.pauseEngine(); // Flameゲームエンジンを一時停止
    ref.read(gameStateNotifierProvider.notifier).pauseGame();
    _showPauseDialog();
  }

  void _resumeGame() {
    _game.resumeEngine(); // Flameゲームエンジンを再開
    ref.read(gameStateNotifierProvider.notifier).resumeGame();
    _startTimer();
  }

  void _showPauseDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) => GlassDialog(
        title: 'PAUSE',
        content: const Text(
          'ゲームを一時停止しています',
          textAlign: TextAlign.center,
        ),
        actions: [
          GradientButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // ゲーム画面を閉じる
            },
            width: 100,
            height: 45,
            gradientColors: const [Colors.grey, Colors.blueGrey],
            child: const Text('終了'),
          ),
          GradientButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resumeGame();
            },
            width: 100,
            height: 45,
            child: const Text('再開'),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              _showTutorial();
            },
            icon: const Icon(Icons.help_outline, color: Colors.white70),
            label: const Text(
              'あそびかたを見る',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  void _showTutorial() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TutorialOverlay(
        onClose: () {
          Navigator.of(context).pop();
          // ポーズ中ならポーズダイアログに戻る、そうでなければゲーム再開
          if (_game.paused) {
            _showPauseDialog();
          } else {
            _resumeGame();
          }
        },
      ),
    );
  }

  void _showGameOverDialog() async {
    final currentScore = _game.score;
    final storage = ref.read(storageServiceProvider);

    // エンドレスモード（stageNumber == 0）の場合、ハイスコアを更新
    int highScore = 0;
    bool isNewRecord = false;
    if (widget.stageData.stageNumber == 0) {
      highScore = await storage.getEndlessHighScore();
      if (currentScore > highScore) {
        await storage.setEndlessHighScore(currentScore);
        highScore = currentScore;
        isNewRecord = true;
      }
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) => GlassDialog(
        title: 'GAME OVER',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isNewRecord) ...[
              const Icon(
                Icons.emoji_events,
                color: Colors.amber,
                size: 48,
              ),
              const SizedBox(height: 8),
              const Text(
                '🎉 新記録！ 🎉',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              'Score: $currentScore',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (widget.stageData.stageNumber == 0 && !isNewRecord) ...[
              const SizedBox(height: 8),
              Text(
                'High Score: $highScore',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ],
        ),
        actions: [
          GradientButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // ゲーム画面を閉じる
            },
            width: 120,
            height: 50,
            gradientColors: const [Colors.grey, Colors.blueGrey],
            child: const Text('タイトルへ'),
          ),
          GradientButton(
            onPressed: () {
              Navigator.of(context).pop();
              _retryGame();
            },
            width: 120,
            height: 50,
            child: const Text('もう一度'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateNotifierProvider);

    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Stack(
            children: [
              // ゲームキャンバス
              Positioned.fill(
                child: GameWidget(
                  key: _gameKey,
                  game: _game,
                ),
              ),
              // HUD（スコア、時間）
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: GameHud(
                  score: gameState.score,
                  elapsedTime: _elapsedTime,
                  comboCount: _comboCount,
                  onPause: _pauseGame,
                ),
              ),
              // 次の風船プレビュー
              Positioned(
                right: 20,
                top: 120,
                child: BalloonPreviewWidget(
                  nextBalloons: _game.nextBalloonTypes,
                ),
              ),
              // タップ可能領域のボーダーライン
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: IgnorePointer(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return CustomPaint(
                        size: Size(constraints.maxWidth,
                            MediaQuery.of(context).size.height),
                        painter: _TapAreaBorderPainter(),
                      );
                    },
                  ),
                ),
              ),
              // Cooldownゲージ
              Positioned(
                left: 0,
                right: 0,
                bottom: 10,
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: CooldownGaugeWidget(
                      progress: _game.cooldownProgress,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// タップ可能領域のボーダーラインを描画するPainter
class _TapAreaBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 画面の80%の位置に線を引く
    final lineY = size.height * 0.8;

    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // 破線を描画
    const dashWidth = 10.0;
    const dashSpace = 5.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, lineY),
        Offset(startX + dashWidth, lineY),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
