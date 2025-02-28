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
PRINT N'Quitando Clave externa [Administracion].[FK_Hospital_Medico]...';


GO
ALTER TABLE [Administracion].[Hospital] DROP CONSTRAINT [FK_Hospital_Medico];


GO
PRINT N'Iniciando recompilación de la tabla [Administracion].[Hospital]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [Administracion].[tmp_ms_xx_Hospital] (
    [codHospital]  INT           NOT NULL,
    [nombre]       VARCHAR (100) NOT NULL,
    [ciudad]       VARCHAR (100) NOT NULL,
    [telefono]     VARCHAR (15)  NOT NULL,
    [DNI_Director] VARCHAR (20)  NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_hospital1] PRIMARY KEY CLUSTERED ([codHospital] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [Administracion].[Hospital])
    BEGIN
        INSERT INTO [Administracion].[tmp_ms_xx_Hospital] ([codHospital], [nombre], [ciudad], [telefono], [DNI_Director])
        SELECT   [codHospital],
                 [nombre],
                 [ciudad],
                 [telefono],
                 [DNI_Director]
        FROM     [Administracion].[Hospital]
        ORDER BY [codHospital] ASC;
    END

DROP TABLE [Administracion].[Hospital];

EXECUTE sp_rename N'[Administracion].[tmp_ms_xx_Hospital]', N'Hospital';

EXECUTE sp_rename N'[Administracion].[tmp_ms_xx_constraint_PK_hospital1]', N'PK_hospital', N'OBJECT';

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
