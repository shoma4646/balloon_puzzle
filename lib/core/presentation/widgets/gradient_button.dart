import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final List<Color>? gradientColors;
  final double width;
  final double height;
  final double borderRadius;

  const GradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.gradientColors,
    this.width = double.infinity,
    this.height = 56,
    this.borderRadius = 30,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ?? [AppColors.primary, AppColors.secondary];

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: colors.last.withOpacity(0.4),
            offset: const Offset(0, 8),
            blurRadius: 16,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Center(
            child: DefaultTextStyle(
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
