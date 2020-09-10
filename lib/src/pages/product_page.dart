import 'package:flutter/material.dart';
import 'package:flutter_form_validation/src/models/producto_model.dart';
import 'package:flutter_form_validation/src/providers/products_provider.dart';
import 'package:flutter_form_validation/src/utils/utils.dart' as utils;

class ProductPage extends StatefulWidget {

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _formKey = GlobalKey<FormState>();

  ProductoModel _producto = new ProductoModel();
  final _productProvider  = new ProductsProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Producto"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: (){
            },
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: (){

            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _createName(),
                _createPrice(),
                _createAvailable(),
                _createButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createName(){
    return TextFormField(
      initialValue: _producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: "Producto"
      ),
      onSaved: (value) => _producto.titulo = value,
      validator: (value){
        if(value.trim().length < 3){
          return "Ingrese el nombre del producto";
        } else {
          return null;
        }
      },
    );
  }

  Widget _createPrice(){
    return TextFormField(
      initialValue: _producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
          labelText: "Precio"
      ),
      onSaved: (value) => _producto.valor = double.parse(value),
      validator: (value){
        if(utils.isNumeric(value)){
          return null;
        } else {
          return "Solo números";
        }
      },
    );
  }

  Widget _createAvailable(){
    return SwitchListTile(
      value: _producto.disponible,
      title: Text("Disponible"),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState((){
        _producto.disponible = value;
      }),
    );
  }

  Widget _createButton(){
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      icon: Icon(Icons.save),
      label: Text("Guardar"),
      onPressed: _summit,
    );
  }

  void _summit(){

    //Esta funcion solo valida el formulario
    if(!_formKey.currentState.validate()) return;

    //Vamos a guardar el formulario
    _formKey.currentState.save();


    print("TODO esta OK!");
    print( _producto.titulo );
    print( _producto.valor );
    print( _producto.disponible );

    _productProvider.createProduct(_producto);
  }
}
