import 'package:flutter/material.dart';

import '../../../../../shared/theme/colors.dart';
import '../../../../../shared/theme/font_family.dart';
import '../../../../../shared/theme/font_style.dart';


class CommonChart extends StatelessWidget {
  final double percentage;
  final List<double> values;

  const CommonChart({super.key, required this.percentage,required this.values});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(200, 200),
            painter: DonutChartPainter(values),
          ),

          // Center Text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${percentage.toStringAsFixed(1)}%",
                style: AppFontStyle.text_20_600(AppColors.black,
                  fontFamily: AppFontFamily.gilroySemiBold,
                ),
              ),
              Text(
                "Completion",
                style: AppFontStyle.text_12_400(
                  AppColors.greyClr,
                  fontFamily: AppFontFamily.gilroyRegular,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}


class DonutChartPainter extends CustomPainter {
  final List<double> values;
  DonutChartPainter(this.values);

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 22;
    double radius = (size.width / 2) - strokeWidth;
    Offset center = Offset(size.width / 2, size.height / 2);

    double totalValue = values.fold(0, (a, b) => a + b);

    final List<Color> colors = [
      AppColors.primary,
      AppColors.chartBlueClr,
      AppColors.chartYellowClr,
      AppColors.red,
    ];

    // CASE 1: IF ALL ZERO → Draw full grey circle
    if (totalValue == 0) {
      final paint = Paint()
        ..color = Colors.grey.shade300
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        radians(-90),
        radians(360),
        false,
        paint,
      );
      return;
    }

    // CASE 2: NORMAL DRAW (proportional segments)
    double startAngle = -180; // start top

    for (int i = 0; i < values.length; i++) {
      if (values[i] <= 0) continue; // skip zeros

      double sweepAngle = (values[i] / totalValue) * 360;

      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        radians(startAngle),
        radians(sweepAngle),
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  double radians(double deg) => deg * 3.1415926535 / 180;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
