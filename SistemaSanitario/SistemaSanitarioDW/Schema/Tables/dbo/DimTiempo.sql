-- Tabla Dim_Tiempo con TiempoSK como IDENTITY
CREATE TABLE Dim_Tiempo (
    TiempoSK INT NOT NULL CONSTRAINT PK_DimTiempo PRIMARY KEY,
    fecha DATE  NULL,
    anio INT NULL,
    trimestre INT NULL,
    mes INT NULL,
    dia INT NULL,
    semana INT NULL,
    dia_mes INT NULL
);
GO