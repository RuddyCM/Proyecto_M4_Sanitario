/*
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
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET PAGE_VERIFY NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE (QUERY_CAPTURE_MODE = ALL, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 367), MAX_STORAGE_SIZE_MB = 100) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE = OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
PRINT N'Creando Esquema [Administracion]...';


GO
CREATE SCHEMA [Administracion]
    AUTHORIZATION [dbo];


GO
PRINT N'Creando Esquema [Pacientes]...';


GO
CREATE SCHEMA [Pacientes]
    AUTHORIZATION [dbo];


GO
PRINT N'Creando Esquema [Servicios]...';


GO
CREATE SCHEMA [Servicios]
    AUTHORIZATION [dbo];


GO
PRINT N'Creando Tabla [Administracion].[Medico]...';


GO
CREATE TABLE [Administracion].[Medico] (
    [DNI]              VARCHAR (20)  NOT NULL,
    [apellidos_nombre] VARCHAR (150) NOT NULL,
    [fecha_nacimiento] DATE          NOT NULL,
    [codHospital]      INT           NOT NULL,
    [esDirector]       BIT           NULL,
    CONSTRAINT [PK_Medico] PRIMARY KEY CLUSTERED ([DNI] ASC)
);


GO
PRINT N'Creando Tabla [Administracion].[Medico_Servicio]...';


GO
CREATE TABLE [Administracion].[Medico_Servicio] (
    [DNI_Medico]  VARCHAR (20) NOT NULL,
    [idServicio]  VARCHAR (10) NOT NULL,
    [codHospital] INT          NOT NULL,
    CONSTRAINT [PK_Medico_Servicio] PRIMARY KEY CLUSTERED ([DNI_Medico] ASC, [idServicio] ASC, [codHospital] ASC)
);


GO
PRINT N'Creando Tabla [Administracion].[Hospital]...';


GO
CREATE TABLE [Administracion].[Hospital] (
    [codHospital]  INT           NOT NULL,
    [nombre]       VARCHAR (100) NOT NULL,
    [ciudad]       VARCHAR (100) NOT NULL,
    [telefono]     VARCHAR (20)  NOT NULL,
    [DNI_Director] VARCHAR (20)  NULL,
    CONSTRAINT [PK_Hospital] PRIMARY KEY CLUSTERED ([codHospital] ASC)
);


GO
PRINT N'Creando Tabla [Pacientes].[Paciente]...';


GO
CREATE TABLE [Pacientes].[Paciente] (
    [DNI_Paciente]         VARCHAR (20)  NOT NULL,
    [apellidos_nombre]     VARCHAR (150) NOT NULL,
    [fecha_nacimiento]     DATE          NOT NULL,
    [num_seguridad_social] VARCHAR (20)  NOT NULL,
    CONSTRAINT [PK_Paciente] PRIMARY KEY CLUSTERED ([DNI_Paciente] ASC)
);


GO
PRINT N'Creando Tabla [Pacientes].[HistoriaClinica]...';


GO
CREATE TABLE [Pacientes].[HistoriaClinica] (
    [codHist]      INT          IDENTITY (1, 1) NOT NULL,
    [DNI_Paciente] VARCHAR (20) NOT NULL,
    CONSTRAINT [PK_HistoriaClinica] PRIMARY KEY CLUSTERED ([codHist] ASC)
);


GO
PRINT N'Creando Tabla [Pacientes].[VisitaMedica]...';


GO
CREATE TABLE [Pacientes].[VisitaMedica] (
    [idVisita]       INT          IDENTITY (1, 1) NOT NULL,
    [fecha_hora]     DATETIME     NOT NULL,
    [codHospital]    INT          NOT NULL,
    [idServicio]     VARCHAR (10) NOT NULL,
    [DNI_Medico]     VARCHAR (20) NOT NULL,
    [codHist]        INT          NULL,
    [diagnostico]    TEXT         NOT NULL,
    [tratamiento]    TEXT         NOT NULL,
    [num_habitacion] INT          NULL,
    [fecha_alta]     DATE         NULL,
    CONSTRAINT [PK_VisitaMedica] PRIMARY KEY CLUSTERED ([idVisita] ASC)
);


GO
PRINT N'Creando Tabla [Servicios].[Servicio]...';


GO
CREATE TABLE [Servicios].[Servicio] (
    [idServicio]  VARCHAR (10)  NOT NULL,
    [nombre]      VARCHAR (100) NOT NULL,
    [descripcion] TEXT          NULL,
    CONSTRAINT [PK_Servicio] PRIMARY KEY CLUSTERED ([idServicio] ASC)
);


GO
PRINT N'Creando Tabla [Servicios].[Hospital_Servicio]...';


GO
CREATE TABLE [Servicios].[Hospital_Servicio] (
    [codHospital] INT          NOT NULL,
    [idServicio]  VARCHAR (10) NOT NULL,
    [num_camas]   INT          NULL,
    CONSTRAINT [PK_Hospital_Servicio] PRIMARY KEY CLUSTERED ([codHospital] ASC, [idServicio] ASC)
);


GO
PRINT N'Creando Restricción DEFAULT restricción sin nombre en [Administracion].[Medico]...';


GO
ALTER TABLE [Administracion].[Medico]
    ADD DEFAULT 0 FOR [esDirector];


GO
PRINT N'Creando Restricción DEFAULT restricción sin nombre en [Servicios].[Hospital_Servicio]...';


GO
ALTER TABLE [Servicios].[Hospital_Servicio]
    ADD DEFAULT 0 FOR [num_camas];


GO
PRINT N'Creando Clave externa [Administracion].[FK_Medico_Medico_Servicio]...';


GO
ALTER TABLE [Administracion].[Medico_Servicio] WITH NOCHECK
    ADD CONSTRAINT [FK_Medico_Medico_Servicio] FOREIGN KEY ([DNI_Medico]) REFERENCES [Administracion].[Medico] ([DNI]) ON DELETE CASCADE;


GO
PRINT N'Creando Clave externa [Administracion].[FK_Servicio_Medico_Servicio]...';


GO
ALTER TABLE [Administracion].[Medico_Servicio] WITH NOCHECK
    ADD CONSTRAINT [FK_Servicio_Medico_Servicio] FOREIGN KEY ([idServicio]) REFERENCES [Servicios].[Servicio] ([idServicio]);


GO
PRINT N'Creando Clave externa [Administracion].[FK_Hospital_Medico_Servicio]...';


GO
ALTER TABLE [Administracion].[Medico_Servicio] WITH NOCHECK
    ADD CONSTRAINT [FK_Hospital_Medico_Servicio] FOREIGN KEY ([codHospital]) REFERENCES [Administracion].[Hospital] ([codHospital]);


GO
PRINT N'Creando Clave externa [Administracion].[FK_Hospital_Medico]...';


GO
ALTER TABLE [Administracion].[Hospital] WITH NOCHECK
    ADD CONSTRAINT [FK_Hospital_Medico] FOREIGN KEY ([DNI_Director]) REFERENCES [Administracion].[Medico] ([DNI]) ON DELETE SET NULL;


GO
PRINT N'Creando Clave externa [Pacientes].[FK_Paciente_HistoriaClinica]...';


GO
ALTER TABLE [Pacientes].[HistoriaClinica] WITH NOCHECK
    ADD CONSTRAINT [FK_Paciente_HistoriaClinica] FOREIGN KEY ([DNI_Paciente]) REFERENCES [Pacientes].[Paciente] ([DNI_Paciente]) ON DELETE CASCADE;


GO
PRINT N'Creando Clave externa [Pacientes].[FK_Hospital_VisitaMedica]...';


GO
ALTER TABLE [Pacientes].[VisitaMedica] WITH NOCHECK
    ADD CONSTRAINT [FK_Hospital_VisitaMedica] FOREIGN KEY ([codHospital]) REFERENCES [Administracion].[Hospital] ([codHospital]);


GO
PRINT N'Creando Clave externa [Pacientes].[FK_Servicio_VisitaMedica]...';


GO
ALTER TABLE [Pacientes].[VisitaMedica] WITH NOCHECK
    ADD CONSTRAINT [FK_Servicio_VisitaMedica] FOREIGN KEY ([idServicio]) REFERENCES [Servicios].[Servicio] ([idServicio]);


GO
PRINT N'Creando Clave externa [Pacientes].[FK_Medico_VisitaMedica]...';


GO
ALTER TABLE [Pacientes].[VisitaMedica] WITH NOCHECK
    ADD CONSTRAINT [FK_Medico_VisitaMedica] FOREIGN KEY ([DNI_Medico]) REFERENCES [Administracion].[Medico] ([DNI]);


GO
PRINT N'Creando Clave externa [Pacientes].[FK_HistoriaClinica_VisitaMedica]...';


GO
ALTER TABLE [Pacientes].[VisitaMedica] WITH NOCHECK
    ADD CONSTRAINT [FK_HistoriaClinica_VisitaMedica] FOREIGN KEY ([codHist]) REFERENCES [Pacientes].[HistoriaClinica] ([codHist]) ON DELETE SET NULL;


GO
PRINT N'Creando Clave externa [Servicios].[FK_Hospital_Hospital_Servicio]...';


GO
ALTER TABLE [Servicios].[Hospital_Servicio] WITH NOCHECK
    ADD CONSTRAINT [FK_Hospital_Hospital_Servicio] FOREIGN KEY ([codHospital]) REFERENCES [Administracion].[Hospital] ([codHospital]) ON DELETE CASCADE;


GO
PRINT N'Creando Clave externa [Servicios].[FK_Servicio_Hospital_Servicio]...';


GO
ALTER TABLE [Servicios].[Hospital_Servicio] WITH NOCHECK
    ADD CONSTRAINT [FK_Servicio_Hospital_Servicio] FOREIGN KEY ([idServicio]) REFERENCES [Servicios].[Servicio] ([idServicio]) ON DELETE CASCADE;


GO
PRINT N'Comprobando los datos existentes con las restricciones recién creadas';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [Administracion].[Medico_Servicio] WITH CHECK CHECK CONSTRAINT [FK_Medico_Medico_Servicio];

ALTER TABLE [Administracion].[Medico_Servicio] WITH CHECK CHECK CONSTRAINT [FK_Servicio_Medico_Servicio];

ALTER TABLE [Administracion].[Medico_Servicio] WITH CHECK CHECK CONSTRAINT [FK_Hospital_Medico_Servicio];

ALTER TABLE [Administracion].[Hospital] WITH CHECK CHECK CONSTRAINT [FK_Hospital_Medico];

ALTER TABLE [Pacientes].[HistoriaClinica] WITH CHECK CHECK CONSTRAINT [FK_Paciente_HistoriaClinica];

ALTER TABLE [Pacientes].[VisitaMedica] WITH CHECK CHECK CONSTRAINT [FK_Hospital_VisitaMedica];

ALTER TABLE [Pacientes].[VisitaMedica] WITH CHECK CHECK CONSTRAINT [FK_Servicio_VisitaMedica];

ALTER TABLE [Pacientes].[VisitaMedica] WITH CHECK CHECK CONSTRAINT [FK_Medico_VisitaMedica];

ALTER TABLE [Pacientes].[VisitaMedica] WITH CHECK CHECK CONSTRAINT [FK_HistoriaClinica_VisitaMedica];

ALTER TABLE [Servicios].[Hospital_Servicio] WITH CHECK CHECK CONSTRAINT [FK_Hospital_Hospital_Servicio];

ALTER TABLE [Servicios].[Hospital_Servicio] WITH CHECK CHECK CONSTRAINT [FK_Servicio_Hospital_Servicio];


GO
PRINT N'Actualización completada.';


GO
