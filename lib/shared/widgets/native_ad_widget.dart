import 'package:flutter/material.dart';


class NativeAdWidget extends StatelessWidget {
  final double height;
  final EdgeInsets margin;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final VoidCallback? onAdLoaded;
  final VoidCallback? onAdFailed;

  const NativeAdWidget({
    super.key,
    this.height = 120,
    this.margin = const EdgeInsets.all(8),
    this.borderRadius,
    this.backgroundColor,
    this.onAdLoaded,
    this.onAdFailed,
  });

  @override
  Widget build(BuildContext context) {
    
    return Container(
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.ad_units,
              color: Colors.grey[400],
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'Native ad space\n(R-M-16723402-2)',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}