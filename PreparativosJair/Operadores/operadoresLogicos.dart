import 'dart:io';

void main(){
  print("Ejemplo 1 Operador && y ||: Saber si eres mayor o menor de edad");
  print('ingresa tu edad:');
  int edad =int.parse(stdin.readLineSync()!);
  print("Tienes Licencia?");
  String licencia=stdin.readLineSync()!;
  if(edad >= 18 && licencia == 'si' ||  licencia=='Si'){
    print("Permiso de conducir aprobado");
  }else print("Permino y licencia denegada");
  print("Ejemplo 2: Variables Booleana");
  bool activo=true;
  print(activo);
  print(!activo);
}