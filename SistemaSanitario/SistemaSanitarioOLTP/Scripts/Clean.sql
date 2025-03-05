-- Limpiar y reiniciar las tablas de tu base de datos

DELETE FROM VisitaMedica;
GO

DELETE FROM Medico;
GO
DBCC CHECKIDENT ('Medico', RESEED);
GO

DELETE FROM Medico_Servicio;
GO
DBCC CHECKIDENT ('Medico_Servicio', RESEED);
GO

DELETE FROM Servicio;
GO
DBCC CHECKIDENT ('Servicio', RESEED);
GO

DELETE FROM Hospital;
GO
DBCC CHECKIDENT ('Hospital', RESEED);
GO

DELETE FROM Hospital_Servicio;
GO
DBCC CHECKIDENT ('Hospital_Servicio', RESEED);
GO

DELETE FROM Paciente;
GO
DBCC CHECKIDENT ('Paciente', RESEED);
GO

DELETE FROM HistoriaClinica;
GO
DBCC CHECKIDENT ('HistoriaClinica', RESEED);
GO

DELETE FROM Fact_Visitas;
GO
DBCC CHECKIDENT ('Fact_Visitas', RESEED);
GO
