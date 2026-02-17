void main(){
  //Lista de valores enteros
  List<int>numeros=[1,2,21,570,008];
  //Lista de strings
  List<String>frutas=["manzana","pera","uva"];
  List<String>vacia=[];
  print(numeros);
  print(frutas);
  frutas.add("Naranjas");
  print(frutas);
  //Listas de tamaño fijo
  var elementos=List<int>.filled(5,0);
  print(elementos);
  var elementos2=List<String >.filled(5,"bla");
  print(elementos2);
  //Multiples add
  numeros.addAll([87,85,56,86,742,45,52]);
  print(numeros);
  //busqueda en lugar especifico
  print(frutas[3]);
  //ingreso de un nuevo elemento en luegar especifico
  frutas.insert(1, "sandias");
  print(frutas);
  //eleminiar elementos
  frutas.remove("sandia");
  print(frutas);
  //eliminacion por indice
  frutas.removeAt(0);
  print(frutas);
  //limpiar lista
  frutas.clear();
  print(frutas);
}