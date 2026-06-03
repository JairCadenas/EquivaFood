-- BASE DE DATOS: EQUIVAFOOD
-- DESCRIPCIÓN: Estructura limpia y optimizada de la base de datos en Supabase.
--              Contiene únicamente las tablas esenciales para usuarios y seguridad.
-- 1. TABLA DE USUARIOS
-- Guarda la información del perfil físico, credenciales y preferencias de cada usuario.
CREATE TABLE Usuario (
    id_usuario      SERIAL PRIMARY KEY,                  -- Identificador único autoincremental para cada usuario
    nombre          VARCHAR(60) NOT NULL,                -- Nombre completo del usuario (máximo 60 caracteres)
    edad            INT NOT NULL,                        -- Edad del usuario en años enteros
    peso            DOUBLE PRECISION NOT NULL,           -- Peso del usuario en kilogramos (permite decimales)
    estatura        DOUBLE PRECISION NOT NULL,           -- Estatura del usuario en metros/centímetros (permite decimales)
    correo          VARCHAR(100) NOT NULL UNIQUE,        -- Correo electrónico único (llave para inicio de sesión)
    password        VARCHAR(20) NOT NULL,                -- Contraseña de acceso (máximo 20 caracteres)
    plan_pdf_url    VARCHAR(255),                        -- URL pública del PDF de su dieta guardado en el Storage
    avatar_url      VARCHAR(255),                        -- URL pública de la foto de perfil guardada en el Storage
    restricciones   TEXT[],                              -- Arreglo/Lista de textos con las alergias del usuario (Ej: ['nuez', 'lacteo'])
    preferencia     BOOLEAN DEFAULT TRUE                 -- Preferencia alimentaria: TRUE (Carnívoro/Omnívoro) o FALSE (Vegetariano)
);
-- 2. TABLA DE CÓDIGOS DE RECUPERACIÓN
-- Almacena temporalmente los tokens de seguridad de 6 dígitos enviados por correo 
-- para verificar la identidad antes de cambiar una contraseña olvidada.
CREATE TABLE CodigoRecuperacion (
    id              SERIAL PRIMARY KEY,                  -- Identificador único autoincremental de la operación
    correo          VARCHAR(100) NOT NULL,               -- Correo del usuario que solicitó recuperar su contraseña
    codigo          VARCHAR(6) NOT NULL,                 -- Código numérico de 6 dígitos enviado por el sistema de correos
    creado_en       TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha y hora exacta en la que se generó el código
    expira_en       TIMESTAMP NOT NULL                   -- Fecha y hora límite en la que el código dejará de ser válido (expiración)
);