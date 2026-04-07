class Animal{
  String? nombre,raza;
  int? tamanio;
  Animal(this.nombre, this.raza, this.tamanio);
  void DameDatos(){
    print('Nombre: $nombre, Raza: $raza, Tamaño: $tamanio');
    print('$nombre esta comiendo');
  }
}
class Perro extends Animal{
  Perro(String nombre, String raza, int tamanio)
  :super(nombre,raza,tamanio);
  void DameDatos(){
    print('Nombre: $nombre, Raza: $raza, Tamaño: $tamanio');
    print('$nombre esta comiendo');
  }
}
void main(){
  Animal objeto1=Animal('Mufasa', 'Angora', 50);
  objeto1.DameDatos();
  Perro objeto2=Perro('Zeus', 'Pastor Aleman', 150);
  objeto2.DameDatos();
}