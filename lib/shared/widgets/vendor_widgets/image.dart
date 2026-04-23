import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../Core/Constant/image_constant.dart';
import '../../theme/colors.dart';
import '../shimmer_widget.dart';

enum ImageType { asset, network, svg, file }

class AppImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Color? color;
  final ColorFilter? svgColor;
  final double? scale;
  final double? borderRadius;

  const AppImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.placeholder,
    this.errorWidget,
    this.color,
    this.svgColor,
    this.scale,
    this.borderRadius,
  });

  ImageType getImageType(String path) {
    if (path.startsWith("http") || path.startsWith("https")) {
      return ImageType.network;
    } else if (path.toLowerCase().endsWith(".svg")) {
      return ImageType.svg;
    }else if (path.startsWith("/") || path.startsWith("file://")) {
      return ImageType.file;
    }  else {
      return ImageType.asset;
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = getImageType(path);

    Widget image;

    try {
      image = switch (type) {
        ImageType.asset => Image.asset(
          path,
          width: width,
          height: height,
          fit: fit,
          color: color,
          scale: scale,
          errorBuilder: (_, __, ___) =>
          errorWidget ?? _dummyImage(width, height),
        ),
        ImageType.network => CachedNetworkImage(
          imageUrl: path,
          width: width,
          height: height,
          fit: fit,
          color: color,
          scale: scale ?? 1,
          placeholder: (_, __) =>
          placeholder ?? ShimmerBox(width: width ?? Get.width, height: height ?? Get.height),
          errorWidget: (_, __, ___) =>
          errorWidget ?? _dummyImage(width, height),
        ),
        ImageType.svg => SvgPicture.asset(
          path,
          width: width,
          height: height,
          fit: fit,
          colorFilter: svgColor,
          placeholderBuilder: (_) =>
          placeholder ?? ShimmerBox(width: width ?? Get.width, height: height ?? Get.height),
        ),

        ImageType.file => Builder(
          builder: (_) {
            final cleanPath = path.replaceFirst("file://", "");
            final file = File(cleanPath);

            if (!file.existsSync()) {
              return errorWidget ?? _dummyImage(width, height);
            }

            return Image.file(
              file,
              width: width,
              height: height,
              fit: fit,
              color: color,
              scale: scale ?? 1,
              errorBuilder: (_, __, ___) =>
              errorWidget ?? _dummyImage(width, height),
            );
          },
        ),
      };
    } catch (e) {
      image = _dummyImage(width, height);
    }

    if (borderRadius != null && borderRadius! > 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius!),
        child: image,
      );
    }

    return image;
  }

  /// 🔹 Dummy fallback image (can be local asset or icon)
  Widget _dummyImage(double? width, double? height) {
    return Container(
      width: 80,
      height:height ?? 80,
      color: AppColors.transparent,
      child: SvgPicture.asset(ImageConstants.noDataImage)
    );
  }
}
