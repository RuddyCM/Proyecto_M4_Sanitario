-- Tabla Dim_Servicio
CREATE TABLE Dim_Servicio (
    ServicioSK INT IDENTITY(1,1) PRIMARY KEY,
    idServicio VARCHAR(10)  NOT NULL,
    nombre_servicio VARCHAR(255)
);
