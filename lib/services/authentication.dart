

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tests/models/user.dart';
import 'package:firebase_tests/screens/admin_page.dart';
import 'package:firebase_tests/screens/homepage.dart';
import 'package:firebase_tests/screens/login.dart';
import 'package:firebase_tests/services/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Authentication {

  FirebaseAuth auth = FirebaseAuth.instance;

  void toast(String msg){
    Fluttertoast.showToast(msg: msg,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.green,
      gravity:  ToastGravity.BOTTOM,
    );
  }


  Future<void> login(Users users, AuthNotifier authNotifier) async{
    UserCredential? result;
    try{
       result = await auth.signInWithEmailAndPassword(
          email: users.email!, password: users.password!);
    } catch(e){
      toast(e.toString());
    }

    try{
      if(result != null){
         User? user = auth.currentUser;
        if(!user!.emailVerified){
          auth.signOut();
          toast('Email Not Verified');
        }
        else if(user != null){
          print('Logged In : $user');
          authNotifier.setUser(user);
          await getUserDetails(authNotifier);
          print('done');
          //admin navigation
          if(authNotifier.userDetails!.role == 'admin'){
            Get.to(()=> AdminPage());
          } else{
            Get.to(()=> HomePage());
          }
        }
      }
    } catch(e){
    }

  }

  Future<void> getUserDetails(AuthNotifier authNotifier) async{
   FirebaseFirestore.instance.collection('users').doc(authNotifier.user!.uid).get()
        .catchError((e) => print(e)).then((value) =>
    (value != null) ? authNotifier.setUserDetails(Users.fromMap(value.data()!))
        : print(value));

  }

  Future<void> signUp(Users users, AuthNotifier authNotifier) async{
    UserCredential? result;
    bool userDataUploaded = false;
    try{
      result = await auth.createUserWithEmailAndPassword(
          email: users.email!, password: users.password!);
    } catch(e){
      toast(e.toString());
    }

    try{
      if(result !=null){
        await auth.currentUser!.updateDisplayName(users.displayName);
        User? user = result.user;
        await user!.sendEmailVerification();
        if(user != null){
          await user.reload();
          print('SignUp: $user');
          uploadUserData(users, userDataUploaded);
          await auth.signOut();
          authNotifier.setUser(null);
          toast('Verification sent to email');
          Get.back();
        }
      }

    }catch(e){
      toast(e.toString());
    }
  }

  Future<void> uploadUserData(Users users, bool userDataUploaded)async{
    bool userDataUploadVar = userDataUploaded;

    User? currentUser = auth.currentUser;
    users.uuid = currentUser!.uid;
    CollectionReference userRef =
        FirebaseFirestore.instance.collection('users');
    if(userDataUploadVar != true){
      await userRef.doc(currentUser.uid)
          .set(users.toMap())
          .catchError((e) =>
          print(e)).then((value) => userDataUploadVar=true);
    }
  }

  Future<void> initializeCurrentUser(AuthNotifier authNotifier) async{
    User? user = auth.currentUser;

    if(user !=null){
      authNotifier.setUser(user);
      await getUserDetails(authNotifier);
    }
  }

  Future<void> signOut(AuthNotifier authNotifier) async{
    await auth.signOut();
    authNotifier.setUser(null);
    print('logout');
    Get.to(()=> LogIn());
  }

}