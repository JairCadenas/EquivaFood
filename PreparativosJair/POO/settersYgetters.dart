import 'dart:io';

class Auto{
    String? marca,modelo;
    int? anio;
    //void Datos(){}
    /*Ejemplo 1
    //getter
    String get DimeMarca => marca ?? "No fue definida";
    //setter
    set LaMarca(String valor){
        if(valor.isNotEmpty){
            marca=valor;
        }else{
            print("No se a registrado la marca");
        }
    }
    */
    /*Ejemplo 2*/
    //getter
    String DimeDatos(){
        return '''Marca: $marca
        Modelo: $modelo
        Año: $anio''';
    }
    //setter
    void PideDatos(){
        print("Dime marca: ");
        marca=stdin.readLineSync()!;
        print("Dime modelo: ");
        modelo=stdin.readLineSync()!;
        print("Dime año: ");
        anio=int.parse(stdin.readLineSync()!);
    }
}
void main(){
    Auto auto1 =Auto();
    auto1.PideDatos();
    print(auto1.DimeDatos());
    Auto auto2 =Auto();
    auto2.PideDatos();
    print(auto2.DimeDatos());
}