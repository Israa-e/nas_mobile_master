import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int? id;

  // Basic info
  final String phone;
  final String? firstName;
  final String? fatherName;
  final String? grandFatherName;
  final String? familyName;
  final String? birthDate;

  // Account info
  final String? accountName;
  final String? departmentName;
  final String? accountNumber;
  final List<String>? workHours;

  // Preferences
  final List<String>? favouriteDays;
  final List<String>? favouriteTimes;
  final List<String>? selectedTasks;
  final bool? acceptAlcohol;

  // Address
  final String? governorate;
  final String? district;
  final String? location;
  final String? nationalId;
  final String? nationality;
  final String? gender;

  // Contact info
  final String? maritalStatus;
  final String? countryCode;

  // Images
  final String? personalImage;
  final String? frontIdImage;
  final String? backIdImage;

  // Password
  final String? password;

  // Emergency contacts
  final Map<String, dynamic>? firstContact;
  final Map<String, dynamic>? secondContact;

  // Terms
  final Map<String, dynamic>? acceptedTerms;

  final String? token;
  final int? createdAt;

  const UserModel({
    this.id,
    required this.phone,
    this.firstName,
    this.fatherName,
    this.grandFatherName,
    this.familyName,
    this.birthDate,
    this.accountName,
    this.departmentName,
    this.accountNumber,
    this.workHours,
    this.favouriteDays,
    this.favouriteTimes,
    this.selectedTasks,
    this.acceptAlcohol,
    this.governorate,
    this.district,
    this.location,
    this.nationalId,
    this.gender,
    this.nationality,
    this.maritalStatus,
    this.countryCode,
    this.personalImage,
    this.frontIdImage,
    this.backIdImage,
    this.password,
    this.firstContact,
    this.secondContact,
    this.acceptedTerms,
    this.token,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      phone: json['phone'],
      firstName: json['firstName'],
      fatherName: json['fatherName'],
      grandFatherName: json['grandFatherName'],
      familyName: json['familyName'],
      birthDate: json['birthDate'],
      accountName: json['accountName'],
      departmentName: json['departmentName'],
      accountNumber: json['accountNumber'],
      workHours: List<String>.from(json['workHours'] ?? []),
      favouriteDays: List<String>.from(json['favouriteDays'] ?? []),
      favouriteTimes: List<String>.from(json['favouriteTimes'] ?? []),
      selectedTasks: List<String>.from(json['selectedTasks'] ?? []),
      acceptAlcohol: json['acceptAlcohol'],
      governorate: json['governorate'],
      district: json['district'],
      location: json['location'],
      nationalId: json['nationalId'],
      gender: json['gender'],
      maritalStatus: json['maritalStatus'],
      countryCode: json['countryCode'],
      nationality: json['nationality'],
      personalImage: json['personalImage'],
      frontIdImage: json['frontIdImage'],
      backIdImage: json['backIdImage'],
      password: json['password'],
      firstContact:
          json['firstContact'] != null
              ? Map<String, dynamic>.from(json['firstContact'])
              : null,
      secondContact:
          json['secondContact'] != null
              ? Map<String, dynamic>.from(json['secondContact'])
              : null,
      acceptedTerms:
          json['acceptedTerms'] != null
              ? Map<String, bool>.from(json['acceptedTerms'])
              : null,
      token: json['token'],
      createdAt: json['createdAt'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'firstName': firstName,
      'fatherName': fatherName,
      'grandFatherName': grandFatherName,
      'familyName': familyName,
      'birthDate': birthDate,
      'accountName': accountName,
      'departmentName': departmentName,
      'accountNumber': accountNumber,
      'workHours': workHours != null ? jsonEncode(workHours) : null,
      'favouriteDays': favouriteDays != null ? jsonEncode(favouriteDays) : null,
      'favouriteTimes':
          favouriteTimes != null ? jsonEncode(favouriteTimes) : null,
      'selectedTasks': selectedTasks != null ? jsonEncode(selectedTasks) : null,
      'acceptAlcohol': (acceptAlcohol ?? false) ? 1 : 0, // bool → int ✅
      'governorate': governorate,
      'district': district,
      'location': location,
      'nationalId': nationalId,
      'nationality': nationality,
      'gender': gender,
      'maritalStatus': maritalStatus,
      'countryCode': countryCode,
      'personalImage': personalImage,
      'frontIdImage': frontIdImage,
      'backIdImage': backIdImage,
      'password': password,
      'firstContact': firstContact != null ? jsonEncode(firstContact) : null,
      'secondContact': secondContact != null ? jsonEncode(secondContact) : null,
      'acceptedTerms': acceptedTerms != null ? jsonEncode(acceptedTerms) : null,
      'token': token,
      'createdAt': createdAt,
    };
  }

  @override
  List<Object?> get props => [
    id,
    phone,
    firstName,
    fatherName,
    grandFatherName,
    familyName,
    birthDate,
    accountName,
    departmentName,
    accountNumber,
    workHours,
    favouriteDays,
    favouriteTimes,
    selectedTasks,
    acceptAlcohol,
    nationality,
    governorate,
    district,
    location,
    nationalId,
    gender,
    maritalStatus,
    countryCode,
    personalImage,
    frontIdImage,
    backIdImage,
    password,
    firstContact,
    secondContact,
    acceptedTerms,
    token,
    createdAt,
  ];
}
