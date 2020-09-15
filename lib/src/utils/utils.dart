
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool isNumeric( String s){
  if(s.trim().isEmpty) return false;

  final number = num.tryParse(s);

  return number != null;
}

void showAlertDialog(BuildContext context, String message){
  showDialog(context: context,
    builder: (context){
      return AlertDialog(
        title: Text("Información incorrecta"),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text("Aceptar"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      );
    }
  );
}