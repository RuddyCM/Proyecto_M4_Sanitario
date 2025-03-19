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
PRINT N'Modificando Procedimiento [dbo].[DW_MergeFactVisitas]...';


GO
ALTER PROCEDURE [dbo].[DW_MergeFactVisitas]
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO dbo.Fact_Visitas AS fv
    USING staging.Visitast AS sv
    ON fv.VisitaSK = sv.VisitaSK

    WHEN MATCHED THEN 
        UPDATE SET 
            fv.PacienteSK     = sv.PacienteSK,
            fv.MedicoSK       = sv.MedicoSK,
            fv.HospitalSK     = sv.HospitalSK,
            fv.ServicioSK     = sv.ServicioSK,
            fv.num_habitacion = sv.num_habitacion,
            fv.fecha_hora     = CASE 
                                    WHEN TRY_CONVERT(INT, sv.TiempoSK_FechaHora) IS NOT NULL 
                                    THEN DATEFROMPARTS( sv.TiempoSK_FechaHora / 10000, 
                                                        (sv.TiempoSK_FechaHora % 10000) / 100, 
                                                         sv.TiempoSK_FechaHora % 100 )
                                    ELSE NULL
                               END,
            fv.fecha_alta     = CASE 
                                    WHEN TRY_CONVERT(INT, sv.TiempoSK_FechaAlta) IS NOT NULL 
                                    THEN DATEFROMPARTS( sv.TiempoSK_FechaAlta / 10000, 
                                                        (sv.TiempoSK_FechaAlta % 10000) / 100, 
                                                         sv.TiempoSK_FechaAlta % 100 )
                                    ELSE NULL
                               END,
            fv.diagnostico    = sv.diagnostico,
            fv.tratamiento    = sv.tratamiento,
            fv.dias_ingreso   = sv.dias_ingreso

    WHEN NOT MATCHED THEN 
        INSERT (PacienteSK, MedicoSK, HospitalSK, ServicioSK, num_habitacion, fecha_hora, fecha_alta, diagnostico, tratamiento, dias_ingreso)
        VALUES (sv.PacienteSK, sv.MedicoSK, sv.HospitalSK, sv.ServicioSK, sv.num_habitacion, 
                CASE 
                    WHEN TRY_CONVERT(INT, sv.TiempoSK_FechaHora) IS NOT NULL 
                    THEN DATEFROMPARTS( sv.TiempoSK_FechaHora / 10000, 
                                        (sv.TiempoSK_FechaHora % 10000) / 100, 
                                         sv.TiempoSK_FechaHora % 100 )
                    ELSE NULL
                END,
                CASE 
                    WHEN TRY_CONVERT(INT, sv.TiempoSK_FechaAlta) IS NOT NULL 
                    THEN DATEFROMPARTS( sv.TiempoSK_FechaAlta / 10000, 
                                        (sv.TiempoSK_FechaAlta % 10000) / 100, 
                                         sv.TiempoSK_FechaAlta % 100 )
                    ELSE NULL
                END,
                sv.diagnostico, sv.tratamiento, sv.dias_ingreso
               );

END
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
