import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

/// 視覚エフェクトを生成するファクトリクラス
class EffectFactory {
  static final Random _random = Random();

  /// マージ時のキラキラエフェクト
  static ParticleSystemComponent createMergeEffect({
    required Vector2 position,
    required Color color,
  }) {
    return ParticleSystemComponent(
      position: position,
      particle: Particle.generate(
        count: 20,
        lifespan: 0.8,
        generator: (i) {
          final speed = 50.0 + _random.nextDouble() * 50.0;
          final angle = _random.nextDouble() * 2 * pi;
          final velocity = Vector2(cos(angle), sin(angle)) * speed;

          return AcceleratedParticle(
            position: Vector2.zero(),
            speed: velocity,
            acceleration: Vector2(0, 100), // 重力
            child: ComputedParticle(
              renderer: (canvas, particle) {
                final paint = Paint()
                  ..color = color.withOpacity(1.0 - particle.progress);
                canvas.drawCircle(
                    Offset.zero, 3 * (1.0 - particle.progress), paint);
              },
            ),
          );
        },
      ),
    );
  }

  /// 風船消滅時のポップエフェクト
  static ParticleSystemComponent createPopEffect({
    required Vector2 position,
    required Color color,
  }) {
    return ParticleSystemComponent(
      position: position,
      particle: Particle.generate(
        count: 30,
        lifespan: 0.6,
        generator: (i) {
          final speed = 100.0 + _random.nextDouble() * 100.0;
          final angle = _random.nextDouble() * 2 * pi;
          final velocity = Vector2(cos(angle), sin(angle)) * speed;

          return AcceleratedParticle(
            position: Vector2.zero(),
            speed: velocity,
            child: ComputedParticle(
              renderer: (canvas, particle) {
                final paint = Paint()
                  ..color = color.withOpacity(1.0 - particle.progress)
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 2.0;

                canvas.drawCircle(
                  Offset.zero,
                  5 * particle.progress, // 広がるリング
                  paint,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
