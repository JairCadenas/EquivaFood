class Persona{
  String? nombre;
  int? edad;

  Persona(String nombre, int edad){ //método constructor
    this.nombre = nombre;
    this.edad = edad;
  }


}
void main(){
  Persona objeto1 = Persona('José', 60);
  print(objeto1.nombre);
  print(objeto1.edad);
}