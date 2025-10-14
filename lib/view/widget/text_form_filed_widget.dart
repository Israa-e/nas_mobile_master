import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/core/constant/url.dart';
import 'package:nas/view/widget/custom_snackbar.dart';

// ignore: must_be_immutable
class TextFormFiledWidget extends StatefulWidget {
  final String text;
  final TextEditingController textEditingController;
  final bool isPassword;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;

  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const TextFormFiledWidget({
    super.key,
    required this.text,
    required this.textEditingController,
    this.isPassword = false,
    this.validator,
    this.keyboardType,
    this.onEditingComplete,
    this.focusNode,
    this.inputFormatters,
  });

  @override
  State<TextFormFiledWidget> createState() => _TextFormFiledWidgetState();
}

class _TextFormFiledWidgetState extends State<TextFormFiledWidget> {
  bool isFocused = false;

  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    isPasswordVisible =
        !widget.isPassword; // Default visibility based on `isPassword`
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildCollapsedTextField()],
      ),
    );
  }

  Widget _buildCollapsedTextField() {
    return SizedBox(
      height: 58,
      child: Focus(
        onFocusChange: (focus) {
          setState(() {
            isFocused = focus;
          });
        },
        child: Stack(
          clipBehavior: Clip.none,
          alignment:
              Alignment.center, // جعل العناصر داخل Stack تتمركز بشكل صحيح

          children: [
            Center(
              child: TextFormField(
                obscureText: widget.isPassword && !isPasswordVisible,
                keyboardType: widget.keyboardType,
                validator: widget.validator ?? _defaultValidator,
                textAlignVertical: TextAlignVertical.center,
                inputFormatters: widget.inputFormatters,
                maxLines: 1,
                cursorHeight: Get.height * 0.026, // Adjust this value as needed
                cursorWidth: Get.width * 0.004,
                focusNode: widget.focusNode,
                controller: widget.textEditingController,
                onEditingComplete: widget.onEditingComplete,
                decoration: InputDecoration(
                  filled: true,
                  isDense: false,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: Get.height * 0.01,
                    horizontal: Get.width * 0.03,
                  ),
                  fillColor: isFocused ? AppTheme.white : Colors.transparent,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppTheme.white, width: 4),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppTheme.white, width: 4),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppTheme.white,
                      width: 4,
                    ), // Same as normal border
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppTheme.white,
                      width: 4,
                    ), // Same as focused border
                  ),
                  errorMaxLines: 1,

                  errorStyle: TextStyle(fontSize: 0), // Hide error text
                  // suffix:
                  //     widget.isPassword
                  //         ? Container(
                  //           margin: EdgeInsets.only(top: Get.height * 0.03),
                  //           child: IconButton(
                  //             onPressed: () {
                  //               setState(() {
                  //                 isPasswordVisible = !isPasswordVisible;
                  //               });
                  //             },
                  //             icon: SvgPicture.asset(
                  //               isPasswordVisible == true
                  //                   ? "${AppUrl.rootIcons}/cover_eye.svg"
                  //                   : "${AppUrl.rootIcons}/eye.svg",
                  //               height: Get.height * 0.025,
                  //               width: Get.width * 0.025,
                  //               fit: BoxFit.scaleDown,
                  //             ),
                  //           ),
                  //         )
                  //         : SizedBox(height: Get.height * 0.07, width: 0),
                ),
                style: AppTheme.textTheme16.copyWith(
                  color: isFocused ? Colors.black : AppTheme.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (widget.isPassword)
              Positioned(
                left: Get.width * 0.03, // تحريك الأيقونة لليسار
                child: IconButton(
                  onPressed: () {
                    widget.focusNode?.requestFocus();
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                  icon: SvgPicture.asset(
                    isPasswordVisible
                        ? "${AppUrl.rootIcons}/cover_eye.svg"
                        : "${AppUrl.rootIcons}/eye.svg",
                    height: Get.height * 0.025,
                    width: Get.width * 0.025,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300), // مدة التحريك
              curve: Curves.easeInOut, // تأثير سلس للتحريك
              top: isFocused ? -Get.height * 0.035 : -Get.height * 0.008,
              right: Get.width * 0.05,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color:
                      isFocused
                          ? Colors.transparent
                          : AppTheme.primaryColor, // إخفاء الخط عند التركيز
                ),
                child: Text(
                  widget.text,
                  style: AppTheme.textTheme16.copyWith(
                    color: AppTheme.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String? _defaultValidator(String? value) {
  if (value == null || value.isEmpty) {
    showErrorSnackbar(message: 'يرجى إكمال جميع الحقول المطلوبة');
    return 'هذا الحقل مطلوب';
  }
  return null;
}
