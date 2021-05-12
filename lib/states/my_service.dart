import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:golfpeaofficer/models/information_model.dart';
import 'package:golfpeaofficer/utility/my_constant.dart';
import 'package:golfpeaofficer/widgets/check_job.dart';
import 'package:golfpeaofficer/widgets/history.dart';
import 'package:golfpeaofficer/widgets/record_job.dart';
import 'package:golfpeaofficer/widgets/show_man.dart';
import 'package:golfpeaofficer/widgets/show_progress.dart';
import 'package:golfpeaofficer/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyService extends StatefulWidget {
  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  InfomationModel infomationModel;

  List<Widget> widgets = [];

  int index = 0;

  List<String> titles = ['บันทึกงานใหม่', 'ประวัติการทำงาน', 'ตรวจสอบสถานะงาน'];

//อ่านข้อมูล   ทำงานก่อน build
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    readData();
  }

  Future<Null> readData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String employedid = preferences.getString(MyConstant.keyEmployedid);


    String apiInformation =
        'https://wesafe.pea.co.th/webservicejson/api/values/job/$employedid';

    await Dio().get(apiInformation).then((value) {
      print('### value ===> $value');

      for (var item in value.data) {
        setState(() {
          infomationModel = InfomationModel.fromJson(item);

    widgets.add(RecordJob(
      model: infomationModel,
    ));

    widgets.add(History(
      employedid: employedid,
    ));

    widgets.add(CheckJob(
      employedid: employedid,
    ));



        }); // ถ้าตัวแปรข้างในเปลี่ยน  จะ บิ้วใหม่ทันที
        print('### name Login = ${infomationModel.fIRSTNAME}');
      }
    });
  }

//ถ้าย้ายไปหน้าอื่น  ตัวนี้จะทำงานทิ้งท้าย
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[index]),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            Column(
              children: [
                buildUserAccountsDrawerHeader(),
                  buildMenuRecordJob(context),
                buildMenuHistory(context),
          
                checkJob(context),
              ],
            ),
            buildSignOut(),
          ],
        ),
      ),
      body: infomationModel == null ? ShowProgress() : widgets[index],
    );
  }



  ListTile buildMenuRecordJob(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.dashboard,
        size: 36,
        color: MyConstant.primary,
      ),
      title: ShowTitle(
        title: 'บันทึกงานใหม่',
        index: 1,
      ),
      onTap: () {
        setState(() {
          index = 0;
        });
        Navigator.pop(context);
      },
    );
  }

  
  ListTile buildMenuHistory(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.lock_clock,
        size: 36,
        color: MyConstant.primary,
      ),
      title: ShowTitle(
        title: 'ประวัติการทำงาน',
        index: 1,
      ),
      onTap: () {
        setState(() {
          index = 1;
        });

        Navigator.pop(context);
      },
    );
  }


  ListTile checkJob(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.check_circle,
        size: 36,
        color: MyConstant.primary,
      ),
      title: ShowTitle(
        title: 'ตรวจสอบ',
        index: 1,
      ),
      subtitle: ShowTitle(title: 'ตรวจสอบสถานะและปิดงาน'),
      onTap: () {
        setState(() {
          index = 2;
        });
        Navigator.pop(context);
      },
    );
  }

  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(color: MyConstant.primary),
      currentAccountPicture: ShowMan(),
      accountName: infomationModel == null
          ? Text('Name')
          : Text('${infomationModel.fIRSTNAME} ${infomationModel.lASTNAME}'),
      accountEmail: infomationModel == null
          ? Text('Position')
          : Text('ตำแหน่ง : ${infomationModel.dEPTNAME}'),
    );
  }

  Column buildSignOut() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.clear();

            Navigator.pushNamedAndRemoveUntil(
                context, '/authen', (route) => false);
          },
          tileColor: Colors.red.shade900,
          leading: Icon(
            Icons.exit_to_app,
            size: 36,
            color: Colors.white,
          ),
          title: ShowTitle(
            title: 'Sign Out',
            index: 3,
            // array จาก widgets style
          ),
        ),
      ],
    );
  }
}
