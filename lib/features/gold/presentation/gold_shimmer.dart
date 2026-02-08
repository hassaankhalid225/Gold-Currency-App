import 'package:flutter/material.dart';
import '../../../../shared/widgets/shimmer_loading.dart';

class GoldShimmer extends StatelessWidget {
  const GoldShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown Skeleton
            const SkeletonBox(height: 56, borderRadius: 8),
            const SizedBox(height: 20),
            
            // Main Price Card
            const SkeletonBox(height: 180, borderRadius: 20),
            const SizedBox(height: 20),
            
            // Unit Cards Row
            const Row(
              children: [
                Expanded(child: SkeletonBox(height: 100, borderRadius: 20)),
                SizedBox(width: 16),
                Expanded(child: SkeletonBox(height: 100, borderRadius: 20)),
              ],
            ),
            const SizedBox(height: 20),
            
            // Buy/Sell Container
            const SkeletonBox(height: 120, borderRadius: 20),
          ],
        ),
      ),
    );
  }
}
