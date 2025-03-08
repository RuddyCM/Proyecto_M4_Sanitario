PRINT 'Cleaning database...';
SET NOCOUNT ON;

DELETE FROM Pacientes.VisitaMedica;
DELETE FROM Pacientes.HistoriaClinica;
DELETE FROM Pacientes.Paciente;

DELETE FROM Administracion.Medico_Servicio;
DELETE FROM Administracion.Medico;

DELETE FROM Servicios.Hospital_Servicio;
DELETE FROM Servicios.Servicio;

DELETE FROM Administracion.Hospital;

PRINT 'Database cleaned successfully!';
