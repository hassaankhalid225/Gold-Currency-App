import 'package:flutter/material.dart';
import '../../../../shared/widgets/shimmer_loading.dart';

class CurrencyShimmer extends StatelessWidget {
  const CurrencyShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Base Currency Label
            const SkeletonBox(width: 100, height: 16),
            const SizedBox(height: 8),
            // Base Dropdown
            const SkeletonBox(height: 56, borderRadius: 16),
            
            const SizedBox(height: 16),
            // Swap Button
            const Center(child: SkeletonBox(width: 48, height: 48, borderRadius: 24)),
            const SizedBox(height: 16),
            
            // Target Currency Label
            const SkeletonBox(width: 120, height: 16),
            const SizedBox(height: 8),
            // Target Dropdown
            const SkeletonBox(height: 56, borderRadius: 16),
            
            const SizedBox(height: 24),
            // Exchange Rate
            const Center(child: SkeletonBox(width: 200, height: 32)),
            const SizedBox(height: 24),
            
            // Input
            const SkeletonBox(height: 56, borderRadius: 12),
            const SizedBox(height: 16),
            
            // Result Card
            const SkeletonBox(height: 120, borderRadius: 24),
            
            const SizedBox(height: 24),
            // Popular Pairs Header
            const SkeletonBox(width: 150, height: 24),
            const SizedBox(height: 16),
            
            // Popular Pairs List
            const SkeletonBox(height: 60, borderRadius: 12),
            const SizedBox(height: 12),
            const SkeletonBox(height: 60, borderRadius: 12),
          ],
        ),
      ),
    );
  }
}
