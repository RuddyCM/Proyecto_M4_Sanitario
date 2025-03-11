-- Tabla Dim_Tiempo con TiempoSK como IDENTITY
CREATE TABLE Dim_Tiempo (
    TiempoSK INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_DimTiempo PRIMARY KEY,
    fecha DATE UNIQUE NOT NULL,
    anio INT NOT NULL,
    trimestre INT NOT NULL,
    mes INT NOT NULL,
    dia INT NOT NULL,
    semana INT NOT NULL,
    dia_mes INT NOT NULL
);
