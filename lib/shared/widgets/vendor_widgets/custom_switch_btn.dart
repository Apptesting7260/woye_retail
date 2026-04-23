import 'package:flutter/material.dart';

class CustomWideSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double width;
  final double height;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;

  const CustomWideSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 70,         // Wider than normal switch
    this.height = 34,        // Higher than normal switch
    this.activeColor = Colors.green,
    this.inactiveColor = Colors.grey,
    this.thumbColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height),
          color: value ? activeColor : inactiveColor.withAlpha(160),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: height - 8,
            height: height - 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: thumbColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
