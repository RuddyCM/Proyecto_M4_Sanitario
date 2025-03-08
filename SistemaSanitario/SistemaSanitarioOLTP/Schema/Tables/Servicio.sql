CREATE TABLE Servicios.Servicio 
(
    idServicio VARCHAR(10) CONSTRAINT PK_Servicio PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT NULL,
    rowversion timestamp not null,
);