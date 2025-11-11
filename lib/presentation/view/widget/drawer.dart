import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/core/constant/url.dart';
import 'package:nas/core/database/database_helper.dart';
import 'package:nas/core/utils/shared_prefs.dart';
import 'package:nas/presentation/view/screen/Auth/login.dart';
import 'package:nas/presentation/view/screen/main/drawer/change_password.dart';
import 'package:nas/presentation/view/screen/main/drawer/change_wallet_number.dart';
import 'package:nas/presentation/view/screen/main/drawer/edit_phone_number.dart';
import 'package:nas/presentation/view/screen/main/drawer/job_selection_screen.dart';
import 'package:nas/presentation/view/screen/main/drawer/modify_working_hours.dart';
import 'package:nas/presentation/view/widget/button_border.dart';

// دالة لعرض صورة المستخدم
Widget _buildUserImage(String? imagePath) {
  // إذا لم توجد صورة
  if (imagePath == null || imagePath.isEmpty || imagePath == 'c') {
    return Image.asset("${AppUrl.rootImages}/profile.png", fit: BoxFit.cover);
  }

  // إذا كانت الصورة من الإنترنت
  if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
    return Image.network(
      imagePath,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value:
                loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          "${AppUrl.rootImages}/profile.png",
          fit: BoxFit.cover,
        );
      },
    );
  }
  // إذا كانت الصورة محلية
  try {
    final file = File(imagePath);
    if (file.existsSync()) {
      return Image.file(
        file,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            "${AppUrl.rootImages}/profile.png",
            fit: BoxFit.cover,
          );
        },
      );
    }
  } catch (e) {
    print('Error loading image: $e');
    return Image.asset("${AppUrl.rootImages}/profile.png", fit: BoxFit.cover);
  }

  // صورة افتراضية
  // إذا كانت الصورة محلية
  try {
    return Image.file(
      File(imagePath),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        print('Error loading image: $error');
        return Image.asset(
          "${AppUrl.rootImages}/profile.png",
          fit: BoxFit.cover,
        );
      },
    );
  } catch (e) {
    print('Error loading local image: $e');
    return Image.asset("${AppUrl.rootImages}/profile.png", fit: BoxFit.cover);
  }
}

// دالة لجلب بيانات المستخدم
Future<Map<String, dynamic>?> getUserData() async {
  try {
    int? userId = await SharedPrefsHelper.getUserId();
    if (userId == null) return null;

    DatabaseHelper dbHelper = DatabaseHelper.instance;
    List<Map<String, dynamic>> userDetails = await dbHelper.getAllUsersById(
      userId,
    );

    if (userDetails.isNotEmpty) {
      print("user data: ${userDetails[0]}");
      return userDetails[0];
    }
    return null;
  } catch (e) {
    print('Error getting user data: $e');
    return null;
  }
}

Drawer drawer(controller) {
  return Drawer(
    width: double.infinity,
    shape: OutlineInputBorder(borderRadius: BorderRadius.zero),
    child: Container(
      width: double.infinity,
      color: AppTheme.primaryColor,
      child: FutureBuilder<Map<String, dynamic>?>(
        future: getUserData(),
        builder: (context, snapshot) {
          // في حالة الانتظار
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppTheme.white),
            );
          }

          // في حالة وجود خطأ
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'حدث خطأ في تحميل البيانات',
                style: TextStyle(color: AppTheme.white),
              ),
            );
          }

          // البيانات جاهزة
          final userData = snapshot.data;

          final String firstName = userData?['firstName'] ?? 'المستخدم';
          final String familyName = userData?['familyName'] ?? '';
          final String fullName =
              '$firstName ${familyName.isNotEmpty ? familyName : ''}';
          final String phone =
              (userData?['phone'] ?? '0000000') +
              " " +
              (userData?['countryCode'] ?? '+970 ');

          final String? image = userData?['personalImage'];
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(60),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  left: 38,
                                  right: 38,
                                  top: 50,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppTheme.primaryColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Container(
                                    height: 68,
                                    width: 68,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey[200],

                                      image: DecorationImage(
                                        image:
                                            image == null
                                                ? AssetImage(
                                                  "${AppUrl.rootImages}/profile.png",
                                                )
                                                : FileImage(File(image)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                    // userData?['personalImage'] != null &&
                                    //         userData!['personalImage']
                                    //             .toString()
                                    //             .startsWith('http')
                                    //     ? ClipOval(
                                    //       child: Image.network(
                                    //         userData['personalImage'],
                                    //         fit: BoxFit.cover,
                                    //         errorBuilder: (
                                    //           context,
                                    //           error,
                                    //           stackTrace,
                                    //         ) {
                                    //           return Image.asset(
                                    //             "${AppUrl.rootImages}/profile.png",
                                    //             fit: BoxFit.contain,
                                    //           );
                                    //         },
                                    //       ),
                                    //     )
                                    //     : Image.asset(
                                    //       "${AppUrl.rootImages}/profile.png",
                                    //       fit: BoxFit.contain,
                                    //     ),
                                  ),
                                  title: Text(
                                    fullName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        phone,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'التقييم :',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: List.generate(
                                              5,
                                              (index) => Icon(
                                                Icons.star,
                                                color: Colors.yellow,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: AppTheme.primaryColor,
                                      width: 1.5,
                                    ),
                                    left: BorderSide(
                                      color: AppTheme.primaryColor,
                                      width: 1.5,
                                    ),
                                    right: BorderSide(
                                      color: AppTheme.primaryColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(10),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'ساعات العمل : 0',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "التوصيات : 0",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),

                              // Drawer Menu Items
                              _buildDrawerItem(
                                image: "work",
                                title: 'تعديل انواع العمل',
                                onTap: () {
                                  Get.to(() => JobSelectionScreen());
                                },
                              ),
                              _buildDrawerItem(
                                image: "time",
                                title: 'تعديل ساعات العمل',
                                onTap: () {
                                  Get.to(() => ModifyWorkingHours());
                                },
                              ),
                              _buildDrawerItem(
                                image: "wallet",
                                title: 'تغيير رقم المحفظة',
                                onTap: () {
                                  Get.to(() => ChangeWalletNumber());
                                },
                              ),
                              _buildDrawerItem(
                                image: "phone",
                                title: 'تعديل رقم الهاتف',
                                onTap: () {
                                  Get.to(() => EditPhoneNumber());
                                },
                              ),
                              _buildDrawerItem(
                                image: "lock",
                                title: 'تغيير كلمة المرور',
                                onTap: () {
                                  Get.to(() => ChangePassword());
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 22),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 35,
                          ),
                          child: IntrinsicWidth(
                            child: Column(
                              children: [
                                ButtonBorder(
                                  onTap: () {
                                    showDeleteDialog(userData?['id']);
                                  },
                                  color: AppTheme.red,
                                  height: 46,
                                  borderRadius: 15,
                                  widget: Padding(
                                    padding: const EdgeInsets.only(
                                      right: 14.0,
                                      left: 52,
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "${AppUrl.rootIcons}/trash.svg",
                                          height: 20,
                                          width: 19,
                                          fit: BoxFit.scaleDown,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'إلغاء الحساب نهائيا',
                                          style: TextStyle(
                                            color: AppTheme.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                ButtonBorder(
                                  height: 46,
                                  borderRadius: 15,
                                  onTap: () async {
                                    await SharedPrefsHelper.clearAll();
                                    Get.offAll(() => LoginScreen());
                                  },
                                  color: AppTheme.white,
                                  widget: Padding(
                                    padding: const EdgeInsets.only(
                                      right: 14.0,
                                      left: 52,
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "${AppUrl.rootIcons}/log-out.svg",
                                          height: 20,
                                          width: 19,
                                          fit: BoxFit.scaleDown,
                                        ),
                                        SizedBox(width: 32),
                                        Center(
                                          child: Text(
                                            "تسجيل خروج",
                                            style: TextStyle(
                                              color: AppTheme.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 24),
                  Padding(
                    padding: const EdgeInsets.only(top: 35.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: AppTheme.white,
                        size: 20,
                      ),
                      onPressed: () => controller.toggleDrawer(),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    ),
  );
}

void showDeleteDialog(int? userId) {
  Get.dialog(
    Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 18, bottom: 26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "هل تريد حقاً حذف حسابك؟\n(لا يمكنك التراجع)",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ButtonBorder(
                  height: 30,
                  borderRadius: 10,
                  onTap: () async {
                    if (userId != null) {
                      try {
                        final dbHelper = DatabaseHelper.instance;
                        await dbHelper.deleteUser(userId);
                        await SharedPrefsHelper.clearAll();
                        Get.offAll(() => LoginScreen());
                      } catch (e) {
                        print('Error deleting user: $e');
                        Get.back();
                      }
                    }
                  },
                  text: "تأكيد",
                  color: AppTheme.red,
                ),
                SizedBox(width: 20),
                ButtonBorder(
                  height: 30,
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
    barrierDismissible: false,
  );
}

Widget _buildDrawerItem({
  required String image,
  required String title,
  required VoidCallback onTap,
}) {
  return Container(
    margin: EdgeInsets.only(left: 35, right: 35, bottom: 29),
    decoration: BoxDecoration(
      color: AppTheme.secondaryColor,
      borderRadius: BorderRadius.circular(15),
    ),
    child: ListTile(
      leading: SvgPicture.asset(
        "${AppUrl.rootIcons}/$image.svg",
        height: 18, // تحديد الارتفاع داخل `SvgPicture`
        width: 16, // تحديد العرض داخل `SvgPicture`
        fit: BoxFit.scaleDown, // يمنع التمدد خارج الحدود
      ),
      title: Text(
        title,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppTheme.white,
        ),
      ),
      onTap: onTap,
    ),
  );
}
