-- Tabla Dim_Servicio
CREATE TABLE Dim_Servicio (
    ServicioSK INT IDENTITY(1,1) PRIMARY KEY,
    idServicio VARCHAR(10) UNIQUE NOT NULL,
    nombre_servicio NVARCHAR(255)
);
