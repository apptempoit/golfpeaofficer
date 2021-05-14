import 'dart:io';

import 'package:flutter/material.dart';
import 'package:golfpeaofficer/models/record_model.dart';
import 'package:golfpeaofficer/widgets/show_icon_image.dart';
import 'package:golfpeaofficer/widgets/show_title.dart';
import 'package:golfpeaofficer/widgets/type2_widget.dart';
import 'package:image_picker/image_picker.dart';

class ProcessRecord extends StatefulWidget {
  final List<RecordModel> recordModels;
  final String nameRecord;
  final String idDoc;

  ProcessRecord({
    @required this.recordModels,
    @required this.nameRecord,
    @required this.idDoc,
  });

  @override
  _ProcessRecordState createState() => _ProcessRecordState();
}

class _ProcessRecordState extends State<ProcessRecord> {
  List<RecordModel> recordModels;
  int amountStep;
  int processStep = 0;
  String nameJob;
  double size;
  String chooses;
  String idDoc;
  List<Widget> widgets = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recordModels = widget.recordModels;
    nameJob = widget.nameRecord;
    amountStep = recordModels.length;
    idDoc = widget.idDoc;
    for (var item in recordModels) {
      Widget myWidget = createType(item);
      setState(() {
        widgets.add(myWidget);
      });
    }
  }

  //จากหน้าหลัก ส่งงานไป หน้าถัดไป

  Widget createType(RecordModel recordModel) {
    switch (int.parse(recordModel.type)) {
      case 1:
        return type1(recordModel);
        break;
      case 2:
        return Type2Widget(
          recordModel: recordModel,
          nameJob: nameJob,
          idJob: idDoc,
        );
        break;
      case 3:
        return type3(recordModel);
        break;
      case 4:
        return type4(recordModel);
        break;
      default:
        return type0();
        break;
    }
  }

  Widget buildFromRecord() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: 250,
      child: TextFormField(
        //  controller: jobController,
        /*
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Please Fill User';
          } else {
            return null;
          }
        },
        */
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.book_outlined),
          labelText: 'บันทึกข้อความ :',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget type0() => Text('No Job');

  Widget type1(
    RecordModel model,
  ) =>
      Column(
        children: [
          ShowTitle(
            title: model.menuChecklistName,
          ),
          ElevatedButton(onPressed: () {}, child: Text('Check')),
        ],
      );

  Widget type3(
    RecordModel model,
  ) =>
      Column(
        children: [
          ShowTitle(
            title: model.menuChecklistName,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildFromRecord(),
            ],
          ),

          /*
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_downward),
                  label: Text('Next')),
            ],
          ),
          */
        ],
      );

  Widget type4(
    RecordModel model,
  ) {
    return Column(
      children: [
        /*
      ShowTitle(
            title: model.menuChecklistName,
          ),
*/
        Row(
          children: [
            Container(
              width: 250,
              child: RadioListTile(
                value: '1',
                groupValue: chooses,
                onChanged: (value) {
                  setState(() {
                    chooses = value;
                  });
                },
                title: ShowTitle(
                  title: model.menuChecklistName,
                ),
              ),
            ),
            Container(
              width: 250, //size*0.4
              child: RadioListTile(
                value: '0',
                groupValue: chooses,
                onChanged: (value) {
                  setState(() {
                    chooses = value;
                  });
                },
                title: ShowTitle(title: 'ไม่ต้อง ${model.menuChecklistName}'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //  size = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: ElevatedButton(
          onPressed: () {
/*
setState(() {
  processStep++;
});*/

            if (processStep < (amountStep - 1)) {
              setState(() {
                processStep++;
              });
            }
          },
          child: Text('Next')),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(nameJob),
            Text('Step ${processStep + 1}/$amountStep'),
          ],
        ),
      ),
      // body: type4(recordModels[0]),
      body: widgets[processStep],
    );
  }
}
