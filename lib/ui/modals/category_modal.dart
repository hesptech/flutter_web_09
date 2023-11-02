import 'package:admin_dashboard/services/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:admin_dashboard/models/category.dart';
import 'package:admin_dashboard/providers/categories_provider.dart';
import 'package:admin_dashboard/ui/buttons/custom_outlined_button.dart';
import 'package:admin_dashboard/ui/inputs/custom_inputs.dart';
import 'package:admin_dashboard/ui/labels/custom_labels.dart';

class CategoryModal extends StatefulWidget {
  
  final Categoria? categoria;

  const CategoryModal({Key? key, this.categoria}) : super(key: key);

  @override
  State<CategoryModal> createState() => _CategoryModalState();
}

class _CategoryModalState extends State<CategoryModal> {
  
  String nombre = '';
  String? id;

  @override
  void initState() {
    super.initState();

    nombre = widget.categoria?.nombre?? '';
    id     = widget.categoria?.id;
  }
  
  @override
  Widget build(BuildContext context) {

    final categoryProvider = Provider.of<CategoriesProvider>(context, listen: false);

    return Container(
      padding: EdgeInsets.all(20.0),
      height: 500,
      width: 300,
      decoration: buildBoxDecoration(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.categoria?.nombre ?? 'Nueva categoria', style: CustomLabels.h1.copyWith( color: Colors.white )),
              IconButton(
                icon: Icon( Icons.close ),
                onPressed: () => Navigator.of(context).pop(), 
              )
            ],
          ),

          Divider( color: Colors.white.withOpacity(0.5),),

          SizedBox(height: 20.0,),

          TextFormField(
            initialValue: widget.categoria?.nombre?? '',
            onChanged: ( value ) => nombre = value,
            decoration: CustomInputs.loginInputDecoration(
              hint: 'Nombre de categoria',
              label: 'categoria',
              icon: Icons.new_releases_outlined
            ),
            style: TextStyle(color: Colors.white),
          ),

          Container(
            margin: EdgeInsets.only(top: 30.0),
            alignment: Alignment.center,
            child: CustomOutlinedButton(
              onPressed: () async{

                try {
                  if(id == null) {
                    await categoryProvider.newCategory(nombre);
                    NotificationsService.showSnackBar('$nombre creado!');
                  } else {
                    await categoryProvider.updateCategoria(id!, nombre);
                    NotificationsService.showSnackBar('$nombre actualizado!');
                  }
                  Navigator.of(context).pop();
                } catch (e) {
                  Navigator.of(context).pop();
                  NotificationsService.showSnackBar('no se pudo guardar la categoria');
                }

              }, 
              text: 'Guardar',
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  BoxDecoration buildBoxDecoration() => BoxDecoration(
    borderRadius: BorderRadius.only( topLeft: Radius.circular(20), topRight: Radius.circular(20) ),
    color: Colors.red.withOpacity(0.5),
    boxShadow: [
      BoxShadow(color: Colors.black)
    ]
  );
}