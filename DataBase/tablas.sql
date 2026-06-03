-- 1. TABLA DE USUARIOS
CREATE TABLE Usuario (
    id_usuario      SERIAL PRIMARY KEY,
    nombre          VARCHAR(60) NOT NULL,
    edad            INT NOT NULL,
    peso            DOUBLE PRECISION NOT NULL,
    estatura        DOUBLE PRECISION NOT NULL,
    correo          VARCHAR(100) NOT NULL UNIQUE,
    password        VARCHAR(20) NOT NULL,
    plan_pdf_url    VARCHAR(255),       
    avatar_url      VARCHAR(255),       
    restricciones   TEXT[],
    preferencia     BOOLEAN DEFAULT TRUE 
);

-- 2. TABLA DE CÓDIGOS DE RECUPERACIÓN
CREATE TABLE CodigoRecuperacion (
    id              SERIAL PRIMARY KEY,
    correo          VARCHAR(100) NOT NULL,
    codigo          VARCHAR(6) NOT NULL,
    creado_en       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expira_en       TIMESTAMP NOT NULL
);