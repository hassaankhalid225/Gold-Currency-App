import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class ShimmerLoading extends StatelessWidget {
  final Widget child;

  const ShimmerLoading({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFE0E0E0),
      highlightColor: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF5F5F5),
      child: child,
    );
  }
}

class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonBox({
    super.key, 
    this.width = double.infinity, 
    required this.height, 
    this.borderRadius = 8
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black, // Color doesn't matter, it's masked by Shimmer
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
