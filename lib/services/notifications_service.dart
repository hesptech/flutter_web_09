import 'package:flutter/material.dart';

class NotificationsService {

  static GlobalKey<ScaffoldMessengerState> messangerKey = new GlobalKey<ScaffoldMessengerState>();

  static showSnackBarError( String message) {

    final snackBar = new SnackBar(
      backgroundColor: Colors.red,
      content: Text(message,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );

    messangerKey.currentState!.showSnackBar(snackBar);
  }


  static showSnackBar( String message) {

    final snackBar = new SnackBar(
      backgroundColor: Colors.red,
      content: Text(message,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );

    messangerKey.currentState!.showSnackBar(snackBar);
  }

  static showBusyIndicator( BuildContext context ) {
    final AlertDialog dialog = AlertDialog(
      content: Container(
        width: 100.0,
        height: 100.0,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );

    showDialog(context: context, builder: ( _ ) => dialog );
  }
}