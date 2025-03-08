CREATE TABLE Dim_Paciente (
    PacienteSK INT IDENTITY(1,1) PRIMARY KEY,
    DNI_Paciente VARCHAR(20) UNIQUE NOT NULL,
    apellidos_nombre NVARCHAR(255),
    fecha_nacimiento DATE,
    num_seguridad_social VARCHAR(50),
    otros_datos TEXT
);
