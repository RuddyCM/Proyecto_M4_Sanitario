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
El tipo de la columna ciudad en la tabla [dbo].[Dim_Hospital] es  NVARCHAR (255) NULL, pero se va a cambiar a  VARCHAR (255) NULL. Si la columna contiene datos no compatibles con el tipo  VARCHAR (255) NULL, podrían producirse pérdidas de datos y errores en la implementación.

El tipo de la columna director en la tabla [dbo].[Dim_Hospital] es  NVARCHAR (255) NULL, pero se va a cambiar a  VARCHAR (255) NULL. Si la columna contiene datos no compatibles con el tipo  VARCHAR (255) NULL, podrían producirse pérdidas de datos y errores en la implementación.
*/

IF EXISTS (select top 1 1 from [dbo].[Dim_Hospital])
    RAISERROR (N'Se detectaron filas. La actualización del esquema va a terminar debido a una posible pérdida de datos.', 16, 127) WITH NOWAIT

GO
/*
El tipo de la columna apellidos_nombre en la tabla [dbo].[Dim_Medico] es  NVARCHAR (255) NULL, pero se va a cambiar a  VARCHAR (255) NULL. Si la columna contiene datos no compatibles con el tipo  VARCHAR (255) NULL, podrían producirse pérdidas de datos y errores en la implementación.

El tipo de la columna direccion_hospital en la tabla [dbo].[Dim_Medico] es  NVARCHAR (255) NULL, pero se va a cambiar a  VARCHAR (255) NULL. Si la columna contiene datos no compatibles con el tipo  VARCHAR (255) NULL, podrían producirse pérdidas de datos y errores en la implementación.
*/

IF EXISTS (select top 1 1 from [dbo].[Dim_Medico])
    RAISERROR (N'Se detectaron filas. La actualización del esquema va a terminar debido a una posible pérdida de datos.', 16, 127) WITH NOWAIT

GO
PRINT N'Quitando Restricción UNIQUE restricción sin nombre en [dbo].[Dim_Medico]...';


GO
ALTER TABLE [dbo].[Dim_Medico] DROP CONSTRAINT [UQ__Dim_Medi__25DD5F725FBF67D2];


GO
PRINT N'Modificando Tabla [dbo].[Dim_Hospital]...';


GO
ALTER TABLE [dbo].[Dim_Hospital] ALTER COLUMN [ciudad] VARCHAR (255) NULL;

ALTER TABLE [dbo].[Dim_Hospital] ALTER COLUMN [director] VARCHAR (255) NULL;


GO
PRINT N'Modificando Tabla [dbo].[Dim_Medico]...';


GO
ALTER TABLE [dbo].[Dim_Medico] ALTER COLUMN [apellidos_nombre] VARCHAR (255) NULL;

ALTER TABLE [dbo].[Dim_Medico] ALTER COLUMN [direccion_hospital] VARCHAR (255) NULL;


GO
PRINT N'Modificando Procedimiento [dbo].[DW_MergeDimMedico]...';


GO
ALTER PROCEDURE [dbo].[DW_MergeDimMedico]
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO [dbo].[Dim_Medico] AS dm
    USING [staging].[Medicost] AS sm
    ON dm.[MedicoSK] = sm.[DNI_MedicoSK]
    WHEN MATCHED THEN
        UPDATE SET 
            dm.[apellidos_nombre] = sm.[apellidos_nombre],
            dm.[fecha_nacimiento] = sm.[fecha_nacimiento],
            dm.[codHospital] = sm.[codHospital],
            dm.[direccion_hospital] = sm.[direccion_hospital],
            dm.[es_director] = sm.[es_director]
    WHEN NOT MATCHED THEN
        INSERT ([apellidos_nombre], [fecha_nacimiento], [codHospital], [direccion_hospital], [es_director])
        VALUES (sm.[apellidos_nombre], sm.[fecha_nacimiento], sm.[codHospital], sm.[direccion_hospital], sm.[es_director]);

END
GO
PRINT N'Actualizando Procedimiento [dbo].[DW_MergeDimHospital]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[DW_MergeDimHospital]';


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
