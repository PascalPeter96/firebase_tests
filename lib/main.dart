import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_tests/screens/login.dart';
import 'package:firebase_tests/screens/welcome.dart';
import 'package:firebase_tests/services/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
        create: (_) => AuthNotifier(),
        child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Welcome(),
    );
  }
}
