int valor1 = 50, valor2 = 30;

int sumar(){
  return valor1 + valor2;
}
String DimeNombre(){
  return 'informaticonfig';
}

//Una función no tiene que pertenecer forzosamente a una clase
//El método siempre debe de pertener a una clase
//Para invocar las funciones siempre se debe de hacer desde el main

void main(){
  print(sumar());
  print(DimeNombre());
}