import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageHelper {
  // 1️⃣ اختيار صورة من المعرض
  static Future<File?> pickImageFromGallery() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  // 2️⃣ اختيار صورة من الكاميرا
  static Future<File?> pickImageFromCamera() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      print('Error taking photo: $e');
      return null;
    }
  }

  // 3️⃣ حفظ الصورة في مجلد التطبيق
  static Future<String?> saveImageLocally(File imageFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final String imagePath = path.join(directory.path, 'images');

      // إنشاء المجلد إذا لم يكن موجوداً
      final imageDirectory = Directory(imagePath);
      if (!await imageDirectory.exists()) {
        await imageDirectory.create(recursive: true);
      }

      // إنشاء اسم فريد للصورة
      final String fileName =
          'IMG_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final String fullPath = path.join(imagePath, fileName);

      // نسخ الصورة
      final File savedImage = await imageFile.copy(fullPath);

      return savedImage.path;
    } catch (e) {
      print('Error saving image: $e');
      return null;
    }
  }

  // 4️⃣ تحويل الصورة إلى Base64 (للحفظ في قاعدة البيانات)
  static Future<String?> imageToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      print('Error converting to base64: $e');
      return null;
    }
  }

  // 5️⃣ تحويل Base64 إلى صورة
  static Uint8List base64ToImage(String base64String) {
    return base64Decode(base64String);
  }

  // 6️⃣ حذف صورة من مجلد التطبيق
  static Future<bool> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting image: $e');
      return false;
    }
  }

  // 7️⃣ الحصول على حجم الصورة
  static Future<int?> getImageSize(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        return await file.length();
      }
      return null;
    } catch (e) {
      print('Error getting image size: $e');
      return null;
    }
  }

  // 8️⃣ التحقق من وجود الصورة
  static Future<bool> imageExists(String imagePath) async {
    try {
      if (imagePath.startsWith('http')) {
        return true; // نفترض أن الصورة من الإنترنت موجودة
      }
      final file = File(imagePath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }
}
