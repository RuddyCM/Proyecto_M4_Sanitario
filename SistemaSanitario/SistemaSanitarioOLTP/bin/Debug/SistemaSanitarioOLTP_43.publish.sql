﻿/*
Script de implementación para BDsanitarioOLTP

Una herramienta generó este código.
Los cambios realizados en este archivo podrían generar un comportamiento incorrecto y se perderán si
se vuelve a generar el código.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "BDsanitarioOLTP"
:setvar DefaultFilePrefix "BDsanitarioOLTP"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detectar el modo SQLCMD y deshabilitar la ejecución del script si no se admite el modo SQLCMD.
Para volver a habilitar el script después de habilitar el modo SQLCMD, ejecute lo siguiente:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'El modo SQLCMD debe estar habilitado para ejecutar correctamente este script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
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
GO

GO
PRINT N'Actualización completada.';


GO
