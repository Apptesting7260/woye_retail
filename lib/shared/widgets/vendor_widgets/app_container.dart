import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class AppContainer extends StatelessWidget {
  final Widget? child;
  final double? radius;
  final Gradient? gradient;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final BoxShape? shape;
  final List<BoxShadow>? boxShadow;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final AlignmentGeometry? alignment;
  final void Function()? onTap;
  const AppContainer({super.key, this.onTap,this.child, this.radius, this.gradient, this.color, this.padding, this.height, this.width, this.margin, this.shape, this.boxShadow, this.borderRadius, this.border, this.alignment});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: padding,
        alignment: alignment,
        margin: margin,
        height: height,
        width: width,
        decoration: BoxDecoration(
            borderRadius: shape == null ? borderRadius ?? BorderRadius.circular(radius ?? 0) : null,
            gradient: gradient,
            border: border,
            color: color ?? AppColors.white,
            boxShadow: boxShadow ?? [
              BoxShadow(color: AppColors.black.withAlpha(15),blurRadius: 1,spreadRadius: 1),
            ],
            shape: shape ?? BoxShape.rectangle
        ),
        child: child,
      ),
    );
  }
}
