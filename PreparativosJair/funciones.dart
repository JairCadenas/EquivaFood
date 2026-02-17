import 'dart:io';

int valor1=50, valor2=30;
int sumar(){
  int suma;
  suma=valor1+valor2;
  return suma;
}
String DameInformacion(){
  print('Ingresa tu nombre de usuario: ');
  String? usuario = stdin.readLineSync();
  return usuario!;
}
void main(){
  print("El serultado de la suma fue: ${sumar()}");
  print(DameInformacion());
}