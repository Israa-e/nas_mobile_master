import 'package:equatable/equatable.dart';

class JobModel extends Equatable {
  final int id;
  final String title;
  final String day;
  final String date;
  final String startTime;
  final String endTime;
  final String? description;
  String? appliedBy;
  final String? location;
  final String? salary;
  bool isPending; // new field

  final List<String>? requirements;
  final String? status;

  JobModel({
    required this.id,
    required this.title,
    required this.day,
    required this.date,
    this.isPending = false,
    this.appliedBy,
    required this.startTime,
    required this.endTime,
    this.description,
    this.location,
    this.salary,
    this.requirements,
    this.status = 'new',
  });

  JobModel copyWith({
    int? id,
    String? title,
    String? day,
    String? date,
    String? startTime,
    String? endTime,
    String? description,
    bool? isPending,
    String? appliedBy,
    String? location,
    String? salary,
    List<String>? requirements,
    String? status,
  }) {
    return JobModel(
      id: id ?? this.id,
      title: title ?? this.title,
      day: day ?? this.day,
      isPending: isPending ?? this.isPending,
      date: date ?? this.date,
      appliedBy: appliedBy ?? this.appliedBy,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      description: description ?? this.description,
      location: location ?? this.location,
      salary: salary ?? this.salary,
      requirements: requirements ?? this.requirements,
      status: status ?? this.status,
    );
  }

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'],
      title: json['title'] ?? 'مقدم طعام',
      day: json['day'] ?? '',
      date: json['date'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      isPending: json['isPending'] ?? false,
      appliedBy: json['appliedBy'],
      description: json['description'],
      location: json['location'],
      salary: json['salary'],
      requirements:
          json['requirements'] != null
              ? List<String>.from(json['requirements'])
              : [],
      status: json['status'] ?? 'new',
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    day,
    date,
    startTime,
    isPending,
    endTime,
    description,
    appliedBy,
    location,
    salary,
    requirements,
    status,
  ];
}
