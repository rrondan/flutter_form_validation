import 'dart:async';

class LoginBloc {

  StreamController _emailController    = StreamController<String>.broadcast();
  StreamController _passwordController = StreamController<String>.broadcast();

  //Insertar Valores al Stream
  Function(String) get changeEmail    => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  // Recuperar los datos del Stream
  Stream<String> get emailStream    => _emailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;

  dispose(){
    _emailController?.close();
    _passwordController?.close();
  }


}