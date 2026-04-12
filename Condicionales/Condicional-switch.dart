import 'dart:io';
void main(){
  print('Coloque el nivel');
  String nivel = stdin.readLineSync()!;

  switch(nivel){
    case 'A':
    print('Excelente!');
    break;
    case 'B':
    print('Bueno!');
    break;
    case 'C':
    print('Regular!');
    break;
    case 'D':
    print('Deficiente!');
    break;
    default:
    print('nivel colocado incorrecto');
  }
}