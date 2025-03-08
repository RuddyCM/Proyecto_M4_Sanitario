-- Tabla Dim_Hospital
CREATE TABLE Dim_Hospital (
    HospitalSK INT IDENTITY(1,1) PRIMARY KEY,
    codHospital INT UNIQUE NOT NULL,
    nombre NVARCHAR(255),
    ciudad NVARCHAR(255),
    telefono VARCHAR(50),
    director NVARCHAR(255),
    numero_total_camas INT
);