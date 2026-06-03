# Correcciones Necesarias del Repositorio EquivaFood

Documento que detalla los problemas identificados en el repositorio y su orden de prioridad para resolución.

---

### 3.2 Reorganizar Estructura de Carpetas

**Descripción del Problema:**
- Todos los archivos están en la carpeta `lib/` sin categorización
- No existe separación clara entre pantallas, servicios, modelos y utilidades
- Dificulta el mantenimiento y escalabilidad del proyecto

**Estructura Recomendada:**
```
lib/
├── main.dart
├── screens/
│   |
│   ├── registro_screen.dart (renombrado de Registro.dart)
│   ├── recuperar_contrasena_screen.dart
│   ├── codigo_verificacion_screen.dart
│   ├── cambio_contrasena_screen.dart
│   └── pantalla_principal_screen.dart
├── services/
│   └── api_service.dart
├── models/
│   └── (modelos de datos si existen)
└── utils/
    └── (utilidades comunes si existen)
```

**Acciones Requeridas:**

1. Crear estructura de carpetas
2. Mover y renombrar archivos según la nueva estructura
3. Actualizar todas las importaciones
4. Hacer commit

---

## Prioridad 4: Baja (Documentación y Mantenimiento)

### 4.1 Crear README.md Completo

**Descripción del Problema:**
- El README.md está vacío
- No hay documentación sobre cómo configurar y ejecutar el proyecto
- Falta información para nuevos colaboradores

**Contenido Recomendado:**

```markdown
# EquivaFood

Descripción breve del proyecto.

## Requisitos Previos

- Flutter SDK 3.10.7+
- Dart 3.10.7+
- Git

## Instalación

1. Clonar el repositorio:
   ```bash
   git clone [URL del repositorio]
   ```

2. Navegar al directorio del proyecto:
   ```bash
   cd EquivaFood/equivafood
   ```

3. Instalar dependencias:
   ```bash
   flutter pub get
   ```

4. Configurar variables de entorno:
   - Copiar `assets/.env.example` a `assets/.env`
   - Completar con las credenciales de Supabase y SMTP

5. Ejecutar la aplicación:
   ```bash
   flutter run
   ```

## Estructura del Proyecto

- `lib/screens/` - Pantallas de la aplicación
- `lib/services/` - Servicios y lógica de negocio
- `lib/models/` - Modelos de datos
- `lib/utils/` - Utilidades comunes

## Tecnologías Utilizadas

- Flutter
- Dart
- Supabase
- Flutter Dotenv

## Contribución

[Especificar pautas de contribución]

## Licencia

[Especificar licencia]
```

## 4.2 Documentar Estructura de Base de Datos

**Descripción del Problema:**
- No hay documentación sobre la estructura de las tablas en Supabase
- Dificulta el entendimiento del proyecto para colaboradores

**Acciones Requeridas:**

1. Crear archivo `ARQUITECTURA_BD.md` o similar
2. Documentar estructura de tablas, relaciones y campos
3. Incluir diagrama si es posible

---