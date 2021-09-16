
import 'package:firebase_tests/models/user.dart';
import 'package:firebase_tests/screens/admin_page.dart';
import 'package:firebase_tests/screens/homepage.dart';
import 'package:firebase_tests/screens/signup.dart';
import 'package:firebase_tests/services/auth_notifier.dart';
import 'package:firebase_tests/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class LogIn extends StatefulWidget {
  // const LogIn({Key? key}) : super(key: key);
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  Users _users = new Users();
  final GlobalKey<FormState> _formKey =GlobalKey<FormState>();
  Authentication _authentication = Authentication();

  bool showPassword = true;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
      _authentication.initializeCurrentUser(authNotifier);
    });
    super.initState();
  }

  void toast(String msg){
    Fluttertoast.showToast(msg: msg,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.green,
      gravity:  ToastGravity.BOTTOM,
    );
  }

  void _submitForm(){
    if(!_formKey.currentState!.validate()){
      return;
    }
    _formKey.currentState!.save();
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    RegExp regExp = new RegExp(r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$');
    if(!regExp.hasMatch(_users.email!)){
      toast('Enter correct email format');
    } else if(_users.password!.length<8){
      toast('Password should have atleast 8 chars');
    }else{
      _authentication.login(_users, authNotifier);
      // (authNotifier.user == null) ? Get.offAll(()=> LogIn())
      //     : (authNotifier.userDetails == null) ? print('waiting')
      //     : (authNotifier.userDetails!.role == 'admin') ? Get.offAll(()=> AdminPage())
      //     : Get.offAll(()=> HomePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(child: Text('Please Login'),),
                  _buildLoginForm(),
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildLoginForm(){
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: true);
    return Column(
      children: [
        TextFormField(
          validator: (value){
            return null;
          },
          onSaved: (newValue){
            _users.email = newValue;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            labelText: 'Email',
            prefixIcon: Icon(Icons.email),
          ),
        ),
        SizedBox(),
        TextFormField(
          validator: (value){
            return null;
          },
          onSaved: (newValue){
            _users.password = newValue;
          },
          decoration: InputDecoration(
            suffix: IconButton(
                onPressed: (){
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                icon: Icon((showPassword) ? Icons.visibility_off : Icons.visibility)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            labelText: 'Password',
            prefixIcon: Icon(Icons.lock),),
          keyboardType: TextInputType.visiblePassword,
          obscureText: showPassword,
        ),
        SizedBox(height: 17,),
        ElevatedButton(
          onPressed: (){
            _submitForm();
          },
          child: Text('Login'),),
        SizedBox(),
        ElevatedButton(
          onPressed: (){
            Get.to(() => SignUp());
          },
          child: Text('Or SignUp'),),
      ],
    );
  }
}
