class Persona{
  String? nombre,apellido;
  int? edad;
  void DimeDatos(){
    print('Nombre: $nombre');
  }
}
class Animal{
  String? nombre, raza;
  double? tamanio;
  bool? desparasitario, vacunado;
  void DimeDatos(){
    print('''Nombre: $nombre
    Raza: $raza
    Tamaño: $tamanio
    Desparasitado: $desparasitario
    Vacunado: $vacunado''');
  }
}
void main(){
  Persona persona1 = Persona();
  persona1.nombre ="Josue";
  persona1.apellido="Castillo";
  persona1.edad=25;
  Persona persona2 = Persona();
  persona2.nombre ="Jair";
  persona2.apellido="Cadenas";
  persona2.edad=25;
  persona1.DimeDatos();
  persona2.DimeDatos();
  Animal perro1=Animal();
  perro1.nombre="Zeus";
  perro1.raza="Pastor Aleman";
  perro1.tamanio=42.3;
  perro1.vacunado=true;
  perro1.desparasitario=true;
  Animal perro2=Animal();
  perro2.nombre="Kitty";
  perro2.raza="RotWallers";
  perro2.tamanio=23.4;
  perro2.vacunado=true;
  perro2.desparasitario=true;
  perro1.DimeDatos();
  perro2.DimeDatos();
}