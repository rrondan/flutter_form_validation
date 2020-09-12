
import 'dart:convert';
import 'dart:io';

import 'package:flutter_form_validation/src/models/producto_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';


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

  Future<int> deleteProduct( String id ) async{
    final url = "$_url/productos/$id.json";
    final resp = await http.delete(url);
    return 1;
  }

  Future<bool> editProduct(ProductoModel product) async{
    final url = "$_url/productos/${product.id}.json";
    final resp = await http.put(url, body: productToJson(product));
    final decodedData = json.decode(resp.body);
    print(decodedData);
    return true;
  }

  Future<String> uploadImage(File image) async{
    final url = Uri.parse("https://api.cloudinary.com/v1_1/dvqk8yhxt/image/upload?upload_preset=xeoetyhq");

    final mimeType = mime(image.path).split("/"); // image/jpeg
    
    final imageUploadRequest = http.MultipartRequest(
      "POST",
      url
    );
    final file = await http.MultipartFile.fromPath(
      "file",
      image.path,
      contentType: MediaType(mimeType[0], mimeType[1])
    );

    imageUploadRequest.files.add(file);

    http.StreamedResponse streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if( resp.statusCode != 200 && resp.statusCode != 201){
      print("Algo salio mal");
      print(resp.body);
      return null;
    }

    final respData = json.decode(resp.body);
    print(respData);
    return respData["secure_url"];
  }
}