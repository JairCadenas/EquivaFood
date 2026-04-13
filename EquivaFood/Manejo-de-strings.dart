void main(){
  String palabra = 'Hola';
  String palabra2 = 'A TODOS';
  String palabra3 = 'O\'Neill';
  String palabra4 = "texto en linea1\n"
      "segunda linea del texto\n"
      "tercera linea";

    String palabra5 = '''estoy aprendiendo a trabajar
    con Flutter pero primero hago las bases
    con Dart''';
    String palabra6 = '';

  /*print('Saludo: $palabra $palabra2');
  print(palabra2);
  print(palabra3);
  print(palabra4);
  print(palabra5);*/

  print(palabra5.length);
  print(palabra6.isEmpty);
  print(palabra6.isNotEmpty);
  print(palabra2[4]);
  print(palabra.contains('mesa'));
  print(palabra3.startsWith('O'));
  print(palabra3.endsWith('l'));
  print(palabra5.indexOf('hago'));
  print(palabra4.substring(0,8));
  print(palabra4.split('segunda'));
  print(palabra.toUpperCase());
  print(palabra2.toLowerCase());
}