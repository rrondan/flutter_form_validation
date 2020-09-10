
import 'dart:convert';

import 'package:flutter_form_validation/src/models/producto_model.dart';
import 'package:http/http.dart' as http;

class ProductsProvider{

  String _url = "https://flutter-productos-81311.firebaseio.com/";

  Future<bool> createProduct(ProductoModel product) async{
    final url = "$_url/productos.json";
    final resp = await http.post(url, body: productToJson(product));
    final decodedData = json.decode(resp.body);
    print(decodedData);
    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    final url = "$_url/productos.json";
    final resp = await http.get(url);
    Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<ProductoModel> products = new List();
    if(decodedData == null) return [];

    decodedData.forEach((id, prod) {
      final prodTemp = ProductoModel.fromJson(prod);
      prodTemp.id = id;
      products.add(prodTemp);
    });

    return products;
  }

}