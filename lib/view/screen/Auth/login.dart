import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:nas/controller/login_controller.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/core/constant/url.dart';
import 'package:nas/view/widget/button_border.dart';
import 'package:nas/view/widget/custom_checkbox.dart';
import 'package:nas/view/widget/primary_button.dart';
import 'package:nas/view/widget/text_form_filed_widget.dart';

import '../../../data/fcm_api.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final LoginController controller = Get.find<LoginController>();

    final width = Get.width;
    final height = Get.height;
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.1),

                  Center(
                    child: Image.asset(
                      AppUrl.logo,
                      width: width * 0.3,
                      height: width * 0.3,
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: height * 0.08),

                  Form(
                    key: controller.formstate,
                    child: Column(
                      children: [
                        GetBuilder<LoginController>(
                          builder:
                              (_) => TextFormFiledWidget(
                                text: 'رقم الهاتف',
                                validator: (value) {
                                  return null;

                                  // if (value == null || value.isEmpty) {
                                  //   return 'يرجى إدخال رقم الهاتف';
                                  // }
                                  // if (!RegExp(r'^05\d{8}$').hasMatch(value)) {
                                  //   return 'رقم الهاتف غير صالح، يجب أن يبدأ بـ05 ويتكون من 10 أرقام';
                                  // }
                                  // return null;
                                },
                                // inputFormatters: [
                                //   FilteringTextInputFormatter
                                //       .digitsOnly, // يسمح فقط بالأرقام 0-9
                                // ],
                                keyboardType: TextInputType.number,
                                onEditingComplete:
                                    () => controller.handleFocusTransition(
                                      controller.phoneFocusNode,
                                      controller.passwordFocusNode,
                                    ),
                                focusNode: controller.phoneFocusNode,
                                textEditingController:
                                    controller.phoneController,
                              ),
                        ),

                        SizedBox(height: height * 0.06),

                        GetBuilder<LoginController>(
                          builder:
                              (_) => TextFormFiledWidget(
                                text: "كلمة المرور",
                                isPassword: true,
                                onEditingComplete:
                                    () =>
                                        controller.passwordFocusNode.unfocus(),
                                focusNode: controller.passwordFocusNode,
                                textEditingController:
                                    controller.passwordController,
                              ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: height * 0.03),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: GetBuilder<LoginController>(
                            builder:
                                (_) => CustomCheckbox(
                                  icon: false,
                                  padding: EdgeInsets.only(top: height * 0.01),
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  title: "تذكرني",
                                  richText: Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      "تذكرني",
                                      style: AppTheme.textTheme16.copyWith(
                                        color: AppTheme.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  isSelected: controller.rememberMe,
                                  onChanged:
                                      () => controller.toggleRememberMe(
                                        !controller.rememberMe,
                                      ), // تمرير القيمة الجديدة
                                ),
                          ),
                        ),
                        TextButton(
                          onPressed: controller.forgotPassword,
                          child: Text(
                            'نسيت كلمة المرور؟',
                            style: AppTheme.textTheme16.copyWith(
                              color: AppTheme.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.03),

                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          onTap: () async {
                            controller.login();
                            // Send welcome notification when login is successful
                            Future.delayed(Duration(seconds: 1), () {
                              controller.sendTestNotification();
                            });
                          },
                          text: "دخول",
                        ),
                      ),

                      SizedBox(width: width * 0.08),

                      Expanded(
                        child: ButtonBorder(
                          onTap:
                              // (){
                              //   testSimpleNotification();
                              // },
                              controller.joinWork,

                          text: "إنضم للعمل",
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: height * 0.03),
                    child: GestureDetector(
                      onTap: controller.needHelp,
                      child: Text(
                        'تحتاج مساعدة؟',
                        style: AppTheme.textTheme16.copyWith(
                          color: AppTheme.transparent,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void testSimpleNotification() {
  final fcmApi = FCMApi(); // Get the singleton instance

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'simple_channel',
    'Simple Channel',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails details = NotificationDetails(
    android: androidDetails,
  );

  fcmApi.flutterLocalNotificationsPlugin.show(
    0,
    'Simple Title',
    'Simple Message',
    details,
  );
  print('Simple notification triggered');
}
