-- Dim_Paciente
CREATE TABLE Dim_Paciente (
    DNI_Paciente VARCHAR(20) PRIMARY KEY,
    apellidos_nombre VARCHAR(255),
    fecha_nacimiento DATE,
    num_seguridad_social VARCHAR(20),
    otros_datos TEXT
);

