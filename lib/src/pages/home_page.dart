import 'package:flutter/material.dart';
import 'package:flutter_form_validation/src/bloc/products_bloc.dart';
import 'package:flutter_form_validation/src/bloc/products_firebase_bloc.dart';
import 'package:flutter_form_validation/src/bloc/provider.dart';
import 'package:flutter_form_validation/src/models/producto_model.dart';
import 'package:flutter_form_validation/src/utils/my_images.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context).productsFirebaseBloc;

    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: _createListProducts(bloc),
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

  Widget _createListProducts(ProductsFirebaseBloc productsBloc){
    return StreamBuilder<List<ProductoModel>>(
      stream: productsBloc.productsStream,
      builder: (context,AsyncSnapshot<List<ProductoModel>> snapshot){
        if(snapshot.hasData){
          final products = snapshot.data;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) => _createItem(context, products[index], productsBloc),
          );
        } else {
          return Center( child:  CircularProgressIndicator());
        }
      }
    );
  }

  Widget _createItem(BuildContext context, ProductoModel product, ProductsFirebaseBloc productsBloc){
    return Dismissible(
      key: UniqueKey(),
      background: Container(color: Colors.red),
      onDismissed: (direccion){
        productsBloc.deleteProduct(product.id);
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, "product", arguments: product),
          child: Column(
            children: <Widget>[
              product.fotoUrl == null ?
                  Image(image: AssetImage(MyImages.NO_IMAGE),
                    height: 300.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ) :
                  FadeInImage(
                    image: NetworkImage(product.fotoUrl),
                    placeholder: AssetImage(MyImages.LOADING),
                    height: 300.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
              ListTile(
                title: Text("${ product.titulo } - S/${ product.valor }"),
                subtitle: Text(product.id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
