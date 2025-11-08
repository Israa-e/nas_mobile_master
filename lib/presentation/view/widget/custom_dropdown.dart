import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nas/core/constant/theme.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class CustomDropdown extends StatelessWidget {
  final List<String> items;
  final String? value;
  final double? width;

  final String hint;
  final void Function(String?)? onChanged;
  const CustomDropdown({
    super.key,
    required this.items,
    required this.hint,
    required this.onChanged,
    this.value,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || Platform.isIOS) {
      return _buildCupertinoDropdown(context);
    } else if (Platform.isAndroid) {
      return _buildMaterialDropdown();
    } else {
      // Fallback for other platforms
      return _buildCupertinoDropdown(context);
    }
  }

  Widget _buildCupertinoDropdown(BuildContext context) {
    int selectedIndex = items.indexOf(value ?? items[0]);

    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder:
              (_) => Container(
                height: 300.h,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.95),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        backgroundColor: Colors.transparent,
                        itemExtent: 36.h,
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedIndex,
                        ),
                        onSelectedItemChanged: (index) {
                          onChanged?.call(items[index]);
                        },
                        children:
                            items.map((item) {
                              return Center(
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.white,
                                    letterSpacing: 0.3,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
        );
      },
      child: Container(
        height: 32,
        width: width ?? 50,
        constraints: BoxConstraints(maxWidth: 150, minWidth: 50),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.8),
          border: Border.all(color: AppTheme.white, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          value ?? hint,
          style: TextStyle(
            color: AppTheme.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildMaterialDropdown() {
    final effectiveValue = items.contains(value) ? value : null;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 32,
          width: width ?? 50,
          constraints: BoxConstraints(maxWidth: 150, minWidth: 50),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.white, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: effectiveValue,
              dropdownColor: AppTheme.primaryColor,
              isExpanded: true,
              items:
                  items.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
              onChanged: onChanged,
              style: TextStyle(color: AppTheme.white, fontSize: 13),
              icon: Icon(
                Icons.arrow_drop_down,
                color: AppTheme.white,
                size: 14,
              ),
            ),
          ),
        );
      },
    );
  }
}
