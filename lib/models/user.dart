
import 'package:flutter/cupertino.dart';

class Users {

  String? displayName;
  String? email;
  String? password;
  String? phone;
  String? role;
  String? uuid;

  Users({ this.displayName,  this.email, this.password, this.phone, this.role,
      this.uuid});

  Users.fromMap(Map<String, dynamic> data){
    displayName = data['displayName'];
    email = data['email'];
    password = data['password'];
    phone = data['phone'];
    role = data['role'];
    uuid = data['uuid'];
  }

  Map<String, dynamic> toMap(){
    return {
      'displayName' : displayName,
      'email' : email,
      'password' : password,
      'phone' : phone,
      'role' : role,
      'uuid' : uuid,
    };

  }


}