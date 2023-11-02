import 'dart:typed_data';

import 'package:admin_dashboard/api/cafe_api.dart';
import 'package:flutter/material.dart';
import 'package:admin_dashboard/models/usuario.dart';

class UserFormProvider extends ChangeNotifier {

  Usuario? user;
  late GlobalKey<FormState> formKey;

  void updateListener() {
    notifyListeners();
  }

  bool _validform() {
    return formKey.currentState!.validate();
  }


  copyUserWith({
    String? rol,
    bool? estado,
    bool? google,
    String? nombre,
    String? correo,
    String? uid,
    String? img,
  }) {
    user = new Usuario(
      rol: rol ?? this.user!.rol, 
      estado: estado ?? this.user!.estado, 
      google: google ?? this.user!.google, 
      nombre: nombre ?? this.user!.nombre, 
      correo: correo ?? this.user!.correo, 
      uid: uid ?? this.user!.uid,
      img: img ?? this.user!.img,
    );
    notifyListeners();
  }


  Future updateUser() async {
    
    if ( !this._validform() ) return false;

    final data = {
      'nombre': user!.nombre,
      'correo': user!.correo,
    };

    try {
      final resp = await CafeApi.put('/usuarios/${ user!.uid }', data);
      print(resp);
      return true;
       
    } catch (e) {
      //print('error en update user: $e');
      return false;
      //throw e;
    }
  }


   Future<Usuario> uploadImage( String path, Uint8List bytes ) async {

    try {
      
      final resp = await CafeApi.uploadFile(path, bytes);
      user = Usuario.fromJson(resp);
      notifyListeners();

      return user!;
    } catch (e) {
      throw 'Error in Provider upload image';
    }
   }
}
