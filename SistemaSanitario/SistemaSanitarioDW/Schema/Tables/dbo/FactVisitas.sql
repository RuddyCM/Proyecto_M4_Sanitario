-- Crear la tabla de hechos sin claves primarias ni foráneas
CREATE TABLE Fact_Visitas (
    VisitaSK INT NOT NULL,  -- Ahora es autoincremental
    PacienteSK INT NULL,
    MedicoSK INT NULL,
    HospitalSK INT NULL,
    ServicioSK INT NULL,
    TiempoSK_FechaHora INT NULL,  -- Clave sustituta para fecha_hora
    TiempoSK_FechaAlta INT NULL,  -- Clave sustituta para fecha_alta
    num_habitacion INT NULL,
    fecha_hora DATETIME NULL,
    fecha_alta DATE NULL,
    diagnostico TEXT NULL,
    tratamiento TEXT NULL,
    dias_ingreso INT NULL
);
GO

-- 🔹 Agregar la clave primaria
ALTER TABLE Fact_Visitas 
ADD CONSTRAINT PK_Fact_Visitas PRIMARY KEY (VisitaSK);
GO

-- 🔹 Agregar claves foráneas (Relacionando con Dimensiones)
ALTER TABLE Fact_Visitas 
ADD CONSTRAINT FK_Dim_Paciente FOREIGN KEY (PacienteSK) REFERENCES Dim_Paciente(PacienteSK);
GO

ALTER TABLE Fact_Visitas 
ADD CONSTRAINT FK_Dim_Medico FOREIGN KEY (MedicoSK) REFERENCES Dim_Medico(MedicoSK);
GO

ALTER TABLE Fact_Visitas 
ADD CONSTRAINT FK_Dim_Hospital FOREIGN KEY (HospitalSK) REFERENCES Dim_Hospital(HospitalSK);
GO

ALTER TABLE Fact_Visitas 
ADD CONSTRAINT FK_Dim_Servicio FOREIGN KEY (ServicioSK) REFERENCES Dim_Servicio(ServicioSK);
GO

-- 🔹 Relaciones con la dimensión de tiempo
ALTER TABLE Fact_Visitas 
ADD CONSTRAINT FK_Dim_Tiempo_TiempoSK_FechaHora FOREIGN KEY (TiempoSK_FechaHora) REFERENCES Dim_Tiempo(TiempoSK);
GO

ALTER TABLE Fact_Visitas 
ADD CONSTRAINT FK_Dim_Tiempo_TiempoSK_FechaAlta FOREIGN KEY (TiempoSK_FechaAlta) REFERENCES Dim_Tiempo(TiempoSK);
GO
