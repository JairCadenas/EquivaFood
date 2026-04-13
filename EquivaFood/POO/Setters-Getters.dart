import 'dart:io';
class Auto{
  String? marca, modelo;
  int? anio;

  //getter
  //String get DimeMarca => marca ?? 'No definida';
  String DimeDatos(){
    return '''Marca: $marca 
    Modelo: $modelo
    Año: $anio''';
  }

  //setter
  /*set LaMarca(String valor){
    if (valor.isNotEmpty){
      marca = valor;
    }else{
      print('La marca no debe estar vacía');
    }
  }
}*/

void PideDatos(){
  print('Dime marca del vehículo...');
  marca = stdin.readLineSync()!;
  print('Dime modelo del vehículo...');
  modelo = stdin.readLineSync()!;
  print('Dime año del vehículo...');
  anio = int.parse(stdin.readLineSync()!);
  }
}

void main(){
  Auto auto1 = Auto();
  auto1.PideDatos();
  print(auto1.DimeDatos());
  
}