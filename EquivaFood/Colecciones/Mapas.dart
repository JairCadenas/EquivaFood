void main(){
  Map<String, String> capitales = {
    'España' : 'Madrid',
    'Colombia' : 'Bogotá',
    'Perú' : 'Lima',
    'México' : 'Ciudad de México'
  };

  Map<String, int> usuarios = {
    'usuario01' : 3216584,
    'usuario02' : 3838383,
    'usuario03' : 3993939,
  };

  /*print(capitales);
  print(capitales['México']);

  capitales['Rep. Dominicana'] = 'Santo Domingo';
  print(capitales);

  capitales['Perú'] = 'valor no encontrado';
  print(capitales);*/

  print(capitales.keys);
  print(capitales.values);
  print(capitales.length);
  print(capitales.isEmpty);
  print(capitales.containsKey('Perú'));
  print(capitales.containsValue('Ciudad de México'));
  capitales.clear();
  print(capitales);
}