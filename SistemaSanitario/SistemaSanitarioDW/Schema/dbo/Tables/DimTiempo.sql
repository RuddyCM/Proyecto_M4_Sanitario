CREATE TABLE Dim_Tiempo (
    idFecha INT PRIMARY KEY,
    fecha DATE,
    año INT,
    trimestre INT,
    mes INT,
    día INT,
    semana INT,
    día_mes INT,
    nombre_mes VARCHAR(20)
);