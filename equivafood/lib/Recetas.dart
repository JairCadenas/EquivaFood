import 'package:flutter/material.dart';

// ── MODELO DE RECETA ──────────────────────────────────────────────────────────
class Receta {
  final String nombre;
  final String tiempoComida;    
  final String tiempo;          
  final String dificultad;      
  final List<String> ingredientes;
  final List<String> pasos;
  final List<String> tags;      
  final IconData icono;

  const Receta({
    required this.nombre,
    required this.tiempoComida,
    required this.tiempo,
    required this.dificultad,
    required this.ingredientes,
    required this.pasos,
    required this.tags,
    required this.icono,
  });
}

// ── BANCO DE MEMORIA DE RECETAS COMPLETO ───────────────────────────────────────
const List<Receta> _recetas = [
  // ── DESAYUNOS ───────────────────────────────────────────────────────────────
  Receta(
    nombre: 'Omelette de claras con champiñones',
    tiempoComida: 'Desayuno', tiempo: '10 min', dificultad: 'Fácil',
    tags: ['huevo'],
    icono: Icons.egg_outlined,
    ingredientes: ['3 claras de huevo', '6 champiñones rebanados', '¼ cebolla', 'Sal y pimienta', '1 cdita aceite de oliva'],
    pasos: [
      'Bate las claras con sal y pimienta hasta que estén espumosas.',
      'Calienta el aceite en sartén antiadherente y acitrona la cebolla con los champiñones.',
      'Vierte las claras sobre los champiñones y cocina a fuego bajo por ambos lados hasta que cuaje.'
    ],
  ),
  Receta(
    nombre: 'Yogurt Griego con 5 almendras',
    tiempoComida: 'Desayuno', tiempo: '2 min', dificultad: 'Fácil',
    tags: ['lacteo', 'nuez'],
    icono: Icons.restaurant,
    ingredientes: ['150g de yogurt griego natural sin azúcar', '5 almendras enteras'],
    pasos: [
      'Sirve el yogurt griego frío en un tazón pequeño.',
      'Espolvorea las 5 almendras por encima de la superficie.',
      'Mezcla ligeramente con una cuchara antes de consumir.'
    ],
  ),
  Receta(
    nombre: '2 Huevos cocidos con espinacas',
    tiempoComida: 'Desayuno', tiempo: '10 min', dificultad: 'Fácil',
    tags: ['huevo'],
    icono: Icons.egg_outlined,
    ingredientes: ['2 huevos enteros', '1 taza de espinacas frescas', 'Sal y pimienta al gusto'],
    pasos: [
      'Coloca los huevos en una olla con agua hirviendo durante 9 minutos. Retira la cáscara y corta por la mitad.',
      'Sancocha las espinacas en una sartén con un toque de agua por 2 minutos.',
      'Sirve los huevos sobre la cama de espinacas y sazona.'
    ],
  ),
  Receta(
    nombre: 'Queso Panela asado (60g) con nopal',
    tiempoComida: 'Desayuno', tiempo: '8 min', dificultad: 'Fácil',
    tags: ['lacteo'],
    icono: Icons.dinner_dining,
    ingredientes: ['60g de queso panela en rebanadas', '1 nopal mediano limpio', 'Sal y orégano'],
    pasos: [
      'Coloca el nopal en un comal caliente hasta que se ase por ambos lados.',
      'Pon las rebanadas de queso panela a dorar ligeramente en el mismo comal.',
      'Sirve el queso sobre el nopal asado y espolvorea un toque de orégano.'
    ],
  ),
  Receta(
    nombre: 'Avena con leche de almendra y fruta',
    tiempoComida: 'Desayuno', tiempo: '8 min', dificultad: 'Fácil',
    tags: ['gluten', 'nuez'],
    icono: Icons.soup_kitchen_outlined, // Corregido para evitar errores de compatibilidad
    ingredientes: ['½ taza de avena en hojuelas', '1 taza de leche de almendras', '½ taza de fruta picada (fresa o plátano)', 'Canela al gusto'],
    pasos: [
      'En una olla pequeña, calienta la leche de almendras junto con la avena y una pizca de canela.',
      'Cocina a fuego medio durante 5 minutos moviendo constantemente hasta que espese.',
      'Sirve en un tazón and decora con la fruta picada fresca encima.'
    ],
  ),
  Receta(
    nombre: 'Tostadas de arroz con aguacate',
    tiempoComida: 'Desayuno', tiempo: '5 min', dificultad: 'Fácil',
    tags: [],
    icono: Icons.breakfast_dining,
    ingredientes: ['2 tostadas de arroz inflado', '½ aguacate maduro', 'Pizca de sal y limón'],
    pasos: [
      'Machaca el aguacate en un tazón chico con unas gotas de limón y sal.',
      'Unta la mezcla equitativamente sobre las dos tostadas de arroz y consume de inmediato.'
    ],
  ),
  Receta(
    nombre: 'Tofu revuelto con espinacas',
    tiempoComida: 'Desayuno', tiempo: '10 min', dificultad: 'Fácil',
    tags: ['soya'],
    icono: Icons.eco_outlined,
    ingredientes: ['150g de tofu firme', '1 taza de espinacas picadas', '¼ de cebolla picada', 'Sal y una pizca de cúrcuma'],
    pasos: [
      'Desmenuza el tofu con las manos o un tenedor hasta que tenga textura de huevo revuelto.',
      'Sofríe la cebolla en una sartén antiadherente e incorpora el tofu con la sal y la cúrcuma para darle color.',
      'Agrega las espinacas frescas y cocina por 3 minutos hasta que se reduzcan.'
    ],
  ),
  Receta(
    nombre: 'Licuado de proteína vegetal con plátano',
    tiempoComida: 'Desayuno', tiempo: '3 min', dificultad: 'Fácil',
    tags: ['soya'],
    icono: Icons.local_cafe_outlined,
    ingredientes: ['1 scoop de proteína vegetal en polvo', '1 plátano maduro', '1 taza de agua o leche vegetal'],
    pasos: [
      'Coloca todos los ingredientes en la licuadora junto con hielos si lo deseas.',
      'Licúa a velocidad alta por 1 minuto hasta que quede cremoso y sirve.'
    ],
  ),
  Receta(
    nombre: 'Chilaquiles con salsa verde (sin queso)',
    tiempoComida: 'Desayuno', tiempo: '15 min', dificultad: 'Media',
    tags: ['gluten'],
    icono: Icons.restaurant_menu,
    ingredientes: ['2 tortillas de maíz horneadas en tótopos', '½ taza de salsa verde casera templada', 'Pollo deshebrado opcional'],
    pasos: [
      'Coloca los tótopos horneados en un plato hondo.',
      'Baña con la salsa verde caliente de manera uniforme.',
      'Acompaña con pollo deshebrado encima si tu plan lo permite.'
    ],
  ),
  Receta(
    nombre: 'Hotcakes de avena con miel',
    tiempoComida: 'Desayuno', tiempo: '12 min', dificultad: 'Fácil',
    tags: ['gluten', 'huevo', 'lacteo'],
    icono: Icons.cake_outlined,
    ingredientes: ['½ taza de avena licuada', '1 huevo entero', '¼ taza de leche light', '1 cdita de miel natural'],
    pasos: [
      'Mezcla la avena, el huevo y la leche en la licuadora hasta tener una masa tersa.',
      'Vierte porciones en una sartén antiadherente caliente formando círculos.',
      'Voltea cuando salgan burbujas en la superficie y sirve con un hilo de miel.'
    ],
  ),

  // ── COLACIONES ──────────────────────────────────────────────────────────────
  Receta(
    nombre: '10 mitades de nuez',
    tiempoComida: 'Colación', tiempo: '1 min', dificultad: 'Fácil',
    tags: ['nuez'],
    icono: Icons.eco_outlined,
    ingredientes: ['10 mitades de nuez pecana limpia'],
    pasos: ['Sirve las porciones en un recipiente pequeño y consúmelas de manera directa como snack.'],
  ),
  Receta(
    nombre: '1 Taza de Jícama con limón',
    tiempoComida: 'Colación', tiempo: '5 min', dificultad: 'Fácil',
    tags: [],
    icono: Icons.restaurant_menu,
    ingredientes: ['1 taza de jícama picada en cubos o bastones', 'Jugo de 1 limón', 'Sal al gusto'],
    pasos: ['Coloca la jícama picada en un tazón, agrega el jugo de limón, sal y revuelve bien.'],
  ),
  Receta(
    nombre: '1 Pera pequeña',
    tiempoComida: 'Colación', tiempo: '1 min', dificultad: 'Fácil',
    tags: [],
    icono: Icons.apple,
    ingredientes: ['1 pieza de pera pequeña fresca'],
    pasos: ['Lava perfectamente la fruta con abundante agua y consúmela fresca entera o en gajos.'],
  ),
  Receta(
    nombre: '1 Gelatina light',
    tiempoComida: 'Colación', tiempo: '1 min', dificultad: 'Fácil',
    tags: [],
    icono: Icons.layers_outlined,
    ingredientes: ['1 porción de gelatina baja en calorías'],
    pasos: ['Desmolda la gelatina fría del refrigerador y consume directamente con una cuchara.'],
  ),
  Receta(
    nombre: 'Pepino con chile y limón',
    tiempoComida: 'Colación', tiempo: '4 min', dificultad: 'Fácil',
    tags: [],
    icono: Icons.eco_outlined,
    ingredientes: ['1 pepino mediano en rodajas', 'Jugo de 1 limón', 'Chile en polvo sin azúcar'],
    pasos: ['Lava y pela el pepino, córtalo en rodajas, colócalo en un plato y sazona con limón y chile.'],
  ),
  Receta(
    nombre: 'Edamame (1/2 taza)',
    tiempoComida: 'Colación', tiempo: '6 min', dificultad: 'Fácil',
    tags: ['soya'],
    icono: Icons.grain, // Corregido: Removido el carácter extraño
    ingredientes: ['½ taza de edamames en vaina', 'Agua para hervir', 'Pizca de sal gruesa'],
    pasos: [
      'Hierve las vainas de edamame en agua con sal durante 4 o 5 minutos.',
      'Escurre el agua, espolvorea sal gruesa encima y consume solo los frijoles internos presionando las vainas.'
    ],
  ),
  Receta(
    nombre: 'Zanahoria con hummus',
    tiempoComida: 'Colación', tiempo: '5 min', dificultad: 'Fácil',
    tags: [],
    icono: Icons.restaurant,
    ingredientes: ['1 zanahoria mediana en bastones', '2 cucharadas de hummus de garbanzo'],
    pasos: ['Lava y corta la zanahoria en tiras delgadas. Sírvelas en un plato plano junto con el hummus para dipear.'],
  ),
  Receta(
    nombre: '1 Manzana con mantequilla de maní',
    tiempoComida: 'Colación', tiempo: '3 min', dificultad: 'Fácil',
    tags: ['nuez'],
    icono: Icons.star_border,
    ingredientes: ['1 manzana en gajos', '1 cucharada de mantequilla de maní pura'],
    pasos: ['Corta la manzana limpia en rodajas y úntales una porción controlada de mantequilla de maní.'],
  ),
  Receta(
    nombre: 'Galletas de arroz con aguacate',
    tiempoComida: 'Colación', tiempo: '3 min', dificultad: 'Fácil',
    tags: [],
    icono: Icons.circle_notifications_outlined,
    ingredientes: ['2 galletas de arroz inflado', '¼ de aguacate machacado', 'Sal'],
    pasos: ['Unta el aguacate sobre las galletas de arroz y añade una pizca de sal.'],
  ),
  Receta(
    nombre: 'Mix de semillas (girasol, chía)',
    tiempoComida: 'Colación', tiempo: '1 min', dificultad: 'Fácil',
    tags: [],
    icono: Icons.grain,
    ingredientes: ['1 cucharada de semillas de girasol', '1 cucharadita de semillas de chía'],
    pasos: ['Mezcla ambas semillas en un contenedor pequeño para consumirlas juntas como snack crocante.'],
  ),

  // ── COMIDAS ─────────────────────────────────────────────────────────────────
  Receta(
    nombre: 'Filete de Pescado (120g) al vapor',
    tiempoComida: 'Comida', tiempo: '15 min', dificultad: 'Fácil',
    tags: ['pescado'],
    icono: Icons.set_meal_outlined,
    ingredientes: ['120g de filete de pescado blanco', 'Sal, pimienta y finas hierbas'],
    pasos: [
      'Sazona el filete de pescado con sal, pimienta y finas hierbas.',
      'Envuélvelo en papel aluminio sellando herméticamente los extremos.',
      'Cocina en una sartén a fuego medio durante 10 a 12 minutos hasta que esté tierno.'
    ],
  ),
  Receta(
    nombre: 'Carne de res magra (100g) asada',
    tiempoComida: 'Comida', tiempo: '12 min', dificultad: 'Fácil',
    tags: ['carne'],
    icono: Icons.restaurant,
    ingredientes: ['100g de bistec de res magro', 'Pizca de sal y ajo en polvo'],
    pasos: [
      'Sazona la carne con la sal y el ajo en polvo por ambas caras.',
      'Calienta una plancha o sartén antiadherente a fuego alto y asar 3-4 minutos por lado.'
    ],
  ),
  Receta(
    nombre: 'Tacos de pechuga de pavo (3 pzas)',
    tiempoComida: 'Comida', tiempo: '8 min', dificultad: 'Fácil',
    tags: ['carne', 'gluten'],
    icono: Icons.restaurant,
    ingredientes: ['90g de pechuga de pavo asada', '3 tortillas de maíz', 'Salsa casera'],
    pasos: [
      'Calienta las 3 tortillas de maíz en un comal.',
      'Distribuye la pechuga de pavo cortada en tiras dentro de las tortillas.',
      'Acompaña con salsa picante al gusto.'
    ],
  ),
  Receta(
    nombre: 'Salmón a la plancha con espárragos',
    tiempoComida: 'Comida', tiempo: '15 min', dificultad: 'Media',
    tags: ['pescado'],
    icono: Icons.set_meal,
    ingredientes: ['120g de filete de salmón', '5 espárragos limpios', '1 cdita de aceite de oliva', 'Sal'],
    pasos: [
      'Sazona el salmón con sal y pimienta.',
      'Cocina el salmón en una sartén con el aceite de oliva a fuego medio 4 min por el lado de la piel y 3 min del otro.',
      'En la misma sartén, saltea los espárragos hasta que estén crujientes.'
    ],
  ),
  Receta(
    nombre: 'Lentejas guisadas con verduras',
    tiempoComida: 'Comida', tiempo: '25 min', dificultad: 'Media',
    tags: [],
    icono: Icons.soup_kitchen_outlined,
    ingredientes: ['1 taza de lentejas cocidas', '½ taza de jitomate y cebolla en cubos', '1 taza de caldo de verduras'],
    pasos: [
      'En una olla pequeña, sofríe el jitomate y la cebolla con unas gotas de agua.',
      'Vierte las lentejas cocidas y el caldo de verduras.',
      'Deja hervir a fuego bajo durante 10 minutos para sazonar y sirve caliente.'
    ],
  ),
  Receta(
    nombre: 'Fajitas de tofu con pimientos',
    tiempoComida: 'Comida', tiempo: '12 min', dificultad: 'Fácil',
    tags: ['soya'],
    icono: Icons.restaurant,
    ingredientes: ['150g de tofu firme en tiras', '½ pimiento verde en tiras', '½ pimiento rojo en tiras', '¼ cebolla'],
    pasos: [
      'Dora las tiras de tofu en una sartén antiadherente caliente hasta que cambien de color y retira.',
      'En la misma sartén saltea los pimientos y la cebolla por 5 minutos.',
      'Reincorpora el tofu, sazona con sal y salsa de soya baja en sodio, mezcla y sirve.'
    ],
  ),
  Receta(
    nombre: 'Sopa de garbanzo con espinacas',
    tiempoComida: 'Comida', tiempo: '15 min', dificultad: 'Fácil',
    tags: [],
    icono: Icons.soup_kitchen_outlined,
    ingredientes: ['1 taza de garbanzos cocidos', '1 taza de espinacas frescas picadas', '1 taza de puré de tomate natural'],
    pasos: [
      'Pon a calentar el puré de tomate natural en una olla pequeña.',
      'Agrega los garbanzos e integra las espinacas frescas.',
      'Cocina por 5 minutos a fuego medio hasta que las espinacas se suavicen.'
    ],
  ),
  Receta(
    nombre: 'Pechuga de pollo a la plancha (120g)',
    tiempoComida: 'Comida', tiempo: '15 min', dificultad: 'Fácil',
    tags: ['carne'],
    icono: Icons.restaurant,
    ingredientes: ['120g de pechuga de pollo fileteada', 'Sal, pimienta y ajo en polvo'],
    pasos: [
      'Sazona el pollo uniformemente.',
      'Cocina en una sartén caliente sin aceite de 5 a 6 minutos por lado hasta que dore.'
    ],
  ),
  Receta(
    nombre: 'Atún en agua con ensalada (120g)',
    tiempoComida: 'Comida', tiempo: '5 min', dificultad: 'Fácil',
    tags: ['pescado'],
    icono: Icons.dinner_dining,
    ingredientes: ['1 lata de atún en agua (120g)', '1 taza de lechuga picada', '½ jitomate en cubos'],
    pasos: [
      'Drena por completo el agua de la lata de atún.',
      'Mezcla el atún con la lechuga y el jitomate en un tazón hondo y sazona con limón y sal.'
    ],
  ),
  Receta(
    nombre: 'Hamburguesa de frijol negro',
    tiempoComida: 'Comida', tiempo: '15 min', dificultad: 'Media',
    tags: ['gluten'],
    icono: Icons.dinner_dining,
    ingredientes: ['1 medallón de frijol negro preparado', '1 pan integral para hamburguesa', 'Hojas de lechuga y jitomate'],
    pasos: [
      'Dora el medallón de frijol negro en una sartén caliente por 3 minutos de cada lado.',
      'Calienta ligeramente las tapas de pan integral.',
      'Arma la hamburguesa colocando el medallón, la lechuga y las rodajas de jitomate.'
    ],
  ),
  Receta(
    nombre: 'Camarones salteados con verduras',
    tiempoComida: 'Comida', tiempo: '10 min', dificultad: 'Fácil',
    tags: ['pescado'],
    icono: Icons.set_meal_outlined,
    ingredientes: ['120g de camarones limpios', '1 taza de calabacita y brócoli picados', '1 cdita de aceite'],
    pasos: [
      'Calienta el aceite en la sartén y saltea las verduras por 4 minutos.',
      'Agrega los camarones y cocina de 3 a 4 minutos adicionales hasta que cambien a color rosa. Sazona.'
    ],
  ),
  Receta(
    nombre: 'Tempeh al ajillo con brócoli',
    tiempoComida: 'Comida', tiempo: '12 min', dificultad: 'Fácil',
    tags: ['soya'],
    icono: Icons.eco_outlined,
    ingredientes: ['120g de tempeh en cubos', '1 taza de floretes de brócoli', '1 diente de ajo laminado'],
    pasos: [
      'Sofríe el ajo laminado en una sartén antiadherente cuidando que no se queme.',
      'Añade el tempeh y el brócoli, cocina tapado por 7 minutos moviendo ocasionalmente.'
    ],
  ),

  // ── CENAS ────────────────────────────────────────────────────────────────────
  Receta(
    nombre: 'Sándwich de pan integral con pavo',
    tiempoComida: 'Cena', tiempo: '5 min', dificultad: 'Fácil',
    tags: ['carne', 'gluten'],
    icono: Icons.layers_outlined,
    ingredientes: ['2 rebanadas de pan integral', '2 rebanadas de jamón de pechuga de pavo', 'Lechuga y jitomate'],
    pasos: [
      'Coloca las rebanadas de pavo, la lechuga y el jitomate sobre una tapa de pan.',
      'Cierra el sándwich con la otra tapa y sirve.'
    ],
  ),
  Receta(
    nombre: 'Quesadilla con tortilla de maíz (1 pza)',
    tiempoComida: 'Cena', tiempo: '4 min', dificultad: 'Fácil',
    tags: ['lacteo'],
    icono: Icons.dinner_dining,
    ingredientes: ['1 tortilla de maíz', '30g de queso panela oaxaca rallado'],
    pasos: [
      'Coloca el queso dentro de la tortilla de maíz doblada a la mitad.',
      'Put la quesadilla en un comal a fuego bajo, volteándola hasta que el queso se derrita.'
    ],
  ),
  Receta(
    nombre: 'Taza de cereal de fibra con leche light',
    tiempoComida: 'Cena', tiempo: '2 min', dificultad: 'Fácil',
    tags: ['gluten', 'lacteo'],
    icono: Icons.dinner_dining,
    ingredientes: ['1 taza de cereal integral alto en fibra', '1 taza de leche descremada o light'],
    pasos: ['Sirve el cereal en un plato hondo y baña con la taza de leche light fría.'],
  ),
  Receta(
    nombre: 'Rollitos de jamón con queso cottage',
    tiempoComida: 'Cena', tiempo: '4 min', dificultad: 'Fácil',
    tags: ['carne', 'lacteo'],
    icono: Icons.reorder_outlined,
    ingredientes: ['3 rebanadas de jamón de pavo', '60g de queso cottage bajo en grasa'],
    pasos: [
      'Extiende las rebanadas de jamón sobre un plato plano.',
      'Coloca una cucharada de queso cottage en un extremo de cada rebanada y enrolla firmemente.'
    ],
  ),
  Receta(
    nombre: 'Sopa de verduras con tofu',
    tiempoComida: 'Cena', tiempo: '15 min', dificultad: 'Fácil',
    tags: ['soya'],
    icono: Icons.soup_kitchen_outlined,
    ingredientes: ['1 taza de caldo de verduras natural', '½ taza de verduras mixtas en cubos', '100g de tofu firme en cubos'],
    pasos: [
      'Calienta el caldo de verduras en una olla hasta que hierva.',
      'Agrega las verduras mixtas y el tofu en cubos.',
      'Cocina a fuego medio durante 8 minutos y sirve caliente.'
    ],
  ),
  Receta(
    nombre: 'Wrap vegetal con hummus y espinacas',
    tiempoComida: 'Cena', tiempo: '5 min', dificultad: 'Fácil',
    tags: ['gluten'],
    icono: Icons.restaurant, // Corregido: Reemplazado por un icono nativo compatible
    ingredientes: ['1 tortilla de harina integral grande', '2 cucharadas de hummus', '1 taza de espinacas frescas'],
    pasos: [
      'Unta las dos cucharadas de hummus de manera uniforme sobre la tortilla integral.',
      'Coloca las espinacas limpias en el centro, dobla los extremos hacia adentro y enrolla.'
    ],
  ),
  Receta(
    nombre: 'Crema de elote light',
    tiempoComida: 'Cena', tiempo: '10 min', dificultad: 'Fácil',
    tags: [],
    icono: Icons.soup_kitchen_outlined,
    ingredientes: ['1 taza de granos de elote natural', '½ taza de leche descremada', 'Sal y pimienta'],
    pasos: [
      'Licúa los granos de elote con la leche light y una pizca de sal hasta disolver.',
      'Calienta la mezcla en una olla a fuego bajo por 5 minutos moviendo para evitar que se pegue.'
    ],
  ),
  Receta(
    nombre: 'Tostadas de frijol con nopal asado',
    tiempoComida: 'Cena', tiempo: '10 min', dificultad: 'Fácil',
    tags: [],
    icono: Icons.dinner_dining,
    ingredientes: ['2 tostadas de maíz horneadas crujientes', '½ taza de frijoles de la olla machacados', '1 nopal asado'],
    pasos: [
      'Unta los frijoles calientes sobre las dos tostadas horneadas.',
      'Corta el nopal asado en tiras y colócalo encima de las tostadas con salsa al gusto.'
    ],
  ),
  Receta(
    nombre: 'Ensalada de garbanzos con pepino',
    tiempoComida: 'Cena', tiempo: '6 min', dificultad: 'Fácil',
    tags: [],
    icono: Icons.eco_outlined,
    ingredientes: ['½ taza de garbanzos cocidos', '1 taza de pepino picado en cubos', 'Sal y limón'],
    pasos: ['Combina los garbanzos y el pepino fresco en un recipiente, añade jugo de limón y revuelve bien.'],
  ),
  Receta(
    nombre: 'Tortilla de maíz con aguacate y jitomate',
    tiempoComida: 'Cena', tiempo: '5 min', dificultad: 'Fácil',
    tags: [],
    icono: Icons.restaurant_menu,
    ingredientes: ['2 tortillas de maíz', '¼ de aguacate', '½ jitomate en rodajas'],
    pasos: [
      'Calienta las tortillas en un comal.',
      'Unta el aguacate en las tortillas calientes, pon las rodajas de jitomate encima y dobla.'
    ],
  ),
];

// CORREGIDO: Función global limpia sin guion bajo inicial para evitar conflictos del compilador
String convertirAnalisisDeGramos(String ingrediente) {
  final text = ingrediente.toLowerCase().trim();

  if (text.contains('1 taza de espinacas')) return '$ingrediente (aprox. 30g)';
  if (text.contains('1 taza de jícama')) return '$ingrediente (aprox. 120g)';
  if (text.contains('½ taza de avena')) return '$ingrediente (aprox. 40g)';
  if (text.contains('1 taza de leche')) return '$ingrediente (aprox. 240g o ml)';
  if (text.contains('½ taza de fruta')) return '$ingrediente (aprox. 80g)';
  if (text.contains('½ taza de edamames')) return '$ingrediente (aprox. 50g)';
  if (text.contains('1 taza de pepino')) return '$ingrediente (aprox. 150g)';
  if (text.contains('1 taza de granos de elote')) return '$ingrediente (aprox. 160g)';
  if (text.contains('1 taza de lentejas')) return '$ingrediente (aprox. 200g)';
  if (text.contains('1 taza de garbanzos')) return '$ingrediente (aprox. 170g)';
  if (text.contains('1 taza de lechuga')) return '$ingrediente (aprox. 50g)';
  
  if (text.contains('1 cucharada de mantequilla')) return '$ingrediente (aprox. 16g)';
  if (text.contains('2 cucharadas de hummus')) return '$ingrediente (aprox. 30g)';
  if (text.contains('1 cdita aceite')) return '$ingrediente (aprox. 5g)';
  
  if (text.contains('1 scoop')) return '$ingrediente (aprox. 30g)';
  if (text.contains('1 plátano maduro')) return '$ingrediente (aprox. 120g)';
  if (text.contains('½ aguacate')) return '$ingrediente (aprox. 50g)';
  if (text.contains('¼ de aguacate') || text.contains('¼ aguacate')) return '$ingrediente (aprox. 25g)';
  if (text.contains('1 manzana med')) return '$ingrediente (aprox. 150g)';
  if (text.contains('1 pieza de pera')) return '$ingrediente (aprox. 140g)';
  if (text.contains('1 nopal med')) return '$ingrediente (aprox. 80g)';
  if (text.contains('½ jitomate')) return '$ingrediente (aprox. 60g)';

  return ingrediente;
}

// ══════════════════════════════════════════════════════════════════════════════
// VISTA FILTRADA INDIVIDUAL — CORREGIDA
// ══════════════════════════════════════════════════════════════════════════════
class RecetasScreen extends StatelessWidget {
  final String? alimentoOrigen;
  final List<String> restricciones;
  final bool preferenciaCarne;

  // CORREGIDO: Removido el 'const' problemático debido a los elementos variables del cuerpo
  const RecetasScreen({
    super.key,
    required this.alimentoOrigen,
    required this.restricciones,
    required this.preferenciaCarne,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF33D1C1);

    Receta? recetaEncontrada;
    try {
      recetaEncontrada = _recetas.firstWhere(
        (r) => r.nombre.toLowerCase().trim().contains(alimentoOrigen!.toLowerCase().trim()) || 
               alimentoOrigen!.toLowerCase().trim().contains(r.nombre.toLowerCase().trim()),
      );
    } catch (_) {
      recetaEncontrada = null; 
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Receta del Menú',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: recetaEncontrada == null
          ? _buildRecetaAutomatica(alimentoOrigen ?? 'Alimento alternativo', primaryColor)
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: Colors.black.withOpacity(0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.07),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: primaryColor,
                            child: Icon(recetaEncontrada.icono, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recetaEncontrada.nombre,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 13, color: primaryColor),
                                    const SizedBox(width: 4),
                                    Text(recetaEncontrada.tiempo, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                                    const SizedBox(width: 12),
                                    const Icon(Icons.bar_chart, size: 13, color: primaryColor),
                                    const SizedBox(width: 4),
                                    Text(recetaEncontrada.dificultad, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // CORREGIDO: Removido 'const' de la columna raíz para habilitar llamadas dinámicas
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Ingredientes', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 14)),
                          const SizedBox(height: 8),
                          ...recetaEncontrada.ingredientes.map((ing) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2.5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('• ', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Expanded(
                                      child: Text(
                                        convertirAnalisisDeGramos(ing), // Invocación segura de gramos
                                        style: const TextStyle(fontSize: 13, color: Colors.black87),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          const SizedBox(height: 20),
                          const Text('Preparación', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 14)),
                          const SizedBox(height: 10),
                          ...recetaEncontrada.pasos.asMap().entries.map((e) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 9,
                                      backgroundColor: primaryColor.withOpacity(0.12),
                                      child: Text('${e.key + 1}',
                                          style: const TextStyle(fontSize: 10, color: primaryColor, fontWeight: FontWeight.bold)),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(child: Text(e.value, style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.3))),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildRecetaAutomatica(String nombreAlimento, Color primaryColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black.withOpacity(0.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              color: Colors.orange.withOpacity(0.06),
              child: Row(
                children: [
                  const CircleAvatar(backgroundColor: Colors.orange, child: Icon(Icons.bolt, color: Colors.white)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(nombreAlimento, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Text('Guía rápida generada por la app', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ingredientes Sugeridos', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text('• 1 porción controlada de: $nombreAlimento', style: const TextStyle(fontSize: 13)),
                  const Text('• Condimentos libres (sal, pimienta, limón al gusto)', style: TextStyle(fontSize: 13)),
                  const SizedBox(height: 20),
                  const Text('Instrucciones básicas', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 14)),
                  const SizedBox(height: 8),
                  const Text('1. Desinfecta e higieniza tus insumos y manos antes de iniciar.', style: TextStyle(fontSize: 13)),
                  const Text('2. Pesa la cantidad indicada en tu plan original para mantener las equivalencias.', style: TextStyle(fontSize: 13)),
                  const Text('3. Cocina a la plancha o al vapor evitando el exceso de aceites añadidos.', style: TextStyle(fontSize: 13)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}