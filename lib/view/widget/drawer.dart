import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/core/constant/url.dart';
import 'package:nas/view/screen/Auth/login.dart';
import 'package:nas/view/screen/main/drawer/change_password.dart';
import 'package:nas/view/screen/main/drawer/change_wallet_number.dart';
import 'package:nas/view/screen/main/drawer/edit_phone_number.dart';
import 'package:nas/view/screen/main/drawer/job_selection_screen.dart';
import 'package:nas/view/screen/main/drawer/modify_working_hours.dart';
import 'package:nas/view/widget/button_border.dart';

Drawer drawer(controller) {
  return Drawer(
    width: double.infinity,
    shape: OutlineInputBorder(borderRadius: BorderRadius.zero),
    child: Container(
      width: double.infinity, // Make it cover the full width

      color: AppTheme.primaryColor,
      child: ListView(
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
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                width: 68,

                                child: Image.asset(
                                  "${AppUrl.rootImages}/profile.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                              title: Text(
                                "الاسم ثنائي",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "+970569423655",
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
                                  'ساعات العمل : 120',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "التوصيات : 3",
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
                                showDeleteDialog();
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
                                      height:
                                          20, // تحديد الارتفاع داخل `SvgPicture`
                                      width:
                                          19, // تحديد العرض داخل `SvgPicture`
                                      fit:
                                          BoxFit
                                              .scaleDown, // يمنع التمدد خارج الحدود
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
                              onTap: () {
                                Get.off(() => LoginScreen());
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
                                      height:
                                          20, // تحديد الارتفاع داخل `SvgPicture`
                                      width:
                                          19, // تحديد العرض داخل `SvgPicture`
                                      fit:
                                          BoxFit
                                              .scaleDown, // يمنع التمدد خارج الحدود
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
                  onPressed:
                      () =>
                          controller
                              .toggleDrawer(), // Close the top screen or drawer
                ),
              ),
            ],
          ),
          // Profile Header
          // Destructive Actions
        ],
      ),
    ),
  );
}

void showDeleteDialog() {
  Get.dialog(
    Dialog(
      // Add margin to the entire Dialog
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
                  onTap: () => Get.off(() => LoginScreen()),
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
