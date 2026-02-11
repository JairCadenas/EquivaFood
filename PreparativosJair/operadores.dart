import 'dart:io';

void main(){
  int valor1, valor2;
  var resultados;
  print("Ingresa el valor 1: ");
  valor1 = int.parse(stdin.readLineSync()!);
  print("Ingresa el valor 2: ");
  valor2 = int.parse(stdin.readLineSync()!);
  //Suma
  resultados=valor1+valor2;
  print('Suma: ${resultados}');
  //Resta
  resultados=valor1-valor2;
  print('Resta: ${resultados}');
  //Multi
  resultados=valor1*valor2;
  print('Miltiplicacion: ${resultados}');
  //Div
  resultados=valor1/valor2;
  print('Divicion: ${resultados}');
  //Div entero
  resultados=valor1 ~/ valor2;
  print('Divicion por enteros: ${resultados}');
  //Residuo
  resultados=valor1%valor2;
  print('Residuo: ${resultados}');
}