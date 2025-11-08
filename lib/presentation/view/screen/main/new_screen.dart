import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nas/core/constant/theme.dart';
import 'package:nas/core/database/database_helper.dart';
import 'package:nas/data/models/job_model.dart';

import 'package:nas/presentation/view/screen/main/job_details_screen.dart';
import 'package:nas/presentation/view/widget/build_header.dart';
import 'package:nas/presentation/view/widget/build_job_card.dart';

class NewScreen extends StatefulWidget {
  const NewScreen({super.key});

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<JobModel> jobs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetch new jobs when screen loads
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    setState(() => isLoading = true);

    try {
      final jobsData = await _dbHelper.getAllJobs(status: 'new');

      setState(() {
        jobs =
            jobsData.map((jobMap) {
              // Parse requirements from JSON string
              List<String>? requirements;
              if (jobMap['requirements'] != null) {
                try {
                  requirements = List<String>.from(
                    jsonDecode(jobMap['requirements']),
                  );
                } catch (e) {
                  requirements = [];
                }
              }

              return JobModel(
                id: jobMap['id'] as int,
                title: jobMap['title'] as String,
                day: jobMap['day'] as String? ?? '',
                date: jobMap['date'] as String? ?? '',
                startTime: jobMap['startTime'] as String,
                endTime: jobMap['endTime'] as String,
                description: jobMap['description'] as String?,
                location: jobMap['location'] as String?,
                salary: jobMap['salary'] as String?,
                requirements: requirements,
                status: jobMap['status'] as String? ?? 'new',
                isPending: (jobMap['isPending'] as int? ?? 0) == 1,
                appliedBy: jobMap['appliedBy'],
              );
            }).toList();

        isLoading = false;
      });
    } catch (e) {
      print('Error loading jobs: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            buildHeader(image: 'new', text: "طلبات جديدة"),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadJobs,
                child:
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : jobs.isEmpty
                        ? const Center(
                          child: Text(
                            'لا توجد وظائف متاحة',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                        : ListView.builder(
                          itemCount: jobs.length,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final job = jobs[index];
                            return buildJobCard(
                              index: index,
                              onTap: () {
                                Get.to(() => JobDetailsScreen(job: job))?.then((
                                  _,
                                ) {
                                  _loadJobs(); // Refresh data when returning
                                });
                              },
                              job: job,
                              type: job.title,
                              controller: null,
                            );
                          },
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
