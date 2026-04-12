import 'dart:io';
void main(){
  print('Ingresa tu edad');
  int edad = int.parse(stdin.readLineSync()!);

  if(edad >= 18){
    print('Eres mayor de edad');
  }
  else if(edad >= 10){
    print('eres un adolescente');
  }
  else{
    print('eres un niño');
  }

  int numero = 10;
  // los dos puntos : significan 'de lo contrario'
  String resultado = (numero % 2==0) ? 'par' : 'impar';
  print(resultado);
}