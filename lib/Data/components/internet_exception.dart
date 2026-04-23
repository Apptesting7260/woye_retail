import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../shared/theme/colors.dart';
import '../../shared/theme/font_family.dart';
import '../../shared/theme/font_style.dart';


class InternetExceptionWidget extends StatefulWidget {
  final VoidCallback onPress;
  final String? customMessage;
  final double iconSizeMultiplier;

  const InternetExceptionWidget({
    super.key,
    required this.onPress,
    this.customMessage,
    this.iconSizeMultiplier = 0.18,
  });

  @override
  State<InternetExceptionWidget> createState() => _InternetExceptionWidgetState();
}

class _InternetExceptionWidgetState extends State<InternetExceptionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Simple fade in animation for the whole widget
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    // Rotation animation for retry icon
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    // Pulse animation for the icon
    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.15), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.15, end: 1.0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Color animation for button press effect
    _colorAnimation = ColorTween(
      begin: AppColors.primary.withOpacity(0.8),
      end: AppColors.primary,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Start the animation
    _controller.forward();

    // Set up loop for pulsing animation
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Only loop the pulse animation, not the scale
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            _controller.forward(from: 0.0);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleRetry() async {
    // Animate button press
    await _controller.animateTo(
      0.5,
      duration: const Duration(milliseconds: 200),
    );

    await _controller.animateBack(
      0.0,
      duration: const Duration(milliseconds: 200),
    );

    // Call the original onPress callback
    widget.onPress();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Center(
      child: SingleChildScrollView(
        padding: REdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Pulsing icon
                  _buildPulsingIcon(theme, isDarkMode),

                  SizedBox(height: 32.h),

                  // Title
                  _buildTitleText(theme, isDarkMode),

                  SizedBox(height: 12.h),

                  // Description
                  _buildDescriptionText(theme, isDarkMode),

                  SizedBox(height: 36.h),

                  // Animated retry button
                  _buildAnimatedRetryButton(theme),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPulsingIcon(ThemeData theme, bool isDarkMode) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            padding: REdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDarkMode
                  ? AppColors.primary.withOpacity(0.1)
                  : AppColors.primary.withOpacity(0.08),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2 * _pulseAnimation.value),
                  blurRadius: 15 * _pulseAnimation.value,
                  spreadRadius: 2 * _pulseAnimation.value,
                ),
              ],
            ),
            child: Icon(
              Icons.wifi_off_rounded,
              size: Get.height * widget.iconSizeMultiplier,
              color: AppColors.primary,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitleText(ThemeData theme, bool isDarkMode) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _scaleAnimation.value,
          child: child,
        );
      },
      child: Text(
        "Connection Lost",
        textAlign: TextAlign.center,
        style: AppFontStyle.text_20_600(
          isDarkMode ? AppColors.white : AppColors.black,
          fontFamily: AppFontFamily.gilroySemiBold,
        ),
      ),
    );
  }

  Widget _buildDescriptionText(ThemeData theme, bool isDarkMode) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _scaleAnimation.value,
          child: child,
        );
      },
      child: Padding(
        padding: REdgeInsets.symmetric(horizontal: 16),
        child: Text(
          widget.customMessage ??
              "Unable to establish a connection. Please check your internet settings and try again.",
          maxLines: 3,
          textAlign: TextAlign.center,
          style: AppFontStyle.text_15_400(
            isDarkMode ? AppColors.white.withOpacity(0.7) : AppColors.black.withOpacity(0.7),
            fontFamily: AppFontFamily.gilroyMedium,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedRetryButton(ThemeData theme) {
    return SizedBox(
      width: Get.width * 0.55,
      child: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return ElevatedButton(
                onPressed: _handleRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _colorAnimation.value,
                  foregroundColor: AppColors.white,
                  elevation: 4,
                  shadowColor: AppColors.primary.withOpacity(0.3),
                  padding: REdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.rotate(
                      angle: _rotationAnimation.value,
                      child: Icon(Icons.refresh_rounded, size: 20.r),
                    ),
                    SizedBox(width: 8.w),
                    AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: child,
                        );
                      },
                      child: Text(
                        "Retry Connection",
                        style: AppFontStyle.text_15_500(
                          AppColors.white,
                          fontFamily: AppFontFamily.gilroyMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}