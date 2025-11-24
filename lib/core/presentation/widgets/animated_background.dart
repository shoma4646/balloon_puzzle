import 'dart:math';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_FloatingItem> _items = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Initialize floating items
    for (int i = 0; i < 15; i++) {
      _items.add(_generateItem());
    }
  }

  _FloatingItem _generateItem() {
    return _FloatingItem(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      size: _random.nextDouble() * 50 + 20,
      speed: _random.nextDouble() * 0.2 + 0.05,
      color: [
        AppColors.balloonRed,
        AppColors.balloonBlue,
        AppColors.balloonGreen,
        AppColors.balloonYellow,
        AppColors.balloonPurple,
      ][_random.nextInt(5)]
          .withOpacity(0.1 + _random.nextDouble() * 0.2),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient Background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.backgroundStart,
                AppColors.backgroundEnd,
              ],
            ),
          ),
        ),

        // Floating Items
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              children: _items.map((item) {
                // Update position
                item.y -= item.speed * 0.01;
                if (item.y < -0.2) {
                  item.y = 1.2;
                  item.x = _random.nextDouble();
                }

                return Positioned(
                  left: MediaQuery.of(context).size.width * item.x,
                  top: MediaQuery.of(context).size.height * item.y,
                  child: Container(
                    width: item.size,
                    height: item.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: item.color,
                      boxShadow: [
                        BoxShadow(
                          color: item.color,
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),

        // Content
        widget.child,
      ],
    );
  }
}

class _FloatingItem {
  double x;
  double y;
  double size;
  double speed;
  Color color;

  _FloatingItem({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.color,
  });
}
