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
/*
Se está quitando la columna [staging].[Visitast].[fecha_hora]; puede que se pierdan datos.

El tipo de la columna TiempoSK_FechaAlta en la tabla [staging].[Visitast] es  DATETIME NULL, pero se va a cambiar a  INT NULL. Si la columna contiene datos no compatibles con el tipo  INT NULL, podrían producirse pérdidas de datos y errores en la implementación.
*/

IF EXISTS (select top 1 1 from [staging].[Visitast])
    RAISERROR (N'Se detectaron filas. La actualización del esquema va a terminar debido a una posible pérdida de datos.', 16, 127) WITH NOWAIT

GO
PRINT N'La siguiente operación se generó a partir de un archivo de registro de refactorización d3e15a85-7c73-4684-8d04-81df3834a318, dcaeec92-756a-47ec-bd19-1549ba931008';

PRINT N'Cambiar el nombre de [staging].[Visitast].[fecha_alta] a TiempoSK_FechaAlta';


GO
EXECUTE sp_rename @objname = N'[staging].[Visitast].[fecha_alta]', @newname = N'TiempoSK_FechaAlta', @objtype = N'COLUMN';


GO
PRINT N'Iniciando recompilación de la tabla [staging].[Visitast]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [staging].[tmp_ms_xx_Visitast] (
    [VisitaSK]           INT           NOT NULL,
    [PacienteSK]         INT           NULL,
    [MedicoSK]           INT           NULL,
    [HospitalSK]         INT           NULL,
    [ServicioSK]         INT           NULL,
    [num_habitacion]     INT           NULL,
    [TiempoSK_FechaHora] INT           NULL,
    [TiempoSK_FechaAlta] INT           NULL,
    [diagnostico]        VARCHAR (MAX) NULL,
    [tratamiento]        VARCHAR (MAX) NULL,
    [dias_ingreso]       INT           NULL
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [staging].[Visitast])
    BEGIN
        INSERT INTO [staging].[tmp_ms_xx_Visitast] ([VisitaSK], [PacienteSK], [MedicoSK], [HospitalSK], [ServicioSK], [num_habitacion], [TiempoSK_FechaAlta], [diagnostico], [tratamiento], [dias_ingreso])
        SELECT [VisitaSK],
               [PacienteSK],
               [MedicoSK],
               [HospitalSK],
               [ServicioSK],
               [num_habitacion],
               CAST ([TiempoSK_FechaAlta] AS INT),
               [diagnostico],
               [tratamiento],
               [dias_ingreso]
        FROM   [staging].[Visitast];
    END

DROP TABLE [staging].[Visitast];

EXECUTE sp_rename N'[staging].[tmp_ms_xx_Visitast]', N'Visitast';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Modificando Procedimiento [dbo].[DW_MergeFactVisitas]...';


GO
ALTER PROCEDURE [dbo].[DW_MergeFactVisitas]
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO [dbo].[Fact_Visitas] AS fv
    USING [staging].[Visitast] AS sv 
    ON fv.[VisitaSK] = sv.[VisitaSK]

    WHEN MATCHED THEN 
        UPDATE SET 
            fv.[PacienteSK]     = sv.[PacienteSK],
            fv.[MedicoSK]       = sv.[MedicoSK],
            fv.[HospitalSK]     = sv.[HospitalSK],
            fv.[ServicioSK]     = sv.[ServicioSK],
            fv.[num_habitacion] = sv.[num_habitacion],
            fv.[fecha_hora]     = sv.[TiempoSK_FechaHora],
            fv.[fecha_alta]     = sv.[TiempoSK_FechaAlta],
            fv.[diagnostico]    = sv.[diagnostico],
            fv.[tratamiento]    = sv.[tratamiento],
            fv.[dias_ingreso]   = sv.[dias_ingreso]

    WHEN NOT MATCHED THEN 
        INSERT ([PacienteSK], [MedicoSK], [HospitalSK], [ServicioSK], [num_habitacion], 
                [fecha_hora], [fecha_alta], [diagnostico], [tratamiento], [dias_ingreso])
        VALUES (sv.[PacienteSK], sv.[MedicoSK], sv.[HospitalSK], sv.[ServicioSK], sv.[num_habitacion], 
                sv.[TiempoSK_FechaHora], sv.[TiempoSK_FechaAlta], sv.[diagnostico], sv.[tratamiento], sv.[dias_ingreso]);

END
GO
-- Paso de refactorización para actualizar el servidor de destino con los registros de transacciones implementadas

IF OBJECT_ID(N'dbo.__RefactorLog') IS NULL
BEGIN
    CREATE TABLE [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
    EXEC sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
END
GO
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'd3e15a85-7c73-4684-8d04-81df3834a318')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('d3e15a85-7c73-4684-8d04-81df3834a318')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'dcaeec92-756a-47ec-bd19-1549ba931008')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('dcaeec92-756a-47ec-bd19-1549ba931008')

GO

GO
/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

IF NOT EXISTS(SELECT TOP(1) 1 
              FROM [dbo].[PackageConfig] 
              WHERE [TableName] = 'Pacientest')
BEGIN
    INSERT [dbo].[PackageConfig] ([TableName], [LastRowVersion]) 
    VALUES ('Pacientest', 0)
END
GO

IF NOT EXISTS(SELECT TOP(1) 1 
              FROM [dbo].[PackageConfig] 
              WHERE [TableName] = 'Hospitalest')
BEGIN
    INSERT [dbo].[PackageConfig] ([TableName], [LastRowVersion]) 
    VALUES ('Hospitalest', 0)
END
GO

IF NOT EXISTS(SELECT TOP(1) 1 
              FROM [dbo].[PackageConfig] 
              WHERE [TableName] = 'Medicost')
BEGIN
    INSERT [dbo].[PackageConfig] ([TableName], [LastRowVersion]) 
    VALUES ('Medicost', 0)
END
GO

IF NOT EXISTS(SELECT TOP(1) 1 
              FROM [dbo].[PackageConfig] 
              WHERE [TableName] = 'Serviciost')
BEGIN
    INSERT [dbo].[PackageConfig] ([TableName], [LastRowVersion]) 
    VALUES ('Serviciost', 0)
END
GO

IF NOT EXISTS(SELECT TOP(1) 1 
              FROM [dbo].[PackageConfig] 
              WHERE [TableName] = 'Visitast')
BEGIN
    INSERT [dbo].[PackageConfig] ([TableName], [LastRowVersion]) 
    VALUES ('Visitast', 0)
END
GO

IF NOT EXISTS(SELECT TOP(1) 1
              FROM [dbo].[Dim_Tiempo])
BEGIN
    BEGIN TRAN 
        DECLARE @startdate DATE = '2016-01-01',
                @enddate   DATE = '2030-12-31'; -- Ajusta según el rango que necesites
        DECLARE @datelist TABLE(FullDate DATE);

    IF @startdate IS NULL
        BEGIN
            SELECT TOP 1 
                   @startdate = fecha
            FROM dbo.Dim_Tiempo 
            ORDER By TiempoSK ASC;
        END

    WHILE (@startdate <= @enddate)
    BEGIN 
        INSERT INTO @datelist(FullDate)
        SELECT @startdate

        SET @startdate = DATEADD(dd,1,@startdate);
    END

    INSERT INTO dbo.Dim_Tiempo(fecha, anio, trimestre, mes, dia, semana, dia_mes)
SELECT 
    dl.FullDate,
    YEAR(dl.FullDate),
    DATEPART(qq, dl.FullDate),
    MONTH(dl.FullDate),
    DATEPART(d, dl.FullDate),
    DATEPART(wk, dl.FullDate),
    DATEPART(DAY, dl.FullDate)
FROM @datelist dl
LEFT OUTER JOIN dbo.Dim_Tiempo dt ON (dl.FullDate = dt.fecha)
WHERE dt.fecha IS NULL;
    
    COMMIT TRAN
END
GO

IF NOT EXISTS(SELECT TOP(1) 1 
              FROM [dbo].[Dim_Tiempo] 
              WHERE fecha = CAST(GETDATE() AS DATE))
BEGIN
    INSERT INTO [dbo].[Dim_Tiempo] 
        ([fecha], [anio], [trimestre], [mes], [dia], [semana], [dia_mes])
    VALUES 
        (GETDATE(), 0, 0, 0, 0, 0, 0);
END
GO

GO
PRINT N'Actualización completada.';


GO
