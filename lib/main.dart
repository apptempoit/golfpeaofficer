import 'package:flutter/material.dart';
import 'package:golfpeaofficer/states/authen.dart';
import 'package:golfpeaofficer/states/my_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/myservice' : (BuildContext context) => MyService(),
};

String initialRoute;

Future<Null> main()async{
// initialRoute = '/authen';
// runApp(MyApp());

WidgetsFlutterBinding.ensureInitialized();
SharedPreferences preferences = await SharedPreferences.getInstance();

String employedid = preferences.getString('employedid');

// เชคสิทธ ในนี้เลย
if (employedid == null) {
  initialRoute = '/authen';
  runApp(MyApp());
} else {
    initialRoute = '/myservice';
  runApp(MyApp());
}


}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: map,
      initialRoute: initialRoute,
      theme: ThemeData(primarySwatch: Colors.purple),
    );
  }
}