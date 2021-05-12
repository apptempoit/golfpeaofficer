import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

    String api =
        '${MyConstant.domain}/boyproj/getUserWhereUser.php?isAdd=true&user=$user';
    await Dio().get(api).then(
      (value) async {
        print('### value ==> $value');
        if (value.toString() == 'null') {
          normalDialog(context, 'User Failed!!!!', 'No $user in Database');
        } else {
          for (var item in json.decode(value.data)) {
            UserModel model = UserModel.fromMap(item);

            if (password == model.password) {
              print('### Remember $remember');

              //remember = true  ติ๊ก
              if (remember) {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                preferences.setString('name', model.name);
                preferences.setString('employedid', model.employedid);
                routeToService();
              } else {
                routeToService();
              }
            } else {
              normalDialog(context, "Password Wrong!!!", 'Please try again');
            }
          }
        }
      },
    );
  }

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
