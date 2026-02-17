import 'dart:io';

void main(){
  print("Coloque un nivel: (A,B,C,D)");
  String nivel =stdin.readLineSync()!;
  switch(nivel){
    case "A":
      print("Exelente");
      break;
    case "B":
      print("Bueno");
      break;
    case "C":
      print("Regular");
      break;
    case "D":
      print("Deficiente");
      break;
    default:
      print("No existe ese nivel");
  }
}