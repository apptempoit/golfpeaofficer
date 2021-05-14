import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:golfpeaofficer/models/information_model.dart';
import 'package:golfpeaofficer/models/user_model.dart';
import 'package:golfpeaofficer/utility/dialog.dart';
import 'package:golfpeaofficer/utility/my_constant.dart';
import 'package:golfpeaofficer/widgets/show_image.dart';
import 'package:golfpeaofficer/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  double size;
  bool remember = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildImage(),
                buildAppName(),
                buildUser(),
                buildPassword(),
                buildRemember(),
                buildLogin(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildLogin() {
    return Container(
        width: size * 0.6,
        child: ElevatedButton(
          onPressed: () {
            if (formKey.currentState.validate()) {
              //กรอกจนครบ return null จะมาทำตรงนี้
              print('No Space');
              checkAuthen(userController.text, passwordController.text);
            } else {}
          },
          child: Text('Login'),
        ));
  }

//Thread
  Future<Null> checkAuthen(String user, String password) async {
    print('## user = $user, pass = $password');
/*
    String api =
        '${MyConstant.domain}/boyproj/getUserWhereUser.php?isAdd=true&user=$user';
 
 */
 String api =
        'https://wesafe.pea.co.th/webservicejson/api/values/GetUser/$user';
 
 print('#### api Authen ==> $api');
    await Dio().get(api).then(
      (value) async {
        print('### value ==> $value');

    for (var item in value.data) {
            UserModel model = UserModel.fromMap(item);

            if (password == model.password) {
              print('### Remember $remember');

              //remember = true  ติ๊ก
              if (remember) {
//Temporary
//https://wesafe.pea.co.th/webservicejson/api/values/job/900000
                String path =
                    'https://wesafe.pea.co.th/webservicejson/api/values/job/${model.employedid}';
                await Dio().get(path).then((value) async {
                  for (var item in value.data) {
                    InfomationModel infomationModel =
                        InfomationModel.fromJson(item);

                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    preferences.setString(
                        MyConstant.keyFIRST_NAME, infomationModel.fIRSTNAME);
                    preferences.setString(
                        MyConstant.keyLAST_NAME, infomationModel.lASTNAME);
                    preferences.setString(
                        MyConstant.keyEmployedid, infomationModel.eMPLOYEEID);
                    preferences.setString(
                        MyConstant.keyDEPTNAME, infomationModel.dEPTNAME);
                    preferences.setString(
                        MyConstant.keyREGIONCODE, infomationModel.rEGIONCODE);
                    preferences.setString(
                        MyConstant.keyTEAM, infomationModel.tEAM);
                    routeToService();
                  }
                });
              } else {
                routeToService();
              }
            } else {
              normalDialog(context, "Password Wrong!!!", 'Please try again');
            }
          }// end for



      },
    ).catchError((onError)=>normalDialog(context, 'User False', 'User False Try Again'));  }

  Future<Object> routeToService() {
    return Navigator.pushNamedAndRemoveUntil(
        context, '/myservice', (route) => false);
  }

  Container buildRemember() {
    return Container(
      width: size * 0.6,
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: ShowTitle(
          title: 'Remember Me',
          index: 1,
        ),
        value: remember,
        onChanged: (value) {
          setState(() {
            remember = value;
            //       print('### remember = $remember');
          });
        },
      ),
    );
  }

  Container buildUser() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: size * 0.6,
      child: TextFormField(
        controller: userController,
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Please Fill User';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.perm_identity),
          labelText: 'User :',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Container buildPassword() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: size * 0.6,
      child: TextFormField(
        controller: passwordController,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please Fill Password';
          } else {
            return null;
          }
        },
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock_outline),
          labelText: 'Password :',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  ShowTitle buildAppName() {
    return ShowTitle(
      title: MyConstant.appName,
      index: 0,
    );
  }

  Container buildImage() {
    return Container(
      width: size * 0.6,
      child: ShowImage(),
    );
  }
}
