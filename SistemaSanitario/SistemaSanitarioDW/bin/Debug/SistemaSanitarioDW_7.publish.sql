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
PRINT N'Creando Tabla [dbo].[Dim_Hospital]...';


GO
CREATE TABLE [dbo].[Dim_Hospital] (
    [HospitalSK]         INT            IDENTITY (1, 1) NOT NULL,
    [codHospital]        INT            NOT NULL,
    [nombre]             NVARCHAR (255) NULL,
    [ciudad]             NVARCHAR (255) NULL,
    [telefono]           VARCHAR (50)   NULL,
    [director]           NVARCHAR (255) NULL,
    [numero_total_camas] INT            NULL,
    PRIMARY KEY CLUSTERED ([HospitalSK] ASC),
    UNIQUE NONCLUSTERED ([codHospital] ASC)
);


GO
PRINT N'Creando Tabla [dbo].[Dim_Medico]...';


GO
CREATE TABLE [dbo].[Dim_Medico] (
    [MedicoSK]           INT            IDENTITY (1, 1) NOT NULL,
    [DNI_Medico]         VARCHAR (20)   NOT NULL,
    [apellidos_nombre]   NVARCHAR (255) NULL,
    [fecha_nacimiento]   DATE           NULL,
    [codHospital]        INT            NULL,
    [direccion_hospital] NVARCHAR (255) NULL,
    [es_director]        BIT            NULL,
    PRIMARY KEY CLUSTERED ([MedicoSK] ASC),
    UNIQUE NONCLUSTERED ([DNI_Medico] ASC)
);


GO
PRINT N'Creando Tabla [dbo].[Dim_Paciente]...';


GO
CREATE TABLE [dbo].[Dim_Paciente] (
    [PacienteSK]           INT            IDENTITY (1, 1) NOT NULL,
    [DNI_Paciente]         VARCHAR (20)   NOT NULL,
    [apellidos_nombre]     NVARCHAR (255) NULL,
    [fecha_nacimiento]     DATE           NULL,
    [num_seguridad_social] VARCHAR (50)   NULL,
    [otros_datos]          TEXT           NULL,
    PRIMARY KEY CLUSTERED ([PacienteSK] ASC),
    UNIQUE NONCLUSTERED ([DNI_Paciente] ASC)
);


GO
PRINT N'Creando Tabla [dbo].[Dim_Servicio]...';


GO
CREATE TABLE [dbo].[Dim_Servicio] (
    [ServicioSK]      INT            IDENTITY (1, 1) NOT NULL,
    [idServicio]      VARCHAR (10)   NOT NULL,
    [nombre_servicio] NVARCHAR (255) NULL,
    PRIMARY KEY CLUSTERED ([ServicioSK] ASC),
    UNIQUE NONCLUSTERED ([idServicio] ASC)
);


GO
PRINT N'Creando Tabla [dbo].[Dim_Tiempo]...';


GO
CREATE TABLE [dbo].[Dim_Tiempo] (
    [TiempoSK]  INT  IDENTITY (1, 1) NOT NULL,
    [fecha]     DATE NOT NULL,
    [anio]      INT  NULL,
    [trimestre] INT  NULL,
    [mes]       INT  NULL,
    [dia]       INT  NULL,
    [semana]    INT  NULL,
    [dia_mes]   INT  NULL,
    PRIMARY KEY CLUSTERED ([TiempoSK] ASC),
    UNIQUE NONCLUSTERED ([fecha] ASC)
);


GO
PRINT N'Creando Tabla [dbo].[Fact_Visitas]...';


GO
CREATE TABLE [dbo].[Fact_Visitas] (
    [VisitaSK]       INT      IDENTITY (1, 1) NOT NULL,
    [PacienteSK]     INT      NULL,
    [MedicoSK]       INT      NULL,
    [HospitalSK]     INT      NULL,
    [ServicioSK]     INT      NULL,
    [TiempoSK]       INT      NULL,
    [num_habitacion] INT      NULL,
    [fecha_hora]     DATETIME NULL,
    [fecha_alta]     DATE     NULL,
    [diagnostico]    TEXT     NULL,
    [tratamiento]    TEXT     NULL,
    [dias_ingreso]   INT      NULL,
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
PRINT N'Creando Clave externa restricción sin nombre en [dbo].[Fact_Visitas]...';


GO
ALTER TABLE [dbo].[Fact_Visitas] WITH NOCHECK
    ADD FOREIGN KEY ([TiempoSK]) REFERENCES [dbo].[Dim_Tiempo] ([TiempoSK]);


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
