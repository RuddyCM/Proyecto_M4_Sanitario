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
PRINT N'Creando Tabla [Administracion].[Medico_Servicio]...';


GO
CREATE TABLE [Administracion].[Medico_Servicio] (
    [DNI_Medico]  VARCHAR (20) NOT NULL,
    [idServicio]  VARCHAR (10) NOT NULL,
    [codHospital] INT          NOT NULL,
    CONSTRAINT [PK_Medico_Servicio] PRIMARY KEY CLUSTERED ([DNI_Medico] ASC, [idServicio] ASC, [codHospital] ASC)
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
PRINT N'Creando Tabla [Servicios].[Hospital_Servicio]...';


GO
CREATE TABLE [Servicios].[Hospital_Servicio] (
    [codHospital] INT          NOT NULL,
    [idServicio]  VARCHAR (10) NOT NULL,
    [num_camas]   INT          NULL,
    CONSTRAINT [PK_Hospital_Servicio] PRIMARY KEY CLUSTERED ([codHospital] ASC, [idServicio] ASC)
);


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
