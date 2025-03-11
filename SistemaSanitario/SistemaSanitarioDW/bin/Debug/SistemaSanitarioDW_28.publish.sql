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

    MERGE INTO [dbo].[Fact_Visitas] AS fv
    USING [staging].[Visitast] AS sv 
    ON fv.[VisitaSK] = sv.[VisitaSK]

    WHEN MATCHED THEN 
    UPDATE 
    SET fv.[PacienteSK]     = sv.[PacienteSK],
        fv.[MedicoSK]       = sv.[MedicoSK],
        fv.[HospitalSK]     = sv.[HospitalSK],
        fv.[ServicioSK]     = sv.[ServicioSK],
        fv.[TiempoSK]       = CONVERT(INT, FORMAT(sv.[fecha_hora], 'yyyyMMdd')),  -- 🔹 Conversión a INT
        fv.[num_habitacion] = sv.[num_habitacion],
        fv.[fecha_hora]     = sv.[fecha_hora],
        fv.[fecha_alta]     = sv.[fecha_alta],
        fv.[diagnostico]    = sv.[diagnostico],
        fv.[tratamiento]    = sv.[tratamiento],
        fv.[dias_ingreso]   = sv.[dias_ingreso]

    WHEN NOT MATCHED THEN 
    INSERT ([VisitaSK], [PacienteSK], [MedicoSK], [HospitalSK], [ServicioSK], [TiempoSK], [num_habitacion], [fecha_hora], [fecha_alta], [diagnostico], [tratamiento], [dias_ingreso])
    VALUES (sv.[VisitaSK], sv.[PacienteSK], sv.[MedicoSK], sv.[HospitalSK], sv.[ServicioSK], CONVERT(INT, FORMAT(sv.[fecha_hora], 'yyyyMMdd')), sv.[num_habitacion], sv.[fecha_hora], sv.[fecha_alta], sv.[diagnostico], sv.[tratamiento], sv.[dias_ingreso]);

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
              WHERE [TableName] = 'Paciente')
BEGIN
    INSERT [dbo].[PackageConfig] ([TableName], [LastRowVersion]) 
    VALUES ('Paciente', 0)
END
GO

IF NOT EXISTS(SELECT TOP(1) 1 
              FROM [dbo].[PackageConfig] 
              WHERE [TableName] = 'Hospital')
BEGIN
    INSERT [dbo].[PackageConfig] ([TableName], [LastRowVersion]) 
    VALUES ('Hospital', 0)
END
GO

IF NOT EXISTS(SELECT TOP(1) 1 
              FROM [dbo].[PackageConfig] 
              WHERE [TableName] = 'Medico')
BEGIN
    INSERT [dbo].[PackageConfig] ([TableName], [LastRowVersion]) 
    VALUES ('Medico', 0)
END
GO

IF NOT EXISTS(SELECT TOP(1) 1 
              FROM [dbo].[PackageConfig] 
              WHERE [TableName] = 'Servicio')
BEGIN
    INSERT [dbo].[PackageConfig] ([TableName], [LastRowVersion]) 
    VALUES ('Servicio', 0)
END
GO

IF NOT EXISTS(SELECT TOP(1) 1 
              FROM [dbo].[PackageConfig] 
              WHERE [TableName] = 'VisitaMedica')
BEGIN
    INSERT [dbo].[PackageConfig] ([TableName], [LastRowVersion]) 
    VALUES ('VisitaMedica', 0)
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

    INSERT INTO dbo.DimTiempo(TiempoSK
                              ,fecha 
                              ,anio 
                              ,trimestre
                              ,mes 
                              ,dia 
                              ,semana
                              ,dia_mes)
    SELECT 
          TiempoSK       = CONVERT(INT,CONVERT(VARCHAR,dl.FullDate,112))
        , fecha          = dl.FullDate
        , anio           = YEAR(dl.FullDate)
        , trimestre      = DATEPART(qq, dl.FullDate)
        , mes            = MONTH(dl.FullDate)
        , dia            = DATEPART(d, dl.FullDate)
        , semana         = DATEPART(wk, dl.FullDate)
        , dia_mes        = DATEPART(DAY, dl.FullDate)
    FROM @datelist dl
    LEFT OUTER JOIN dbo.Dim_Tiempo dt ON (dl.FullDate = dt.fecha)
    WHERE dt.fecha IS NULL;
    
    COMMIT TRAN
END
GO

IF NOT EXISTS(SELECT TOP(1) 1 
              FROM [dbo].[Dim_Tiempo] 
              WHERE [TiempoSK] = 0)
BEGIN
    INSERT INTO [dbo].[Dim_Tiempo] 
        ([TiempoSK]
        ,[fecha]
        ,[anio]
        ,[trimestre]
        ,[mes]
        ,[dia]
        ,[semana]
        ,[dia_mes])
    VALUES 
        (0, -- Clave de tiempo predeterminada
        GETDATE(), -- Fecha actual como placeholder
        0, -- Año desconocido
        0, -- Trimestre desconocido
        0, -- Mes desconocido
        0, -- Día desconocido
        0, -- Semana desconocida
        0); -- Día del mes desconocido
END
GO

GO

GO
PRINT N'Actualización completada.';


GO
