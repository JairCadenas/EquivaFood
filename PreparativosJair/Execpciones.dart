import 'dart:io';
void main(){
  try{
    print("Ingresa un dato: ");
    int? valor1= int.parse(stdin.readLineSync()!);
    print("Ingresa un dato: ");
    int? valor2= int.parse(stdin.readLineSync()!);
    int resultado = valor1  ~/ valor2 ;
    print('Resultado: $resultado');
  }on FormatException{
    print("Solo se pueden ingresar datos de valor entero");
  }on IntegerDivisionByZeroException{
    print("Las diviciones entre 0 no son permitidas");
  }
  catch(ERROR){
    print("Error en operacion: $ERROR");
  }
}