CREATE TABLE Administracion.Medico_Servicio 
(
    DNI_Medico VARCHAR(20) NOT NULL,
    idServicio VARCHAR(10) NOT NULL,
    codHospital INT NOT NULL,
    CONSTRAINT PK_Medico_Servicio PRIMARY KEY (DNI_Medico, idServicio, codHospital),
    CONSTRAINT FK_Medico_Medico_Servicio FOREIGN KEY (DNI_Medico) REFERENCES Administracion.Medico(DNI) ON DELETE CASCADE,
    CONSTRAINT FK_Servicio_Medico_Servicio FOREIGN KEY (idServicio) REFERENCES Servicios.Servicio(idServicio) ON DELETE NO ACTION,
    CONSTRAINT FK_Hospital_Medico_Servicio FOREIGN KEY (codHospital) REFERENCES Administracion.Hospital(codHospital) ON DELETE NO ACTION
);