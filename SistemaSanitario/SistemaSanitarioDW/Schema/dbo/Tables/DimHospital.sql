-- Dim_Hospital
CREATE TABLE Dim_Hospital (
    codHospital VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(255),
    ciudad VARCHAR(255),
    telefono VARCHAR(20),
    director VARCHAR(20),
    numero_total_camas INT
);