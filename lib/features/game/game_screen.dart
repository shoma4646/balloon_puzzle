import 'dart:async';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/stage_data.dart';
import '../../providers/game_state_provider.dart';
import '../../shared/constants/app_colors.dart';
import 'components/balloon_puzzle_game.dart';
import 'widgets/balloon_preview_widget.dart';
import 'widgets/cooldown_gauge_widget.dart';
import 'widgets/game_hud.dart';

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

  @override
  void initState() {
    super.initState();

    // ゲームインスタンスを作成
    _game = BalloonPuzzleGame(
      stageData: widget.stageData,
      onScoreUpdate: (score) {
        ref.read(gameStateProvider.notifier).updateScore(score);
      },
      onGameOver: () {
        _stopTimer();
        ref.read(gameStateProvider.notifier).gameOver();
        _showGameOverDialog();
      },
    );

    // ゲームを開始（Futureで遅延実行）
    Future(() {
      ref.read(gameStateProvider.notifier).startGame();
      _startTimer();
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
      ref.read(gameStateProvider.notifier).updateElapsedTime(_elapsedTime);
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _pauseGame() {
    _stopTimer();
    ref.read(gameStateProvider.notifier).pauseGame();
    _showPauseDialog();
  }

  void _resumeGame() {
    ref.read(gameStateProvider.notifier).resumeGame();
    _startTimer();
  }

  void _showPauseDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('一時停止'),
        content: const Text('ゲームを一時停止しています'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // ゲーム画面を閉じる
            },
            child: const Text('終了'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resumeGame();
            },
            child: const Text('再開'),
          ),
        ],
      ),
    );
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('ゲームオーバー'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('スコア: ${_game.score}'),
            Text('時間: ${_formatTime(_elapsedTime)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // ダイアログを閉じる
              Navigator.of(context).pop(); // ゲーム画面を閉じる
            },
            child: const Text('終了'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // ダイアログを閉じる
              _retryGame(); // ゲームをリセット
            },
            child: const Text('リトライ'),
          ),
        ],
      ),
    );
  }

  void _retryGame() {
    // ゲームインスタンスを再作成
    setState(() {
      _game = BalloonPuzzleGame(
        stageData: widget.stageData,
        onScoreUpdate: (score) {
          ref.read(gameStateProvider.notifier).updateScore(score);
        },
        onGameOver: () {
          _stopTimer();
          ref.read(gameStateProvider.notifier).gameOver();
          _showGameOverDialog();
        },
      );
      _elapsedTime = 0;
    });

    // ゲームを再開
    ref.read(gameStateProvider.notifier).startGame();
    _startTimer();
  }

  String _formatTime(double seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toInt().toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundSkyLight,
              AppColors.backgroundSky,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // ゲームキャンバス
              Positioned.fill(
                child: GameWidget(game: _game),
              ),
              // HUD（スコア、時間）
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: GameHud(
                  score: gameState.score,
                  elapsedTime: _elapsedTime,
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
                        size: Size(constraints.maxWidth, MediaQuery.of(context).size.height),
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
