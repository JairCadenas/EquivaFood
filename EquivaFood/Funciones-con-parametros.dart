int Sumar(int a, int b, int c){
  return a + b + c;
}
void DimeNombre(String nombre){
  print('Nombre: $nombre');
}

//void no es necesario que retorne algo, por eso se usa print
void main(){
  print(Sumar(80, 3, 200));
  DimeNombre('Informaticonfig');
}