import 'package:flutter/material.dart';

class DashedDivider extends StatelessWidget {
  const DashedDivider({
    super.key,
    this.height = 1,
    this.dashWidth = 6,
    this.dashGap = 5,
    this.color,
  });

  final double height;
  final double dashWidth;
  final double dashGap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Colors.black.withOpacity(0.18);

    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.maxWidth;
        final dashCount = (boxWidth / (dashWidth + dashGap)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: height,
              child: DecoratedBox(decoration: BoxDecoration(color: c)),
            );
          }),
        );
      },
    );
  }
}
