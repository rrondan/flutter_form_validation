import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_validation/src/bloc/products_bloc.dart';
import 'package:flutter_form_validation/src/bloc/products_firebase_bloc.dart';
import 'package:flutter_form_validation/src/bloc/provider.dart';
import 'package:flutter_form_validation/src/dialogs/progress_dialog.dart';
import 'package:flutter_form_validation/src/models/producto_model.dart';
import 'package:flutter_form_validation/src/utils/my_images.dart';
import 'package:flutter_form_validation/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductPage extends StatefulWidget {

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _formKey = GlobalKey<FormState>();

  ProductoModel _producto = new ProductoModel();

  File _photo;
  bool _loading = false;
  ProgressDialog _progressDialog;
  ProductsFirebaseBloc _productsBloc;

  @override
  Widget build(BuildContext context) {
    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
    if(_productsBloc == null){
      _productsBloc = Provider.of(context).productsFirebaseBloc;
    }
    if(prodData != null){
      _producto = prodData;
    }
    if(_progressDialog == null){
      _progressDialog = ProgressDialog(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Producto"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: () => _processImage(ImageSource.gallery),
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () => _processImage(ImageSource.camera),
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
                _showPhoto(),
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

  Widget _showPhoto(){
    if(_producto.fotoUrl != null){
      return FadeInImage(
        image: NetworkImage(_producto.fotoUrl),
        placeholder: AssetImage(MyImages.LOADING),
        height: 300.0,
        fit: BoxFit.contain,
      );
    } else {
      return Image(
        image: _photo != null ? FileImage(_photo)
            : AssetImage(MyImages.NO_IMAGE),
        height: 300,
        fit: BoxFit.cover,
      );
    }
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
      onPressed: !_loading ? _summit : null,
    );
  }

  void _summit() async{

    //Esta funcion solo valida el formulario
    if(!_formKey.currentState.validate()) return;

    //Vamos a guardar el formulario
    _formKey.currentState.save();

    setState(() => _loading = true );
    _progressDialog.show();

    if(_photo != null){
      _producto.fotoUrl = await _productsBloc.uploadImage(_photo);
    }

    if(_producto.id == null) {
      await _productsBloc.addProduct(_producto);
    } else {
      await _productsBloc.editProduct(_producto);
    }

    setState(() => _loading = false );
    _progressDialog.hide();
    Navigator.pop(context);
  }

  void _processImage(ImageSource source) async{
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);
    _photo = File(pickedFile.path);
    if(_photo != null){
      _producto.fotoUrl = null;
    }
    setState(() { });
  }
}
