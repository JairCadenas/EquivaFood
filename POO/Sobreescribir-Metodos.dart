class Vehiculo{
  void combustible(){
    print('Combustible genérico del vehículo');
  }

}

class Carro extends Vehiculo{
  @override
  void combustible(){
    print('Gasolina');
  }
}

class Moto extends Vehiculo{
  @override
  void combustible(){
  print('Eléctrica');
  }
}

void main(){
  var vehiculo1 = Vehiculo();
  vehiculo1.combustible();
  var vehiculo2 = Carro();
  vehiculo2.combustible();
  var vehiculo3 = Moto();
  vehiculo3.combustible();
}