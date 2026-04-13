void main(){
  DateTime ahora = DateTime.now();
  print(ahora);
  print('Año: ${ahora.year}');
  print('Mes: ${ahora.month}');
  print('Día: ${ahora.day}');
  print('Hora: ${ahora.hour}');
  print('Minutos: ${ahora.minute}');
  print('Segundos: ${ahora.second}');
  print('===========================\n');

  print(ahora.add(Duration(days: 10))); //le agrega 10 días más a la fecha actual
  print(ahora.subtract(Duration(days: 8))); //reduce cierta cantidad de días
  print('===========================\n');

  DateTime fechaIngreso = DateTime(2025,1,17);
   DateTime fechaCancelacion = DateTime(2025,9,17);
   print(fechaIngreso.isBefore(fechaCancelacion)); //comprueba si la fecha de ingreso es antes de la de cancelacion
   print(fechaIngreso.isAfter(fechaCancelacion));
   print(fechaIngreso.isAtSameMomentAs(fechaCancelacion));

  //fecha especifica
  DateTime cumple = DateTime(2004,4,30);
  print(cumple);
}