-- Tabla Dim_Hospital
CREATE TABLE Dim_Hospital (
    HospitalSK INT IDENTITY(1,1) PRIMARY KEY,
    codHospital INT NOT NULL,
    nombre VARCHAR(255),
    ciudad VARCHAR(255),
    telefono VARCHAR(50),
    director VARCHAR(255),
    numero_total_camas INT
);