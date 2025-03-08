/*
Script de implementación para BDsanitarioOLTP

Una herramienta generó este código.
Los cambios realizados en este archivo podrían generar un comportamiento incorrecto y se perderán si
se vuelve a generar el código.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "BDsanitarioOLTP"
:setvar DefaultFilePrefix "BDsanitarioOLTP"
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
PRINT N'Creando Esquema [Administracion]...';


GO
CREATE SCHEMA [Administracion]
    AUTHORIZATION [dbo];


GO
PRINT N'Creando Esquema [Pacientes]...';


GO
CREATE SCHEMA [Pacientes]
    AUTHORIZATION [dbo];


GO
PRINT N'Creando Esquema [Servicios]...';


GO
CREATE SCHEMA [Servicios]
    AUTHORIZATION [dbo];


GO
PRINT N'Creando Tabla [Administracion].[Medico]...';


GO
CREATE TABLE [Administracion].[Medico] (
    [DNI]              VARCHAR (20)  NOT NULL,
    [apellidos_nombre] VARCHAR (150) NOT NULL,
    [fecha_nacimiento] DATE          NOT NULL,
    [codHospital]      INT           NOT NULL,
    [esDirector]       BIT           NULL,
    CONSTRAINT [PK_Medico] PRIMARY KEY CLUSTERED ([DNI] ASC)
);


GO
PRINT N'Creando Tabla [Administracion].[Medico_Servicio]...';


GO
CREATE TABLE [Administracion].[Medico_Servicio] (
    [DNI_Medico]  VARCHAR (20) NOT NULL,
    [idServicio]  VARCHAR (10) NOT NULL,
    [codHospital] INT          NOT NULL,
    CONSTRAINT [PK_Medico_Servicio] PRIMARY KEY CLUSTERED ([DNI_Medico] ASC, [idServicio] ASC, [codHospital] ASC)
);


GO
PRINT N'Creando Tabla [Administracion].[Hospital]...';


GO
CREATE TABLE [Administracion].[Hospital] (
    [codHospital]  INT           NOT NULL,
    [nombre]       VARCHAR (100) NOT NULL,
    [ciudad]       VARCHAR (100) NOT NULL,
    [telefono]     VARCHAR (20)  NOT NULL,
    [DNI_Director] VARCHAR (20)  NULL,
    CONSTRAINT [PK_Hospital] PRIMARY KEY CLUSTERED ([codHospital] ASC)
);


GO
PRINT N'Creando Tabla [Pacientes].[Paciente]...';


GO
CREATE TABLE [Pacientes].[Paciente] (
    [DNI_Paciente]         VARCHAR (20)  NOT NULL,
    [apellidos_nombre]     VARCHAR (150) NOT NULL,
    [fecha_nacimiento]     DATE          NOT NULL,
    [num_seguridad_social] VARCHAR (20)  NOT NULL,
    CONSTRAINT [PK_Paciente] PRIMARY KEY CLUSTERED ([DNI_Paciente] ASC)
);


GO
PRINT N'Creando Tabla [Pacientes].[HistoriaClinica]...';


GO
CREATE TABLE [Pacientes].[HistoriaClinica] (
    [codHist]      INT          IDENTITY (1, 1) NOT NULL,
    [DNI_Paciente] VARCHAR (20) NOT NULL,
    CONSTRAINT [PK_HistoriaClinica] PRIMARY KEY CLUSTERED ([codHist] ASC)
);


GO
PRINT N'Creando Tabla [Pacientes].[VisitaMedica]...';


GO
CREATE TABLE [Pacientes].[VisitaMedica] (
    [idVisita]       INT          IDENTITY (1, 1) NOT NULL,
    [fecha_hora]     DATETIME     NOT NULL,
    [codHospital]    INT          NOT NULL,
    [idServicio]     VARCHAR (10) NOT NULL,
    [DNI_Medico]     VARCHAR (20) NOT NULL,
    [codHist]        INT          NULL,
    [diagnostico]    TEXT         NOT NULL,
    [tratamiento]    TEXT         NOT NULL,
    [num_habitacion] INT          NULL,
    [fecha_alta]     DATE         NULL,
    CONSTRAINT [PK_VisitaMedica] PRIMARY KEY CLUSTERED ([idVisita] ASC)
);


GO
PRINT N'Creando Tabla [Servicios].[Servicio]...';


GO
CREATE TABLE [Servicios].[Servicio] (
    [idServicio]  VARCHAR (10)  NOT NULL,
    [nombre]      VARCHAR (100) NOT NULL,
    [descripcion] TEXT          NULL,
    CONSTRAINT [PK_Servicio] PRIMARY KEY CLUSTERED ([idServicio] ASC)
);


GO
PRINT N'Creando Tabla [Servicios].[Hospital_Servicio]...';


GO
CREATE TABLE [Servicios].[Hospital_Servicio] (
    [codHospital] INT          NOT NULL,
    [idServicio]  VARCHAR (10) NOT NULL,
    [num_camas]   INT          NULL,
    CONSTRAINT [PK_Hospital_Servicio] PRIMARY KEY CLUSTERED ([codHospital] ASC, [idServicio] ASC)
);


GO
PRINT N'Creando Restricción DEFAULT restricción sin nombre en [Administracion].[Medico]...';


GO
ALTER TABLE [Administracion].[Medico]
    ADD DEFAULT 0 FOR [esDirector];


GO
PRINT N'Creando Restricción DEFAULT restricción sin nombre en [Servicios].[Hospital_Servicio]...';


GO
ALTER TABLE [Servicios].[Hospital_Servicio]
    ADD DEFAULT 0 FOR [num_camas];


GO
PRINT N'Creando Clave externa [Administracion].[FK_Medico_Medico_Servicio]...';


GO
ALTER TABLE [Administracion].[Medico_Servicio] WITH NOCHECK
    ADD CONSTRAINT [FK_Medico_Medico_Servicio] FOREIGN KEY ([DNI_Medico]) REFERENCES [Administracion].[Medico] ([DNI]) ON DELETE CASCADE;


GO
PRINT N'Creando Clave externa [Administracion].[FK_Servicio_Medico_Servicio]...';


GO
ALTER TABLE [Administracion].[Medico_Servicio] WITH NOCHECK
    ADD CONSTRAINT [FK_Servicio_Medico_Servicio] FOREIGN KEY ([idServicio]) REFERENCES [Servicios].[Servicio] ([idServicio]);


GO
PRINT N'Creando Clave externa [Administracion].[FK_Hospital_Medico_Servicio]...';


GO
ALTER TABLE [Administracion].[Medico_Servicio] WITH NOCHECK
    ADD CONSTRAINT [FK_Hospital_Medico_Servicio] FOREIGN KEY ([codHospital]) REFERENCES [Administracion].[Hospital] ([codHospital]);


GO
PRINT N'Creando Clave externa [Administracion].[FK_Hospital_Medico]...';


GO
ALTER TABLE [Administracion].[Hospital] WITH NOCHECK
    ADD CONSTRAINT [FK_Hospital_Medico] FOREIGN KEY ([DNI_Director]) REFERENCES [Administracion].[Medico] ([DNI]) ON DELETE SET NULL;


GO
PRINT N'Creando Clave externa [Pacientes].[FK_Paciente_HistoriaClinica]...';


GO
ALTER TABLE [Pacientes].[HistoriaClinica] WITH NOCHECK
    ADD CONSTRAINT [FK_Paciente_HistoriaClinica] FOREIGN KEY ([DNI_Paciente]) REFERENCES [Pacientes].[Paciente] ([DNI_Paciente]) ON DELETE CASCADE;


GO
PRINT N'Creando Clave externa [Pacientes].[FK_Hospital_VisitaMedica]...';


GO
ALTER TABLE [Pacientes].[VisitaMedica] WITH NOCHECK
    ADD CONSTRAINT [FK_Hospital_VisitaMedica] FOREIGN KEY ([codHospital]) REFERENCES [Administracion].[Hospital] ([codHospital]);


GO
PRINT N'Creando Clave externa [Pacientes].[FK_Servicio_VisitaMedica]...';


GO
ALTER TABLE [Pacientes].[VisitaMedica] WITH NOCHECK
    ADD CONSTRAINT [FK_Servicio_VisitaMedica] FOREIGN KEY ([idServicio]) REFERENCES [Servicios].[Servicio] ([idServicio]);


GO
PRINT N'Creando Clave externa [Pacientes].[FK_Medico_VisitaMedica]...';


GO
ALTER TABLE [Pacientes].[VisitaMedica] WITH NOCHECK
    ADD CONSTRAINT [FK_Medico_VisitaMedica] FOREIGN KEY ([DNI_Medico]) REFERENCES [Administracion].[Medico] ([DNI]);


GO
PRINT N'Creando Clave externa [Pacientes].[FK_HistoriaClinica_VisitaMedica]...';


GO
ALTER TABLE [Pacientes].[VisitaMedica] WITH NOCHECK
    ADD CONSTRAINT [FK_HistoriaClinica_VisitaMedica] FOREIGN KEY ([codHist]) REFERENCES [Pacientes].[HistoriaClinica] ([codHist]) ON DELETE SET NULL;


GO
PRINT N'Creando Clave externa [Servicios].[FK_Hospital_Hospital_Servicio]...';


GO
ALTER TABLE [Servicios].[Hospital_Servicio] WITH NOCHECK
    ADD CONSTRAINT [FK_Hospital_Hospital_Servicio] FOREIGN KEY ([codHospital]) REFERENCES [Administracion].[Hospital] ([codHospital]) ON DELETE CASCADE;


GO
PRINT N'Creando Clave externa [Servicios].[FK_Servicio_Hospital_Servicio]...';


GO
ALTER TABLE [Servicios].[Hospital_Servicio] WITH NOCHECK
    ADD CONSTRAINT [FK_Servicio_Hospital_Servicio] FOREIGN KEY ([idServicio]) REFERENCES [Servicios].[Servicio] ([idServicio]) ON DELETE CASCADE;


GO
PRINT 'Populating database with initial data...';
SET NOCOUNT ON;

-- 1. Insertar servicios (No tiene dependencias)
PRINT 'Populating Servicios.Servicio table';
SET NOCOUNT ON;
INSERT INTO Servicios.Servicio (idServicio, nombre, descripcion) VALUES ('SERV01', 'Teacher, music', 'Libero nobis ullam sed aliquam nihil.');
INSERT INTO Servicios.Servicio (idServicio, nombre, descripcion) VALUES ('SERV02', 'Data processing manager', 'Expedita voluptatibus quae officia.');
INSERT INTO Servicios.Servicio (idServicio, nombre, descripcion) VALUES ('SERV03', 'Theatre director', 'Accusamus excepturi voluptates a.');
INSERT INTO Servicios.Servicio (idServicio, nombre, descripcion) VALUES ('SERV04', 'Arts administrator', 'Incidunt repudiandae ratione.');
INSERT INTO Servicios.Servicio (idServicio, nombre, descripcion) VALUES ('SERV05', 'Patent examiner', 'Quis ducimus aperiam optio.');


-- 2. Insertar hospitales (No tiene dependencias)
PRINT 'Populating Administracion.Hospital table';
SET NOCOUNT ON;
INSERT INTO Administracion.Hospital (codHospital, nombre, ciudad, telefono, DNI_Director) VALUES (1, 'Cazorla, Hernando and Valenciano', 'Santa Cruz de Tenerife', '+34719 457 584', 7402147);
INSERT INTO Administracion.Hospital (codHospital, nombre, ciudad, telefono, DNI_Director) VALUES (2, 'Gámez LLC', 'Barcelona', '+34621332989', 35303697);
INSERT INTO Administracion.Hospital (codHospital, nombre, ciudad, telefono, DNI_Director) VALUES (3, 'Cabello LLC', 'Cuenca', '+34 720 734 231', 58807118);
INSERT INTO Administracion.Hospital (codHospital, nombre, ciudad, telefono, DNI_Director) VALUES (4, 'Abad-Ríos', 'Soria', '+34 749 14 83 50', 26775577);
INSERT INTO Administracion.Hospital (codHospital, nombre, ciudad, telefono, DNI_Director) VALUES (5, 'Sarabia, Aguilar and Vendrell', 'La Coruña', '+34749 99 69 06', 3357301);
INSERT INTO Administracion.Hospital (codHospital, nombre, ciudad, telefono, DNI_Director) VALUES (6, 'Riquelme-Bernad', 'Teruel', '+34 622897319', 23456901);
INSERT INTO Administracion.Hospital (codHospital, nombre, ciudad, telefono, DNI_Director) VALUES (7, 'Madrid Group', 'Cádiz', '+34 723 31 33 19', 25089541);
INSERT INTO Administracion.Hospital (codHospital, nombre, ciudad, telefono, DNI_Director) VALUES (8, 'Ribera, Mate and Somoza', 'Jaén', '+34706964078', 1237997);
INSERT INTO Administracion.Hospital (codHospital, nombre, ciudad, telefono, DNI_Director) VALUES (9, 'Abril Inc', 'Valladolid', '+34728 255 346', 6467537);
INSERT INTO Administracion.Hospital (codHospital, nombre, ciudad, telefono, DNI_Director) VALUES (10, 'Ropero, Palomo and Verdugo', 'Granada', '+34731 123 640', 36413869);


-- 3. Insertar médicos (Depende de hospitales)
PRINT 'Populating Administracion.Medico table';
SET NOCOUNT ON;
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('59339518', 'Natividad Uribe', '1990-06-11', 6, 0);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('12107986', 'Simón del Amigó', '1968-06-21', 2, 0);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('36413869', 'Agustín de Español', '1979-06-10', 10, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('2519467', 'Micaela Larrea Sabater', '1966-11-18', 2, 0);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('82700030', 'Clemente Isern Padilla', '1994-07-18', 9, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('6467537', 'Nerea Belmonte Sevillano', '1965-07-28', 9, 0);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('9684214', 'Rosenda Polo-Esparza', '1965-10-27', 5, 0);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('27217280', 'Hilda Llano Viana', '1974-10-01', 1, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('7402147', 'Rufina Valle Portillo', '1963-03-11', 1, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('17253062', 'Plácido Paredes Téllez', '1983-11-11', 9, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('2999153', 'Manolo Duran-Fuertes', '1963-01-23', 10, 0);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('96353304', 'Celestino Pelayo Cervantes Porcel', '1965-05-05', 6, 0);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('83006024', 'Bibiana Cerro Mur', '1963-05-05', 6, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('15739125', 'Vilma Falcó Piquer', '1978-04-03', 5, 0);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('25301670', 'Clarisa de Gallego', '1972-11-05', 5, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('27110702', 'Dulce Baeza-Cortés', '1987-02-07', 2, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('65510215', 'Dionisia Cabrero Ortiz', '1998-11-04', 9, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('96708421', 'Bibiana Garrido Salmerón', '1970-12-27', 5, 0);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('86909002', 'Félix Juliá-Garmendia', '1994-09-29', 9, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('44312046', 'Teodosio Uribe Suárez', '1994-03-16', 1, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('99754418', 'Jesús del Ferrández', '1972-02-03', 8, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('23456901', 'Roberta Paredes Cabeza', '1983-07-13', 6, 0);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('33055948', 'Teo Damián Enríquez Castell', '1962-07-14', 7, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('8503366', 'Nilo Canals Pulido', '1970-06-20', 10, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('25089541', 'Godofredo Caballero', '1994-11-26', 7, 0);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('85449907', 'Yaiza Becerra Céspedes', '1969-12-18', 9, 0);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('51111661', 'Concepción Rivera Gras', '1989-01-18', 10, 0);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('53269785', 'Celia Flor-Gutierrez', '1981-03-08', 10, 0);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('1237997', 'Ana Sofía Ferrández Doménech', '1970-06-10', 8, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('3357301', 'Dorotea del Uría', '1990-04-11', 5, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('27510100', 'Curro Nuñez Montes', '1995-06-30', 7, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('98741936', 'Javi Bustamante-Miguel', '1995-10-08', 2, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('29273251', 'Fausto Camps', '1999-11-05', 6, 0);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('99484137', 'José Antonio Agudo Ibarra', '1994-08-10', 8, 0);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('88227149', 'Aureliano Andres Melero', '1985-01-13', 8, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('52194975', 'Roxana Checa Bustos', '1998-06-30', 2, 0);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('41709987', 'Donato Royo Lastra', '1969-04-06', 5, 0);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('78024457', 'Jenny Castrillo Llorens', '1979-02-24', 5, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('26775577', 'Isaías Gárate Aparicio', '1959-12-05', 4, 0);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('57959437', 'Noelia Bautista Osuna', '1989-12-05', 3, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('90974980', 'Felicidad Hidalgo Giralt', '1998-11-20', 4, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('21622291', 'Palmira Castilla Madrigal', '1996-09-10', 9, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('69385561', 'Isidora Tejada Sans', '1964-11-07', 8, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('50830206', 'Jorge del Cordero', '1972-07-02', 7, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('64798509', 'Rosario Ochoa-Iborra', '1998-06-24', 5, 0);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('58807118', 'Rubén Escolano Bou', '1983-11-21', 3, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('68448391', 'Plácido Leocadio Espejo Tapia', '1978-06-14', 10, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('35066437', 'Dominga Adán Riba', '1975-05-30', 2, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('56938083', 'Odalys Lorenzo Cruz', '1969-11-17', 7, 1);
INSERT INTO Administracion.Medico (DNI, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('35303697', 'José Mari Clavero Casares', '1985-05-17', 2, 1);


-- 4. Relación hospital-servicio (Depende de hospitales y servicios)
PRINT 'Populating Servicios.Hospital_Servicio table';
SET NOCOUNT ON;
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (1, 'SERV01', 16);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (1, 'SERV02', 5);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (1, 'SERV03', 13);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (1, 'SERV04', 5);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (1, 'SERV05', 5);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (2, 'SERV01', 14);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (2, 'SERV02', 6);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (2, 'SERV03', 15);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (2, 'SERV04', 10);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (2, 'SERV05', 9);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (3, 'SERV01', 8);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (3, 'SERV02', 8);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (3, 'SERV03', 16);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (3, 'SERV04', 7);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (3, 'SERV05', 5);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (4, 'SERV01', 18);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (4, 'SERV02', 6);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (4, 'SERV03', 7);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (4, 'SERV04', 5);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (4, 'SERV05', 6);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (5, 'SERV01', 18);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (5, 'SERV02', 16);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (5, 'SERV03', 8);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (5, 'SERV04', 13);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (5, 'SERV05', 6);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (6, 'SERV01', 13);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (6, 'SERV02', 13);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (6, 'SERV03', 10);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (6, 'SERV04', 6);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (6, 'SERV05', 17);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (7, 'SERV01', 15);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (7, 'SERV02', 16);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (7, 'SERV03', 9);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (7, 'SERV04', 12);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (7, 'SERV05', 7);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (8, 'SERV01', 20);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (8, 'SERV02', 6);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (8, 'SERV03', 5);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (8, 'SERV04', 17);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (8, 'SERV05', 13);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (9, 'SERV01', 8);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (9, 'SERV02', 12);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (9, 'SERV03', 15);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (9, 'SERV04', 7);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (9, 'SERV05', 18);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (10, 'SERV01', 12);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (10, 'SERV02', 5);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (10, 'SERV03', 19);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (10, 'SERV04', 10);
INSERT INTO Servicios.Hospital_Servicio (codHospital, idServicio, num_camas) VALUES (10, 'SERV05', 6);


-- 5. Relación médico-servicio (Depende de médicos, hospitales y servicios)
PRINT 'Populating Administracion.Medico_Servicio table';
SET NOCOUNT ON;
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('59339518', 'SERV02', 6);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('12107986', 'SERV02', 2);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('36413869', 'SERV01', 10);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('2519467', 'SERV01', 2);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('82700030', 'SERV01', 9);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('6467537', 'SERV02', 9);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('9684214', 'SERV04', 5);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('27217280', 'SERV01', 1);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('7402147', 'SERV01', 1);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('17253062', 'SERV04', 9);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('2999153', 'SERV03', 10);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('96353304', 'SERV05', 6);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('83006024', 'SERV03', 6);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('15739125', 'SERV03', 5);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('25301670', 'SERV04', 5);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('27110702', 'SERV03', 2);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('65510215', 'SERV05', 9);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('96708421', 'SERV05', 5);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('86909002', 'SERV01', 9);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('44312046', 'SERV02', 1);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('99754418', 'SERV04', 8);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('23456901', 'SERV03', 6);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('33055948', 'SERV02', 7);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('8503366', 'SERV04', 10);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('25089541', 'SERV03', 7);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('85449907', 'SERV01', 9);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('51111661', 'SERV04', 10);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('53269785', 'SERV05', 10);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('1237997', 'SERV03', 8);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('3357301', 'SERV04', 5);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('27510100', 'SERV02', 7);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('98741936', 'SERV02', 2);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('29273251', 'SERV04', 6);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('99484137', 'SERV01', 8);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('88227149', 'SERV01', 8);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('52194975', 'SERV03', 2);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('41709987', 'SERV03', 5);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('78024457', 'SERV04', 5);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('26775577', 'SERV04', 4);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('57959437', 'SERV05', 3);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('90974980', 'SERV05', 4);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('21622291', 'SERV04', 9);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('69385561', 'SERV05', 8);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('50830206', 'SERV04', 7);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('64798509', 'SERV02', 5);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('58807118', 'SERV05', 3);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('68448391', 'SERV02', 10);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('35066437', 'SERV03', 2);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('56938083', 'SERV03', 7);
INSERT INTO Administracion.Medico_Servicio (DNI_Medico, idServicio, codHospital) VALUES ('35303697', 'SERV01', 2);


-- 6. Insertar pacientes (No tiene dependencias)
PRINT 'Populating Pacientes.Paciente table';
SET NOCOUNT ON;
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('84890623', 'Guadalupe Reyes Portillo', '1952-01-22', '4770213033');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('40487706', 'Etelvina Alberdi Valderrama', '1974-05-11', '9144804348');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('85297971', 'Borja Puerta Amigó', '2000-11-12', '6689889630');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('69094818', 'Calisto de Figuerola', '1933-05-12', '2964271840');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('87739144', 'Marcelo Recio-Solís', '1964-08-08', '9310115142');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('71218551', 'Obdulia Olivé', '2019-02-26', '7961673768');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('65495872', 'Jose Bueno Noriega', '2004-07-28', '5148138905');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('51145684', 'Isabela Gelabert-Solís', '1977-02-02', '76779737');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('73059940', 'Camila Otero Rebollo', '1952-10-27', '7135251941');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('22694583', 'Dan Riquelme Trillo', '1944-04-04', '9524021248');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('49511432', 'Íñigo Lastra', '1969-08-28', '2083327764');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('89576638', 'Lorenza Olivares Roda', '2016-09-02', '7175930312');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('732836', 'Remigio Rosselló', '2013-03-18', '2012834748');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('23027480', 'Iris Gallego-Baró', '1982-10-23', '6917711874');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('80766024', 'Esmeralda Méndez', '1942-11-29', '8926407468');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('35652620', 'Herminia Castell', '1971-07-01', '8200539801');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('41490914', 'Cayetano Silvestre Juan Ribas', '1928-07-28', '7289665535');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('17350097', 'Elpidio Hoyos Casas', '1987-05-18', '1706561303');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('71572960', 'Cosme Matas', '2018-07-27', '4463020763');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('95914365', 'Tatiana Catalá Salom', '2019-03-22', '8502361148');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('98229739', 'Lupe Company Rojas', '2003-03-15', '6946651944');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('87790236', 'Elodia Vallejo Bartolomé', '1959-07-09', '1810044690');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('89646580', 'Mamen Bautista Cabello', '1981-04-10', '9182787332');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('65338628', 'Eliseo Vidal Anguita', '2010-01-12', '6717186698');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('29653669', 'Rodolfo Río-Serna', '2021-08-22', '8553881356');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('80067097', 'Dulce Angelita Simó Palma', '1983-09-23', '5989067192');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('13571183', 'Ignacia Manuel Leal', '1967-11-26', '1801958597');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('7761219', 'Virgilio Pelayo Ródenas', '1940-02-28', '9256839775');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('60468213', 'Darío Valbuena Cal', '1957-06-24', '4048008714');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('72927664', 'Hilda Huerta Piñol', '1928-12-19', '6088270522');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('353317', 'Severo Chus Bertrán Diaz', '1966-10-23', '8450100940');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('86081008', 'Mar del Pellicer', '1974-07-09', '7854707366');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('89791205', 'Benigno Rodríguez-Garcia', '1944-05-24', '5381736869');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('59314993', 'José Mari del Cobo', '1941-04-01', '1101482348');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('79655933', 'Oriana Tejera Villalobos', '1940-09-27', '3943209502');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('81000655', 'Aurelio Azcona Hernandez', '1986-07-31', '3117777685');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('9796749', 'Severo Eustaquio Torralba Carrasco', '2001-06-01', '5673853730');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('40801631', 'Yésica Salgado Valera', '1981-07-20', '4123035775');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('62059732', 'Angelina Bermejo-Peral', '2022-11-06', '5159018772');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('83630254', 'Macario Comas Hierro', '1939-03-24', '3596164998');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('72361444', 'Teobaldo Contreras Cámara', '1958-10-25', '6334583163');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('18691860', 'Domitila Romero Aroca', '1998-03-02', '8460380303');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('59650636', 'Jaime Yáñez', '2024-11-04', '854542199');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('58946793', 'Aitor Grande', '1943-10-09', '6281460497');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('87800974', 'Berto Oliver-Barrio', '2023-07-17', '2589719367');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('58628618', 'Víctor Azcona Zamora', '1957-12-09', '1637006984');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('57106785', 'Rosalía del Giménez', '1986-04-16', '569530873');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('18810019', 'Macarena Alsina Porta', '1980-06-09', '6096250174');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('68060095', 'Ignacio Saavedra-Elías', '1957-08-01', '93376160');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('81150009', 'Paula Nogueira', '1950-09-26', '8902262531');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('46322230', 'Benito del Español', '1955-05-30', '7088451592');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('46059646', 'Rita Cid Calderon', '2022-01-02', '9099605481');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('87396355', 'Graciano Mascaró Blasco', '1958-12-29', '1210555426');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('97444542', 'Gerardo Simó-Benito', '1975-09-25', '6299228010');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('39448332', 'Ainoa de Soriano', '1952-09-28', '7233220461');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('20353914', 'Florentina Diez Márquez', '1932-01-11', '7243536196');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('62041795', 'Ruben Gaya Campos', '1986-12-23', '4737437911');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('74899527', 'Camilo Puerta', '1928-03-20', '539101415');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('23745850', 'Roberto Vélez', '1991-08-14', '1394983877');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('82904803', 'Ariel Casanova Sobrino', '2017-04-18', '7690808233');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('58528349', 'Juan José Moreno Peralta', '1978-12-11', '4416025385');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('48723110', 'Nacio de Gámez', '1986-05-03', '9511423038');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('72066590', 'Angelita Román Báez', '2024-11-07', '1628399960');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('54999342', 'Lorenzo Peña Cantón', '1946-02-02', '2235216978');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('65827608', 'Jesús Olegario Bonilla Pavón', '1982-02-02', '5362674906');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('32428941', 'Zaida Juárez Olivera', '1965-02-16', '3239825693');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('8199742', 'Lucio de Zorrilla', '1949-05-05', '1232616691');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('57198013', 'Gilberto del Planas', '2023-08-20', '9186770276');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('49948989', 'Luisina Higueras Borja', '1982-11-06', '6487544630');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('94084274', 'Íñigo Menendez Sanz', '1927-12-08', '2007300131');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('15115525', 'Rebeca Cámara Fiol', '2016-11-10', '3262105787');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('16762516', 'Maristela del Puente', '1977-04-08', '5576716459');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('93366171', 'Edelmiro Figueras-Azcona', '2000-04-25', '8484730385');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('9331304', 'Pacífica Valbuena-Marquez', '1961-08-27', '5092775630');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('56069834', 'Sigfrido Pagès Soler', '1956-04-04', '4812805128');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('56611016', 'Eduardo Figueroa Isern', '1976-01-27', '6143688197');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('97125766', 'Zaira Prats Nuñez', '2004-09-11', '2560836014');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('40010746', 'Sofía Bas Girona', '1957-04-05', '7456355369');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('55404448', 'Celia Perlita Andreu Carrión', '1969-08-21', '864999468');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('67595779', 'Nydia Parra Guitart', '1956-11-10', '4052385126');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('34093913', 'Marcela Cuadrado Morante', '2004-07-31', '7188499833');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('31263808', 'Gilberto España Méndez', '2024-05-10', '3250350452');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('97942775', 'María Carmen María Teresa Ballester Ocaña', '2001-09-27', '7376538296');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('24887192', 'Casandra Alonso-Andrade', '2012-09-04', '2558896148');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('24755264', 'Marcelo Eusebio Giménez Lloret', '1961-07-06', '9958839111');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('45475926', 'Simón Toño Ferrer Morata', '1930-04-02', '1231364663');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('56690108', 'Virgilio Benavente Bustamante', '2023-12-30', '905420039');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('13249748', 'Román Hernandez Bernad', '2022-03-23', '7742975903');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('87367111', 'Ceferino Vicens', '2007-03-09', '124623765');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('94056640', 'Amador Sales', '2020-01-01', '5052963432');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('9145129', 'Dolores Fortuny Hurtado', '1991-01-25', '1625890418');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('82302284', 'Armando Hidalgo Bauzà', '1959-05-25', '4622752217');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('58540216', 'Lorenzo Puente-Prieto', '1963-08-22', '8291317543');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('56724569', 'Adora Gallart', '2019-07-31', '3164856262');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('92290448', 'Nazaret Vilaplana', '1986-05-15', '1091013213');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('32952924', 'Silvio Ortuño Pinilla', '1935-02-01', '3007179483');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('61143143', 'Chita Paula Moll Nogués', '1949-09-06', '8149419857');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('46442628', 'Carla Blázquez Amador', '1927-08-22', '4546634496');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('55201866', 'Noa Olmo Ribas', '1985-11-28', '4109322258');
INSERT INTO Pacientes.Paciente (DNI_Paciente, apellidos_nombre, fecha_nacimiento, num_seguridad_social) VALUES ('65893668', 'Manuel Cardona Salamanca', '1977-08-29', '1023740842');


-- 7. Insertar historias clínicas (Depende de pacientes)
PRINT 'Populating Pacientes.HistoriaClinica table';
SET NOCOUNT ON;
SET IDENTITY_INSERT Pacientes.VisitaMedica OFF;

SET IDENTITY_INSERT Pacientes.HistoriaClinica ON;
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (186, '84890623');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (18, '40487706');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (189, '85297971');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (71, '69094818');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (190, '87739144');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (150, '71218551');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (158, '65495872');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (108, '51145684');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (100, '73059940');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (93, '22694583');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (82, '49511432');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (97, '89576638');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (190, '732836');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (48, '23027480');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (81, '80766024');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (2, '35652620');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (190, '41490914');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (40, '17350097');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (168, '71572960');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (146, '95914365');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (50, '98229739');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (63, '87790236');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (40, '89646580');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (105, '65338628');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (46, '29653669');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (126, '80067097');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (163, '13571183');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (193, '7761219');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (193, '60468213');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (135, '72927664');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (31, '353317');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (95, '86081008');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (49, '89791205');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (115, '59314993');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (146, '79655933');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (126, '81000655');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (48, '9796749');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (119, '40801631');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (160, '62059732');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (107, '83630254');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (31, '72361444');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (84, '18691860');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (90, '59650636');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (97, '58946793');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (146, '87800974');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (179, '58628618');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (94, '57106785');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (97, '18810019');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (41, '68060095');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (45, '81150009');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (118, '46322230');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (132, '46059646');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (93, '87396355');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (180, '97444542');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (89, '39448332');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (177, '20353914');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (14, '62041795');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (56, '74899527');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (82, '23745850');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (22, '82904803');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (181, '58528349');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (95, '48723110');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (197, '72066590');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (124, '54999342');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (144, '65827608');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (71, '32428941');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (6, '8199742');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (168, '57198013');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (136, '49948989');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (174, '94084274');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (190, '15115525');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (58, '16762516');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (53, '93366171');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (187, '9331304');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (109, '56069834');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (79, '56611016');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (79, '97125766');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (76, '40010746');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (47, '55404448');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (69, '67595779');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (61, '34093913');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (62, '31263808');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (95, '97942775');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (42, '24887192');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (85, '24755264');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (149, '45475926');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (36, '56690108');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (177, '13249748');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (52, '87367111');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (73, '94056640');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (21, '9145129');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (124, '82302284');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (198, '58540216');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (48, '56724569');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (185, '92290448');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (6, '32952924');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (73, '61143143');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (164, '46442628');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (199, '55201866');
INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente) VALUES (94, '65893668');


SET IDENTITY_INSERT Pacientes.HistoriaClinica OFF;


-- 8. Insertar visitas médicas (Depende de médicos, historias clínicas, hospitales y servicios)
PRINT 'Populating Pacientes.VisitaMedica table';
SET NOCOUNT ON;

SET IDENTITY_INSERT Pacientes.VisitaMedica ON;
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (2, '2025-02-13 19:22:26', 7, 'SERV04', '25089541', 95, 'Ullam dolorum ipsa doloribus. Reiciendis quisquam iusto iusto. Quam ullam nulla.', 'Placeat dicta corporis labore neque suscipit molestias dicta. Amet dolores cumque harum doloremque.', 428, '2025-01-28');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (357, '2025-01-11 04:40:02', 2, 'SERV03', '52194975', 40, 'Architecto aspernatur adipisci magni rerum.', 'Excepturi a ab inventore quos. Rem quod debitis aperiam.', 388, '2025-02-09');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (319, '2025-01-21 02:57:07', 9, 'SERV01', '65510215', 58, 'Accusamus doloremque ducimus itaque voluptate. Fugit quas et tempora rem id praesentium.', 'Porro officiis perspiciatis aliquam illum harum similique.', 158, '2025-01-03');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (86, '2025-01-08 15:32:40', 8, 'SERV04', '69385561', 146, 'Illum consectetur et ullam. Ducimus optio sapiente perferendis non animi quia.', 'Consectetur praesentium inventore. Repellendus aliquam rem nesciunt quo hic.', 185, '2025-01-22');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (313, '2025-01-09 10:49:11', 9, 'SERV01', '17253062', 119, 'Numquam quas repellendus quos nesciunt itaque. Distinctio earum porro.', 'Inventore eos doloremque ducimus soluta perspiciatis. Aliquid eos pariatur error porro earum.', 138, '2025-02-14');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (54, '2025-01-04 07:02:36', 2, 'SERV04', '35303697', 124, 'Reiciendis omnis officiis quidem unde consequuntur. Ut sint sunt vitae inventore nemo.', 'Tenetur nemo debitis. Excepturi id harum aperiam labore pariatur.', 414, '2025-01-04');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (377, '2025-03-05 18:06:19', 8, 'SERV04', '69385561', 89, 'Hic blanditiis alias fugit numquam magni.', 'Omnis nemo ipsam suscipit nobis nam. Eius ex voluptas sequi.', 447, '2025-01-14');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (332, '2025-01-15 05:34:30', 2, 'SERV02', '12107986', 53, 'Doloribus ex eveniet laboriosam totam maxime placeat. Cum expedita nihil sunt animi hic suscipit.', 'Tenetur sapiente harum voluptates. Fugiat minima recusandae explicabo.', 470, '2025-02-16');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (270, '2025-02-27 12:10:01', 8, 'SERV03', '99484137', 94, 'Ab nesciunt distinctio molestias ea. Vero ducimus fugiat vitae porro.', 'Dignissimos fuga minima at maxime pariatur provident asperiores. Molestias cumque iste asperiores.', 307, '2025-02-26');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (249, '2025-01-04 21:10:08', 6, 'SERV01', '29273251', 193, 'Voluptatum distinctio earum atque ipsum. Consequatur consequatur veniam mollitia.', 'Delectus fuga voluptate perspiciatis blanditiis.', 175, '2025-01-21');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (311, '2025-01-05 10:25:25', 2, 'SERV05', '35066437', 126, 'Pariatur commodi ea id a. A minus nihil in recusandae magnam.', 'Itaque modi itaque. Incidunt maiores ipsam minima.', 212, '2025-02-19');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (223, '2025-01-27 04:05:55', 9, 'SERV02', '85449907', 168, 'Deserunt veniam et repudiandae odio consectetur inventore.', 'Ut non dolorem natus. Natus exercitationem minima totam debitis.', 227, '2025-01-13');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (234, '2025-02-16 21:01:25', 9, 'SERV01', '6467537', 45, 'Modi fugiat perferendis quaerat. Itaque voluptatibus illum veniam.', 'Ad accusamus totam ab quos. Maiores totam non explicabo dolor. Et doloribus officia minima earum.', 206, '2025-01-21');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (386, '2025-02-01 02:08:13', 2, 'SERV03', '98741936', 31, 'Eaque eaque aperiam perferendis. Minima alias unde debitis.', 'Suscipit neque placeat.', 330, '2025-01-18');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (316, '2025-02-01 04:45:44', 10, 'SERV01', '53269785', 146, 'Magni repellendus corrupti ratione et inventore. Ipsa suscipit doloremque atque in tempora.', 'Veniam iste voluptates eaque illo quidem. Soluta distinctio praesentium cupiditate.', 293, '2025-01-26');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (274, '2025-01-05 13:53:29', 6, 'SERV03', '29273251', 146, 'Sed quo architecto odit velit tenetur.', 'Ipsam blanditiis quod.', 317, '2025-01-14');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (80, '2025-01-05 07:42:58', 9, 'SERV03', '86909002', 163, 'Incidunt vel at.', 'Voluptates hic facilis. Iure odit expedita molestiae sequi expedita voluptatum.', 424, '2025-02-07');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (193, '2025-01-09 01:05:15', 9, 'SERV04', '6467537', 50, 'Reprehenderit numquam beatae fuga dolorum excepturi. Aut fugit error repellat.', 'Quibusdam ab quaerat quisquam qui consequatur consequatur.', 182, '2025-01-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (178, '2025-03-02 11:41:20', 1, 'SERV02', '27217280', 69, 'Voluptates odio eligendi nisi. Optio molestias ab reprehenderit.', 'Facere fugiat qui corrupti. Quibusdam perspiciatis quaerat quia.', 398, '2025-02-25');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (143, '2025-01-05 22:18:57', 2, 'SERV01', '27110702', 190, 'Dolores eligendi quidem nulla atque sunt qui. Tenetur cumque dolores hic reiciendis ipsa similique.', 'Placeat modi veniam natus sit voluptatem quod. Hic harum reiciendis sed repellat dolores quidem.', 202, '2025-01-13');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (228, '2025-01-01 17:17:51', 6, 'SERV02', '59339518', 85, 'Labore facere ea quisquam. Repudiandae doloremque optio ipsa voluptatem porro a exercitationem.', 'Corporis fuga quis impedit ut velit. Voluptatum assumenda maiores asperiores est.', 387, '2025-02-21');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (109, '2025-02-15 00:32:23', 1, 'SERV04', '7402147', 97, 'At nobis pariatur ut. Quasi facere veritatis dolores dolorem modi nisi.', 'Praesentium eum expedita iste totam pariatur laborum.', 155, '2025-02-19');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (202, '2025-03-04 08:47:20', 5, 'SERV03', '3357301', 150, 'Distinctio in delectus consectetur. Totam molestiae aperiam.', 'Pariatur blanditiis quasi vitae cum. Excepturi id magnam hic.', 298, '2025-02-27');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (95, '2025-01-15 20:12:53', 10, 'SERV04', '51111661', 126, 'Neque minus a ab eum delectus. Est incidunt accusamus. Odio non facilis illum.', 'Soluta temporibus unde provident vel. Eligendi laboriosam blanditiis blanditiis id tenetur.', 418, '2025-02-18');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (64, '2025-02-28 06:41:00', 8, 'SERV02', '69385561', 73, 'Aliquid eaque minus. Alias maiores illum cum tenetur quisquam voluptatibus.', 'Ea deserunt dicta accusamus blanditiis illo. Ab saepe consequatur.', 190, '2025-02-06');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (260, '2025-02-15 10:06:37', 8, 'SERV01', '99484137', 47, 'Enim expedita sunt expedita exercitationem ad impedit.', 'Cumque eaque eligendi deleniti incidunt possimus velit. Possimus nemo tenetur ea.', 362, '2025-02-27');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (290, '2025-01-28 14:27:27', 5, 'SERV02', '78024457', 40, 'Et sunt fugit placeat recusandae ipsum.', 'Accusantium nisi pariatur aspernatur.', 144, '2025-02-14');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (251, '2025-01-18 20:04:05', 9, 'SERV02', '17253062', 160, 'Ducimus totam ducimus molestiae dolor debitis. Sequi qui non ea modi quo itaque.', 'Ad nobis alias non perferendis a. Nisi iusto a cupiditate.', 293, '2025-02-21');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (272, '2025-01-07 04:08:17', 6, 'SERV01', '83006024', 163, 'Quam accusamus reiciendis consectetur. At eveniet nemo eveniet magnam.', 'Amet quidem deserunt eum. Amet provident enim fugit.', 132, '2025-02-15');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (207, '2025-02-03 10:09:54', 2, 'SERV05', '52194975', 107, 'Quod velit optio repellendus. Temporibus perspiciatis natus beatae explicabo consequuntur.', 'Architecto distinctio fugit soluta. Facilis officiis nostrum vero aliquam nesciunt.', 234, '2025-02-28');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (99, '2025-01-10 08:10:01', 4, 'SERV05', '90974980', 190, 'Impedit ducimus rem. Iusto reiciendis accusamus quaerat.
Ducimus atque porro optio iusto est.', 'Minus velit non ex. Odio ipsam dolores illum.', 278, '2025-02-07');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (63, '2025-01-18 08:47:13', 10, 'SERV01', '2999153', 146, 'Optio quo est voluptatem sit ratione maxime. Quia totam assumenda ipsa excepturi non sapiente.', 'Ea earum tempore tenetur vitae quas iste. Ea quidem ea deserunt.', 489, '2025-01-23');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (10, '2025-02-10 04:54:45', 5, 'SERV05', '3357301', 190, 'In esse ad adipisci rerum itaque numquam. Fugiat dicta quos dolores placeat saepe.', 'Commodi magnam quia repudiandae architecto quisquam. Ad dolores sed.', 122, '2025-02-21');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (319, '2025-03-02 23:23:04', 4, 'SERV02', '26775577', 73, 'Id quis doloribus minus. Quisquam sunt minus id.', 'Laborum unde esse.', 176, '2025-01-06');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (281, '2025-03-02 17:25:56', 9, 'SERV02', '17253062', 107, 'Cumque beatae voluptate ipsa sapiente beatae cumque.
Eum quae et cumque saepe.', 'Reprehenderit cum odio. Ipsam in nobis.', 499, '2025-01-23');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (51, '2025-01-24 16:49:56', 6, 'SERV03', '59339518', 6, 'Error nam non dolore. Sapiente illo magnam aliquam tempora nemo.', 'In veniam reprehenderit ratione. Est reprehenderit voluptatum doloremque perferendis debitis.', 378, '2025-01-06');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (201, '2025-01-13 12:34:27', 9, 'SERV05', '17253062', 58, 'Amet iure eos nemo excepturi earum. Corrupti voluptas labore iste quia fuga soluta.', 'Ipsum aspernatur commodi dicta. Commodi commodi inventore architecto soluta et.', 166, '2025-01-03');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (344, '2025-01-20 23:30:52', 9, 'SERV01', '17253062', 124, 'Suscipit explicabo hic hic nemo unde accusamus.', 'Dolores at occaecati dolores quisquam quos eos. Ipsam eligendi unde cum deleniti.', 390, '2025-03-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (65, '2025-01-20 15:33:20', 5, 'SERV01', '9684214', 61, 'Unde praesentium sint eius tempore quas aut.
Vel delectus qui quia officiis quos.', 'Illo quidem aliquam nemo architecto. Quae modi porro officiis quis quidem.', 186, '2025-02-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (161, '2025-02-04 04:06:55', 7, 'SERV05', '50830206', 95, 'Quia sint nesciunt eos ea laborum sed. Accusamus nostrum sequi accusamus accusamus quam.', 'Deleniti tempora fugit ullam. A harum recusandae asperiores ipsum porro quis maiores.', 154, '2025-02-28');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (346, '2025-01-14 12:57:28', 1, 'SERV01', '27217280', 95, 'Iusto dolor neque quis porro nesciunt. Atque assumenda ipsa qui fugiat reiciendis dolore molestias.', 'Aut dolores ipsum placeat quas porro debitis. At repellat fugit iste.
Voluptate voluptas qui.', 435, '2025-01-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (349, '2025-02-10 10:45:35', 6, 'SERV01', '29273251', 18, 'Ratione corporis corrupti quis repellendus. At iusto quisquam atque autem earum.', 'Eos dolorum harum necessitatibus dicta. Distinctio consequatur commodi non consectetur tenetur.', 219, '2025-02-18');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (387, '2025-02-27 11:51:07', 9, 'SERV01', '21622291', 56, 'Voluptatem illo corporis voluptates. Quod distinctio iure vitae deserunt.', 'Non laborum ipsam quam a nulla.', 130, '2025-01-11');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (9, '2025-01-22 05:52:43', 6, 'SERV05', '23456901', 58, 'Mollitia aut unde architecto. Porro temporibus suscipit aut dolore. Soluta ullam officia.', 'Labore est iste omnis placeat est exercitationem. Dolorum omnis similique nisi porro esse a quod.', 101, '2025-01-09');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (204, '2025-02-15 13:26:31', 9, 'SERV01', '85449907', 190, 'Veniam a eaque ex illo. Sapiente cumque minima repellat quis.', 'Assumenda necessitatibus mollitia numquam itaque. Doloribus sit ut mollitia dolorem.', 281, '2025-01-29');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (106, '2025-02-02 16:05:59', 9, 'SERV04', '86909002', 150, 'Delectus porro laboriosam. Veritatis quasi beatae. Amet natus fuga quos.', 'Tenetur a ratione pariatur totam consectetur saepe illo. Non voluptates maiores.', 110, '2025-02-12');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (277, '2025-01-25 10:40:47', 5, 'SERV03', '3357301', 22, 'Assumenda numquam fugit officiis. Quae in voluptates laudantium facere repudiandae magni.', 'Sit explicabo fuga. Quas quas placeat atque sint voluptas nihil.', 108, '2025-03-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (13, '2025-02-11 02:12:07', 9, 'SERV05', '85449907', 179, 'Eius maxime illo soluta. Quasi doloribus dicta maiores est.', 'Deserunt illo maiores itaque ducimus. Expedita expedita nesciunt omnis.', 383, '2025-01-21');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (378, '2025-01-20 10:56:28', 6, 'SERV04', '96353304', 50, 'Molestiae ducimus in nulla reprehenderit. Ullam expedita corporis.', 'Veritatis tempora quod officiis natus ex dolorum. Optio asperiores sapiente iste.', 403, '2025-01-23');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (226, '2025-01-12 21:10:39', 2, 'SERV02', '98741936', 21, 'Corrupti quis eius quibusdam officiis nam. Nisi blanditiis labore delectus quae unde.', 'Omnis voluptatum itaque est. Ipsum temporibus odio fugit.', 438, '2025-01-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (145, '2025-01-29 06:37:59', 6, 'SERV02', '29273251', 47, 'Delectus tenetur maxime vitae. Eligendi enim rerum a. Aliquam aliquid quibusdam soluta.', 'Tempore et suscipit vel repellat recusandae. Voluptates consectetur expedita.', 397, '2025-03-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (210, '2025-02-07 12:01:34', 9, 'SERV05', '82700030', 146, 'Architecto qui deserunt illo error aliquid quisquam. Cum consectetur reiciendis accusamus.', 'Veritatis unde nesciunt suscipit nihil accusantium.', 220, '2025-02-27');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (91, '2025-02-15 18:39:51', 6, 'SERV04', '29273251', 61, 'Iste magnam eveniet deleniti esse. Quis sequi expedita labore.', 'Provident excepturi architecto.', 198, '2025-01-11');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (204, '2025-02-08 19:55:14', 3, 'SERV02', '57959437', 63, 'Nam odit qui aliquam. Laborum fugiat magni est. Nisi tenetur nam quod sapiente sint tempora.', 'Doloribus quas aliquid optio eum modi sint. Incidunt minus quisquam possimus asperiores.', 361, '2025-03-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (216, '2025-03-03 19:26:06', 8, 'SERV02', '99754418', 61, 'Sunt quis nam sequi quam. Sit delectus maxime quas possimus nam temporibus adipisci.', 'Deleniti alias dicta enim quo veniam dolores. Voluptatum sunt velit voluptatum et illum.', 218, '2025-02-06');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (128, '2025-01-03 23:17:04', 2, 'SERV05', '12107986', 193, 'Eius consequuntur quisquam error quam laboriosam.', 'Suscipit itaque atque ipsum optio aspernatur. Rerum at eligendi nisi similique ea corrupti maxime.', 174, '2025-01-23');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (364, '2025-02-03 11:36:22', 2, 'SERV02', '52194975', 81, 'Aliquam est tempora delectus odit et. Vitae dolor voluptatem natus.', 'Possimus laudantium tempora consequatur sunt quaerat. Cupiditate voluptas laboriosam a non animi.', 330, '2025-03-04');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (342, '2025-02-07 22:09:26', 10, 'SERV03', '68448391', 193, 'Reiciendis labore distinctio amet quisquam. Doloremque voluptates esse unde nobis iure.', 'Explicabo accusantium consequatur qui. Minus corporis architecto laudantium reprehenderit.', 365, '2025-03-04');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (321, '2025-02-26 16:08:47', 10, 'SERV05', '53269785', 135, 'Aspernatur quam quam enim cumque cumque. Dicta id molestiae iure laudantium fuga deserunt.', 'Alias eveniet vel eligendi accusamus cum. Tempore architecto iure quibusdam velit.', 213, '2025-03-03');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (343, '2025-02-07 17:51:20', 5, 'SERV05', '64798509', 108, 'Quisquam molestiae officiis quasi. Doloremque corporis repudiandae a omnis.', 'Eveniet qui repellendus cum possimus. Molestiae voluptatibus exercitationem laudantium consectetur.', 246, '2025-01-22');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (384, '2025-01-17 13:14:42', 9, 'SERV05', '85449907', 168, 'Iste illo mollitia iste voluptatem.', 'Necessitatibus cupiditate aut. Non ratione doloremque commodi libero rerum.', 123, '2025-02-07');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (59, '2025-02-09 16:29:55', 2, 'SERV02', '2519467', 136, 'Voluptatem facere harum autem quia maxime possimus. Necessitatibus laborum esse incidunt non.', 'Accusantium alias adipisci officiis quas ratione sapiente.', 298, '2025-01-23');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (36, '2025-02-10 02:08:52', 6, 'SERV02', '29273251', 115, 'Consectetur saepe et ex id. Quos occaecati optio maxime occaecati sapiente.', 'Aliquam ratione fuga ad vel. Odit aliquid facere repellendus excepturi quo.', 291, '2025-01-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (312, '2025-02-02 00:47:03', 7, 'SERV04', '25089541', 41, 'Molestiae voluptate ducimus nulla at iure maiores. Natus ratione illum illum labore vitae.', 'Rem esse animi facilis saepe pariatur. Hic non aspernatur molestias explicabo.', 384, '2025-02-18');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (81, '2025-01-26 02:36:57', 7, 'SERV02', '33055948', 119, 'Non corporis fugit possimus. Commodi nemo nostrum unde ipsum totam.', 'Perferendis ad quod. Eum esse tenetur dolore.', 193, '2025-02-22');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (296, '2025-02-10 11:47:44', 2, 'SERV04', '12107986', 36, 'Ipsum architecto amet at rerum. Ratione sunt sunt incidunt. Enim optio sint illum.', 'Eveniet magni eligendi quos.', 186, '2025-02-13');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (385, '2025-01-12 16:55:33', 6, 'SERV01', '23456901', 90, 'Fuga perferendis cupiditate error perferendis sint odio. In commodi laboriosam.', 'Eius eos accusamus odit error cupiditate. Numquam totam beatae.', 107, '2025-01-15');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (105, '2025-02-05 08:18:23', 10, 'SERV05', '8503366', 71, 'Cumque ullam nam corrupti. Error enim odit aut. Eius et maiores esse aliquid culpa similique.', 'Eos architecto illum assumenda molestias provident. Officia quis commodi ut.', 209, '2025-02-16');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (106, '2025-03-05 21:19:25', 4, 'SERV01', '90974980', 89, 'Ipsa sapiente quae tempore labore. Voluptas ab debitis a aliquid ad.', 'Facere exercitationem sint nisi et totam. Minus iure ab enim.', 333, '2025-01-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (97, '2025-02-08 09:50:38', 2, 'SERV05', '35066437', 135, 'Neque aspernatur dicta a. Dolores voluptatem pariatur magni aliquam iusto perferendis. Eos qui ab.', 'Odio voluptates vero exercitationem quaerat unde. Fuga explicabo officia tenetur.', 479, '2025-02-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (152, '2025-01-28 06:53:19', 6, 'SERV01', '96353304', 168, 'Quas soluta accusantium fugiat culpa magnam. Neque veniam nemo. Labore amet corrupti dignissimos.', 'Sapiente nemo sint. Ut blanditiis doloribus.', 341, '2025-02-27');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (327, '2025-01-23 22:36:20', 5, 'SERV02', '15739125', 6, 'Quidem earum soluta totam deleniti perferendis amet. Temporibus facere omnis nesciunt aut.', 'Laudantium doloremque odit iure perspiciatis voluptatibus natus. Molestiae iste eos optio eius.', 401, '2025-02-16');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (81, '2025-01-10 10:48:20', 2, 'SERV02', '98741936', 47, 'Aut rem rem excepturi rem illo. Consectetur sed ab voluptatem hic.', 'Unde sequi doloribus porro quas porro non. Ratione alias rem accusantium minus facere deleniti.', 270, '2025-02-14');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (176, '2025-02-06 17:50:28', 10, 'SERV05', '2999153', 108, 'Alias assumenda deserunt aliquam alias. Dignissimos cupiditate corrupti.', 'Ut recusandae autem libero placeat. Saepe dicta natus.', 335, '2025-01-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (53, '2025-02-07 20:37:45', 7, 'SERV02', '33055948', 97, 'Voluptas alias atque perspiciatis voluptatum. Corrupti ex accusamus.', 'Aliquam in eius eum nisi. Architecto minima recusandae. Ipsum ipsa esse molestias.', 475, '2025-03-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (86, '2025-02-04 01:47:01', 9, 'SERV03', '65510215', 135, 'Adipisci numquam in optio saepe. Eum sint cum blanditiis in.', 'Molestias quae distinctio ad fuga.', 218, '2025-02-03');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (24, '2025-01-16 16:48:58', 5, 'SERV01', '25301670', 97, 'Tempora nostrum hic. Dolorem repellat enim tempore excepturi sed deleniti molestias.', 'Sit perferendis at quod omnis distinctio eligendi.', 447, '2025-02-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (88, '2025-01-08 20:13:53', 3, 'SERV03', '57959437', 14, 'Cumque saepe nemo tenetur assumenda nulla. Maiores ex repellat id architecto.', 'Iure iusto quidem nam laudantium. Voluptas alias molestiae saepe aut.', 437, '2025-02-17');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (350, '2025-01-30 01:37:21', 7, 'SERV03', '27510100', 61, 'Aliquam quidem ipsa. Enim quaerat labore dicta. Minus a doloremque quas maxime cum accusamus.', 'Cum aliquid explicabo nostrum assumenda odio ipsam distinctio.', 280, '2025-02-09');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (180, '2025-03-02 18:48:07', 2, 'SERV05', '2519467', 149, 'Doloribus numquam laboriosam delectus. Alias suscipit dolor dolorum. Repellendus velit ratione.', 'Ipsa fuga delectus veniam ratione. Nostrum ea accusantium ad at dignissimos iste.', 363, '2025-01-26');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (130, '2025-02-13 17:50:24', 6, 'SERV02', '23456901', 164, 'Dolores ipsam occaecati nam.', 'Facere in voluptas nisi ipsa sed delectus. Soluta architecto ea modi.
Sunt sed libero.', 168, '2025-01-29');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (391, '2025-01-23 12:42:48', 6, 'SERV04', '96353304', 62, 'Libero et incidunt. Perspiciatis exercitationem labore quod provident beatae nisi.', 'Pariatur sed minus.', 266, '2025-02-11');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (284, '2025-01-12 06:22:20', 6, 'SERV04', '29273251', 150, 'Eligendi quod a perferendis illo ab. Harum deserunt architecto cum maxime consequuntur.', 'Excepturi nesciunt perspiciatis itaque ipsa mollitia. Laboriosam voluptates hic nam dolores nobis.', 280, '2025-02-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (72, '2025-02-11 23:56:47', 5, 'SERV01', '9684214', 163, 'Odit quidem unde excepturi vitae natus. Facilis doloremque qui quo.', 'Placeat vero reiciendis. Delectus dolorum quod temporibus.', 164, '2025-03-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (43, '2025-03-05 03:18:40', 10, 'SERV05', '36413869', 90, 'Doloribus commodi est nesciunt sit. Facilis autem deserunt vero nobis illum.', 'Molestiae voluptates consectetur omnis occaecati. Qui ad eveniet fugiat esse labore sed.', 363, '2025-01-07');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (140, '2025-02-20 22:33:06', 10, 'SERV02', '53269785', 73, 'Iure suscipit enim accusamus minus consectetur architecto. Est quaerat dolorem.', 'Commodi aspernatur commodi mollitia laboriosam. Delectus tempore dolorem.', 416, '2025-01-19');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (32, '2025-01-06 06:50:33', 9, 'SERV02', '65510215', 168, 'Ratione accusamus accusamus quam doloremque consectetur. Nemo quas nisi cupiditate earum sint non.', 'Aperiam qui libero ut eius. Impedit doloribus accusantium. Vero tempore aperiam.', 447, '2025-02-22');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (313, '2025-02-16 07:30:18', 5, 'SERV04', '15739125', 94, 'Cupiditate perspiciatis incidunt similique. Iste qui commodi libero. Quod ratione quaerat nesciunt.', 'Magni laudantium blanditiis veritatis. Velit molestias possimus saepe. Animi impedit amet deserunt.', 222, '2025-02-28');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (42, '2025-02-22 08:23:50', 2, 'SERV02', '35303697', 95, 'Inventore eius rerum repudiandae. Voluptatibus ratione nisi. Hic consequuntur cum quidem sed.', 'Natus expedita exercitationem molestias aut quae quidem. Dolore officiis quasi numquam.', 189, '2025-01-14');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (144, '2025-01-17 15:47:45', 2, 'SERV04', '12107986', 146, 'Numquam quibusdam fugit similique. Tempora facilis optio.', 'Eveniet numquam soluta unde deserunt saepe assumenda.', 448, '2025-01-14');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (84, '2025-01-10 20:47:37', 2, 'SERV01', '27110702', 95, 'Cupiditate dicta animi autem alias. Ullam totam porro illum maiores tenetur.', 'Expedita dignissimos assumenda quod accusamus. Ipsa repudiandae similique nihil ullam.', 123, '2025-02-27');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (254, '2025-02-19 10:32:58', 4, 'SERV02', '90974980', 181, 'Odit rerum rem minus. Fuga voluptas rerum sed ducimus autem dolor explicabo.', 'A earum nihil vitae hic. Illum animi quae architecto.', 330, '2025-01-11');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (64, '2025-01-12 19:20:48', 10, 'SERV05', '8503366', 146, 'Asperiores quisquam officiis asperiores sed.', 'Beatae eligendi ex sunt quo. Assumenda commodi voluptatum possimus tenetur fugiat sapiente culpa.', 108, '2025-02-06');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (226, '2025-01-28 21:30:35', 9, 'SERV02', '17253062', 146, 'Architecto animi culpa totam quis amet quis.', 'Repudiandae quaerat aliquid sed illum fugiat.', 471, '2025-02-19');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (239, '2025-02-05 11:37:54', 2, 'SERV03', '35066437', 14, 'Magni delectus ad vel. Et distinctio nemo nisi neque officiis. Temporibus ab quam repellendus.', 'Libero voluptatibus accusamus. Non cumque nulla incidunt officiis iusto.', 293, '2025-01-06');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (144, '2025-01-09 05:32:23', 9, 'SERV01', '85449907', 6, 'Distinctio quod provident corporis fugit consequatur.', 'Magnam sed voluptas quos doloremque.', 400, '2025-01-29');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (157, '2025-01-16 00:30:04', 6, 'SERV04', '83006024', 94, 'Beatae asperiores optio necessitatibus. Aliquid deleniti earum quia quas.', 'Nesciunt laborum labore facilis provident doloremque magni. Qui maxime sunt.', 448, '2025-02-23');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (296, '2025-01-23 21:27:29', 9, 'SERV03', '6467537', 185, 'Aliquam dolores fugiat. Recusandae maxime ut dignissimos.', 'Commodi eveniet adipisci voluptatum. Voluptatibus expedita eaque voluptatum vero.', 486, '2025-01-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (315, '2025-02-25 13:24:49', 5, 'SERV05', '3357301', 146, 'Libero officia voluptate architecto magni. Placeat tenetur odio fuga.', 'Exercitationem veniam odio. Odio voluptate ipsum asperiores corporis.', 151, '2025-02-15');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (333, '2025-02-05 03:46:14', 6, 'SERV05', '59339518', 100, 'Quod eos laboriosam reiciendis deserunt rerum. Animi quas quaerat dignissimos.', 'Ea esse a enim. Officia sequi vitae quibusdam porro.', 332, '2025-01-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (294, '2025-01-08 14:39:42', 6, 'SERV04', '29273251', 48, 'Vitae praesentium consequatur cum eaque possimus.', 'Ut necessitatibus in quis. Molestias pariatur temporibus asperiores velit.', 344, '2025-02-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (50, '2025-02-02 16:28:35', 5, 'SERV05', '96708421', 82, 'Quod harum occaecati enim. Tenetur in at dignissimos nisi molestiae dolore libero.', 'Incidunt repellat officiis. Numquam optio nam.', 296, '2025-01-12');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (35, '2025-01-20 18:48:42', 4, 'SERV04', '26775577', 49, 'Deserunt totam neque voluptates. Laboriosam quos adipisci voluptatem culpa.', 'Molestiae fuga corrupti voluptate natus delectus.', 115, '2025-02-18');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (22, '2025-02-25 11:13:50', 8, 'SERV01', '69385561', 124, 'Facilis voluptas maiores quaerat tempora quasi. Hic nam eligendi nesciunt temporibus illum dolorum.', 'Voluptatum explicabo reiciendis occaecati debitis perspiciatis. Quis neque provident ea.', 446, '2025-03-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (347, '2025-03-05 16:57:14', 2, 'SERV01', '2519467', 36, 'Error sequi minus voluptatem id. Voluptatem pariatur sed at fugit sunt expedita.', 'Impedit dolores magni blanditiis. Veniam iusto possimus accusantium occaecati tenetur sed.', 500, '2025-01-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (218, '2025-03-04 15:28:44', 2, 'SERV05', '27110702', 56, 'Cum quas ut est et alias adipisci. Cupiditate maiores sed aperiam natus non.', 'Maiores rem error consequatur sapiente unde beatae incidunt. Quia nesciunt minima cumque rem illo.', 250, '2025-02-10');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (400, '2025-02-09 04:38:40', 9, 'SERV04', '6467537', 190, 'Repudiandae fugiat numquam eveniet sit. Perferendis debitis repellendus ex dolorem adipisci.', 'Laboriosam quis consequuntur sequi beatae distinctio suscipit.', 111, '2025-01-10');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (243, '2025-01-17 21:33:59', 6, 'SERV05', '59339518', 49, 'Cum temporibus earum ex beatae atque reprehenderit vel. Rem deserunt eius quod.', 'Rem eum dicta minima voluptate. Iusto repudiandae quidem nemo accusantium explicabo assumenda.', 162, '2025-01-12');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (236, '2025-01-05 17:45:51', 2, 'SERV04', '2519467', 42, 'Ipsam ad rem enim similique eius nesciunt. Facere consequuntur omnis modi occaecati.', 'Nemo unde similique debitis. Voluptatum nobis quasi libero iste.', 286, '2025-02-19');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (25, '2025-02-17 14:44:00', 5, 'SERV03', '15739125', 150, 'Magnam sit dignissimos fugiat.', 'Unde modi odit nulla consequatur minus. Blanditiis non neque similique praesentium reprehenderit.', 231, '2025-02-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (294, '2025-01-30 02:52:16', 4, 'SERV02', '26775577', 93, 'Delectus accusamus laudantium sit excepturi. Inventore iusto aperiam reiciendis veritatis.', 'Explicabo quis quod alias. Hic quae iusto nostrum.', 381, '2025-03-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (165, '2025-01-09 12:28:53', 9, 'SERV02', '82700030', 73, 'Repudiandae eius inventore qui. Eligendi maiores deleniti nemo voluptate magni molestiae.', 'Quisquam sed magni iure dignissimos praesentium assumenda.', 132, '2025-02-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (24, '2025-01-26 12:58:55', 5, 'SERV01', '15739125', 199, 'Libero quo ad illum cumque id illo. Aliquid iusto hic molestiae saepe quis.', 'Odit delectus praesentium labore porro. Voluptatem quo porro illum magnam iusto.', 499, '2025-01-27');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (151, '2025-02-24 20:25:36', 3, 'SERV05', '58807118', 97, 'Totam delectus saepe laudantium esse cupiditate quos. Enim ad ad.', 'Provident soluta modi voluptas. Amet voluptatem eius enim.', 306, '2025-01-14');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (355, '2025-02-07 14:49:13', 6, 'SERV03', '83006024', 174, 'Amet voluptatem porro sit illum. Iusto quam atque hic tenetur quasi similique.', 'Magni quis harum aliquam id eos quam. Quae odio aspernatur.', 199, '2025-02-27');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (147, '2025-02-25 07:01:02', 10, 'SERV03', '51111661', 146, 'Repellat distinctio minus quidem rerum. Quas neque sunt explicabo.', 'Optio nostrum saepe eos. Explicabo voluptate unde voluptas.', 426, '2025-02-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (133, '2025-02-28 16:00:06', 2, 'SERV05', '35066437', 146, 'Labore facere fuga voluptates. Inventore nostrum esse placeat.', 'Esse incidunt saepe ad. Ab dolore architecto quas unde. Officia fuga quae tenetur unde.', 179, '2025-01-19');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (4, '2025-01-29 02:08:36', 5, 'SERV01', '15739125', 135, 'Molestias quia nihil dignissimos facilis. Voluptatem provident illum veritatis.', 'Ea reprehenderit ipsum. Numquam tenetur officia quis aliquam quos quasi dolor.', 364, '2025-01-17');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (39, '2025-02-01 21:07:09', 9, 'SERV03', '21622291', 118, 'Dolor ut ut perspiciatis iusto reprehenderit. Debitis expedita saepe est.', 'Aperiam similique minima. Recusandae eveniet consectetur perspiciatis similique enim totam dolore.', 217, '2025-02-24');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (390, '2025-01-12 23:16:08', 5, 'SERV04', '25301670', 45, 'Optio sint deleniti modi repudiandae.', 'Quaerat aspernatur ipsa. Minima nobis reiciendis harum sequi incidunt voluptatibus corrupti.', 206, '2025-01-09');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (360, '2025-01-05 10:27:29', 5, 'SERV01', '41709987', 190, 'Ut id blanditiis eligendi dolorum.
Eligendi pariatur minus. Tempora earum odio minima blanditiis.', 'Vel mollitia fugit porro. Facere earum voluptatum sapiente sint. Dolores sit dolore ipsa sequi.', 128, '2025-01-22');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (65, '2025-02-04 04:28:04', 2, 'SERV01', '35303697', 124, 'Rerum amet dolores expedita maxime nemo laborum praesentium. Similique omnis dignissimos.', 'Blanditiis magnam atque animi. Inventore molestiae soluta sed architecto eaque.', 423, '2025-02-21');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (117, '2025-02-13 17:08:22', 4, 'SERV04', '90974980', 190, 'Odit eius error non exercitationem delectus eaque voluptas. Sapiente magni quasi facilis occaecati.', 'Exercitationem similique itaque. Magnam quo nulla optio ducimus. Quis vitae sequi dolor possimus.', 381, '2025-02-25');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (99, '2025-03-04 22:06:37', 10, 'SERV01', '2999153', 118, 'Quasi ea sunt aliquam provident itaque. Maxime repellat ipsa aspernatur architecto sequi.', 'Repudiandae quia molestiae vero officiis aut dolore.', 485, '2025-01-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (38, '2025-03-02 02:51:50', 7, 'SERV02', '56938083', 42, 'Explicabo exercitationem magni reiciendis. Id sequi ad nesciunt eius perferendis.', 'Amet adipisci incidunt. Voluptatum quisquam aliquam. Quos veniam minus culpa dolore asperiores.', 406, '2025-01-26');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (209, '2025-02-12 11:18:23', 8, 'SERV04', '99484137', 73, 'Autem ab consequuntur sapiente officia velit ab. Et laborum neque eum id suscipit iste aliquid.', 'Illum tempora molestiae unde reprehenderit.
Cumque quos veniam provident est placeat.', 350, '2025-02-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (343, '2025-02-11 09:32:57', 9, 'SERV04', '86909002', 95, 'Similique aut id tenetur tempora. Harum ipsam accusantium voluptas.', 'Aspernatur quo fuga ipsa. Accusamus id iure expedita rerum dolorem impedit quasi.', 387, '2025-02-10');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (27, '2025-01-10 23:56:43', 10, 'SERV03', '2999153', 71, 'Saepe nam nobis magnam libero quaerat repellat. Facere natus incidunt veritatis molestiae esse.', 'Doloribus neque modi iusto dolore expedita. Dignissimos eligendi quo minima corporis.', 469, '2025-01-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (325, '2025-02-26 03:56:51', 2, 'SERV01', '2519467', 76, 'Libero neque modi. Dolores quae dicta quaerat. Mollitia fuga quod fuga modi magni dolorum.', 'Est numquam tempora ipsa quisquam quia. Pariatur explicabo ducimus cumque nam laboriosam suscipit.', 398, '2025-02-28');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (373, '2025-01-18 00:42:52', 5, 'SERV05', '96708421', 124, 'Fuga magnam alias possimus. Error voluptates non perferendis possimus consectetur officia.', 'Voluptatibus provident sunt placeat facere iusto suscipit. Sint quo animi magnam culpa aperiam.', 139, '2025-02-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (33, '2025-02-22 23:35:22', 1, 'SERV05', '27217280', 150, 'Pariatur quidem doloremque eaque facilis. Aliquam assumenda necessitatibus dignissimos maiores.', 'Vero suscipit totam perferendis. Odit cumque eos officia natus laborum.', 169, '2025-03-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (113, '2025-01-12 06:14:44', 10, 'SERV02', '2999153', 158, 'Voluptas porro omnis ullam. Nulla ab vero assumenda odit delectus assumenda.', 'Esse in architecto recusandae distinctio.', 426, '2025-02-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (280, '2025-01-11 01:41:25', 7, 'SERV01', '27510100', 53, 'Inventore quis nisi laboriosam. Quaerat harum nihil.', 'Aliquid enim ducimus. Ab assumenda consectetur ab. Alias animi alias soluta ipsam distinctio odio.', 162, '2025-02-22');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (4, '2025-02-12 21:52:25', 8, 'SERV02', '99484137', 14, 'A perspiciatis nobis sapiente repudiandae. Nihil ipsa omnis amet ad velit impedit.', 'Doloribus repellendus provident sint. Sunt facilis tempora sed illo debitis totam temporibus.', 177, '2025-02-16');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (172, '2025-02-05 03:43:41', 5, 'SERV03', '96708421', 149, 'Eligendi non deleniti rem dicta ut iste.
Minus dolore a molestias quis facilis molestias.', 'Reprehenderit harum occaecati minus consectetur cum eos. Blanditiis quidem iure impedit magni.', 473, '2025-01-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (396, '2025-02-04 04:52:53', 7, 'SERV01', '50830206', 73, 'Neque doloribus aspernatur. Dolores mollitia soluta minima nulla.', 'Asperiores cupiditate rem quia hic. Laborum quisquam autem pariatur totam laudantium.', 285, '2025-02-23');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (336, '2025-02-28 08:08:42', 2, 'SERV01', '35303697', 56, 'Porro nostrum itaque. Nemo commodi temporibus.', 'Consequuntur quisquam hic eaque. Aperiam odit et corporis.', 388, '2025-01-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (315, '2025-01-20 13:10:50', 8, 'SERV04', '1237997', 71, 'Consequatur ut perspiciatis magni fugit sint. Architecto atque quo dicta accusamus.', 'Dolorum asperiores dolore optio incidunt.', 340, '2025-02-03');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (11, '2025-01-02 12:20:39', 9, 'SERV03', '6467537', 82, 'Aut nobis deserunt molestiae architecto delectus. Aperiam quos ratione perspiciatis.', 'Provident dolorem tempora voluptates autem. Incidunt dolore eaque nisi error officiis.', 483, '2025-02-17');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (365, '2025-01-29 19:14:27', 10, 'SERV03', '53269785', 90, 'Quo illum neque placeat exercitationem. Et reiciendis cum.', 'Cumque aperiam eveniet quasi voluptate eaque voluptatibus.', 411, '2025-01-13');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (19, '2025-02-26 18:01:22', 10, 'SERV03', '53269785', 93, 'Quod nihil nam mollitia voluptatum modi sequi dicta. Similique rerum temporibus nam maxime enim.', 'Nam aliquid adipisci blanditiis. Libero ratione sed ratione earum vero ipsa.', 398, '2025-02-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (19, '2025-01-27 19:44:44', 6, 'SERV05', '96353304', 163, 'Qui cumque occaecati consequuntur in. Perspiciatis eaque itaque ab expedita voluptate quibusdam.', 'Officiis illo sit aliquid delectus ratione omnis nihil.', 347, '2025-01-25');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (193, '2025-02-11 12:37:22', 5, 'SERV03', '41709987', 58, 'Pariatur corrupti totam. Ratione illum fugit facere dolorem voluptatibus cum.', 'Quas ipsa quas. Minus non temporibus occaecati. Incidunt quibusdam ipsa exercitationem ad nesciunt.', 301, '2025-02-26');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (339, '2025-03-01 06:14:47', 5, 'SERV02', '78024457', 41, 'Sed recusandae corrupti eos laudantium consequatur omnis. Cum voluptatem nostrum corrupti.', 'Sit harum quaerat explicabo officiis.', 221, '2025-01-21');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (366, '2025-01-14 16:53:51', 8, 'SERV03', '99754418', 186, 'Enim eius labore iste consequuntur nemo possimus quasi. Eius hic veritatis modi quis culpa.', 'Atque molestias nulla excepturi facilis quo. Molestiae quasi aut tempore quas.', 435, '2025-01-23');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (269, '2025-01-17 01:20:32', 4, 'SERV02', '90974980', 50, 'Eos cupiditate dolores consequuntur. Architecto dolorum asperiores architecto accusamus.', 'Officiis molestiae iusto. Eius voluptas asperiores cupiditate.', 405, '2025-01-14');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (310, '2025-01-18 10:03:36', 5, 'SERV04', '25301670', 49, 'Debitis provident non sed eos harum minima. Nam omnis fugit omnis temporibus neque.', 'Ea magnam eaque veniam.', 140, '2025-01-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (318, '2025-02-07 07:11:01', 7, 'SERV04', '56938083', 193, 'Quidem iusto optio facere laborum voluptatibus.', 'Nobis non quos quo possimus cupiditate. Ipsam asperiores esse alias.', 166, '2025-01-28');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (108, '2025-02-11 10:28:43', 5, 'SERV01', '41709987', 36, 'Quisquam maiores omnis vel fugit sunt eveniet tempore. At nostrum odio ad excepturi blanditiis.', 'Adipisci magni maiores ipsum dolore possimus voluptatem.', 468, '2025-01-25');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (400, '2025-02-27 21:33:55', 10, 'SERV01', '53269785', 6, 'Ducimus eligendi aliquid perferendis libero architecto. Vel est sapiente culpa doloremque nulla.', 'Libero occaecati inventore quisquam. Animi vel vero.', 285, '2025-01-24');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (22, '2025-02-04 04:00:18', 6, 'SERV04', '83006024', 180, 'Suscipit illum suscipit minus vel mollitia. Modi vitae vel eligendi nesciunt laboriosam.', 'Repudiandae consectetur dolor blanditiis reprehenderit. Beatae eum recusandae est.', 304, '2025-01-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (369, '2025-02-28 23:38:39', 7, 'SERV01', '27510100', 82, 'Labore ipsam mollitia ipsa temporibus impedit rerum totam.', 'Quis aut veritatis iure neque.', 300, '2025-02-17');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (71, '2025-01-05 09:14:59', 8, 'SERV05', '88227149', 97, 'Perferendis mollitia dolorem officiis.', 'In molestias odit velit. Iste rerum quibusdam.', 239, '2025-01-15');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (259, '2025-01-15 06:33:20', 6, 'SERV02', '29273251', 49, 'Velit harum repudiandae recusandae. Odio repellat ex rem at dolore.', 'Commodi maiores modi officia tempora amet. Eius beatae magni.', 130, '2025-02-26');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (38, '2025-01-05 13:51:21', 2, 'SERV03', '2519467', 193, 'Ad ea quod ullam reprehenderit. Neque enim animi est possimus aliquid.', 'Molestias saepe laboriosam aperiam veniam. Aliquam ab beatae unde id voluptatem.', 158, '2025-02-28');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (5, '2025-02-15 17:03:50', 8, 'SERV05', '99484137', 187, 'Inventore odio voluptates consectetur numquam hic earum. Dolorum nobis porro reprehenderit ad.', 'Eaque voluptas voluptas dolores voluptas iste. Adipisci voluptatum nulla tempora.', 352, '2025-02-04');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (59, '2025-02-28 20:18:21', 2, 'SERV02', '12107986', 45, 'Quos sunt quibusdam autem hic. Enim est alias ipsam ratione nobis delectus.', 'Hic labore corrupti praesentium porro. Blanditiis nostrum veniam.', 173, '2025-01-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (317, '2025-01-06 22:33:37', 5, 'SERV03', '96708421', 48, 'Fugit ut magnam id odio adipisci pariatur. Id maxime repudiandae voluptatem expedita sed.', 'Officia odit eius omnis. Nemo nam exercitationem minima vero ab. Sequi atque nemo adipisci.', 131, '2025-01-29');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (55, '2025-01-23 09:26:36', 5, 'SERV01', '15739125', 168, 'Distinctio iste id. Ad in magnam voluptatum laudantium libero eum.', 'Eius dolore possimus ab. Laborum natus animi sequi est nostrum. Quos libero adipisci odio ut.', 410, '2025-02-12');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (394, '2025-01-10 10:16:50', 5, 'SERV04', '15739125', 185, 'Fugit nisi voluptas inventore.', 'Quam quam ducimus placeat. Natus aspernatur iusto.', 340, '2025-02-27');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (399, '2025-02-03 14:25:24', 1, 'SERV01', '7402147', 163, 'Quo in atque enim. Eos minima doloremque id id itaque pariatur. Aspernatur tempora amet.', 'Sunt ea corrupti. Iusto quos reiciendis velit. Temporibus deleniti provident sed sint sed fuga.', 440, '2025-02-13');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (139, '2025-01-31 20:14:49', 2, 'SERV05', '52194975', 61, 'Ab ad tempore aut maxime mollitia.
Et nesciunt laborum nesciunt magni eos.', 'Ipsa suscipit inventore fugit facere. Aperiam delectus nam magni.', 129, '2025-02-13');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (28, '2025-02-05 21:18:19', 7, 'SERV02', '33055948', 180, 'Beatae quia incidunt sequi consequatur sapiente. Sed consequatur eligendi eligendi autem.', 'Quibusdam autem delectus cumque. Facilis odio nemo dolore distinctio impedit.', 467, '2025-01-17');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (308, '2025-01-04 01:33:39', 5, 'SERV01', '15739125', 105, 'Esse asperiores autem. Aliquid nulla odit atque voluptates eum.', 'Debitis exercitationem repellat molestias ut corrupti vel. Odit ipsum nemo labore.', 305, '2025-02-24');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (114, '2025-02-24 15:06:40', 7, 'SERV02', '50830206', 94, 'Dolore modi soluta maiores aperiam. Atque officia ipsam at.', 'Quis non soluta incidunt magnam earum. Ut ab molestiae dicta velit quos dolores sequi.', 325, '2025-02-03');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (209, '2025-02-18 05:46:26', 5, 'SERV01', '41709987', 97, 'Nam ea accusamus maiores. Aliquam ad repudiandae quae facere nam voluptatum. Alias rerum nobis qui.', 'Tenetur optio nulla quasi cum. Facilis magni possimus impedit.
Neque tempore ipsa dolorem.', 198, '2025-02-27');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (354, '2025-01-30 11:06:30', 9, 'SERV05', '85449907', 97, 'Dolorum amet distinctio reprehenderit. Beatae voluptas id error.', 'Quisquam eveniet eveniet deserunt ullam dolorum. Reprehenderit repudiandae reiciendis voluptate.', 277, '2025-02-18');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (229, '2025-01-11 22:34:03', 10, 'SERV03', '51111661', 56, 'Atque tempore in fugit sapiente.', 'Rerum ea ut magni. Assumenda molestiae unde quam illum ad soluta.', 297, '2025-01-16');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (219, '2025-01-02 03:15:46', 4, 'SERV05', '26775577', 48, 'Nulla alias deserunt laborum. Velit reiciendis omnis quia recusandae.', 'Maiores deleniti sed eveniet commodi harum labore. Magni reiciendis nam sint velit molestias rerum.', 356, '2025-02-06');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (326, '2025-02-10 18:59:36', 7, 'SERV04', '25089541', 119, 'Facere quae magni deleniti. Aspernatur perspiciatis quaerat similique.', 'Veritatis modi optio sapiente. Enim voluptates eaque minima nisi. Illum blanditiis fuga nihil.', 211, '2025-01-12');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (135, '2025-01-15 06:02:11', 6, 'SERV04', '23456901', 164, 'Distinctio reprehenderit sit error quasi provident. Ipsum dignissimos dolorum adipisci dolorum.', 'Iste error in excepturi inventore. Nobis eaque placeat eligendi occaecati.', 496, '2025-01-13');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (379, '2025-02-09 20:10:23', 4, 'SERV05', '26775577', 158, 'Deleniti veniam quaerat ea tempora odit.', 'Quis blanditiis aperiam possimus modi. Itaque accusantium sapiente quibusdam nisi quam debitis.', 355, '2025-02-09');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (212, '2025-03-04 19:54:03', 7, 'SERV02', '25089541', 94, 'Sunt eos totam a mollitia. Ipsam non iusto unde.', 'Quas quo voluptate deserunt veniam cumque. Sapiente ea eligendi numquam error non ea.', 156, '2025-02-11');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (252, '2025-01-13 18:50:08', 9, 'SERV01', '21622291', 71, 'Quaerat pariatur pariatur itaque fugit omnis. Sunt modi ullam repudiandae.', 'Ullam hic temporibus nobis eos. Beatae nisi non velit voluptatum.', 362, '2025-02-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (107, '2025-01-14 03:37:20', 2, 'SERV03', '27110702', 50, 'Praesentium omnis temporibus. Enim laboriosam quas velit ullam consequuntur libero aspernatur.', 'Et reiciendis at voluptatum numquam. Vero fugit saepe quasi.', 427, '2025-02-28');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (295, '2025-01-26 05:38:47', 8, 'SERV03', '1237997', 49, 'Voluptatibus illum sed sapiente. Eaque rem suscipit ipsa. Id doloremque dolore velit.', 'Quia repellendus quas voluptatum impedit sed expedita. Praesentium fuga officiis debitis libero.', 369, '2025-02-12');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (127, '2025-02-27 11:26:49', 2, 'SERV02', '27110702', 89, 'Enim dolor dolor nemo odio nostrum. Unde aspernatur eum tenetur.', 'Recusandae iusto id accusantium nisi nemo soluta. Vero suscipit quaerat commodi.', 319, '2025-02-03');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (327, '2025-02-26 09:08:46', 8, 'SERV05', '69385561', 160, 'Minus ipsam quia repellendus placeat repellat culpa. Mollitia labore ipsa quos veniam odio.', 'Quis doloremque doloribus. Dignissimos inventore exercitationem.
Veritatis ab praesentium.', 251, '2025-01-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (6, '2025-01-23 15:07:47', 2, 'SERV05', '27110702', 61, 'Architecto culpa labore tenetur officia molestias. Ipsam nobis aut eius animi.', 'Possimus ipsum quis accusamus. Optio quas autem.', 112, '2025-01-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (308, '2025-02-06 04:19:22', 5, 'SERV04', '3357301', 22, 'Tempora quos dolor unde nulla. Inventore reprehenderit dolorum officiis tempora. At nihil unde ea.', 'Nam modi pariatur.', 149, '2025-01-22');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (333, '2025-02-12 02:14:47', 5, 'SERV04', '25301670', 56, 'Iure minima temporibus. Saepe excepturi recusandae culpa laborum.', 'Minima excepturi cupiditate. Occaecati eum nobis unde ab.', 417, '2025-02-26');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (149, '2025-02-14 23:24:15', 2, 'SERV04', '2519467', 79, 'Facilis modi autem. Assumenda assumenda totam ea. Labore fuga iusto quisquam.', 'Voluptas illum earum consequatur ab neque molestiae. Dicta quam nobis fugit.', 102, '2025-02-15');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (267, '2025-01-11 09:01:51', 7, 'SERV01', '33055948', 71, 'Magnam commodi accusantium quidem eius quia. Recusandae tempora harum deserunt sunt.', 'Quia aliquid sed. Quidem sint recusandae voluptatum quibusdam voluptates.', 234, '2025-01-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (379, '2025-02-03 04:17:47', 1, 'SERV01', '27217280', 174, 'Fugiat voluptas ut numquam fugiat. Veritatis quae commodi rem explicabo.', 'Magni similique voluptate maxime cum corrupti nobis dolorum. Ipsa non quisquam itaque nostrum.', 181, '2025-02-24');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (72, '2025-02-10 18:53:41', 3, 'SERV04', '57959437', 94, 'Non magnam magni quibusdam.', 'Animi voluptatem quod fugit.', 447, '2025-01-13');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (298, '2025-01-30 06:19:50', 3, 'SERV04', '58807118', 198, 'Error eaque repudiandae magnam laborum ullam quae cumque. Vel beatae sequi natus odio sequi nam.', 'Praesentium quod sed iure. Mollitia occaecati reiciendis molestiae cum totam beatae iure.', 269, '2025-01-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (352, '2025-02-13 22:32:34', 2, 'SERV05', '35066437', 190, 'Dolores magni nostrum vitae quia. Aspernatur vitae debitis similique earum. Officia unde accusamus.', 'Nemo voluptates hic deserunt vel at et nam. At pariatur quibusdam eligendi nesciunt veniam.', 430, '2025-02-13');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (330, '2025-02-07 09:11:01', 10, 'SERV04', '2999153', 90, 'Unde hic quae sequi unde natus magnam. Sit voluptatibus exercitationem necessitatibus.', 'Odit reprehenderit illum optio dolorum soluta modi illo. Sunt tempore placeat quia placeat.', 375, '2025-01-29');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (336, '2025-01-23 01:23:19', 1, 'SERV02', '44312046', 132, 'Molestias tempore enim qui vero deserunt. Molestias maxime aperiam incidunt.', 'Beatae voluptatum sapiente recusandae voluptatibus iste. Aliquam ab numquam veniam eaque cum.', 397, '2025-02-14');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (367, '2025-02-04 17:55:06', 10, 'SERV01', '36413869', 95, 'Alias deserunt quod ullam. Nesciunt hic amet praesentium est aliquid quibusdam.', 'Facere neque atque amet rerum facere eum. In dicta ducimus quia voluptate aperiam.', 490, '2025-02-27');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (294, '2025-02-19 05:55:15', 9, 'SERV02', '82700030', 168, 'Excepturi illo voluptate unde placeat. Eius aliquam porro illo itaque veniam.', 'Voluptates voluptatibus deleniti accusantium provident. Eum quam doloribus porro.', 452, '2025-01-10');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (33, '2025-02-01 10:46:44', 2, 'SERV02', '35066437', 93, 'Doloremque molestiae explicabo maiores doloremque.', 'Nemo deserunt natus illo delectus alias odit.', 296, '2025-01-16');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (146, '2025-01-06 17:25:37', 5, 'SERV02', '64798509', 21, 'Ut consectetur inventore at repellat quis et. Id adipisci fuga explicabo.', 'Voluptate at saepe doloremque laboriosam. Fugit laborum laudantium suscipit.', 109, '2025-01-19');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (273, '2025-02-06 10:06:38', 7, 'SERV02', '33055948', 42, 'Tenetur illum reprehenderit nulla. Assumenda non vel quas eligendi fugiat saepe qui.', 'Neque aperiam tempore excepturi quas. Itaque neque cupiditate molestias praesentium.', 219, '2025-01-18');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (193, '2025-02-05 13:23:01', 7, 'SERV05', '33055948', 109, 'Aliquam facilis fuga ipsum quo.', 'Vero magni error quod deleniti.', 400, '2025-01-14');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (30, '2025-02-25 16:07:34', 6, 'SERV01', '83006024', 107, 'Ex ex animi. Neque assumenda voluptates laboriosam quae.', 'Dolorum laborum nesciunt vero quo corrupti. Molestiae ullam iure nulla nemo minus dolores quia.', 230, '2025-02-14');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (32, '2025-01-01 03:03:34', 10, 'SERV04', '53269785', 186, 'Sunt aspernatur esse adipisci. Ipsa eius enim.', 'Quibusdam neque pariatur vel perferendis in. Ab voluptate exercitationem praesentium aperiam.', 386, '2025-02-12');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (92, '2025-01-18 00:56:25', 2, 'SERV04', '35066437', 124, 'Nesciunt ipsum labore quia autem magni. Provident placeat est officiis inventore placeat itaque.', 'Voluptate aliquid aut maxime. Non temporibus quisquam asperiores. Id aliquid facilis fugit.', 277, '2025-02-09');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (63, '2025-02-01 05:29:16', 2, 'SERV05', '98741936', 58, 'Assumenda reiciendis animi est voluptatum corrupti.', 'Sed qui similique perferendis minima maxime distinctio.', 449, '2025-02-13');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (310, '2025-02-10 23:29:29', 10, 'SERV05', '2999153', 47, 'Quam nobis quo deleniti delectus. Officia itaque nesciunt architecto.', 'Beatae laudantium doloremque id. Tempora repudiandae quia quam cum fugiat repellendus inventore.', 380, '2025-01-21');
SET IDENTITY_INSERT Pacientes.VisitaMedica OFF;

PRINT 'Data insertion completed.';
GO

GO
PRINT N'Comprobando los datos existentes con las restricciones recién creadas';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [Administracion].[Medico_Servicio] WITH CHECK CHECK CONSTRAINT [FK_Medico_Medico_Servicio];

ALTER TABLE [Administracion].[Medico_Servicio] WITH CHECK CHECK CONSTRAINT [FK_Servicio_Medico_Servicio];

ALTER TABLE [Administracion].[Medico_Servicio] WITH CHECK CHECK CONSTRAINT [FK_Hospital_Medico_Servicio];

ALTER TABLE [Administracion].[Hospital] WITH CHECK CHECK CONSTRAINT [FK_Hospital_Medico];

ALTER TABLE [Pacientes].[HistoriaClinica] WITH CHECK CHECK CONSTRAINT [FK_Paciente_HistoriaClinica];

ALTER TABLE [Pacientes].[VisitaMedica] WITH CHECK CHECK CONSTRAINT [FK_Hospital_VisitaMedica];

ALTER TABLE [Pacientes].[VisitaMedica] WITH CHECK CHECK CONSTRAINT [FK_Servicio_VisitaMedica];

ALTER TABLE [Pacientes].[VisitaMedica] WITH CHECK CHECK CONSTRAINT [FK_Medico_VisitaMedica];

ALTER TABLE [Pacientes].[VisitaMedica] WITH CHECK CHECK CONSTRAINT [FK_HistoriaClinica_VisitaMedica];

ALTER TABLE [Servicios].[Hospital_Servicio] WITH CHECK CHECK CONSTRAINT [FK_Hospital_Hospital_Servicio];

ALTER TABLE [Servicios].[Hospital_Servicio] WITH CHECK CHECK CONSTRAINT [FK_Servicio_Hospital_Servicio];


GO
PRINT N'Actualización completada.';


GO
