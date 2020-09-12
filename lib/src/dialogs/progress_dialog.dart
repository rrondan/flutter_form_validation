import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressDialog {

  final BuildContext context;
  bool _dialogIsOpen = false;

  ProgressDialog(this.context);

  void show(){
    if(!_dialogIsOpen) {
      AlertDialog alertDialog = AlertDialog(
        content: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Cargando..."),
          ],
        ),
      );
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => alertDialog
      );
      _dialogIsOpen = true;
    }
  }

  void hide(){
    if(_dialogIsOpen){
      _dialogIsOpen = false;
      Navigator.pop(context);
    }
  }

}