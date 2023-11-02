import 'package:flutter/material.dart';

class NavbarAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /* return ClipOval(
      child: Container(
        child: Image.network('https://images.unsplash.com/photo-1534528741775-53994a69daeb'),
        width: 30,
        height: 30,
      ),
    ); */

    return Container(
      //child: Image.network('https://images.unsplash.com/photo-1534528741775-53994a69daeb'),
      child: const CircleAvatar(
        backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb'),
        radius: 80,
      ),
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
    );
  }
}