import 'package:firebase_tests/screens/admin_page.dart';
import 'package:firebase_tests/screens/homepage.dart';
import 'package:firebase_tests/screens/login.dart';
import 'package:firebase_tests/services/auth_notifier.dart';
import 'package:firebase_tests/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  Authentication _authentication = Authentication();
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      initAuth();
    });
    super.initState();
  }

  initAuth(){
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    _authentication.initializeCurrentUser(authNotifier);
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: ElevatedButton(
            onPressed: (){
              (authNotifier.user == null) ? Get.offAll(()=> LogIn())
                  : (authNotifier.userDetails == null) ? print('waiting')
                  : (authNotifier.userDetails!.role == 'admin') ? Get.offAll(()=> AdminPage())
                  : Get.offAll(()=> HomePage());
            },
            child: Text('Welcome')),
      ),
    );
  }
}
