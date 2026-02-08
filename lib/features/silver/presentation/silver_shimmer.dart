
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class SilverShimmer extends StatelessWidget {
  const SilverShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: 50, color: Colors.white),
            const SizedBox(height: 20),
            Container(height: 200, color: Colors.white),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: Container(height: 100, color: Colors.white)),
                const SizedBox(width: 8),
                Expanded(child: Container(height: 100, color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
