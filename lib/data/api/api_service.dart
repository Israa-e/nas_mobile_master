import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));
  Future<List<String>> getCountryCodes() async {
    try {
      final response = await _dio.get('/c/bd33-4d1b-47a4-9779');
      print('API response: ${response.data}'); // 👈 اطبع لترى البيانات فعلاً
      if (response.statusCode == 200 && response.data is List) {
        return List<String>.from(response.data);
      }
    } catch (e) {
      print('Error fetching country codes: $e');
    }
    // fallback
    return ['+970', '+972', '+962', '+966', '+967'];
  }

  // جلب الجنسيات
  Future<List<String>> getNationalities() async {
    try {
      final response = await _dio.get('/c/3720-f6e9-43c3-94f0');
      if (response.statusCode == 200 && response.data is List) {
        return List<String>.from(response.data);
      }
    } catch (e) {
      print('Error fetching nationalities: $e');
    }
    // fallback
    return ['فلسطيني', 'أردني', 'مصري', 'سوري', 'لبناني', 'آخر'];
  }
}
