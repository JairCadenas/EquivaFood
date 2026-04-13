class Persona{
  String? nombre, apellido;
  int? edad;

   void DimeDatos(){
    print('Nombre: $nombre $apellido '
          'Edad: $edad');
   }
}
class Animal{
  String? nombre, raza;
  double? tamanio;
  bool? desparacitado, vacunado;

  void DimeDatos(){
    print('''Nombre: $nombre
    Raza: $raza
    Tamaño: $tamanio cm
    Desparacitado: $desparacitado
    Vacunado: $vacunado''');
  }
}
//Un método se puede llamar igual pero solo en distintas clases

void main(){
  Persona persona1 = Persona();
  Persona persona2 = Persona();
  persona1.nombre = 'José';
  persona1.apellido = 'Feliciano';
  persona1.edad = 50;
  persona1.DimeDatos();
  persona2.nombre = 'Ana';
  persona2.apellido = 'Contreras';
  persona2.edad = 20;
  persona2.DimeDatos();

  Animal perro1 = Animal();
  perro1.nombre = 'Firulais';
  perro1.raza = 'Chiwawa';
  perro1.tamanio = 25.5;
  perro1.vacunado = true;
  perro1.desparacitado = true;
  perro1.DimeDatos();
}