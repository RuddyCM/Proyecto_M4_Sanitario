﻿/*
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
PRINT N'Modificando Tabla [dbo].[Dim_Tiempo]...';


GO
ALTER TABLE [dbo].[Dim_Tiempo] ALTER COLUMN [dia_mes] INT NULL;


GO
PRINT N'Actualizando Procedimiento [dbo].[DW_MergeFactVisitas]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[DW_MergeFactVisitas]';


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
            ORDER BY TiempoSK ASC;
        END

    WHILE (@startdate <= @enddate)
    BEGIN 
        INSERT INTO @datelist(FullDate)
        SELECT @startdate

        SET @startdate = DATEADD(dd,1,@startdate);
    END

    -- 🚀 Insertamos los datos asegurando que 'TiempoSK' y 'dia_mes' no sean NULL
    INSERT INTO dbo.Dim_Tiempo(TiempoSK, fecha, anio, trimestre, mes, dia, semana, dia_mes)
    SELECT 
        -- Generamos un identificador único para TiempoSK basado en la fecha (YYYYMMDD)
        CONVERT(INT, FORMAT(dl.FullDate, 'yyyyMMdd')), 
        dl.FullDate,
        YEAR(dl.FullDate),
        DATEPART(QUARTER, dl.FullDate),
        MONTH(dl.FullDate),
        DAY(dl.FullDate),
        DATEPART(WEEK, dl.FullDate),
        DAY(dl.FullDate)  -- Aseguramos que 'dia_mes' no sea NULL
    FROM @datelist dl
    LEFT OUTER JOIN dbo.Dim_Tiempo dt ON dl.FullDate = dt.fecha
    WHERE dt.fecha IS NULL;
    
    COMMIT TRAN
END
GO

IF NOT EXISTS(SELECT 1 FROM [dbo].[Dim_Tiempo] WHERE fecha = CAST(GETDATE() AS DATE))
BEGIN
    INSERT INTO [dbo].[Dim_Tiempo] 
        ([fecha], [anio], [trimestre], [mes], [dia], [semana], [dia_mes])
    VALUES 
        (CAST(GETDATE() AS DATE), 
         YEAR(GETDATE()), 
         DATEPART(QUARTER, GETDATE()), 
         MONTH(GETDATE()), 
         DAY(GETDATE()), 
         DATEPART(WEEK, GETDATE()), 
         DAY(GETDATE()));
END
GO

GO

GO
PRINT N'Actualización completada.';


GO
