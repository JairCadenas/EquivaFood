import 'dart:io';
import 'dart:math';
void main(){
  int a, b;

  print('ingrese valor de a...');
  a = int.parse(stdin.readLineSync()!);
  print('ingrese valor de b...');
  b = int.parse(stdin.readLineSync()!);

  print('Potencia de $a, elevado a la: $b = ${pow(a,b)}');
  print('Raiz de $a = ${sqrt(a).round()}');
  double c = 8.53445533;
  print(c.round());
  print(c.floor());
  print(min(a, b));
  print(max(a, b));

  var aleatorio = Random();
  print(aleatorio.nextInt(100));
  print(aleatorio.nextDouble());

}