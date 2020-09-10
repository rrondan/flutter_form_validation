import 'package:flutter/material.dart';
import 'package:flutter_form_validation/src/bloc/provider.dart';
import 'package:flutter_form_validation/src/models/producto_model.dart';
import 'package:flutter_form_validation/src/providers/products_provider.dart';

class HomePage extends StatelessWidget {
  final _productsProvider = new ProductsProvider();
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context).loginBloc;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: _createListProducts(),
      floatingActionButton: _addButton(context),
    );
  }

  Widget _addButton(BuildContext context){
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: (){
        Navigator.pushNamed(context, "product");
      },
    );
  }

  Widget _createListProducts(){
    return FutureBuilder<List<ProductoModel>>(
      future: _productsProvider.cargarProductos(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          final products = snapshot.data;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) => _createItem(context, products[index]),
          );
        } else {
          return Center( child:  CircularProgressIndicator());
        }
      },
    );
  }

  Widget _createItem(BuildContext context, ProductoModel product){
    return Dismissible(
      key: UniqueKey(),
      background: Container(color: Colors.red),
      onDismissed: (direccion){
        //TODO: Borrar producto
      },
      child: ListTile(
        title: Text("${ product.titulo } - S/${ product.valor }"),
        subtitle: Text(product.id),
        //TODO: Mandar producto
        onTap: () => Navigator.pushNamed(context, "product"),
      ),
    );
  }
}
