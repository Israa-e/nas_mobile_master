import 'package:flutter/material.dart';
import 'package:nas/core/constant/theme.dart';

class CustomRadioButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final TextStyle? textStyle;
  final double? size;
  final double? width;

  const CustomRadioButton({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.size = 16.0,
    this.textStyle,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                color: isSelected ? Colors.transparent : Colors.white,
              ),
              child:
                  isSelected
                      ? Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.secondaryColor,
                          ),
                        ),
                      )
                      : null,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style:
                    textStyle ??
                    TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
