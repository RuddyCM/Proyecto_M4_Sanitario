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
            SET PAGE_VERIFY NONE,
                DISABLE_BROKER 
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
PRINT N'Creando Esquema [Pactientes]...';


GO
CREATE SCHEMA [Pactientes]
    AUTHORIZATION [dbo];


GO
PRINT N'Creando Esquema [Servicios]...';


GO
CREATE SCHEMA [Servicios]
    AUTHORIZATION [dbo];


GO
PRINT N'Creando Tabla [Administracion].[Hospital]...';


GO
CREATE TABLE [Administracion].[Hospital] (
    [codHospital]  INT           NOT NULL,
    [nombre]       VARCHAR (100) NOT NULL,
    [ciudad]       VARCHAR (100) NOT NULL,
    [telefono]     VARCHAR (15)  NOT NULL,
    [DNI_Director] VARCHAR (20)  NULL,
    PRIMARY KEY CLUSTERED ([codHospital] ASC)
);


GO
PRINT N'Creando Tabla [Administracion].[Medico]...';


GO
CREATE TABLE [Administracion].[Medico] (
    [DNI]              VARCHAR (20)  NOT NULL,
    [apellidos_nombre] VARCHAR (150) NOT NULL,
    [fecha_nacimiento] DATE          NOT NULL,
    [codHospital]      INT           NOT NULL,
    [esDirector]       BIT           NULL,
    PRIMARY KEY CLUSTERED ([DNI] ASC)
);


GO
PRINT N'Creando Tabla [Servicios].[Servicio]...';


GO
CREATE TABLE [Servicios].[Servicio] (
    [idServicio]  VARCHAR (10)  NOT NULL,
    [nombre]      VARCHAR (100) NOT NULL,
    [descripcion] TEXT          NULL,
    PRIMARY KEY CLUSTERED ([idServicio] ASC)
);


GO
PRINT N'Creando Restricción DEFAULT restricción sin nombre en [Administracion].[Medico]...';


GO
ALTER TABLE [Administracion].[Medico]
    ADD DEFAULT 0 FOR [esDirector];


GO
PRINT N'Actualización completada.';


GO
