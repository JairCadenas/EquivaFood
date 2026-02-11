import 'dart:io';

void main(){
  print('Ingresa tu nombre de usuario: ');
  String? usuario = stdin.readLineSync();
  print('Ingresa tu clave: ');
  String? clave = stdin.readLineSync();
  print('El nombre del usuario es: ${usuario}');
  print('Ingresa tu clave: ${clave}');
}