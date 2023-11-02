import 'package:flutter/material.dart';
import 'package:admin_dashboard/models/usuario.dart';
import 'package:admin_dashboard/services/navigation_service.dart';


class UsersDataSource extends DataTableSource {
  
  final List<Usuario> users;
  //final BuildContext context;

  UsersDataSource(
    this.users, 
    //this.context
  ); 

  @override
  DataRow getRow(int index) {

    final Usuario user = this.users[index];
    //final image = Image(image: AssetImage('noimage.jpg'), width: 35, height: 35,);

    final image = ( user.img == null)
      ? Image(image: AssetImage('noimage.jpg'), width: 35, height: 35,)
      : FadeInImage.assetNetwork(
        placeholder: 'loader.gif', 
        image: user.img!,
        height: 35.0,
        width: 35.0,
      );


    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          ClipOval(
            child: image
          ),
        ),
        DataCell(Text(user.nombre)),
        DataCell(Text(user.correo)),
        DataCell(Text(user.uid)),
        DataCell(
          IconButton(
            icon: Icon(Icons.edit_outlined),
            onPressed: () {
              NavigationService.replaceTo('dashboard/users/${user.uid}');
            }  
          )
        ),
      ]
    );


  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => this.users.length  ;

  @override
  int get selectedRowCount => 0;
}