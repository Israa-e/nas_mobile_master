import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nas/presentation/bloc/registration/registration_event.dart';
import 'package:nas/presentation/bloc/registration/registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final int totalPages;

  RegistrationBloc({this.totalPages = 10})
    : super(const RegistrationInitial()) {
    on<RegistrationNextPage>(_onNextPage);
    on<RegistrationPreviousPage>(_onPreviousPage);
    on<RegistrationJumpToPage>(_onJumpToPage);
    on<RegistrationPageDataUpdated>(_onPageDataUpdated);
    on<RegistrationSubmitted>(_onSubmitted);
    on<RegistrationReset>(_onReset);
  }

  void _onNextPage(
    RegistrationNextPage event,
    Emitter<RegistrationState> emit,
  ) {
    if (state is RegistrationInitial) {
      final currentState = state as RegistrationInitial;
      if (currentState.currentPage < totalPages - 1) {
        emit(currentState.copyWith(currentPage: currentState.currentPage + 1));
      }
    }
  }

  void _onPreviousPage(
    RegistrationPreviousPage event,
    Emitter<RegistrationState> emit,
  ) {
    if (state is RegistrationInitial) {
      final currentState = state as RegistrationInitial;
      if (currentState.currentPage > 0) {
        emit(currentState.copyWith(currentPage: currentState.currentPage - 1));
      }
    }
  }

  void _onJumpToPage(
    RegistrationJumpToPage event,
    Emitter<RegistrationState> emit,
  ) {
    if (state is RegistrationInitial) {
      final currentState = state as RegistrationInitial;
      if (event.page >= 0 && event.page < totalPages) {
        emit(currentState.copyWith(currentPage: event.page));
      }
    }
  }

  void _onPageDataUpdated(
    RegistrationPageDataUpdated event,
    Emitter<RegistrationState> emit,
  ) {
    if (state is RegistrationInitial) {
      final currentState = state as RegistrationInitial;
      final updatedPagesData = Map<int, Map<String, dynamic>>.from(
        currentState.pagesData,
      );
      updatedPagesData[event.page] = event.data;
      emit(currentState.copyWith(pagesData: updatedPagesData));
    }
  }

  Future<void> _onSubmitted(
    RegistrationSubmitted event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(RegistrationLoading());
    try {
      // send event.allData to API or local database
      await Future.delayed(const Duration(seconds: 2));

      emit(
        const RegistrationSuccess(
          'تم إرسال طلبك بنجاح. سوف نقوم بمراجعة الطلب وتفعيل حسابك.',
        ),
      );
    } catch (e) {
      emit(RegistrationError(e.toString()));
    }
  }

  void _onReset(RegistrationReset event, Emitter<RegistrationState> emit) {
    emit(const RegistrationInitial());
  }
}
