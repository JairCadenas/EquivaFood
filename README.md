# 🍽️ EquivaFood

<div align="center">

**Una aplicación móvil innovadora para gestionar equivalencias de alimentos y mejorar tu alimentación**

![Dart](https://img.shields.io/badge/Dart-75.5%25-blue?logo=dart)
![Flutter](https://img.shields.io/badge/Flutter-3.10.7-02569B?logo=flutter)
![C++](https://img.shields.io/badge/C++-12.5%25-00599C?logo=c%2B%2B)
![License](https://img.shields.io/badge/License-MIT-green)
![Status](https://img.shields.io/badge/Status-En%20Desarrollo-yellow)

[Características](#-características) • [Instalación](#-instalación) • [Uso](#-uso) • [Contribuir](#-contribuir)

</div>

---

## 📱 Descripción del Proyecto

**EquivaFood** es un proyecto final desarrollado con **Flutter** que facilita a los usuarios gestionar y comprender las equivalencias nutricionales entre diferentes alimentos. La aplicación proporciona una herramienta intuitiva para:

- 🔍 **Consultar equivalencias de alimentos** - Descubre alternativas nutricionales similares
- 📊 **Acceder a datos nutricionales** - Información detallada de cada alimento
- 💾 **Sincronizar datos en nube** - Respaldos seguros en Supabase
- 📱 **Experiencia multiplataforma** - Funciona en iOS y Android de manera fluida
- 🎯 **Tomar decisiones alimenticias informadas** - Base de datos completa de alimentos

Este proyecto combina tecnologías modernas de desarrollo móvil con una arquitectura robusta para garantizar rendimiento y escalabilidad.

---

## ✨ Características Principales

### 🔐 Autenticación y Seguridad
- Sistema de registro e login con Supabase
- Autenticación segura con variables de entorno
- Tokens JWT para sesiones persistentes

### 📚 Base de Datos de Alimentos
- Consulta extensiva de alimentos y sus propiedades
- Información nutricional completa (calorías, proteínas, grasas, carbohidratos)
- Sistema de búsqueda avanzada y filtrado
- Equivalencias entre alimentos similares

### 🖼️ Gestión Multimedia
- Captura de imágenes con la cámara del dispositivo
- Carga de fotos desde la galería
- Almacenamiento en Supabase Storage

### 💾 Datos Inteligentes
- Almacenamiento local con SharedPreferences para caché
- Sincronización automática en la nube
- Funcionalidad offline cuando es posible

### 📧 Notificaciones
- Sistema de alertas por email vía Mailer
- Confirmaciones de acciones importantes
- Recordatorios personalizados

### 🎨 Interfaz de Usuario
- Diseño Material moderno
- Interfaz responsiva para múltiples tamaños
- Animaciones suaves y transiciones fluidas
- Temas personalizables (light/dark mode ready)

---

## 🛠️ Stack Tecnológico

| Componente | Tecnología | Porcentaje |
|-----------|-----------|-----------|
| **Lenguaje Principal** | Dart | 75.5% |
| **Framework Móvil** | Flutter 3.10.7 | - |
| **Backend/BaaS** | Supabase | - |
| **Nativo iOS** | Swift | 1.1% |
| **Nativo Android** | C++ (JNI) | 12.5% |
| **Build System** | CMake | 9.5% |
| **Almacenamiento Local** | SharedPreferences | - |
| **Email** | Mailer | - |

### Dependencias Clave

```yaml
# Backend y Autenticación
supabase_flutter: ^2.12.4       # Backend y base de datos
supabase: ^2.2.0                # Cliente de Supabase

# Multimedia
image_picker: ^1.2.1            # Selección de imágenes
file_picker: ^11.0.2            # Selector de archivos

# Almacenamiento Local
shared_preferences: ^2.5.5      # Caché local

# Email
mailer: ^7.1.0                  # Envío de correos

# Configuración
flutter_dotenv: ^6.0.1          # Variables de entorno

# UI/UX
material_design_icons: ^0.0.1   # Iconos Material
```

---

## 📋 Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:

### Software Requerido
- **Flutter** 3.10.7 o superior
  - [Guía de instalación oficial](https://flutter.dev/docs/get-started/install)
- **Dart** (incluido con Flutter)
- **Git** para versionamiento
- **XCode** (macOS, para desarrollo iOS)
- **Android Studio** (para desarrollo Android)

### Verificar Instalación

```bash
# Verificar versiones instaladas
flutter --version
dart --version
flutter doctor  # Verifica requisitos del sistema
```

---

## 📦 Instalación y Configuración

### 1. Clonar el Repositorio

```bash
git clone https://github.com/JairCadenas/EquivaFood.git
cd EquivaFood
```

### 2. Navegar al Proyecto Flutter

```bash
cd equivafood
```

### 3. Instalar Dependencias

```bash
flutter pub get
```

### 4. Configuración de Variables de Entorno

Crea un archivo `.env` en la raíz del directorio `equivafood/`:

```env
# Supabase Configuration
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_anon_key_here
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here

# Email Configuration (Mailer)
EMAIL_USER=your-email@gmail.com
EMAIL_PASSWORD=your_app_password
```

### 5. Configurar Supabase

1. Crear una cuenta en [Supabase](https://supabase.com)
2. Crear un nuevo proyecto
3. Obtener las credenciales desde el panel de control
4. Configurar las tablas necesarias:
   - `users` - Información de usuarios
   - `foods` - Catálogo de alimentos
   - `equivalencies` - Equivalencias entre alimentos
5. Configurar políticas de seguridad (Row Level Security)

### 6. Configurar Iconos (Opcional)

```bash
flutter pub run flutter_launcher_icons:main
```

---

## 🚀 Uso de la Aplicación

### Ejecutar en Emulador/Dispositivo

```bash
# Listar dispositivos disponibles
flutter devices

# Ejecutar en dispositivo por defecto (modo debug)
flutter run

# Ejecutar en dispositivo específico
flutter run -d <device_id>

# Ejecutar con logs detallados
flutter run -v
```

### Modos de Ejecución

```bash
# Modo Debug (con hot reload)
flutter run

# Modo Release (optimizado)
flutter run --release

# Modo Profile (análisis de rendimiento)
flutter run --profile
```

### Compilar para Producción

```bash
# Compilar APK para Android
flutter build apk --release

# Compilar Bundle para Google Play
flutter build appbundle --release

# Compilar para iOS
flutter build ios --release

# Compilar para Web (si está habilitado)
flutter build web --release
```

---

## 📁 Estructura del Proyecto

```
equivafood/
│
├── lib/
│   ├── main.dart                 # Punto de entrada de la app
│   ├── screens/                  # Pantallas principales
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── home_screen.dart
│   │   ├── foods_screen.dart
│   │   └── profile_screen.dart
│   ├── widgets/                  # Componentes reutilizables
│   │   ├── food_card.dart
│   │   ├── nav_bar.dart
│   │   └── custom_button.dart
│   ├── models/                   # Modelos de datos
│   │   ├── food.dart
│   │   ├── user.dart
│   │   └── equivalency.dart
│   ├── services/                 # Servicios y lógica
│   │   ├── supabase_service.dart
│   │   ├── auth_service.dart
│   │   ├── image_service.dart
│   │   └── email_service.dart
│   ├── utils/                    # Utilidades y constantes
│   │   ├── constants.dart
│   │   ├── colors.dart
│   │   └── validators.dart
│   └── providers/                # State management (si aplica)
│
├── assets/                       # Recursos
│   ├── images/
│   ├── icons/
│   ├── ICONO.png
│   └── fonts/
│
├── android/                      # Configuración Android
│   ├── app/
│   └── build.gradle
│
├── ios/                          # Configuración iOS
│   ├── Runner/
│   └── Podfile
│
├── web/                          # Configuración Web (opcional)
│
├── test/                         # Tests unitarios
│
├── pubspec.yaml                  # Definición de dependencias
├── .env.example                  # Ejemplo de variables de entorno
├── .gitignore                    # Archivos ignorados
└── README.md                     # Documentación de la app
```

---

## 🏗️ Arquitectura de la Aplicación

### Flujo de Autenticación
```
Login Screen → Supabase Auth → JWT Token → Home Screen
                                  ↓
                            SharedPreferences (Cache)
```

### Flujo de Datos
```
Supabase Database → Supabase Client → Services → State Management → UI
                         ↓
                  Local Cache (SharedPreferences)
```

---

## 🔐 Seguridad

- Variables de entorno para credenciales
- Archivo `.env` en `.gitignore`
- JWT tokens para autenticación
- Row Level Security (RLS) en Supabase
- Validación de datos en cliente y servidor

---

## 🧪 Testing

Para ejecutar tests unitarios:

```bash
flutter test

# Con cobertura
flutter test --coverage
```

---

## 🤝 Contribuir

Las contribuciones son bienvenidas. Para colaborar:

### Pasos para Contribuir

1. **Fork** el repositorio
   ```bash
   git clone https://github.com/JairCadenas/EquivaFood.git
   ```

2. Crea una rama para tu feature
   ```bash
   git checkout -b feature/NuevaCaracteristica
   ```

3. Realiza tus cambios y haz commits descriptivos
   ```bash
   git commit -m "feat: agregar nueva característica X"
   git commit -m "fix: corregir bug en pantalla Y"
   ```

4. Push a tu rama
   ```bash
   git push origin feature/NuevaCaracteristica
   ```

5. Abre un **Pull Request** con descripción clara

### Convenciones de Código

- **Dart Style Guide**: Sigue las [convenciones oficiales de Dart](https://dart.dev/guides/language/effective-dart)
- **Nombres descriptivos**: Variables y funciones con nombres claros
- **Documentación**: Documenta funciones públicas
- **Widgets pequeños**: Mantén widgets reutilizables y modulares
- **Sin hardcoding**: Usa constantes y variables de entorno

### Tipos de Commits
- `feat:` - Nueva característica
- `fix:` - Correción de bugs
- `docs:` - Cambios en documentación
- `style:` - Cambios de formato
- `refactor:` - Refactorización de código
- `test:` - Adición de tests

---

## 📊 Estado del Proyecto

- ✅ Setup inicial completado
- ✅ Autenticación con Supabase integrada
- ✅ Base de datos de alimentos configurada
- ⏳ Pantallas principales en desarrollo
- ⏳ Sistema de equivalencias en progreso
- ⏳ Tests unitarios pendientes

---

## 🐛 Reportar Bugs

Si encuentras un problema, por favor:

1. Verifica que no haya un issue similar abierto
2. Abre un nuevo [Issue](https://github.com/JairCadenas/EquivaFood/issues)
3. Incluye:
   - Descripción clara del problema
   - Pasos exactos para reproducir
   - Comportamiento esperado vs actual
   - Screenshots o logs relevantes
   - Información del dispositivo/SO

**Formato sugerido:**
```markdown
## Descripción
[Descripción clara del bug]

## Pasos para Reproducir
1. Paso 1
2. Paso 2
3. Paso 3

## Comportamiento Esperado
[Lo que debería suceder]

## Comportamiento Actual
[Lo que sucede]

## Screenshots
[Adjuntar si aplica]

## Ambiente
- Dispositivo: [ej: iPhone 14]
- SO: [ej: iOS 16.5]
- Versión de Flutter: [ej: 3.10.7]
```

---

## 📚 Documentación y Recursos

- [Documentación de Flutter](https://docs.flutter.dev/)
- [Documentación de Dart](https://dart.dev/guides)
- [Documentación de Supabase](https://supabase.com/docs)
- [Flutter Best Practices](https://flutter.dev/docs/testing/best-practices)
- [Material Design Guidelines](https://material.io/design)

---

## 📞 Soporte

- **Issues**: Usa GitHub Issues para reportar problemas
- **Discussions**: Para preguntas y discusiones generales
- **Pull Requests**: Para contribuciones y mejoras

---

## 📄 Licencia

Este proyecto está bajo la **Licencia MIT**. 

Para más detalles, consulta el archivo [LICENSE](LICENSE).

```
MIT License

Copyright (c) 2024 Jair Cadenas

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction...
```

---

## 👤 Autor y Contacto

**Jair Cadenas** - Desarrollador Full Stack

- 🔗 GitHub: [@JairCadenas](https://github.com/JairCadenas)
- 📧 Email: [cadenasjair0818@gmail.com]

**Tania Chávez** - Desarrollador Full Stack

- 🔗 GitHub: [@taniachavezv](https://github.com/JairCadenas)
- 📧 Email: [taniachavezv11@gmail.com]

---

## 🙏 Agradecimientos

- Flutter y Dart team por las excelentes herramientas
- Supabase por la infraestructura backend
- Comunidad de Flutter por el apoyo
- Todos los contribuyentes del proyecto

---

## 🔄 Versiones

### v1.0.0 (Proyecto Final)
- Autenticación inicial
- Base de datos de alimentos
- Interfaz básica
- Integración con Supabase

Ver [CHANGELOG.md](CHANGELOG.md) para más detalles.

---

<div align="center">

**Hecho con ❤️ por [Jair Cadenas y Tania Chávez](https://github.com/JairCadenas)**

⭐ Si te gusta el proyecto, ¡no olvides dejar una estrella!

[⬆ Volver al inicio](#-equivafood)

</div>
