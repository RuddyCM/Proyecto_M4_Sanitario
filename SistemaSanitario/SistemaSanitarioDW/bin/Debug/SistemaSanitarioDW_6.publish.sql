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
El tipo de la columna codHospital en la tabla [dbo].[Dim_Hospital] es  VARCHAR (20) NOT NULL, pero se va a cambiar a  INT NOT NULL. Si la columna contiene datos no compatibles con el tipo  INT NOT NULL, podrían producirse pérdidas de datos y errores en la implementación.
*/

IF EXISTS (select top 1 1 from [dbo].[Dim_Hospital])
    RAISERROR (N'Se detectaron filas. La actualización del esquema va a terminar debido a una posible pérdida de datos.', 16, 127) WITH NOWAIT

GO
/*
El tipo de la columna codHospital en la tabla [dbo].[Dim_Medico] es  VARCHAR (20) NULL, pero se va a cambiar a  INT NULL. Si la columna contiene datos no compatibles con el tipo  INT NULL, podrían producirse pérdidas de datos y errores en la implementación.
*/

IF EXISTS (select top 1 1 from [dbo].[Dim_Medico])
    RAISERROR (N'Se detectaron filas. La actualización del esquema va a terminar debido a una posible pérdida de datos.', 16, 127) WITH NOWAIT

GO
/*
Se está quitando la columna [dbo].[Dim_Servicio].[descripcion]; puede que se pierdan datos.

El tipo de la columna idServicio en la tabla [dbo].[Dim_Servicio] es  VARCHAR (20) NOT NULL, pero se va a cambiar a  VARCHAR (10) NOT NULL. Si la columna contiene datos no compatibles con el tipo  VARCHAR (10) NOT NULL, podrían producirse pérdidas de datos y errores en la implementación.
*/

IF EXISTS (select top 1 1 from [dbo].[Dim_Servicio])
    RAISERROR (N'Se detectaron filas. La actualización del esquema va a terminar debido a una posible pérdida de datos.', 16, 127) WITH NOWAIT

GO
/*
Se está quitando la columna [dbo].[Dim_Tiempo].[año]; puede que se pierdan datos.

Se está quitando la columna [dbo].[Dim_Tiempo].[día]; puede que se pierdan datos.

Se está quitando la columna [dbo].[Dim_Tiempo].[día_mes]; puede que se pierdan datos.

Se está quitando la columna [dbo].[Dim_Tiempo].[idFecha]; puede que se pierdan datos.

Se está quitando la columna [dbo].[Dim_Tiempo].[nombre_mes]; puede que se pierdan datos.

La columna fecha de la tabla [dbo].[Dim_Tiempo] debe cambiarse de NULL a NOT NULL. Si la tabla contiene datos, puede que no funcione el script ALTER. Para evitar esta incidencia, debe agregar valores en todas las filas de esta columna, marcar la columna de modo que permita valores NULL o habilitar la generación de valores predeterminados inteligentes como opción de implementación.
*/

IF EXISTS (select top 1 1 from [dbo].[Dim_Tiempo])
    RAISERROR (N'Se detectaron filas. La actualización del esquema va a terminar debido a una posible pérdida de datos.', 16, 127) WITH NOWAIT

GO
/*
Se está quitando la columna [dbo].[Fact_Visitas].[codHospital]; puede que se pierdan datos.

Se está quitando la columna [dbo].[Fact_Visitas].[costo_servicio]; puede que se pierdan datos.

Se está quitando la columna [dbo].[Fact_Visitas].[DNI_Medico]; puede que se pierdan datos.

Se está quitando la columna [dbo].[Fact_Visitas].[DNI_Paciente]; puede que se pierdan datos.

Se está quitando la columna [dbo].[Fact_Visitas].[idServicio]; puede que se pierdan datos.

Se está quitando la columna [dbo].[Fact_Visitas].[idVisita]; puede que se pierdan datos.

El tipo de la columna fecha_hora en la tabla [dbo].[Fact_Visitas] es  INT NULL, pero se va a cambiar a  DATETIME NULL. Si la columna contiene datos no compatibles con el tipo  DATETIME NULL, podrían producirse pérdidas de datos y errores en la implementación.
*/

IF EXISTS (select top 1 1 from [dbo].[Fact_Visitas])
    RAISERROR (N'Se detectaron filas. La actualización del esquema va a terminar debido a una posible pérdida de datos.', 16, 127) WITH NOWAIT

GO
PRINT N'Quitando Clave externa restricción sin nombre en [dbo].[Fact_Visitas]...';


GO
ALTER TABLE [dbo].[Fact_Visitas] DROP CONSTRAINT [FK__Fact_Visi__codHo__4316F928];


GO
PRINT N'Quitando Clave externa restricción sin nombre en [dbo].[Fact_Visitas]...';


GO
ALTER TABLE [dbo].[Fact_Visitas] DROP CONSTRAINT [FK__Fact_Visi__DNI_M__45F365D3];


GO
PRINT N'Quitando Clave externa restricción sin nombre en [dbo].[Fact_Visitas]...';


GO
ALTER TABLE [dbo].[Fact_Visitas] DROP CONSTRAINT [FK__Fact_Visi__DNI_P__44FF419A];


GO
PRINT N'Quitando Clave externa restricción sin nombre en [dbo].[Fact_Visitas]...';


GO
ALTER TABLE [dbo].[Fact_Visitas] DROP CONSTRAINT [FK__Fact_Visi__idSer__440B1D61];


GO
PRINT N'Quitando Clave externa restricción sin nombre en [dbo].[Fact_Visitas]...';


GO
ALTER TABLE [dbo].[Fact_Visitas] DROP CONSTRAINT [FK__Fact_Visi__fecha__46E78A0C];


GO
PRINT N'Iniciando recompilación de la tabla [dbo].[Dim_Hospital]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Dim_Hospital] (
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

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Dim_Hospital])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Dim_Hospital] ([codHospital], [nombre], [ciudad], [telefono], [director], [numero_total_camas])
        SELECT [codHospital],
               [nombre],
               [ciudad],
               [telefono],
               [director],
               [numero_total_camas]
        FROM   [dbo].[Dim_Hospital];
    END

DROP TABLE [dbo].[Dim_Hospital];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Dim_Hospital]', N'Dim_Hospital';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Iniciando recompilación de la tabla [dbo].[Dim_Medico]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Dim_Medico] (
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

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Dim_Medico])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Dim_Medico] ([DNI_Medico], [apellidos_nombre], [fecha_nacimiento], [codHospital], [direccion_hospital], [es_director])
        SELECT [DNI_Medico],
               [apellidos_nombre],
               [fecha_nacimiento],
               [codHospital],
               CAST ([direccion_hospital] AS NVARCHAR (255)),
               [es_director]
        FROM   [dbo].[Dim_Medico];
    END

DROP TABLE [dbo].[Dim_Medico];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Dim_Medico]', N'Dim_Medico';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Iniciando recompilación de la tabla [dbo].[Dim_Paciente]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Dim_Paciente] (
    [PacienteSK]           INT            IDENTITY (1, 1) NOT NULL,
    [DNI_Paciente]         VARCHAR (20)   NOT NULL,
    [apellidos_nombre]     NVARCHAR (255) NULL,
    [fecha_nacimiento]     DATE           NULL,
    [num_seguridad_social] VARCHAR (50)   NULL,
    [otros_datos]          TEXT           NULL,
    PRIMARY KEY CLUSTERED ([PacienteSK] ASC),
    UNIQUE NONCLUSTERED ([DNI_Paciente] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Dim_Paciente])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Dim_Paciente] ([DNI_Paciente], [apellidos_nombre], [fecha_nacimiento], [num_seguridad_social], [otros_datos])
        SELECT [DNI_Paciente],
               [apellidos_nombre],
               [fecha_nacimiento],
               [num_seguridad_social],
               [otros_datos]
        FROM   [dbo].[Dim_Paciente];
    END

DROP TABLE [dbo].[Dim_Paciente];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Dim_Paciente]', N'Dim_Paciente';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Iniciando recompilación de la tabla [dbo].[Dim_Servicio]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Dim_Servicio] (
    [ServicioSK]      INT            IDENTITY (1, 1) NOT NULL,
    [idServicio]      VARCHAR (10)   NOT NULL,
    [nombre_servicio] NVARCHAR (255) NULL,
    PRIMARY KEY CLUSTERED ([ServicioSK] ASC),
    UNIQUE NONCLUSTERED ([idServicio] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Dim_Servicio])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Dim_Servicio] ([idServicio], [nombre_servicio])
        SELECT [idServicio],
               [nombre_servicio]
        FROM   [dbo].[Dim_Servicio];
    END

DROP TABLE [dbo].[Dim_Servicio];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Dim_Servicio]', N'Dim_Servicio';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Iniciando recompilación de la tabla [dbo].[Dim_Tiempo]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Dim_Tiempo] (
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

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Dim_Tiempo])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Dim_Tiempo] ([fecha], [trimestre], [mes], [semana])
        SELECT [fecha],
               [trimestre],
               [mes],
               [semana]
        FROM   [dbo].[Dim_Tiempo];
    END

DROP TABLE [dbo].[Dim_Tiempo];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Dim_Tiempo]', N'Dim_Tiempo';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Iniciando recompilación de la tabla [dbo].[Fact_Visitas]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Fact_Visitas] (
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

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Fact_Visitas])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Fact_Visitas] ([num_habitacion], [fecha_hora], [fecha_alta], [diagnostico], [tratamiento], [dias_ingreso])
        SELECT [num_habitacion],
               [fecha_hora],
               [fecha_alta],
               [diagnostico],
               [tratamiento],
               [dias_ingreso]
        FROM   [dbo].[Fact_Visitas];
    END

DROP TABLE [dbo].[Fact_Visitas];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Fact_Visitas]', N'Fact_Visitas';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


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
