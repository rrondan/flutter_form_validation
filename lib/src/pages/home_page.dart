import 'package:flutter/material.dart';
import 'package:flutter_form_validation/src/bloc/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context).loginBloc;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("Email: ${bloc.email}"),
          Divider(),
          Text("Password: ${bloc.password}"),
          Divider(),
          StreamBuilder(
            stream: bloc.concatEmailPassword,
            builder: (context, snapshot) => Text("Valor: ${snapshot.data??''}"),
          )
        ],
      ),
    );
  }
}
