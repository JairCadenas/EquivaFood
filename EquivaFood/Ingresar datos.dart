import 'dart:io';
void main(){
  print('Ingresa tu nombre de usuario');
  String? usuario = stdin.readLineSync();
  print('Ingresa tu clave');
  String? v_clave = stdin.readLineSync();

  print('Nombre de usuario ingresado: ${usuario}');
  print('Clave ingresada: ${v_clave}');

}