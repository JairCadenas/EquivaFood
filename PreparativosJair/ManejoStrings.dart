void main(){
  String palabra='Hola';
  String palabra2="a todos";
  String palabra3='O\´Neill';
  String palabra4="Josué";
  String palabra5= "Texto uno\n"
                  "Segunda linea\n"
                  "Tercer linea";

  String palabra6= r"Texto uno\n"
                  "Segunda linea\n"
                  "Tercer linea";
  String palabra7='''asdfghjklñlkjhfdsasdfghjk
  sdfghjklñlkjhgfdssdfghjkllkjhgfd
  sdfghjklkjgfdsdfghjk''';
  //Recomendado para parrafos
  String palabra8='''asdfghjklñlk(jhfdsasdfghjk)
  sd"fghjklñlkjhgfdssdfghjkllk"jhgfd
  sdfghjklkjgfdsdfgúhjk''';
  String palabra9="";
  print('Saludo: $palabra $palabra2');
  print(palabra);
  print(palabra2);
  print(palabra3);
  print(palabra4);
  print(palabra5);
  print(palabra6);
  print(palabra7);
  print(palabra8);
  print(palabra8.length);//Conteo de letras dentro del string
  print("Ejemplo 1 de isEmpty para saber si un string esta basio: ${palabra8.isEmpty}");
  print("Ejemplo 2 de isEmpty para saber si un string esta basio: ${palabra9.isEmpty}");
  print(palabra3[4]); //Busqueda en posicion tal
  print("Ejemplo 1 de uso de contains, busca caracter o palabra dentro de una variable de texto (a) ${palabra.contains("a")}");
  print("Ejemplo 2 de uso de contains, busca caracter o palabra dentro de una variable de texto (Hola) ${palabra.contains("Hola")}");
  print("Ejemplo 3 de uso de contains, busca caracter o palabra dentro de una variable de texto (u) ${palabra.contains("u")}");
  print("Ejemplo de como incia una variable ${palabra3.startsWith("O")}");
  print("Ejemplo de como termina una variable ${palabra3.endsWith("l")}");
  print("Ejmplo de busqueda de palabras en especifico dentro de string (Segunda) ${palabra5.indexOf("Segunda")}");
  print("Ejmplo de chars especificos dentro de string ${palabra5.substring(0,9)}");
  print("Ejmplo de chars o textos especificos dentro de string (a) ${palabra5.split("a")}");
  print("Ejmplo de chars o textos especificos dentro de string (linea) ${palabra5.split("linea")}");
}