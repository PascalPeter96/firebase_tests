
import 'package:firebase_tests/models/user.dart';
import 'package:firebase_tests/screens/login.dart';
import 'package:firebase_tests/services/auth_notifier.dart';
import 'package:firebase_tests/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey =GlobalKey<FormState>();
  Users _users = Users();
  bool showPassword = true;
  bool showConfirmPassword = true;
  final TextEditingController _passwordController = TextEditingController();
  Authentication _authentication = Authentication();
  @override
  void initState() {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    _authentication.initializeCurrentUser(authNotifier);
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
    if(_users.displayName!.length < 3){
      toast('should have atleast 3 chars');
    }else if(!regExp.hasMatch(_users.email!)){
      toast('Enter correct email format');
    } else if(_users.password!.length<8){
      toast('Password should have atleast 8 chars');
    }else if(_passwordController.text.toString() != _users.password){
      toast('passwords dont match');
    } else{
      print('Success');
      _users.role = 'user';
      _authentication.signUp(_users, authNotifier);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp'),
      ),
      body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(child: Text('Please SignUp'),),
                  _buildSignUpForm(),

                ],
              ),
            ),
          )),
    );
  }

  Widget _buildSignUpForm(){
    return Column(
      children: [
        TextFormField(
          validator: (value){
            return null;
          },
          onSaved: (newValue){
            _users.displayName = newValue;
          },
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            labelText: 'UserName',
            prefixIcon: Icon(Icons.account_circle),
          ),
        ),
        SizedBox(),
        TextFormField(
          validator: (value){
            return null;
          },
          onSaved: (newValue){
            _users.email = newValue;
          },
          keyboardType: TextInputType.emailAddress,
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
                });}, icon: Icon((showPassword) ? Icons.visibility_off : Icons.visibility)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            labelText: 'Password',
            prefixIcon: Icon(Icons.lock),),
          keyboardType: TextInputType.visiblePassword,
          obscureText: showPassword,
        ),
        SizedBox(height: 17,),
        TextFormField(
          validator: (value){
            return null;
          },
          controller: _passwordController,
          // onSaved: (newValue){
          //   _users.password = newValue;
          // },
          decoration: InputDecoration(
            suffix: IconButton(
                onPressed: (){
                  setState(() {
                    showConfirmPassword = !showConfirmPassword;
                  });}, icon: Icon((showConfirmPassword) ? Icons.visibility_off : Icons.visibility)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            labelText: 'Confirm Password',
            prefixIcon: Icon(Icons.lock),),
          keyboardType: TextInputType.visiblePassword,
          obscureText: showConfirmPassword,
        ),
        SizedBox(height: 17,),
        ElevatedButton(
          onPressed: (){
            _submitForm();
          },
          child: Text('SignUp'),),
        SizedBox(),
        ElevatedButton(
          onPressed: (){
            Get.to(() => LogIn());
          },
          child: Text('Already have account'),),
      ],
    );
  }

}
