CREATE TABLE User (
    id INT PRIMARY KEY AUTO_INCREMENT,
    correo VARCHAR(50) NOT NULL,
    password VARCHAR(20) NO NULL,
    Datos INT NOT NULL
);
CREATE TABLE DatosUser(
    DatosId INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    edad INT NOT NULL,
    peso DOUBLE NOT NULL,
    estatura DOUBLE NOT NULL
);
ALTER TABLE User
add foreing key (Datos) references DatosUser(DatosId);