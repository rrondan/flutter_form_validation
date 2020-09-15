import 'dart:convert';

import 'package:flutter_form_validation/src/shared_prefs/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider{

  final _prefs = new PreferenciasUsuario();
  final String _apiKeyFirebase = "AIzaSyDDAjUMSvs8QYCPYscojOVk5gz4qgAmY3w";

  Future<Map<String, dynamic>> createUser(String email, String password) async{
    final authData = {
      "email"    : email,
      "password" : password,
      "returnSecureToken" : true
    };
    final resp = await http
        .post("https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_apiKeyFirebase",
      body: json.encode(authData)
    );
    Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);
    if(decodedResp.containsKey("idToken")){
      _prefs.token = decodedResp['idToken'];
      return {'ok': true, 'token': decodedResp['idToken']};
    } else {
      return {'ok': false, 'message': decodedResp['error']['message'] ?? ""};
    }
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async{
    final authData = {
      "email"    : email,
      "password" : password,
      "returnSecureToken" : true
    };
    final resp = await http
        .post("https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_apiKeyFirebase",
        body: json.encode(authData)
    );
    Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);
    if(decodedResp.containsKey("idToken")){
      _prefs.token = decodedResp['idToken'];
      return {'ok': true, 'token': decodedResp['idToken']};
    } else {
      return {'ok': false, 'message': decodedResp['error']['message'] ?? ""};
    }
  }

}