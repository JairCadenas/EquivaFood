CREATE TABLE Usuario (
    id_usuario      SERIAL PRIMARY KEY,
    nombre          VARCHAR(60)  NOT NULL,
    edad            INT          NOT NULL,
    peso            DOUBLE PRECISION NOT NULL,
    estatura        DOUBLE PRECISION NOT NULL,
    correo          VARCHAR(100) NOT NULL UNIQUE,
    password        VARCHAR(20)  NOT NULL,
    planAlimentario VARCHAR(255) NOT NULL
);

CREATE TABLE Plan_Alimenticio (
    id_plan      SERIAL PRIMARY KEY,
    id_usuario   INT          NOT NULL,
    nombre_plan  VARCHAR(100) NOT NULL,
    descripcion  TEXT         NOT NULL,
    fecha_inicio DATE         NOT NULL,
    fecha_fin    DATE         NOT NULL
);

CREATE TABLE Alimento (
    id_alimento    SERIAL PRIMARY KEY,
    nombre         VARCHAR(100) NOT NULL,
    calorias       INT          NOT NULL,
    proteinas      DOUBLE PRECISION NOT NULL,
    grasas         DOUBLE PRECISION NOT NULL,
    carbohidratos  DOUBLE PRECISION NOT NULL
);

CREATE TABLE Cantidad (
    id_plan      INT,
    id_alimento  INT,
    cantidad     VARCHAR(50),
    PRIMARY KEY (id_plan, id_alimento)
);

CREATE TABLE Equivalencia (
    id_equivalencia         SERIAL PRIMARY KEY,
    id_alimento_base        INT,
    id_alimento_equivalente INT,
    descripcion             TEXT
);

CREATE TABLE RestriccionAlimenticia (
    id_restriccion SERIAL PRIMARY KEY,
    id_usuario     INT          NOT NULL,
    alergia        VARCHAR(100) NOT NULL,
    intolerancia   VARCHAR(50)  NOT NULL,
    preferencia    VARCHAR(50)  NOT NULL
);

CREATE TABLE Recetario (
    id_receta   SERIAL PRIMARY KEY,
    nombre      VARCHAR(100),
    mes         VARCHAR(10)  NOT NULL,
    descripcion VARCHAR(255) NOT NULL
);

CREATE TABLE CodigoRecuperacion (
    id        SERIAL PRIMARY KEY,
    correo    VARCHAR(100) NOT NULL UNIQUE,
    codigo    VARCHAR(6)   NOT NULL,
    expira_en TIMESTAMP    NOT NULL
);

-- Los índices en Postgres se crean fuera del CREATE TABLE
CREATE INDEX idx_correo ON CodigoRecuperacion(correo);

-- Foreign Keys
ALTER TABLE Plan_Alimenticio
    ADD CONSTRAINT fk_plan_usuario
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario);

ALTER TABLE Cantidad
    ADD CONSTRAINT fk_cantidad_plan
    FOREIGN KEY (id_plan) REFERENCES Plan_Alimenticio(id_plan);

ALTER TABLE Cantidad
    ADD CONSTRAINT fk_cantidad_alimento
    FOREIGN KEY (id_alimento) REFERENCES Alimento(id_alimento);

ALTER TABLE Equivalencia
    ADD CONSTRAINT fk_equiv_base
    FOREIGN KEY (id_alimento_base) REFERENCES Alimento(id_alimento);

ALTER TABLE Equivalencia
    ADD CONSTRAINT fk_equiv_equivalente
    FOREIGN KEY (id_alimento_equivalente) REFERENCES Alimento(id_alimento);

ALTER TABLE RestriccionAlimenticia
    ADD CONSTRAINT fk_restriccion_usuario
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario);