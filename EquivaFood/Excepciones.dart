import 'dart:io';
void main(){
  try{
  print('Ingrese valor1...');
  int? valor1 = int.parse(stdin.readLineSync()!);
  print('Ingrese valor2...');
  int? valor2 = int.parse(stdin.readLineSync()!);

    int resultado = valor1 ~/ valor2;
    print('Resultado: $resultado');

  }on FormatException{
    print('Deebe ingresar un valor entero');
  }on IntegerDivisionByZeroException{
    print('Division entre 0 no permitida');
  }
  
  catch(ERROR){
    print('Error en operación: $ERROR');
  }
}