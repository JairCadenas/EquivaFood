import 'dart:io';

void main(){
  int valor1, valor2;
  var resultado;

  print('Ingrese valor 1...');
  valor1 = int.parse(stdin.readLineSync()!);
  print('Ingrese valor 2...');
  valor2 = int.parse(stdin.readLineSync()!);

  //operador de suma
  resultado = valor1 + valor2;
  print('Suma: ${resultado}');

  //operador de resta
  resultado = valor1 - valor2;
  print('Resta: ${resultado}');

  //operador de multiplicación
  resultado = valor1 * valor2;
  print('Multiplicación: ${resultado}');

  //operador de división
  resultado = valor1 / valor2;
  print('División: ${resultado}');

    //operador de división entera --> descarta decimales
  resultado = valor1 ~/ valor2;
  print('División entera: ${resultado}');

  //operador de residuo
  resultado = valor1 % valor2;
  print('Residuo: ${resultado}');
  
}