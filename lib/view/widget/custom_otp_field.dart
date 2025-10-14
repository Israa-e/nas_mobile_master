import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/core/constant/theme.dart';

class CustomOtpField extends StatefulWidget {
  final int numberOfFields;
  final Function(String) onSubmit;
  const CustomOtpField({
    super.key,
    required this.numberOfFields,
    required this.onSubmit,
  });

  @override
  State<CustomOtpField> createState() => _CustomOtpFieldState();
}

class _CustomOtpFieldState extends State<CustomOtpField> {
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;
  @override
  void initState() {
    super.initState();
    print("CustomOtpField initialized");
    controllers = List.generate(
      widget.numberOfFields,
      (_) => TextEditingController(),
    );
    focusNodes = List.generate(widget.numberOfFields, (_) {
      final focusNode = FocusNode();
      focusNode.addListener(() {
        setState(() {}); // Rebuild the widget when focus changes
      });
      return focusNode;
    });
  }

  @override
  void dispose() {
    print("CustomOtpField disposed");

    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.removeListener(() {}); // Remove listeners before disposing

      focusNode.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty && index < widget.numberOfFields - 1) {
      if (mounted) {
        focusNodes[index + 1].requestFocus();
      }
    } else if (value.isEmpty && index > 0) {
      if (mounted) {
        focusNodes[index - 1].requestFocus();
      }
    }

    // Check if all fields are filled
    final otp = controllers.map((controller) => controller.text).join();
    if (otp.length == widget.numberOfFields) {
      FocusScope.of(context).unfocus(); // Unfocus all fields
      widget.onSubmit(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.numberOfFields, (index) {
        return Container(
          margin: EdgeInsets.only(left: 20),
          width: 40,
          height: 40,
          child: TextFormField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            cursorHeight: Get.height * 0.026,
            cursorWidth: Get.width * 0.004,

            decoration: InputDecoration(
              filled: true,
              contentPadding: EdgeInsets.only(bottom: 5),
              fillColor:
                  focusNodes[index].hasFocus
                      ? AppTheme.white
                      : Colors.transparent,
              counterText: '', // Hide the maxLength counter
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppTheme.white, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppTheme.white, width: 2),
              ),
            ),
            style: AppTheme.textTheme16.copyWith(
              color: focusNodes[index].hasFocus ? Colors.black : AppTheme.white,
              fontWeight: FontWeight.w500,
            ),
            onChanged: (value) => _onChanged(index, value),
          ),
        );
      }),
    );
  }
}
