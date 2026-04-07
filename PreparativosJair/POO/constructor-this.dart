//Ejemplo de constructor
/*class Persona{
  String? nombre;
  int? edad;
  Persona(){
    nombre='Josué';
  }
  void DimeNombre(){
    nombre='Ana';
  }
}
void main(){
  Persona objeto1=Persona();
  objeto1.nombre='Jair';
  objeto1.DimeNombre();
}*/
//Ejempplo this
class Persona{
  String? nombre;
  int? edad;
  String? v_nombre;
  int? v_edad;
  Persona(String nombre, int edad){
    this.nombre=nombre;
    this.edad=edad;
    v_nombre=nombre;
    v_edad=edad;
  }
}
void main(){
  Persona objeto1=Persona('Jair', 25);
  print(objeto1.nombre);
  print(objeto1.edad);
  print(objeto1.v_nombre);
  print(objeto1.v_edad);
}