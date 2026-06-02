# Correcciones Necesarias del Repositorio EquivaFood

Documento que detalla los problemas identificados en el repositorio y su orden de prioridad para resolución.

---

## Prioridad 1: Crítica (Seguridad)

### 1.1 Credenciales Expuestas en el Repositorio

**Descripción del Problema:**
- El archivo `equivafood/assets/.env` contiene credenciales sensibles (claves de Supabase y contraseñas SMTP)
- Este archivo está bajo control de versión de Git
- No está excluido en el archivo `.gitignore`
- Las credenciales existen en el historial de commits (commit 8cc6b73)

**Riesgos Asociados:**
- Acceso no autorizado a la base de datos Supabase
- Posibilidad de envío de correos fraudulentos desde la cuenta SMTP
- Compromiso de datos de usuarios de la aplicación
- Violación de estándares de seguridad

**Acciones Requeridas:**

1. Rotar inmediatamente todas las credenciales comprometidas en Supabase y el servicio de correo
2. ✓ Crear un archivo `.env.example` con nombres de variables sin valores
3. ✓ Añadir exclusiones al archivo `equivafood/.gitignore`
4. ✓ Eliminar el archivo `equivafood/assets/.env` del repositorio
5. Limpiar el historial de git para eliminar referencias al archivo
6. Documentar en el README.md las instrucciones para configurar variables de entorno localmente
7. Implementar validación en `main.dart` para verificar que las variables de entorno existen antes de iniciar la aplicación

**Tiempo Estimado:** 1-2 horas (incluyendo rotación de credenciales)

---

## Prioridad 2: Alta (Organización y Limpieza)

### 2.1 Eliminar Carpetas de Práctica y Preparativos

**Descripción del Problema:**
- Directorio `Preparativos Tania/` contiene 43 archivos de Dart de práctica
- Directorio `PreparativosJair/` contiene 43 archivos de Dart de práctica
- Estos archivos generan ruido en el repositorio y no son parte de la aplicación
- Ocupan espacio innecesario en el historial de versiones

**Acciones Requeridas:**

1. Hacer backup local de estas carpetas si es necesario
2. Remover del repositorio:
   ```bash
   git rm -r "Preparativos Tania"
   git rm -r PreparativosJair
   git commit -m "Remove: archivos de preparativos y práctica"
   ```
3. Actualizar `.gitignore` en la raíz del proyecto para prevenir futuras carpetas de este tipo:
   ```
   Preparativos*/
   Practicas*/
   ```

### 2.2 Remover Proyectos Flutter Duplicados

**Descripción del Problema:**
- Existen dos carpetas de proyecto Flutter: `equivafood/` y `fluttelogin/`
- `fluttelogin/` solo contiene un archivo `main.dart` y aparentemente está abandonado
- Esto genera confusión sobre cuál es el proyecto activo

**Acciones Requeridas:**

1. Confirmar que `equivafood/` es el proyecto principal activo
2. Remover `fluttelogin/`:
   ```bash
   git rm -r fluttelogin
   git commit -m "Remove: proyecto Flutter duplicado (fluttelogin)"
   ```

### 2.3 Limpiar Archivos Sueltos en la Raíz

**Descripción del Problema:**
- Archivos de imagen generados por IA: `Gemini_Generated_Image_*.png`
- Configuración de IDE: `DSI32.code-workspace` y carpeta `.idea/`
- README.md vacío

**Acciones Requeridas:**

1. Remover imágenes generadas de prueba:
   ```bash
   git rm "Gemini_Generated_Image_w1nkuiw1nkuiw1nk-removebg-preview.png"
   git rm "Gemini_Generated_Image_w1nkuiw1nkuiw1nk.png"
   git commit -m "Remove: imágenes de prueba generadas"
   ```

2. Remover archivo de workspace:
   ```bash
   git rm DSI32.code-workspace
   git commit -m "Remove: archivo de configuración de workspace"
   ```

3. Actualizar `.gitignore` en la raíz:
   ```
   .idea/
   *.code-workspace
   .vscode/
   ```

4. Crear un README.md adecuado (ver Prioridad 3)

### 2.4 Organizar Base de Datos

**Descripción del Problema:**
- Carpeta `DataBase/` contiene archivos SQL sueltos
- No hay documentación clara sobre estructura de base de datos

**Acciones Requeridas:**

1. Revisar contenido de `DataBase/tablas.sql`
2. Documentar la estructura de base de datos en el README.md o crear wiki
3. Considerar si estos scripts deben estar en la raíz del proyecto o en documentación

---

## Prioridad 3: Media (Convenciones de Código)

### 3.1 Renombrar Archivos a snake_case

**Descripción del Problema:**
- Los archivos Dart utilizan PascalCase en lugar de la convención Dart (snake_case)
- Violación de las guías de estilo oficiales de Dart
- Archivos afectados:
  - `CambioContrasena.dart` → `cambio_contrasena.dart`
  - `CodigoVerificacion.dart` → `codigo_verificacion.dart`
  - `RecuperarContrasena.dart` → `recuperar_contrasena.dart`
  - `PantallaPrincipal.dart` → `pantalla_principal.dart`
  - `Registro.dart` → `registro.dart`
  - `api_service.dart` (esto ya está correcto)

**Impacto:**
- Mejora la consistencia con estándares de Dart
- Facilita mantenimiento futuro
- Requiere actualizar todas las importaciones en archivos que usen estos módulos

**Acciones Requeridas:**

1. Renombrar archivos en `equivafood/lib/`:
   ```bash
   git mv equivafood/lib/CambioContrasena.dart equivafood/lib/cambio_contrasena.dart
   git mv equivafood/lib/CodigoVerificacion.dart equivafood/lib/codigo_verificacion.dart
   git mv equivafood/lib/RecuperarContrasena.dart equivafood/lib/recuperar_contrasena.dart
   git mv equivafood/lib/PantallaPrincipal.dart equivafood/lib/pantalla_principal.dart
   git mv equivafood/lib/Registro.dart equivafood/lib/registro.dart
   ```

2. Actualizar importaciones en `main.dart` y otros archivos:
   ```dart
   // Cambiar de:
   import 'Registro.dart';
   import 'RecuperarContrasena.dart';
   import 'PantallaPrincipal.dart';
   
   // A:
   import 'registro.dart';
   import 'recuperar_contrasena.dart';
   import 'pantalla_principal.dart';
   ```

3. Hacer commit:
   ```bash
   git commit -m "Refactor: renombrar archivos a convención snake_case"
   ```

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
│   ├── login_screen.dart (renombrado de main.dart - LoginScreen)
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