

import 'dart:collection';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_form_validation/src/models/producto_model.dart';
import 'package:flutter_form_validation/src/providers/products_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductsFirebaseBloc{

  final _productsProvider = new ProductsProvider();
  DatabaseReference _productsReference = FirebaseDatabase.instance.reference().child("productos");

  final _productsController = new BehaviorSubject<List<ProductoModel>>();

  Stream<List<ProductoModel>> get productsStream => _productsController.stream;

  ProductsFirebaseBloc(){
    _productsReference.onValue.listen((event) {
      Map<String, dynamic> decodedData = HashMap.from(event.snapshot.value);
      final List<ProductoModel> products = new List();
      decodedData.forEach((id, product) {
        final prodTemp = ProductoModel.fromJson(HashMap.from(product));
        prodTemp.id = id.toString();
        products.add(prodTemp);
      });
      _productsController.sink.add(products);
    }).onError((error){
      _productsController.sink.addError(error);
    });
  }

  void dispose(){
    _productsController?.close();
  }

  addProduct(ProductoModel product) async {
    await _productsReference.push().set(product.toJson());
  }

  Future<String> uploadImage(File photo) async {
    String _photoUrl = await _productsProvider.uploadImage(photo);
    return _photoUrl;
  }

  editProduct(ProductoModel product) async{
    await _productsReference.child(product.id).set(product.toJson());
  }

  deleteProduct(String id) async{
    await _productsReference.child(id).remove();
  }

}