import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../theme/colors.dart';

Widget circularProgressIndicator({double size = 30.0,Color? color}) {
  return LoadingAnimationWidget.inkDrop(
    color: color ?? AppColors.primary,
    size: size,
  );
}

Widget circularProgressIndicator2({double size = 30.0,Color? color}) {
  return LoadingAnimationWidget.waveDots(
    color: color ?? AppColors.primary,
    size: size,
  );

}
