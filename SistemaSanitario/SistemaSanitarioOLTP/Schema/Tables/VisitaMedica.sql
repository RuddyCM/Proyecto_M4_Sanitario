CREATE TABLE Pacientes.VisitaMedica (
    idVisita INT IDENTITY(1,1) CONSTRAINT PK_VisitaMedica PRIMARY KEY,
    fecha_hora DATETIME NOT NULL,
    codHospital INT NOT NULL,
    idServicio VARCHAR(10) NOT NULL,
    DNI_Medico VARCHAR(20) NOT NULL,
    codHist INT NULL,
    diagnostico TEXT NOT NULL,
    tratamiento TEXT NOT NULL,
    num_habitacion INT NULL,
    fecha_alta DATE NULL,
    rowversion timestamp not null,
    CONSTRAINT FK_Hospital_VisitaMedica FOREIGN KEY (codHospital) REFERENCES Administracion.Hospital(codHospital) ON DELETE NO ACTION,
    CONSTRAINT FK_Servicio_VisitaMedica FOREIGN KEY (idServicio) REFERENCES Servicios.Servicio(idServicio) ON DELETE NO ACTION,
    CONSTRAINT FK_Medico_VisitaMedica FOREIGN KEY (DNI_Medico) REFERENCES Administracion.Medico(DNI) ON DELETE NO ACTION,
    CONSTRAINT FK_HistoriaClinica_VisitaMedica FOREIGN KEY (codHist) REFERENCES Pacientes.HistoriaClinica(codHist) ON DELETE SET NULL
);