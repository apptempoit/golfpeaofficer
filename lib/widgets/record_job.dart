import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:golfpeaofficer/models/information_model.dart';
import 'package:golfpeaofficer/models/job_model.dart';
import 'package:golfpeaofficer/widgets/show_progress.dart';

class RecordJob extends StatefulWidget {
  final InfomationModel model;
//  final String employedid;
  RecordJob({@required this.model});

  @override
  _RecordJobState createState() => _RecordJobState();
}

class _RecordJobState extends State<RecordJob> {
  InfomationModel informationModel;
  //List<JobModel> jobModelsMyNames = [];
  List<JobModel> jobModels = [];
  List<JobModel> jobModelsForName = [];

  bool load = true;
  List<String> names = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    informationModel = widget.model;
    readData();
  }

  Future<Null> readData() async {
    String apiJob =
        'https://wesafe.pea.co.th/webservicejson/api/values/task/0,${informationModel.ownerID}';
    await Dio().get(apiJob).then((value) {
//  print('## value => $value');

      for (var item in value.data) {
        JobModel model = JobModel.fromJson(item);

        names.add(model.menuMainName);
/*
        setState(() {
          load = false;
          jobModels.add(model);
        });
        */
        jobModels.add(model);
      }

      //  JobModel current = jobModels[0];

      String name = names[0];
      jobModelsForName.add(jobModels[0]);
      bool found = false;

      for (var i = 0; i < jobModels.length; i++) {
        if (name == jobModels[i].menuMainName && !found) {
          found = true;
        } else if (name != jobModels[i].menuMainName) {
          setState(() {
            load = false;
            jobModelsForName.add(jobModels[i]);
          });
          name = jobModels[i].menuMainName;
          found = false;
        }
      }

      //  jobModels.toSet().toList();
      //   print('List if model ==> $jobModelsMyNames');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? ShowProgress()
          : ListView.builder(
              itemCount: jobModelsForName.length,
              itemBuilder: (context, index) =>
                  Text(jobModelsForName[index].menuMainName),
            ),
    );
  }
}
