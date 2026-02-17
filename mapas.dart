void main(){
  Map<String,String>capitales={
    "España":"Madrid",
    "Columbia":"Bogota",
    "Peru":"Lima",
    "México":"Ciudad de México"
  };
  Map<String,int>usuario={
    "Usuairio1":292685,
    "Usuairio2":292755,
    "Usuairio3":297425,
    "Usuairio4":298596
  };
  print(capitales);
  print(capitales["México"]);
  capitales["Rep. Dominicana"]="Santo Domingo";
  print(capitales);
  capitales["Peru"]="No existe este elemento";
  print(capitales);
  print("-----------------");
  print(capitales.keys);
  print(capitales.values);
  print(capitales.length);
  print(capitales.isEmpty);
  print(capitales.containsKey("México"));
  print(capitales.containsValue("Bogota"));
  capitales.clear();
  print(capitales);
}