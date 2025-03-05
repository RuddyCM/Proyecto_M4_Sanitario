-- Dim_Medico
CREATE TABLE Dim_Medico (
    DNI_Medico VARCHAR(20) PRIMARY KEY,
    apellidos_nombre VARCHAR(255),
    fecha_nacimiento DATE,
    codHospital VARCHAR(20),
    direccion_hospital TEXT,
    es_director bit
);