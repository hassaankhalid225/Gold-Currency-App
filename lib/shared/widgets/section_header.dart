import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onActionTap;
  final String actionLabel;
  final Widget? actionWidget;

  const SectionHeader({
    super.key,
    required this.title,
    this.onActionTap,
    this.actionLabel = "See All",
    this.actionWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (actionWidget != null)
            actionWidget!
          else if (onActionTap != null)
            TextButton(
              onPressed: onActionTap,
              child: Text(actionLabel),
            ),
        ],
      ),
    );
  }
}
