import 'package:flutter/material.dart';

class PriceCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final String? unit;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Gradient? backgroundGradient;
  final Color? textColor;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final int animationDirection; // 1 for right (next), -1 for left (prev), 0 for none
  final Key? contentKey;

  const PriceCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.unit,
    this.onTap,
    this.backgroundColor,
    this.backgroundGradient,
    this.textColor,
    this.onPrevious,
    this.onNext,
    this.animationDirection = 0,
    this.contentKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.cardTheme.color,
        gradient: backgroundGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13), // 0.05 opacity
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
          child: Row(
            children: [
              if (onPrevious != null)
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: textColor?.withAlpha(150) ?? Colors.grey, size: 20),
                  onPressed: onPrevious,
                  tooltip: 'Previous',
                ),
              Expanded(
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                         if (animationDirection == 0) {
                           return FadeTransition(opacity: animation, child: child);
                         }
                         
                         // Uses a smoother curve and reduced distance for a premium feel
                         final curvedAnimation = CurvedAnimation(
                            parent: animation, 
                            curve: Curves.fastOutSlowIn, // fast start, slow, smooth end
                         );

                         // Slide from 25% offset instead of 100% to reduce visual noise
                         final beginOffset = Offset(animationDirection * 0.25, 0.0);
                         
                         return SlideTransition(
                           position: Tween<Offset>(begin: beginOffset, end: Offset.zero).animate(curvedAnimation),
                           child: FadeTransition(
                             opacity: curvedAnimation,
                             child: child,
                           ),
                         );
                      },
                      child: Column(
                        key: contentKey, // Unique key per content to trigger animation
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: textColor ?? theme.textTheme.titleMedium?.color,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14, // Smaller title
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              if (unit != null) ...[
                                 const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: (textColor ?? Colors.black).withAlpha(25),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                child: Text(
                                  unit!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: textColor ?? theme.textTheme.bodySmall?.color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10, // Smaller font for 'per tola'
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              value,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                fontSize: 28, // Bigger
                              ),
                            ),
                            if (onTap != null && onPrevious == null && onNext == null)
                               CircleAvatar(
                                 radius: 14,
                                 backgroundColor: (textColor ?? Colors.grey).withAlpha(30),
                                 child: Icon(
                                    Icons.arrow_forward_ios, 
                                    size: 14, 
                                    color: textColor ?? Colors.grey
                                 ),
                               ),
                          ],
                        ),
                         if (subtitle != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            subtitle!,
                            style: theme.textTheme.bodySmall?.copyWith(
                               color: textColor?.withAlpha((255 * 0.7).toInt()) ?? theme.textTheme.bodySmall?.color,
                               fontStyle: FontStyle.italic
                            ),
                          ),
                        ],
                      ],
                    ),
                    ),
                  ),
                ),
              ),
              if (onNext != null)
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios, color: textColor?.withAlpha(150) ?? Colors.grey, size: 20),
                  onPressed: onNext,
                  tooltip: 'Next',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
