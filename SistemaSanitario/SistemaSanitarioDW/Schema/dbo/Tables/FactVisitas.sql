-- Tabla de Hechos: Fact_Visitas
CREATE TABLE Fact_Visitas (
    VisitaSK INT IDENTITY(1,1) PRIMARY KEY,
    PacienteSK INT,
    MedicoSK INT,
    HospitalSK INT,
    ServicioSK INT,
    TiempoSK INT,
    num_habitacion INT,
    fecha_hora DATETIME,
    fecha_alta DATE,
    diagnostico TEXT,
    tratamiento TEXT,
    dias_ingreso INT,
    FOREIGN KEY (PacienteSK) REFERENCES Dim_Paciente(PacienteSK),
    FOREIGN KEY (MedicoSK) REFERENCES Dim_Medico(MedicoSK),
    FOREIGN KEY (HospitalSK) REFERENCES Dim_Hospital(HospitalSK),
    FOREIGN KEY (ServicioSK) REFERENCES Dim_Servicio(ServicioSK),
    FOREIGN KEY (TiempoSK) REFERENCES Dim_Tiempo(TiempoSK)
);
