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
La columna VisitaSK de la tabla [dbo].[Fact_Visitas] debe cambiarse de NULL a NOT NULL. Si la tabla contiene datos, puede que no funcione el script ALTER. Para evitar esta incidencia, debe agregar valores en todas las filas de esta columna, marcar la columna de modo que permita valores NULL o habilitar la generación de valores predeterminados inteligentes como opción de implementación.
*/

IF EXISTS (select top 1 1 from [dbo].[Fact_Visitas])
    RAISERROR (N'Se detectaron filas. La actualización del esquema va a terminar debido a una posible pérdida de datos.', 16, 127) WITH NOWAIT

GO
PRINT N'Quitando Clave externa restricción sin nombre en [dbo].[Fact_Visitas]...';


GO
ALTER TABLE [dbo].[Fact_Visitas] DROP CONSTRAINT [FK__Fact_Visi__Pacie__59063A47];


GO
PRINT N'Quitando Clave externa restricción sin nombre en [dbo].[Fact_Visitas]...';


GO
ALTER TABLE [dbo].[Fact_Visitas] DROP CONSTRAINT [FK__Fact_Visi__Medic__59FA5E80];


GO
PRINT N'Quitando Clave externa restricción sin nombre en [dbo].[Fact_Visitas]...';


GO
ALTER TABLE [dbo].[Fact_Visitas] DROP CONSTRAINT [FK__Fact_Visi__Hospi__5AEE82B9];


GO
PRINT N'Quitando Clave externa restricción sin nombre en [dbo].[Fact_Visitas]...';


GO
ALTER TABLE [dbo].[Fact_Visitas] DROP CONSTRAINT [FK__Fact_Visi__Servi__5BE2A6F2];


GO
PRINT N'Quitando Clave externa [dbo].[FK_Dim_Tiempo_TiempoSK_FechaHora]...';


GO
ALTER TABLE [dbo].[Fact_Visitas] DROP CONSTRAINT [FK_Dim_Tiempo_TiempoSK_FechaHora];


GO
PRINT N'Quitando Clave externa [dbo].[FK_Dim_Tiempo_TiempoSK_FechaAlta]...';


GO
ALTER TABLE [dbo].[Fact_Visitas] DROP CONSTRAINT [FK_Dim_Tiempo_TiempoSK_FechaAlta];


GO
PRINT N'Iniciando recompilación de la tabla [dbo].[Fact_Visitas]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Fact_Visitas] (
    [VisitaSK]           INT      IDENTITY (1, 1) NOT NULL,
    [PacienteSK]         INT      NULL,
    [MedicoSK]           INT      NULL,
    [HospitalSK]         INT      NULL,
    [ServicioSK]         INT      NULL,
    [TiempoSK_FechaHora] INT      NULL,
    [TiempoSK_FechaAlta] INT      NULL,
    [num_habitacion]     INT      NULL,
    [fecha_hora]         DATETIME NULL,
    [fecha_alta]         DATE     NULL,
    [diagnostico]        TEXT     NULL,
    [tratamiento]        TEXT     NULL,
    [dias_ingreso]       INT      NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_Fact_Visitas1] PRIMARY KEY CLUSTERED ([VisitaSK] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Fact_Visitas])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Fact_Visitas] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Fact_Visitas] ([VisitaSK], [PacienteSK], [MedicoSK], [HospitalSK], [ServicioSK], [TiempoSK_FechaHora], [TiempoSK_FechaAlta], [num_habitacion], [fecha_hora], [fecha_alta], [diagnostico], [tratamiento], [dias_ingreso])
        SELECT   [VisitaSK],
                 [PacienteSK],
                 [MedicoSK],
                 [HospitalSK],
                 [ServicioSK],
                 [TiempoSK_FechaHora],
                 [TiempoSK_FechaAlta],
                 [num_habitacion],
                 [fecha_hora],
                 [fecha_alta],
                 [diagnostico],
                 [tratamiento],
                 [dias_ingreso]
        FROM     [dbo].[Fact_Visitas]
        ORDER BY [VisitaSK] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Fact_Visitas] OFF;
    END

DROP TABLE [dbo].[Fact_Visitas];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Fact_Visitas]', N'Fact_Visitas';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_Fact_Visitas1]', N'PK_Fact_Visitas', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creando Clave externa [dbo].[FK_Dim_Tiempo_TiempoSK_FechaHora]...';


GO
ALTER TABLE [dbo].[Fact_Visitas] WITH NOCHECK
    ADD CONSTRAINT [FK_Dim_Tiempo_TiempoSK_FechaHora] FOREIGN KEY ([TiempoSK_FechaHora]) REFERENCES [dbo].[Dim_Tiempo] ([TiempoSK]);


GO
PRINT N'Creando Clave externa [dbo].[FK_Dim_Tiempo_TiempoSK_FechaAlta]...';


GO
ALTER TABLE [dbo].[Fact_Visitas] WITH NOCHECK
    ADD CONSTRAINT [FK_Dim_Tiempo_TiempoSK_FechaAlta] FOREIGN KEY ([TiempoSK_FechaAlta]) REFERENCES [dbo].[Dim_Tiempo] ([TiempoSK]);


GO
PRINT N'Creando Clave externa [dbo].[FK_Dim_Paciente]...';


GO
ALTER TABLE [dbo].[Fact_Visitas] WITH NOCHECK
    ADD CONSTRAINT [FK_Dim_Paciente] FOREIGN KEY ([PacienteSK]) REFERENCES [dbo].[Dim_Paciente] ([PacienteSK]);


GO
PRINT N'Creando Clave externa [dbo].[FK_Dim_Medico]...';


GO
ALTER TABLE [dbo].[Fact_Visitas] WITH NOCHECK
    ADD CONSTRAINT [FK_Dim_Medico] FOREIGN KEY ([MedicoSK]) REFERENCES [dbo].[Dim_Medico] ([MedicoSK]);


GO
PRINT N'Creando Clave externa [dbo].[FK_Dim_Hospital]...';


GO
ALTER TABLE [dbo].[Fact_Visitas] WITH NOCHECK
    ADD CONSTRAINT [FK_Dim_Hospital] FOREIGN KEY ([HospitalSK]) REFERENCES [dbo].[Dim_Hospital] ([HospitalSK]);


GO
PRINT N'Creando Clave externa [dbo].[FK_Dim_Servicio]...';


GO
ALTER TABLE [dbo].[Fact_Visitas] WITH NOCHECK
    ADD CONSTRAINT [FK_Dim_Servicio] FOREIGN KEY ([ServicioSK]) REFERENCES [dbo].[Dim_Servicio] ([ServicioSK]);


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
            ORDER By TiempoSK ASC;
        END

    WHILE (@startdate <= @enddate)
    BEGIN 
        INSERT INTO @datelist(FullDate)
        SELECT @startdate

        SET @startdate = DATEADD(dd,1,@startdate);
    END

    -- 🚀 Aquí agregamos la generación del TiempoSK
    INSERT INTO dbo.Dim_Tiempo(TiempoSK, fecha, anio, trimestre, mes, dia, semana, dia_mes)
    SELECT 
        -- Generamos un identificador único para TiempoSK usando la fecha como número entero
        CONVERT(INT, CONVERT(VARCHAR, dl.FullDate, 112)), 
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
PRINT N'Comprobando los datos existentes con las restricciones recién creadas';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[Fact_Visitas] WITH CHECK CHECK CONSTRAINT [FK_Dim_Tiempo_TiempoSK_FechaHora];

ALTER TABLE [dbo].[Fact_Visitas] WITH CHECK CHECK CONSTRAINT [FK_Dim_Tiempo_TiempoSK_FechaAlta];

ALTER TABLE [dbo].[Fact_Visitas] WITH CHECK CHECK CONSTRAINT [FK_Dim_Paciente];

ALTER TABLE [dbo].[Fact_Visitas] WITH CHECK CHECK CONSTRAINT [FK_Dim_Medico];

ALTER TABLE [dbo].[Fact_Visitas] WITH CHECK CHECK CONSTRAINT [FK_Dim_Hospital];

ALTER TABLE [dbo].[Fact_Visitas] WITH CHECK CHECK CONSTRAINT [FK_Dim_Servicio];


GO
PRINT N'Actualización completada.';


GO
