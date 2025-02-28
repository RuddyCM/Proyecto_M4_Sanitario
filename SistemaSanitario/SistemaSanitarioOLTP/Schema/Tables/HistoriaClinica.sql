CREATE TABLE Pacientes.HistoriaClinica (
    codHist INT CONSTRAINT PK_HistoriaClinica PRIMARY KEY IDENTITY(1,1),
    DNI_Paciente VARCHAR(20) NOT NULL,
    CONSTRAINT FK_Paciente_HistoriaClinica FOREIGN KEY (DNI_Paciente) REFERENCES Pacientes.Paciente(DNI_Paciente) ON DELETE CASCADE
);