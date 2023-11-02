import 'package:flutter/material.dart';

import 'package:admin_dashboard/models/category.dart';
import 'package:admin_dashboard/api/cafe_api.dart';
import 'package:admin_dashboard/models/http/categories_response.dart';

class CategoriesProvider extends ChangeNotifier {

  List<Categoria> categorias = [];

  getCategories() async {
    final resp = await CafeApi.httpGet('/categorias');
    final categoriesResp = CategoriesResponse.fromJson(resp);

    this.categorias = [...categoriesResp.categorias];
    //print(this.categorias);

    notifyListeners();
  }

  Future newCategory( String name ) async {

    final data = {
      'nombre': name
    };

    try {
      final json = await CafeApi.post('/categorias', data);
      final newCategory = Categoria.fromJson(json);

      categorias.add(newCategory);
      notifyListeners();
    } catch(e) {
      //throw '$e error al crear new categoria!';
    }
  }

  Future updateCategoria(String id, String name) async {

    final data = {
      'nombre': name
    };

    try {
      await CafeApi.put('/categorias/$id', data);

      this.categorias = this.categorias.map(
        (category) {
          if(category.id != id) return category;

          category.nombre = name;
          return category;
        }
      ).toList();

      notifyListeners();

    } catch (e) {
      //throw '$e error al actualizar categoria!';
    }   
  }

  Future deleteCategory(String id) async {

    try {
      await CafeApi.delete('/categorias/$id', {});

      this.categorias.removeWhere((categorias) => categorias.id == id );

      notifyListeners();

    } catch (e) {
      //print(e);
      //print('error al actualizar categoria!');
    }   
  }
}