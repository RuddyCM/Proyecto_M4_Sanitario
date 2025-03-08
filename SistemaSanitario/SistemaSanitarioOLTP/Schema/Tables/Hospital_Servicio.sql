CREATE TABLE Servicios.Hospital_Servicio (
    codHospital INT NOT NULL,
    idServicio VARCHAR(10) NOT NULL,
    num_camas INT DEFAULT 0,
    rowversion timestamp not null,
    CONSTRAINT PK_Hospital_Servicio PRIMARY KEY (codHospital, idServicio),
    CONSTRAINT FK_Hospital_Hospital_Servicio FOREIGN KEY (codHospital) REFERENCES Administracion.Hospital(codHospital) ON DELETE CASCADE,
    CONSTRAINT FK_Servicio_Hospital_Servicio FOREIGN KEY (idServicio) REFERENCES Servicios.Servicio(idServicio) ON DELETE CASCADE
);