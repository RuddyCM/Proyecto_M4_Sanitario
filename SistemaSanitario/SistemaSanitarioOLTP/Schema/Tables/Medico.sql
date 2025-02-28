CREATE TABLE Administracion.Medico (
    DNI VARCHAR(20) CONSTRAINT PK_Medico PRIMARY KEY,
    apellidos_nombre VARCHAR(150) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    codHospital INT NOT NULL,
    esDirector BIT DEFAULT 0
);
