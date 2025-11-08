import 'package:get/get.dart';
import 'package:nas/presentation/view/screen/Auth/login.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await Future.delayed(const Duration(seconds: 4));
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      print('حدث خطأ أثناء التهيئة: $e');
    }
  }
}
