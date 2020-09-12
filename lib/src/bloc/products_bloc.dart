
import 'dart:io';

import 'package:flutter_form_validation/src/models/producto_model.dart';
import 'package:flutter_form_validation/src/providers/products_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductsBloc {

  final _productsProvider = new ProductsProvider();
  final _productsController = new BehaviorSubject<List<ProductoModel>>();

  Stream<List<ProductoModel>> get productsStream => _productsController.stream;

  void dispose(){
    _productsController?.close();
  }

  loadProducts() async{
    final products = await _productsProvider.cargarProductos();
    _productsController.sink.add(products);
  }

  addProduct(ProductoModel product) async {
    await _productsProvider.createProduct(product);
    await loadProducts();
  }

  Future<String> uploadImage(File photo) async {
    String _photoUrl = await _productsProvider.uploadImage(photo);
    return _photoUrl;
  }

  editProduct(ProductoModel product) async{
    await _productsProvider.editProduct(product);
    await loadProducts();
  }

  void deleteProduct(String id) async{
    await _productsProvider.deleteProduct(id);
    loadProducts();
  }

}

