import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nas/core/network/api_client.dart';
import 'package:nas/data/models/violation.dart';
import 'package:nas/presentation/bloc/violations/violations_event.dart';
import 'package:nas/presentation/bloc/violations/violations_state.dart';

class ViolationsBloc extends Bloc<ViolationsEvent, ViolationsState> {
  final ApiClient _apiClient = ApiClient();

  ViolationsBloc() : super(ViolationsInitial()) {
    on<ViolationsFetchRequested>(_onFetchRequested);
    on<ViolationAppeal>(_onAppeal);
  }

  Future<void> _onFetchRequested(
    ViolationsFetchRequested event,
    Emitter<ViolationsState> emit,
  ) async {
    emit(ViolationsLoading());

    try {
      // Using JSONPlaceholder as dummy API
      final response = await _apiClient.get('/comments?_limit=8');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        final violations =
            data.map((item) {
              return Violation(
                type: _getRandomViolationType(item['id']),
                expiryDate: '${15 + (item['id'] % 15)}/3/2025',
                reason: item['body'],
              );
            }).toList();

        emit(ViolationsLoaded(violations));
      } else {
        emit(const ViolationsError('فشل في تحميل المخالفات'));
      }
    } catch (e) {
      emit(ViolationsError(e.toString()));
    }
  }

  String _getRandomViolationType(int id) {
    final types = [
      'الإلغاء بعد الموافقة',
      'التأخر عن الموعد',
      'عدم الالتزام بالمعايير',
      'عدم إرسال المستندات',
    ];
    return types[id % types.length];
  }

  Future<void> _onAppeal(
    ViolationAppeal event,
    Emitter<ViolationsState> emit,
  ) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      emit(const ViolationActionSuccess('تم إرسال طلب الاعتراض'));

      // Refresh violations
      add(ViolationsFetchRequested());
    } catch (e) {
      emit(ViolationsError(e.toString()));
    }
  }
}
