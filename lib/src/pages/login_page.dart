import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_validation/src/bloc/login_bloc.dart';
import 'package:flutter_form_validation/src/bloc/provider.dart';
import 'package:flutter_form_validation/src/dialogs/progress_dialog.dart';
import 'package:flutter_form_validation/src/shared_prefs/preferencias_usuario.dart';
import 'package:flutter_form_validation/src/utils/utils.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final _prefs = new PreferenciasUsuario();
    print(_prefs.token);
    return Scaffold(
      //backgroundColor: Colors.red,
      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _crearLoginForm(context),
        ],
      )
    );
  }

  Widget _crearFondo(BuildContext context){
    final size = MediaQuery.of(context).size;
    final fondoMoradoDegrade = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            Color.fromRGBO(63, 63, 156, 1.0),
            //Colors.red,
            Color.fromRGBO(90, 70, 178, 1.0),
          ],
        )
      ),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle
        //borderRadius: BorderRadius.circular(50),
      ),
    );

    final logo = Container(
      padding: EdgeInsets.only(top: 75.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.person_pin_circle, color: Colors.white, size: 100.0),
          SizedBox(height: 10.0, width: double.infinity),
          Text("Formularios", style: TextStyle(color: Colors.white, fontSize: 25.0))
        ],
      ),
    );

    return Stack(
      children: <Widget>[
        fondoMoradoDegrade,
        Positioned( top: 90.0, left: 30.0, child: circulo),
        Positioned( top: -40.0, right: -30.0, child: circulo),
        Positioned( bottom: -50.0, right: -10.0, child: circulo),
        Positioned( bottom: 80.0, right: 20.0, child: circulo),
        Positioned( bottom: -50.0, left: -20.0, child: circulo),
        logo,
      ],
    );
  }

  Widget _crearLoginForm(BuildContext context){
    final bloc = Provider.of(context).loginBloc;
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(height: 180.0),
            Container(
              width: size.width * 0.85,
              margin: EdgeInsets.symmetric(vertical: 30.0),
              padding: EdgeInsets.symmetric(vertical: 50.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3.0,
                    offset: Offset(0.0, 5.0),
                    spreadRadius: 3.0
                  )
                ]
              ),
              child: Column(
                children: <Widget>[
                  Text("Ingreso", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 60.0),
                  _emailTextField(bloc),
                  SizedBox(height: 30.0),
                  _passwordTextField(bloc),
                  SizedBox(height: 30.0),
                  _crearBoton(bloc),
                ],
              ),
            ),
            FlatButton(
              child: Text("Crear una nueva cuenta"),
              onPressed: () {
                bloc.cleanEmailPassword();
                Navigator.pushReplacementNamed(context, "register");
              },
            ),
            SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }

  Widget _emailTextField(LoginBloc bloc){
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (context, snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            /*inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly
            ],*/
            decoration: InputDecoration(
                icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
                hintText: "ejemplo@correo.com",
                labelText: "Correo electrónico",
                counterText: snapshot.data,
                errorText: snapshot.error
            ),
            //onChanged: (value) => bloc.changeEmail(value),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }

  Widget _passwordTextField(LoginBloc bloc){
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (context, snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.deepPurple),
              labelText: "Contraseña",
              counterText: snapshot.data,
              errorText: snapshot.error
            ),
            //onChanged: (value) => bloc.changePassword(value),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  Widget _crearBoton(LoginBloc bloc){
    return StreamBuilder<bool>(
      stream: bloc.formValidStream,
      builder: (context, snapshot) {
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            child: Text("Ingresar"),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
          ),
          color: Colors.deepPurple,
          textColor: Colors.white,
          onPressed: snapshot.hasData ? () => _login(bloc, context) : null
        );
      }
    );
  }

  void _login(LoginBloc bloc, BuildContext context) async{
    ProgressDialog _progressDialog = new ProgressDialog(context);
    _progressDialog.show();
    Map info = await bloc.loginUser();
    _progressDialog.hide();
    if(info['ok']){
      Navigator.pushReplacementNamed(context, "home");
    } else {
      showAlertDialog(context, info['message']);
    }
  }
}
