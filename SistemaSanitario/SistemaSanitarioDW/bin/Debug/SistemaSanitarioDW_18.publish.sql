/*
Script de implementación para BDsanitarioDW

Una herramienta generó este código.
Los cambios realizados en este archivo podrían generar un comportamiento incorrecto y se perderán si
se vuelve a generar el código.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "BDsanitarioDW"
:setvar DefaultFilePrefix "BDsanitarioDW"
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
PRINT N'Creando Tabla [staging].[Hospitalst]...';


GO
CREATE TABLE [staging].[Hospitalst] (
    [HospitalSK]         INT           NOT NULL,
    [codHospital]        INT           NULL,
    [nombre]             VARCHAR (255) NULL,
    [ciudad]             VARCHAR (255) NULL,
    [telefono]           VARCHAR (50)  NULL,
    [director]           VARCHAR (255) NULL,
    [numero_total_camas] INT           NULL
);


GO
PRINT N'Creando Tabla [staging].[Medicost]...';


GO
CREATE TABLE [staging].[Medicost] (
    [DNI_MedicoSK]       INT           NOT NULL,
    [apellidos_nombre]   VARCHAR (255) NULL,
    [fecha_nacimiento]   DATE          NULL,
    [codHospital]        INT           NULL,
    [direccion_hospital] VARCHAR (255) NULL,
    [es_director]        BIT           NULL
);


GO
PRINT N'Creando Tabla [staging].[Pacientess]...';


GO
CREATE TABLE [staging].[Pacientess] (
    [DNI_PacienteSK]       INT           NOT NULL,
    [apellidos_nombre]     VARCHAR (255) NULL,
    [fecha_nacimiento]     DATE          NULL,
    [num_seguridad_social] VARCHAR (50)  NULL,
    [otros_datos]          TEXT          NULL
);


GO
PRINT N'Creando Tabla [staging].[Serviciost]...';


GO
CREATE TABLE [staging].[Serviciost] (
    [ServicioSK]      INT           NOT NULL,
    [idServicio]      VARCHAR (50)  NULL,
    [nombre_servicio] VARCHAR (255) NULL
);


GO
PRINT N'Creando Tabla [staging].[Visitast]...';


GO
CREATE TABLE [staging].[Visitast] (
    [VisitaSK]       INT           NOT NULL,
    [PacienteSK]     INT           NULL,
    [MedicoSK]       INT           NULL,
    [HospitalSK]     INT           NULL,
    [ServicioSK]     INT           NULL,
    [TiempoSK]       INT           NULL,
    [num_habitacion] INT           NULL,
    [fecha_hora]     DATETIME      NULL,
    [fecha_alta]     DATETIME      NULL,
    [diagnostico]    VARCHAR (MAX) NULL,
    [tratamiento]    VARCHAR (MAX) NULL,
    [dias_ingreso]   INT           NULL
);


GO
PRINT N'Actualización completada.';


GO
