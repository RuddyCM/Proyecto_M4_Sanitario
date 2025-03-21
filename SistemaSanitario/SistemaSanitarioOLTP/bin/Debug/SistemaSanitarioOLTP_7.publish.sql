﻿/*
Script de implementación para SistemaSanitario

Una herramienta generó este código.
Los cambios realizados en este archivo podrían generar un comportamiento incorrecto y se perderán si
se vuelve a generar el código.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "SistemaSanitario"
:setvar DefaultFilePrefix "SistemaSanitario"
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
PRINT N'Creando Tabla [Pacientes].[Paciente]...';


GO
CREATE TABLE [Pacientes].[Paciente] (
    [DNI_Paciente]         VARCHAR (20)  NOT NULL,
    [apellidos_nombre]     VARCHAR (150) NOT NULL,
    [fecha_nacimiento]     DATE          NOT NULL,
    [num_seguridad_social] VARCHAR (20)  NOT NULL,
    PRIMARY KEY CLUSTERED ([DNI_Paciente] ASC)
);


GO
PRINT N'Creando Clave externa [Administracion].[FK_Hospital_Medico]...';


GO
ALTER TABLE [Administracion].[Hospital] WITH NOCHECK
    ADD CONSTRAINT [FK_Hospital_Medico] FOREIGN KEY ([DNI_Director]) REFERENCES [Administracion].[Medico] ([DNI]) ON DELETE SET NULL;


GO
PRINT N'Comprobando los datos existentes con las restricciones recién creadas';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [Administracion].[Hospital] WITH CHECK CHECK CONSTRAINT [FK_Hospital_Medico];


GO
PRINT N'Actualización completada.';


GO
