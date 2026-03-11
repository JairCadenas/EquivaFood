void main(){
  String nombre, apellido, nombreCompleto;
  int edad, salario;
  nombre = 'Tomas';
  apellido = 'Gonzales';
  edad = 50;
  salario = 60000;
  nombreCompleto = '$nombre $apellido';

  print('Nombre completo: ' + nombre + ' ' + apellido);
  print('Edad: ${edad} salario: ${salario}');
  print(nombreCompleto);
}