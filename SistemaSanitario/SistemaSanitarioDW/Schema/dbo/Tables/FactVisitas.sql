-- Fact_Visitas
CREATE TABLE Fact_Visitas (
    idVisita INT PRIMARY KEY,
    codHospital VARCHAR(20),
    idServicio VARCHAR(20),
    DNI_Paciente VARCHAR(20),
    DNI_Medico VARCHAR(20),
    num_habitacion INT,
    fecha_hora INT,  -- Cambio aquí a INT
    fecha_alta DATETIME,
    diagnostico TEXT,
    tratamiento TEXT,
    dias_ingreso INT,
    costo_servicio DECIMAL(10,2),
    FOREIGN KEY (codHospital) REFERENCES Dim_Hospital(codHospital),
    FOREIGN KEY (idServicio) REFERENCES Dim_Servicio(idServicio),
    FOREIGN KEY (DNI_Paciente) REFERENCES Dim_Paciente(DNI_Paciente),
    FOREIGN KEY (DNI_Medico) REFERENCES Dim_Medico(DNI_Medico),
    FOREIGN KEY (fecha_hora) REFERENCES Dim_Tiempo(idFecha)
);