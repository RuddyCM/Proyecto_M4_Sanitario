-- Tabla Dim_Medico
CREATE TABLE Dim_Medico (
    MedicoSK INT IDENTITY(1,1) PRIMARY KEY,
    DNI_Medico VARCHAR(20) UNIQUE NOT NULL,
    apellidos_nombre NVARCHAR(255),
    fecha_nacimiento DATE,
    codHospital INT,
    direccion_hospital NVARCHAR(255),
    es_director BIT
);