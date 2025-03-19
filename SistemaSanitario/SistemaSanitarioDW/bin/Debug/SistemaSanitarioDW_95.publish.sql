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
            SET PAGE_VERIFY NONE 
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
PRINT N'La operación de refactorización Cambiar nombre con la clave d3e15a85-7c73-4684-8d04-81df3834a318, dcaeec92-756a-47ec-bd19-1549ba931008 se ha omitido; no se cambiará el nombre del elemento [staging].[Visitast].[fecha_alta] (SqlSimpleColumn) a TiempoSK_FechaAlta';


GO
PRINT N'Creando Esquema [staging]...';


GO
CREATE SCHEMA [staging]
    AUTHORIZATION [dbo];


GO
PRINT N'Creando Tabla [staging].[Hospitalest]...';


GO
CREATE TABLE [staging].[Hospitalest] (
    [codHospital]        INT           NOT NULL,
    [nombre]             VARCHAR (255) NULL,
    [ciudad]             VARCHAR (100) NULL,
    [telefono]           VARCHAR (20)  NULL,
    [director]           VARCHAR (255) NULL,
    [numero_total_camas] INT           NULL,
    PRIMARY KEY CLUSTERED ([codHospital] ASC)
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
PRINT N'Creando Tabla [staging].[Pacientest]...';


GO
CREATE TABLE [staging].[Pacientest] (
    [DNI_PacienteSK]       INT           NOT NULL,
    [apellidos_nombre]     VARCHAR (255) NULL,
    [fecha_nacimiento]     DATE          NULL,
    [num_seguridad_social] VARCHAR (50)  NULL,
    [otros_datos]          TEXT          NULL
);


GO
PRINT N'Creando Tabla [staging].[Visitast]...';


GO
CREATE TABLE [staging].[Visitast] (
    [VisitaSK]           INT           NOT NULL,
    [PacienteSK]         VARCHAR (50)  NULL,
    [MedicoSK]           VARCHAR (50)  NULL,
    [HospitalSK]         INT           NULL,
    [ServicioSK]         NVARCHAR (50) NULL,
    [num_habitacion]     INT           NULL,
    [TiempoSK_FechaHora] INT           NULL,
    [TiempoSK_FechaAlta] INT           NULL,
    [diagnostico]        VARCHAR (MAX) NULL,
    [tratamiento]        VARCHAR (MAX) NULL,
    [dias_ingreso]       INT           NULL,
    [FechaHora]          DATETIME      NULL,
    [FechaAlta]          DATE          NULL
);


GO
PRINT N'Creando Tabla [dbo].[Dim_Hospital]...';


GO
CREATE TABLE [dbo].[Dim_Hospital] (
    [HospitalSK]         INT           IDENTITY (1, 1) NOT NULL,
    [codHospital]        INT           NOT NULL,
    [nombre]             VARCHAR (255) NULL,
    [ciudad]             VARCHAR (255) NULL,
    [telefono]           VARCHAR (50)  NULL,
    [director]           VARCHAR (255) NULL,
    [numero_total_camas] INT           NULL,
    PRIMARY KEY CLUSTERED ([HospitalSK] ASC)
);


GO
PRINT N'Creando Tabla [dbo].[Dim_Medico]...';


GO
CREATE TABLE [dbo].[Dim_Medico] (
    [MedicoSK]           INT           IDENTITY (1, 1) NOT NULL,
    [DNI_Medico]         VARCHAR (20)  NOT NULL,
    [apellidos_nombre]   VARCHAR (255) NULL,
    [fecha_nacimiento]   DATE          NULL,
    [codHospital]        INT           NULL,
    [direccion_hospital] VARCHAR (255) NULL,
    [es_director]        BIT           NULL,
    PRIMARY KEY CLUSTERED ([MedicoSK] ASC)
);


GO
PRINT N'Creando Tabla [dbo].[Dim_Paciente]...';


GO
CREATE TABLE [dbo].[Dim_Paciente] (
    [PacienteSK]           INT           IDENTITY (1, 1) NOT NULL,
    [DNI_Paciente]         VARCHAR (20)  NOT NULL,
    [apellidos_nombre]     VARCHAR (255) NULL,
    [fecha_nacimiento]     DATE          NULL,
    [num_seguridad_social] VARCHAR (50)  NULL,
    [otros_datos]          TEXT          NULL,
    PRIMARY KEY CLUSTERED ([PacienteSK] ASC)
);


GO
PRINT N'Creando Tabla [dbo].[Dim_Servicio]...';


GO
CREATE TABLE [dbo].[Dim_Servicio] (
    [ServicioSK]      INT           IDENTITY (1, 1) NOT NULL,
    [idServicio]      VARCHAR (10)  NOT NULL,
    [nombre_servicio] VARCHAR (255) NULL,
    PRIMARY KEY CLUSTERED ([ServicioSK] ASC)
);


GO
PRINT N'Creando Tabla [dbo].[Dim_Tiempo]...';


GO
CREATE TABLE [dbo].[Dim_Tiempo] (
    [TiempoSK]  INT  NOT NULL,
    [fecha]     DATE NOT NULL,
    [anio]      INT  NOT NULL,
    [trimestre] INT  NOT NULL,
    [mes]       INT  NOT NULL,
    [dia]       INT  NOT NULL,
    [semana]    INT  NOT NULL,
    [dia_mes]   INT  NOT NULL,
    CONSTRAINT [PK_DimTiempo] PRIMARY KEY CLUSTERED ([TiempoSK] ASC),
    UNIQUE NONCLUSTERED ([fecha] ASC)
);


GO
PRINT N'Creando Tabla [dbo].[Fact_Visitas]...';


GO
CREATE TABLE [dbo].[Fact_Visitas] (
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
    PRIMARY KEY CLUSTERED ([VisitaSK] ASC)
);


GO
PRINT N'Creando Tabla [dbo].[PackageConfig]...';


GO
CREATE TABLE [dbo].[PackageConfig] (
    [PackageID]      INT          IDENTITY (1, 1) NOT NULL,
    [TableName]      VARCHAR (50) NOT NULL,
    [LastRowVersion] BIGINT       NULL,
    CONSTRAINT [PK_PackageConfig] PRIMARY KEY CLUSTERED ([PackageID] ASC)
);


GO
PRINT N'Creando Clave externa restricción sin nombre en [dbo].[Fact_Visitas]...';


GO
ALTER TABLE [dbo].[Fact_Visitas] WITH NOCHECK
    ADD FOREIGN KEY ([PacienteSK]) REFERENCES [dbo].[Dim_Paciente] ([PacienteSK]);


GO
PRINT N'Creando Clave externa restricción sin nombre en [dbo].[Fact_Visitas]...';


GO
ALTER TABLE [dbo].[Fact_Visitas] WITH NOCHECK
    ADD FOREIGN KEY ([MedicoSK]) REFERENCES [dbo].[Dim_Medico] ([MedicoSK]);


GO
PRINT N'Creando Clave externa restricción sin nombre en [dbo].[Fact_Visitas]...';


GO
ALTER TABLE [dbo].[Fact_Visitas] WITH NOCHECK
    ADD FOREIGN KEY ([HospitalSK]) REFERENCES [dbo].[Dim_Hospital] ([HospitalSK]);


GO
PRINT N'Creando Clave externa restricción sin nombre en [dbo].[Fact_Visitas]...';


GO
ALTER TABLE [dbo].[Fact_Visitas] WITH NOCHECK
    ADD FOREIGN KEY ([ServicioSK]) REFERENCES [dbo].[Dim_Servicio] ([ServicioSK]);


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
PRINT N'Creando Procedimiento [dbo].[DW_MergeDimHospital]...';


GO
CREATE PROCEDURE [dbo].[DW_MergeDimHospital]
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO [dbo].[Dim_Hospital] AS dh
    USING [staging].[Hospitalest] AS sh
    ON dh.[HospitalSK] = sh.[codHospital]
    WHEN MATCHED THEN
        UPDATE SET 
            dh.[nombre] = sh.[nombre],
            dh.[ciudad] = sh.[ciudad],
            dh.[telefono] = sh.[telefono],
            dh.[director] = sh.[director],
            dh.[numero_total_camas] = sh.[numero_total_camas]
    WHEN NOT MATCHED THEN
        INSERT ([nombre], [ciudad], [telefono], [director], [numero_total_camas])
        VALUES (sh.[nombre], sh.[ciudad], sh.[telefono], sh.[director], sh.[numero_total_camas]);

END
GO
PRINT N'Creando Procedimiento [dbo].[DW_MergeDimMedico]...';


GO
CREATE PROCEDURE [dbo].[DW_MergeDimMedico] 
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
        INSERT ([DNI_Medico], [apellidos_nombre], [fecha_nacimiento], [codHospital], [direccion_hospital], [es_director])
        VALUES (sm.[DNI_MedicoSK], sm.[apellidos_nombre], sm.[fecha_nacimiento], sm.[codHospital], sm.[direccion_hospital], sm.[es_director]);

END
GO
PRINT N'Creando Procedimiento [dbo].[DW_MergeDimPaciente]...';


GO
CREATE PROCEDURE [dbo].[DW_MergeDimPaciente]
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO [dbo].[Dim_Paciente] AS dp
    USING [staging].[Pacientest] AS sp
    ON dp.[PacienteSK] = sp.[DNI_PacienteSK]
    WHEN MATCHED THEN
        UPDATE SET 
            dp.[apellidos_nombre] = sp.[apellidos_nombre],
            dp.[fecha_nacimiento] = sp.[fecha_nacimiento],
            dp.[num_seguridad_social] = sp.[num_seguridad_social],
            dp.[otros_datos] = sp.[otros_datos]
    WHEN NOT MATCHED THEN
        INSERT ([apellidos_nombre], [fecha_nacimiento], [num_seguridad_social], [otros_datos])
        VALUES (sp.[apellidos_nombre], sp.[fecha_nacimiento], sp.[num_seguridad_social], sp.[otros_datos]);

END
GO
PRINT N'Creando Procedimiento [dbo].[DW_MergeDimServicio]...';


GO
CREATE PROCEDURE [dbo].[DW_MergeDimServicio] 
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO [dbo].[Dim_Servicio] AS ds
    USING [staging].[Serviciost] AS ss
    ON ds.[idServicio] = ss.[idServicio]  -- 🔹 Ambas columnas son VARCHAR

    WHEN MATCHED THEN
        UPDATE SET 
            ds.[nombre_servicio] = ss.[nombre_servicio]

    WHEN NOT MATCHED THEN
        INSERT ([idServicio], [nombre_servicio])
        VALUES (ss.[idServicio], ss.[nombre_servicio]);

END
GO
PRINT N'Creando Procedimiento [dbo].[DW_MergeFactVisitas]...';


GO
CREATE PROCEDURE [dbo].[DW_MergeFactVisitas]
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO dbo.Fact_Visitas AS fv
    USING staging.Visitast AS sv
    ON fv.VisitaSK = sv.VisitaSK

    WHEN MATCHED THEN 
        UPDATE 
        SET fv.PacienteSK     = sv.PacienteSK,
            fv.MedicoSK       = sv.MedicoSK,
            fv.HospitalSK     = sv.HospitalSK,
            fv.ServicioSK     = sv.ServicioSK,
            fv.TiempoSK_FechaHora = CONVERT(INT, 
                                    (CONVERT(CHAR(4), DATEPART(YEAR, sv.FechaHora)) +
                                     RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(MONTH, sv.FechaHora)), 2) +
                                     RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(DAY, sv.FechaHora)), 2))
                                    ),
            fv.TiempoSK_FechaAlta = CASE 
                                        WHEN sv.FechaAlta IS NULL THEN 0 
                                        ELSE CONVERT(INT, 
                                            (CONVERT(CHAR(4), DATEPART(YEAR, sv.FechaAlta)) +
                                             RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(MONTH, sv.FechaAlta)), 2) +
                                             RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(DAY, sv.FechaAlta)), 2))
                                        ) 
                                    END,
            fv.num_habitacion = sv.num_habitacion,
            fv.fecha_hora     = sv.FechaHora,
            fv.fecha_alta     = sv.FechaAlta,
            fv.diagnostico    = sv.diagnostico,
            fv.tratamiento    = sv.tratamiento,
            fv.dias_ingreso   = sv.dias_ingreso

    WHEN NOT MATCHED THEN 
        INSERT (VisitaSK, PacienteSK, MedicoSK, HospitalSK, ServicioSK, 
                TiempoSK_FechaHora, TiempoSK_FechaAlta, num_habitacion, 
                fecha_hora, fecha_alta, diagnostico, tratamiento, dias_ingreso)
        VALUES (sv.VisitaSK, sv.PacienteSK, sv.MedicoSK, sv.HospitalSK, sv.ServicioSK, 
                CONVERT(INT, 
                    (CONVERT(CHAR(4), DATEPART(YEAR, sv.FechaHora)) +
                     RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(MONTH, sv.FechaHora)), 2) +
                     RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(DAY, sv.FechaHora)), 2))
                ),
                CASE 
                    WHEN sv.FechaAlta IS NULL THEN 0 
                    ELSE CONVERT(INT, 
                        (CONVERT(CHAR(4), DATEPART(YEAR, sv.FechaAlta)) +
                         RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(MONTH, sv.FechaAlta)), 2) +
                         RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(DAY, sv.FechaAlta)), 2))
                    ) 
                END,
                sv.num_habitacion, sv.FechaHora, sv.FechaAlta, sv.diagnostico, sv.tratamiento, sv.dias_ingreso);

END;
GO
PRINT N'Creando Procedimiento [dbo].[GetLastPackageRowVersion]...';


GO
CREATE PROCEDURE [dbo].[GetLastPackageRowVersion]
(
	@tableName VARCHAR(50)
)
  AS
  BEGIN
	SELECT LastRowVersion
	FROM [dbo].[PackageConfig]
	WHERE TableName = @tableName;
  END
GO
PRINT N'Creando Procedimiento [dbo].[UpdateLastPackageRowVersion]...';


GO
CREATE PROCEDURE [dbo].[UpdateLastPackageRowVersion]
  (
	@tableName VARCHAR(50)
	,@lastRowVersion BIGINT
  )
  AS
  BEGIN
	UPDATE [dbo].[PackageConfig]
	SET LastRowVersion = @lastRowVersion
	WHERE TableName = @tableName;
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
PRINT N'Comprobando los datos existentes con las restricciones recién creadas';


GO
USE [$(DatabaseName)];


GO
CREATE TABLE [#__checkStatus] (
    id           INT            IDENTITY (1, 1) PRIMARY KEY CLUSTERED,
    [Schema]     NVARCHAR (256),
    [Table]      NVARCHAR (256),
    [Constraint] NVARCHAR (256)
);

SET NOCOUNT ON;

DECLARE tableconstraintnames CURSOR LOCAL FORWARD_ONLY
    FOR SELECT SCHEMA_NAME([schema_id]),
               OBJECT_NAME([parent_object_id]),
               [name],
               0
        FROM   [sys].[objects]
        WHERE  [parent_object_id] IN (OBJECT_ID(N'dbo.Fact_Visitas'))
               AND [type] IN (N'F', N'C')
                   AND [object_id] IN (SELECT [object_id]
                                       FROM   [sys].[check_constraints]
                                       WHERE  [is_not_trusted] <> 0
                                              AND [is_disabled] = 0
                                       UNION
                                       SELECT [object_id]
                                       FROM   [sys].[foreign_keys]
                                       WHERE  [is_not_trusted] <> 0
                                              AND [is_disabled] = 0);

DECLARE @schemaname AS NVARCHAR (256);

DECLARE @tablename AS NVARCHAR (256);

DECLARE @checkname AS NVARCHAR (256);

DECLARE @is_not_trusted AS INT;

DECLARE @statement AS NVARCHAR (1024);

BEGIN TRY
    OPEN tableconstraintnames;
    FETCH tableconstraintnames INTO @schemaname, @tablename, @checkname, @is_not_trusted;
    WHILE @@fetch_status = 0
        BEGIN
            PRINT N'Comprobando restricción:' + @checkname + N' [' + @schemaname + N'].[' + @tablename + N']';
            SET @statement = N'ALTER TABLE [' + @schemaname + N'].[' + @tablename + N'] WITH ' + CASE @is_not_trusted WHEN 0 THEN N'CHECK' ELSE N'NOCHECK' END + N' CHECK CONSTRAINT [' + @checkname + N']';
            BEGIN TRY
                EXECUTE [sp_executesql] @statement;
            END TRY
            BEGIN CATCH
                INSERT  [#__checkStatus] ([Schema], [Table], [Constraint])
                VALUES                  (@schemaname, @tablename, @checkname);
            END CATCH
            FETCH tableconstraintnames INTO @schemaname, @tablename, @checkname, @is_not_trusted;
        END
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH

IF CURSOR_STATUS(N'LOCAL', N'tableconstraintnames') >= 0
    CLOSE tableconstraintnames;

IF CURSOR_STATUS(N'LOCAL', N'tableconstraintnames') = -1
    DEALLOCATE tableconstraintnames;

SELECT N'Error de comprobación de restricción:' + [Schema] + N'.' + [Table] + N',' + [Constraint]
FROM   [#__checkStatus];

IF @@ROWCOUNT > 0
    BEGIN
        DROP TABLE [#__checkStatus];
        RAISERROR (N'Error al comprobar las restricciones', 16, 127);
    END

SET NOCOUNT OFF;

DROP TABLE [#__checkStatus];


GO
PRINT N'Actualización completada.';


GO
