

import 'package:flutter/material.dart';
import 'package:admin_dashboard/router/router.dart';
import 'package:admin_dashboard/models/usuario.dart';
import 'package:admin_dashboard/models/http/auth_response.dart';
import 'package:admin_dashboard/api/cafe_api.dart';
import 'package:admin_dashboard/services/local_storage.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/services/notifications_service.dart';

enum AuthStatus {
  checking,
  authenticated,
  notAuthenticated
}

class AuthProvider extends ChangeNotifier {

  //String? _token;
  AuthStatus authStatus = AuthStatus.checking;
  Usuario? user;


  AuthProvider() {
    this.isAuthenticated();
  }


  login( String email, String password ) {

    final data = {
        'correo': email,
        'password': password
    };

    CafeApi.post('/auth/login', data).then(
      (json) {
        //print(json);
        final authResponse = AuthResponse.fromJson(json);
        this.user = authResponse.usuario;
      
        authStatus = AuthStatus.authenticated;
        LocalStorage.prefs.setString('token', authResponse.token );
        NavigationService.replaceTo(Flurorouter.dashboardRoute);

        CafeApi.configureDio();
        notifyListeners();
      }
    ).catchError((e) {
      NotificationsService.showSnackBarError('Usuario/Password novalidos!');
    });
  }

  register( String email, String password, String name ) {

    // Petición HTTP
    final data = {
        'nombre': name,
        'correo': email,
        'password': password
    };
    
    CafeApi.post('/usuarios', data).then(
      (json) {
        //print(json);
        final authResponse =  AuthResponse.fromJson(json);
        this.user = authResponse.usuario;

        authStatus = AuthStatus.authenticated;
        LocalStorage.prefs.setString('token', authResponse.token );
        NavigationService.replaceTo(Flurorouter.dashboardRoute);

        CafeApi.configureDio();
        notifyListeners(); 
      }
    ).catchError((e) {
        //print('error en: $e');
        NotificationsService.showSnackBarError('Usuario/Password no validos!');
    });
  }

  Future<bool> isAuthenticated() async {

    final token = LocalStorage.prefs.getString('token');

    if( token == null ) {
      authStatus = AuthStatus.notAuthenticated;
      notifyListeners();
      return false;
    }

    try {
      final resp = await CafeApi.httpGet('/auth'); 
      final authResponse = AuthResponse.fromJson(resp);
      LocalStorage.prefs.setString('token', authResponse.token);

      this.user = authResponse.usuario;
      authStatus = AuthStatus.authenticated; 
      notifyListeners();
      return true;
    } catch (e) {
      //print(e);
      authStatus = AuthStatus.notAuthenticated;
      notifyListeners();
      return false;
    }
    
    /* await Future.delayed(Duration(milliseconds: 1000 ));
    authStatus = AuthStatus.authenticated;
    notifyListeners();
    return true; */
  }

  loguot() {
    LocalStorage.prefs.remove('token');
    authStatus = AuthStatus.notAuthenticated;
    notifyListeners();
  }
}
