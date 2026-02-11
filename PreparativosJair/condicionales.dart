import 'dart:io';

void main(){
  print("Ejemplo 1: Saber si eres mayor o menor de edad");
  print('ingresa tu edad:');
  int edad =int.parse(stdin.readLineSync()!);
  if(edad>=18){
    print("Eres un adulto");
  }else if(edad>=10){
    print("Eres un adolecente");
  }
  else print("Eres un niño");
  print("Ejemplo 2: Saber si el numero ingresado es par:");
  print("Ingresa un numero a calcular");
  int num=int.parse(stdin.readLineSync()!);
  String resultado=(num%2==0)?'par':'impar';
  print(resultado);

}