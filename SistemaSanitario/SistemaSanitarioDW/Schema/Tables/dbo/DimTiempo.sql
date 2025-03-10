-- Tabla Dim_Tiempo
CREATE TABLE Dim_Tiempo (
    TiempoSK INT IDENTITY(1,1) PRIMARY KEY,
    fecha DATE UNIQUE NOT NULL,
    anio INT,
    trimestre INT,
    mes INT,
    dia INT,
    semana INT,
    dia_mes INT
);