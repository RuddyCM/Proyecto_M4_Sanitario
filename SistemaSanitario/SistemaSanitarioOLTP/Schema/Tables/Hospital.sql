CREATE TABLE Administracion.Hospital 
(
    codHospital INT CONSTRAINT PK_Hospital PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    DNI_Director VARCHAR(20) NULL
);
GO

-- Agregar clave foránea para el director del hospital
ALTER TABLE Administracion.Hospital
ADD CONSTRAINT FK_Hospital_Medico FOREIGN KEY (DNI_Director)
REFERENCES Administracion.Medico(DNI) ON DELETE SET NULL;
GO