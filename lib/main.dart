import 'package:flutter/material.dart';
import 'package:flutter_form_validation/src/bloc/provider.dart';
import 'package:flutter_form_validation/src/pages/home_page.dart';
import 'package:flutter_form_validation/src/pages/login_page.dart';
import 'package:flutter_form_validation/src/pages/product_page.dart';
import 'package:flutter_form_validation/src/pages/register_page.dart';
import 'package:flutter_form_validation/src/shared_prefs/preferencias_usuario.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final prefs = PreferenciasUsuario();
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'Material App',
        initialRoute: prefs.token.toString().isEmpty ? "login" : "home",
        debugShowCheckedModeBanner: false,
        routes: {
          "login": (BuildContext context) => LoginPage(),
          "register": (BuildContext context) => RegisterPage(),
          "home" : (BuildContext context) => HomePage(),
          "product" : (BuildContext context) => ProductPage(),
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple
        ),
      ),
    );
  }
}
