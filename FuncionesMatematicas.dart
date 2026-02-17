import 'dart:io';
import 'dart:math';

void main(){
  int a,b;
  double c=8.75213;
  print("Ingresa el valor de a: ");
  a=int.parse(stdin.readLineSync()!);
  print("Ingresa el valor de b: ");
  b=int.parse(stdin.readLineSync()!);
  print("Potencia de $a, elevado a la $b es: $b=${pow(a, b)}");
  print("La raiz de $a es: $a=${sqrt(a)}");
  print("Ejemplo de uso de round te lleva al proximo antero pasando del .5: ${c.round()}");
  print("Ejemplo de uso de floor te lleva al antero mas cercano sin importar que pase del .5: ${c.floor()}");
  print(min(a, b));
  print(max(a, b));
  var aleatorio=Random();
  print(aleatorio.nextInt(100));
  print(aleatorio.nextDouble());
}