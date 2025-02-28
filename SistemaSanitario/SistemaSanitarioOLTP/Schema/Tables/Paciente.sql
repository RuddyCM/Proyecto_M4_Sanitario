CREATE TABLE Pacientes.Paciente (
    DNI_Paciente VARCHAR(20) CONSTRAINT PK_Paciente PRIMARY KEY,
    apellidos_nombre VARCHAR(150) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    num_seguridad_social VARCHAR(20) NOT NULL
);
