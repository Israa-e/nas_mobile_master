import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nas/core/database/database_helper.dart';
import 'package:nas/core/utils/shared_prefs.dart';
import 'package:nas/data/models/user_model.dart';
import 'package:nas/presentation/bloc/auth/auth_event.dart';
import 'package:nas/presentation/bloc/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  AuthBloc() : super(AuthInitial()) {
    on<AuthCheckStatus>(_onCheckStatus);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckStatus(
    AuthCheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final isLoggedIn = await SharedPrefsHelper.isLoggedIn();

      if (isLoggedIn) {
        final phone = await SharedPrefsHelper.getUserPhone();
        if (phone != null) {
          final userData = await _dbHelper.getUser(phone);
          if (userData != null) {
            final user = UserModel.fromJson(userData);
            emit(AuthAuthenticated(user));
            return;
          }
        }
      }

      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      // Get user from database
      final userData = await _dbHelper.getUser(event.phone);

      if (userData == null) {
        emit(const AuthError('المستخدم غير موجود'));
        return;
      }

      // Verify password (in real app, hash it!)
      if (userData['password'] != event.password) {
        emit(const AuthError('كلمة المرور غير صحيحة'));
        return;
      }

      // Decode JSON fields
      List<String> workHours = [];
      List<String> selectedTasks = [];
      Map<String, dynamic> firstContact = {};
      Map<String, dynamic> secondContact = {};
      Map<String, dynamic> acceptedTerms = {};
      bool acceptAlcohol = false;

      if (userData['workHours'] != null) {
        workHours = List<String>.from(jsonDecode(userData['workHours']));
      }

      if (userData['selectedTasks'] != null) {
        selectedTasks = List<String>.from(
          jsonDecode(userData['selectedTasks']),
        );
      }

      if (userData['firstContact'] != null) {
        firstContact = Map<String, dynamic>.from(
          jsonDecode(userData['firstContact']),
        );
      }

      if (userData['secondContact'] != null) {
        secondContact = Map<String, dynamic>.from(
          jsonDecode(userData['secondContact']),
        );
      }

      if (userData['acceptedTerms'] != null) {
        acceptedTerms = jsonDecode(userData['acceptedTerms']);
      }

      if (userData['acceptAlcohol'] != null) {
        acceptAlcohol = userData['acceptAlcohol'] == 1;
      }

      // Save login state
      await SharedPrefsHelper.setLoggedIn(true);
      await SharedPrefsHelper.setUserId(userData['id']);
      await SharedPrefsHelper.setUserPhone(userData['phone']);
      if (userData['token'] != null) {
        await SharedPrefsHelper.setToken(userData['token']);
      }

      // Create UserModel
      final user = UserModel(
        phone: userData['phone'] ?? '',
        firstName: userData['firstName'] ?? '',
        fatherName: userData['fatherName'] ?? '',
        grandFatherName: userData['grandFatherName'] ?? '',
        familyName: userData['familyName'] ?? '',
        birthDate: userData['birthDate'] ?? '',
        accountName: userData['accountName'] ?? '',
        accountNumber: userData['accountNumber'] ?? '',
        departmentName: userData['departmentName'] ?? '',
        governorate: userData['governorate'] ?? '',
        district: userData['district'] ?? '',
        location: userData['location'] ?? '',
        nationalId: userData['nationalId'] ?? '',
        nationality: userData['nationality'] ?? '',
        gender: userData['gender'] ?? '',
        maritalStatus: userData['maritalStatus'] ?? '',
        countryCode: userData['countryCode'] ?? '',
        personalImage: userData['personalImage'] ?? '',
        frontIdImage: userData['frontIdImage'] ?? '',
        backIdImage: userData['backIdImage'] ?? '',
        password: userData['password'] ?? '',
        workHours: workHours,
        selectedTasks: selectedTasks,
        firstContact: firstContact,
        secondContact: secondContact,
        acceptedTerms: acceptedTerms,
        acceptAlcohol: acceptAlcohol,
        token: userData['token'] ?? '',
        createdAt: userData['createdAt'] ?? 0,
      );

      emit(AuthAuthenticated(user));
    } catch (e) {
      print("Login Error: $e");
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      // Check if user already exists
      final existingUser = await _dbHelper.getUser(event.phone);

      if (existingUser != null) {
        emit(const AuthError('المستخدم موجود بالفعل'));
        return;
      }

      // Insert new user
      final userData = {
        'phone': event.phone,
        'password': event.password, // In real app, hash this!
        'name': event.name,
        'token': 'dummy_token_${DateTime.now().millisecondsSinceEpoch}',
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      };

      final userId = await _dbHelper.insertUser(userData);

      // Save login state
      await SharedPrefsHelper.setLoggedIn(true);
      await SharedPrefsHelper.setUserId(userId);
      await SharedPrefsHelper.setUserPhone(event.phone);
      await SharedPrefsHelper.setToken(userData['token'].toString());

      final user = UserModel.fromJson({...userData, 'id': userId});
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await SharedPrefsHelper.clearAll();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
