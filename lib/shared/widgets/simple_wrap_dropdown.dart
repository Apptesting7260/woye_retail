import 'package:flutter/material.dart';
import 'package:gyaawa/Utils/sized_box.dart';
import 'package:gyaawa/shared/theme/colors.dart';

import '../theme/font_family.dart';
import '../theme/font_style.dart';

class SimpleWrapDropdown<T> extends StatefulWidget {
  final List<T> items;
  final List<T> selectedItems;
  final String Function(T) getLabel;
  final Function(List<T>) onChanged;
  final String hintText;
  final double borderRadius;

  const SimpleWrapDropdown({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.getLabel,
    required this.onChanged,
    this.hintText = "Select",
    this.borderRadius = 8,
  });

  @override
  State<SimpleWrapDropdown<T>> createState() =>
      _SimpleWrapDropdownState<T>();
}

class _SimpleWrapDropdownState<T>
    extends State<SimpleWrapDropdown<T>> {
  bool isOpen = false;

  void toggleItem(T item) {
    final updated = List<T>.from(widget.selectedItems);

    if (updated.contains(item)) {
      updated.remove(item);
    } else {
      updated.add(item);
    }

    widget.onChanged(updated);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() => isOpen = !isOpen);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.hintText,
                style: AppFontStyle.text_12_600(
                  AppColors.black,
                  fontFamily: AppFontFamily.interSemiBold,
                ),
              ),
             Spacer(),
              Icon(
                isOpen
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
              ),
            ],
          ),
        ),
        hBox(15),
        if (isOpen)
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: widget.items.map((e) {
              final isSelected = widget.selectedItems.contains(e);
              return GestureDetector(
                onTap: () => toggleItem(e),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.7,
                      color: AppColors.borderClr,
                    ),
                    color: isSelected
                        ? AppColors.buttonColor
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                  child: Text(
                    widget.getLabel(e),
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.white
                          : AppColors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        hBox(10),
      ],
    );
  }}