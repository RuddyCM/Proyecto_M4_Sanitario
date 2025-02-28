/*
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
PRINT N'Quitando Restricción DEFAULT restricción sin nombre en [Administracion].[Medico]...';


GO
ALTER TABLE [Administracion].[Medico] DROP CONSTRAINT [DF__Medico__esDirect__3B75D760];


GO
PRINT N'Quitando Clave externa [Administracion].[FK_Hospital_Medico]...';


GO
ALTER TABLE [Administracion].[Hospital] DROP CONSTRAINT [FK_Hospital_Medico];


GO
PRINT N'Iniciando recompilación de la tabla [Administracion].[Medico]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [Administracion].[tmp_ms_xx_Medico] (
    [DNI]              VARCHAR (20)  NOT NULL,
    [apellidos_nombre] VARCHAR (150) NOT NULL,
    [fecha_nacimiento] DATE          NOT NULL,
    [codHospital]      INT           NOT NULL,
    [esDirector]       BIT           DEFAULT 0 NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_Medico1] PRIMARY KEY CLUSTERED ([DNI] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [Administracion].[Medico])
    BEGIN
        INSERT INTO [Administracion].[tmp_ms_xx_Medico] ([DNI], [apellidos_nombre], [fecha_nacimiento], [codHospital], [esDirector])
        SELECT   [DNI],
                 [apellidos_nombre],
                 [fecha_nacimiento],
                 [codHospital],
                 [esDirector]
        FROM     [Administracion].[Medico]
        ORDER BY [DNI] ASC;
    END

DROP TABLE [Administracion].[Medico];

EXECUTE sp_rename N'[Administracion].[tmp_ms_xx_Medico]', N'Medico';

EXECUTE sp_rename N'[Administracion].[tmp_ms_xx_constraint_PK_Medico1]', N'PK_Medico', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Iniciando recompilación de la tabla [Pacientes].[Paciente]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [Pacientes].[tmp_ms_xx_Paciente] (
    [DNI_Paciente]         VARCHAR (20)  NOT NULL,
    [apellidos_nombre]     VARCHAR (150) NOT NULL,
    [fecha_nacimiento]     DATE          NOT NULL,
    [num_seguridad_social] VARCHAR (20)  NOT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_Paciente1] PRIMARY KEY CLUSTERED ([DNI_Paciente] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [Pacientes].[Paciente])
    BEGIN
        INSERT INTO [Pacientes].[tmp_ms_xx_Paciente] ([DNI_Paciente], [apellidos_nombre], [fecha_nacimiento], [num_seguridad_social])
        SELECT   [DNI_Paciente],
                 [apellidos_nombre],
                 [fecha_nacimiento],
                 [num_seguridad_social]
        FROM     [Pacientes].[Paciente]
        ORDER BY [DNI_Paciente] ASC;
    END

DROP TABLE [Pacientes].[Paciente];

EXECUTE sp_rename N'[Pacientes].[tmp_ms_xx_Paciente]', N'Paciente';

EXECUTE sp_rename N'[Pacientes].[tmp_ms_xx_constraint_PK_Paciente1]', N'PK_Paciente', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Iniciando recompilación de la tabla [Servicios].[Servicio]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [Servicios].[tmp_ms_xx_Servicio] (
    [idServicio]  VARCHAR (10)  NOT NULL,
    [nombre]      VARCHAR (100) NOT NULL,
    [descripcion] TEXT          NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_Servicio1] PRIMARY KEY CLUSTERED ([idServicio] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [Servicios].[Servicio])
    BEGIN
        INSERT INTO [Servicios].[tmp_ms_xx_Servicio] ([idServicio], [nombre], [descripcion])
        SELECT   [idServicio],
                 [nombre],
                 [descripcion]
        FROM     [Servicios].[Servicio]
        ORDER BY [idServicio] ASC;
    END

DROP TABLE [Servicios].[Servicio];

EXECUTE sp_rename N'[Servicios].[tmp_ms_xx_Servicio]', N'Servicio';

EXECUTE sp_rename N'[Servicios].[tmp_ms_xx_constraint_PK_Servicio1]', N'PK_Servicio', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


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
