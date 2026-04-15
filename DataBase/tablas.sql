CREATE TABLE Usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    edad INT NOT NULL,
    peso DOUBLE NOT NULL,
    estatura DOUBLE NOT NULL,
    correo VARCHAR(100) NOT NULL,
    password VARCHAR(20) NOT NULL,
    planAlimentario VARCHAR(255) NOT NULL 
);

CREATE TABLE Plan_Alimenticio (
    id_plan INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    nombre_plan VARCHAR(100) NOT NULL,
    descripcion TEXT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL
);

CREATE TABLE Alimento (
    id_alimento INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    calorias INT NOT NULL,
    proteinas DOUBLE NOT NULL,
    grasas DOUBLE NOT NULL,
    carbohidratos DOUBLE NOT NULL
);

CREATE TABLE Cantidad (
    id_plan INT,
    id_alimento INT,
    cantidad VARCHAR(50),
    PRIMARY KEY (id_plan, id_alimento)
);

CREATE TABLE Equivalencia(
    id_equivalencia INT AUTO_INCREMENT PRIMARY KEY,
    id_alimento_base INT,
    id_alimento_equivalente INT,
    descripcion TEXT
);

CREATE TABLE RestriccionAlimenticia (
    id_restriccion INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    alergia VARCHAR(100) NOT NULL,
    intolerancia VARCHAR(50) NOT NULL,
    preferencia VARCHAR(50) NOT NULL
);

CREATE TABLE Recetario (
    id_receta INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    mes VARCHAR(10) NOT NULL,
    descripcion VARCHAR(255) NOT NULL
);

ALTER TABLE Plan_Alimenticio
ADD FOREIGN KEY (id_usuario)
REFERENCES Usuario(id_usuario);

ALTER TABLE Cantidad
ADD FOREIGN KEY (id_plan)
REFERENCES Plan_Alimenticio(id_plan);

ALTER TABLE Cantidad
ADD FOREIGN KEY (id_alimento)
REFERENCES Alimento(id_alimento);

ALTER TABLE Equivalencia
ADD FOREIGN KEY (id_alimento_base)
REFERENCES Alimento(id_alimento);

ALTER TABLE Equivalencia
ADD FOREIGN KEY (id_alimento_equivalente)
REFERENCES Alimento(id_alimento);

ALTER TABLE RestriccionAlimenticia
ADD FOREIGN KEY (id_usuario)
REFERENCES Usuario(id_usuario);

