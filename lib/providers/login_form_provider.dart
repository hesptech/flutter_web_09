import 'package:admin_dashboard/models/usuario.dart';
import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {

  Usuario? user;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String email    = '';
  String password = '';

  bool validateForm() {

    if ( formKey.currentState!.validate() ) {
      // print('Form valid ... Login');
      // print('$email === $password');
      return true;
    } else {
      // print('Form not valid');
      return false;
    }

  }


}