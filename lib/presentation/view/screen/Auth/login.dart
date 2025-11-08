import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/core/constant/url.dart';
import 'package:nas/core/database/database_helper.dart';
import 'package:nas/presentation/bloc/auth/auth_bloc.dart';
import 'package:nas/presentation/bloc/auth/auth_event.dart';
import 'package:nas/presentation/bloc/auth/auth_state.dart';
import 'package:nas/presentation/view/screen/Auth/worker_registration_screen.dart';
import 'package:nas/presentation/view/screen/main/main_home_screen.dart';
import 'package:nas/presentation/view/widget/button_border.dart';
import 'package:nas/presentation/view/widget/custom_checkbox.dart';
import 'package:nas/presentation/view/widget/custom_snackbar.dart';
import 'package:nas/presentation/view/widget/primary_button.dart';
import 'package:nas/presentation/view/widget/text_form_filed_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _rememberMe = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      final DatabaseHelper dbHelper = DatabaseHelper.instance;
      final getUser = await dbHelper.getUser(_phoneController.text.trim());
      print("getUser: $getUser");

      context.read<AuthBloc>().add(
        AuthLoginRequested(
          phone: _phoneController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    final height = Get.height;

    bool _isSnackbarOpen = false;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (!_isSnackbarOpen) {
          if (state is AuthAuthenticated) {
            _isSnackbarOpen = true;

            showSuccessSnackbar(message: 'تم تسجيل الدخول بنجاح');
            Future.delayed(const Duration(milliseconds: 500), () {
              Get.offAll(() => const MainHomeScreen());
            });
          } else if (state is AuthError) {
            _isSnackbarOpen = true;
            showErrorSnackbar(message: state.message);
            return;
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.primaryColor,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: _formKey,
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
                      TextFormFiledWidget(
                        text: 'رقم الهاتف',
                        keyboardType: TextInputType.phone,
                        focusNode: _phoneFocusNode,
                        textEditingController: _phoneController,
                        onEditingComplete: () {
                          _phoneFocusNode.unfocus();
                          _passwordFocusNode.requestFocus();
                        },
                      ),
                      SizedBox(height: height * 0.06),
                      TextFormFiledWidget(
                        text: "كلمة المرور",
                        isPassword: true,
                        focusNode: _passwordFocusNode,
                        keyboardType: TextInputType.visiblePassword,
                        textEditingController: _passwordController,
                        onEditingComplete: () => _passwordFocusNode.unfocus(),
                      ),
                      SizedBox(height: height * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomCheckbox(
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
                              isSelected: _rememberMe,
                              onChanged:
                                  () => setState(() {
                                    _rememberMe = !_rememberMe;
                                  }),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to forgot password
                            },
                            child: Text(
                              'نسيت كلمة المرور؟',
                              style: AppTheme.textTheme16.copyWith(
                                color: AppTheme.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.03),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          if (state is AuthLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppTheme.white,
                              ),
                            );
                          }

                          return Row(
                            children: [
                              Expanded(
                                child: PrimaryButton(
                                  onTap: _handleLogin,
                                  text: "دخول",
                                ),
                              ),
                              SizedBox(width: width * 0.08),
                              Expanded(
                                child: ButtonBorder(
                                  onTap: () {
                                    Get.to(
                                      () => const WorkerRegistrationScreen(),
                                    );
                                  },
                                  text: "إنضم للعمل",
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: height * 0.03),
                        child: GestureDetector(
                          onTap: needHelp,
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
        ),
      ),
    );
  }
}

void needHelp() async {
  Get.focusScope?.unfocus();
  needHelpDialog();
}

void needHelpDialog() {
  Get.dialog(
    Dialog(
      // Add margin to the entire Dialog
      insetPadding: EdgeInsets.symmetric(horizontal: 30),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          // height: 183,
          color: AppTheme.white,
          padding: EdgeInsets.symmetric(horizontal: 29, vertical: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Text(
                "قم بكتابة سؤالك وسيتم الرد عليك قريبا",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppTheme.primaryColor,
                      width: 2,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppTheme.primaryColor,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppTheme.primaryColor,
                      width: 2,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                ),
                maxLines: 4,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PrimaryButton(
                    onTap: () {
                      Get.back();
                      showSuccessDialog();
                    },
                    text: "إرسال",
                    height: Get.height * 0.04,
                    borderRadius: 10,

                    textColor: AppTheme.white,
                    color: AppTheme.primaryColor,
                  ),
                  SizedBox(width: 30),
                  ButtonBorder(
                    height: Get.height * 0.04,
                    borderRadius: 10,
                    onTap: () => Get.back(),
                    text: "إغلاق",
                    color: AppTheme.primaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}

void showSuccessDialog() {
  Get.dialog(
    Dialog(
      // Add margin to the entire Dialog
      insetPadding: EdgeInsets.symmetric(horizontal: 68),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          // height: 183,
          color: AppTheme.white,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Text(
                "تم ارسال طلبك بنجاح سوف نقوم بمراجعة الطلب والرد عليك في أقرب وقت ممكن ",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),

              ButtonBorder(
                height: 30,
                borderRadius: 10,

                onTap: () {
                  Get.back();
                },
                text: "إغلاق",
                color: AppTheme.primaryColor,
              ),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
