import 'package:admin_dashboard/ui/modals/category_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:admin_dashboard/datatables/categories_datasource.dart';
import 'package:admin_dashboard/providers/categories_provider.dart';
import 'package:admin_dashboard/ui/buttons/custom_outlined_button.dart';
import 'package:admin_dashboard/ui/labels/custom_labels.dart';

class CategoriesView extends StatefulWidget {

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {


  @override
  void initState() {
    super.initState();

    Provider.of<CategoriesProvider>(context, listen: false).getCategories();
  }

  @override
  Widget build(BuildContext context) {

    final categorias = Provider.of<CategoriesProvider>(context).categorias;

    return Container(
      padding: EdgeInsets.symmetric( horizontal: 20, vertical: 10 ),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Text('Categorias', style: CustomLabels.h1 ),

          SizedBox( height: 10 ),

          PaginatedDataTable(
            columns: [
              DataColumn(label: Text('ID'),),
              DataColumn(label: Text('Categoria'),),
              DataColumn(label: Text('Creado por'),),
              DataColumn(label: Text('Acciones'),),
            ], 
            source: CategoriesDTS( categorias, context ),
            header: Text('Lista de categorias'),
            actions: [
              CustomOutlinedButton(
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context, 
                    builder: ( _ ) => CategoryModal( categoria: null),
                  );
                }, 
                text: '+ new',
                color: Colors.black,
                isFilled: true,
              )
            ],
          )
        ],
      ),
    );
  }
}