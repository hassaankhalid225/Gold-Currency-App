import 'package:flutter/material.dart';
import '../../../../shared/widgets/shimmer_loading.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gold Price Card Skeleton
            const SkeletonBox(height: 180, borderRadius: 20),
            const SizedBox(height: 24),
            
            // Section Header
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonBox(width: 150, height: 24),
                SkeletonBox(width: 60, height: 20),
              ],
            ),
            const SizedBox(height: 16),
            
            // Currency List Skeletons
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, __) => const SkeletonBox(height: 72, borderRadius: 16),
            ),
          ],
        ),
      ),
    );
  }
}
