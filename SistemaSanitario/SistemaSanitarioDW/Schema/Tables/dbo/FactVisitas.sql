-- Tabla de Hechos: Fact_Visitas
CREATE TABLE Fact_Visitas (
    VisitaSK INT IDENTITY(1,1) PRIMARY KEY,
    PacienteSK INT,
    MedicoSK INT,
    HospitalSK INT,
    ServicioSK INT,
    TiempoSK INT,
    num_habitacion INT NOT NULL,
    fecha_hora DATETIME NOT NULL,
    fecha_alta DATE NOT NULL,
    diagnostico TEXT NOT NULL,
    tratamiento TEXT NOT NULL,
    dias_ingreso INT NOT NULL,
    FOREIGN KEY (PacienteSK) REFERENCES Dim_Paciente(PacienteSK),
    FOREIGN KEY (MedicoSK) REFERENCES Dim_Medico(MedicoSK),
    FOREIGN KEY (HospitalSK) REFERENCES Dim_Hospital(HospitalSK),
    FOREIGN KEY (ServicioSK) REFERENCES Dim_Servicio(ServicioSK),
    FOREIGN KEY (TiempoSK) REFERENCES Dim_Tiempo(TiempoSK)
);
