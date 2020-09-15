

import 'package:flutter/cupertino.dart';
import 'package:flutter_form_validation/src/bloc/login_bloc.dart';
import 'package:flutter_form_validation/src/bloc/products_bloc.dart';
import 'package:flutter_form_validation/src/bloc/products_firebase_bloc.dart';

class Provider extends InheritedWidget{

  static Provider _instancia;

  factory Provider({Key key, Widget child}){
    if(_instancia == null){
      _instancia = Provider._internal(key: key, child:child);
    }
    return _instancia;
  }

  Provider._internal({ Key key, Widget child })
      : super(key: key, child:child);

  final loginBloc = LoginBloc();
  final productsFirebaseBloc = ProductsFirebaseBloc();
  final _productsBloc = ProductsBloc();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  //Retornamos el provider
  static Provider of (BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>() ;
  }

  //Retornando un atributo de la Clase.
  static ProductsBloc productsBloc (BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._productsBloc ;
  }

}
