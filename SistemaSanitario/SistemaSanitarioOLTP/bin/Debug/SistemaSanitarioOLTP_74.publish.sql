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
PRINT N'Modificando Procedimiento [dbo].[GetVisitaMedicaChangesByRowVersion]...';


GO
ALTER PROCEDURE [dbo].[GetVisitaMedicaChangesByRowVersion]
(
   @startRow BIGINT,
   @endRow BIGINT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        vm.codHospital,
        vm.idServicio,
        hc.DNI_Paciente,  -- Se obtiene desde HistoriaClinica
        vm.DNI_Medico,
        vm.num_habitacion,
        
        -- Conversión de fecha a formato YYYYMMDD para la clave de tiempo
        TiempoSK_FechaHora = CONVERT(INT, 
                            (CONVERT(CHAR(4), DATEPART(YEAR, vm.fecha_hora)) +
                             RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(MONTH, vm.fecha_hora)), 2) +
                             RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(DAY, vm.fecha_hora)), 2))
                            ),

        TiempoSK_FechaAlta = CASE 
                                WHEN vm.fecha_alta IS NULL THEN 0  -- Si es NULL, asignar 0
                                ELSE CONVERT(INT, 
                                    (CONVERT(CHAR(4), DATEPART(YEAR, vm.fecha_alta)) +
                                     RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(MONTH, vm.fecha_alta)), 2) +
                                     RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(DAY, vm.fecha_alta)), 2))
                                ) 
                            END,

        vm.fecha_hora,
        vm.fecha_alta,
        vm.diagnostico,
        vm.tratamiento,
        vm.rowversion
    FROM Pacientes.VisitaMedica vm
    INNER JOIN Pacientes.HistoriaClinica hc 
        ON vm.codHist = hc.codHist  -- Asegurar que siempre haya un `DNI_Paciente`
    WHERE (vm.rowversion > CONVERT(ROWVERSION, @startRow) 
           AND vm.rowversion <= CONVERT(ROWVERSION, @endRow));
END;
GO
PRINT 'Populating database with initial data...';
SET NOCOUNT ON;
PRINT 'Cleaning database...';
SET NOCOUNT ON;

DELETE FROM Pacientes.VisitaMedica;
DELETE FROM Pacientes.HistoriaClinica;
DELETE FROM Pacientes.Paciente;

DELETE FROM Administracion.Medico_Servicio;
DELETE FROM Administracion.Medico;

DELETE FROM Servicios.Hospital_Servicio;
DELETE FROM Servicios.Servicio;

DELETE FROM Administracion.Hospital;

PRINT 'Database cleaned successfully!';

-- 1. Servicios
PRINT 'Populating Servicios.Servicio table';
PRINT 'Populating Servicios.Servicio table';
SET NOCOUNT ON;
INSERT INTO Servicios.Servicio (idServicio, nombre, descripcion) VALUES ('SERV01', 'Pediatria', 'Atencion a Infantes');
INSERT INTO Servicios.Servicio (idServicio, nombre, descripcion) VALUES ('SERV02', 'Ginecologia', 'diagnostican y tratan enfermedades y condiciones que afectan los órganos reproductivos');
INSERT INTO Servicios.Servicio (idServicio, nombre, descripcion) VALUES ('SERV03', 'Medicina General', 'atención médica primaria a pacientes de todas las edades');
INSERT INTO Servicios.Servicio (idServicio, nombre, descripcion) VALUES ('SERV04', 'Odontologia', 'atencion de la salud de los dientes, encías, mandíbula y boca');
INSERT INTO Servicios.Servicio (idServicio, nombre, descripcion) VALUES ('SERV05', 'Urgencias', 'Atencion medica de Emergencias');


-- 2. Médicos
PRINT 'Populating Administracion.Medico table';
PRINT 'Populating Administracion.Medico table';
SET NOCOUNT ON;
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('59339518', 'Natividad Uribe', '1990-06-11', 6, 0);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('12107986', 'Simón del Amigó', '1968-06-21', 2, 0);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('36413869', 'Agustín de Español', '1979-06-10', 10, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('2519467', 'Micaela Larrea Sabater', '1966-11-18', 2, 0);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('82700030', 'Clemente Isern Padilla', '1994-07-18', 9, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('6467537', 'Nerea Belmonte Sevillano', '1965-07-28', 9, 0);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('9684214', 'Rosenda Polo-Esparza', '1965-10-27', 5, 0);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('27217280', 'Hilda Llano Viana', '1974-10-01', 1, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('7402147', 'Rufina Valle Portillo', '1963-03-11', 1, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('17253062', 'Plácido Paredes Téllez', '1983-11-11', 9, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('2999153', 'Manolo Duran-Fuertes', '1963-01-23', 10, 0);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('96353304', 'Celestino Pelayo Cervantes Porcel', '1965-05-05', 6, 0);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('83006024', 'Bibiana Cerro Mur', '1963-05-05', 6, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('15739125', 'Vilma Falcó Piquer', '1978-04-03', 5, 0);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('25301670', 'Clarisa de Gallego', '1972-11-05', 5, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('27110702', 'Dulce Baeza-Cortés', '1987-02-07', 2, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('65510215', 'Dionisia Cabrero Ortiz', '1998-11-04', 9, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('96708421', 'Bibiana Garrido Salmerón', '1970-12-27', 5, 0);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('86909002', 'Félix Juliá-Garmendia', '1994-09-29', 9, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('44312046', 'Teodosio Uribe Suárez', '1994-03-16', 1, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('99754418', 'Jesús del Ferrández', '1972-02-03', 8, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('23456901', 'Roberta Paredes Cabeza', '1983-07-13', 6, 0);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('33055948', 'Teo Damián Enríquez Castell', '1962-07-14', 7, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('8503366', 'Nilo Canals Pulido', '1970-06-20', 10, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('25089541', 'Godofredo Caballero', '1994-11-26', 7, 0);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('85449907', 'Yaiza Becerra Céspedes', '1969-12-18', 9, 0);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('51111661', 'Concepción Rivera Gras', '1989-01-18', 10, 0);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('53269785', 'Celia Flor-Gutierrez', '1981-03-08', 10, 0);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('1237997', 'Ana Sofía Ferrández Doménech', '1970-06-10', 8, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('3357301', 'Dorotea del Uría', '1990-04-11', 5, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('27510100', 'Curro Nuñez Montes', '1995-06-30', 7, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('98741936', 'Javi Bustamante-Miguel', '1995-10-08', 2, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('29273251', 'Fausto Camps', '1999-11-05', 6, 0);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('99484137', 'José Antonio Agudo Ibarra', '1994-08-10', 8, 0);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('88227149', 'Aureliano Andres Melero', '1985-01-13', 8, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('52194975', 'Roxana Checa Bustos', '1998-06-30', 2, 0);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('41709987', 'Donato Royo Lastra', '1969-04-06', 5, 0);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('78024457', 'Jenny Castrillo Llorens', '1979-02-24', 5, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('26775577', 'Isaías Gárate Aparicio', '1959-12-05', 4, 0);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('57959437', 'Noelia Bautista Osuna', '1989-12-05', 3, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('90974980', 'Felicidad Hidalgo Giralt', '1998-11-20', 4, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('21622291', 'Palmira Castilla Madrigal', '1996-09-10', 9, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('69385561', 'Isidora Tejada Sans', '1964-11-07', 8, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('50830206', 'Jorge del Cordero', '1972-07-02', 7, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('64798509', 'Rosario Ochoa-Iborra', '1998-06-24', 5, 0);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('58807118', 'Rubén Escolano Bou', '1983-11-21', 3, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('68448391', 'Plácido Leocadio Espejo Tapia', '1978-06-14', 10, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('35066437', 'Dominga Adán Riba', '1975-05-30', 2, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('56938083', 'Odalys Lorenzo Cruz', '1969-11-17', 7, 1);
INSERT INTO Administracion.Medico (DNI_Medico, apellidos_nombre, fecha_nacimiento, codHospital, esDirector) VALUES ('35303697', 'José Mari Clavero Casares', '1985-05-17', 2, 1);


-- 3. Hospitales (ahora después de los médicos para evitar errores de FK)
PRINT 'Populating Administracion.Hospital table';
PRINT 'Populating Administracion.Hospital table';
SET NOCOUNT ON;
INSERT INTO Administracion.Hospital (codHospital, nombre, ciudad, telefono, DNI_Director) VALUES (1, 'Hospital Obrero N°1', 'La Paz', '+591 2 2441716', 7402147);
INSERT INTO Administracion.Hospital (codHospital, nombre, ciudad, telefono, DNI_Director) VALUES (2, 'Hospital Arco Iris', 'La Paz', '+591 2 2248383', 35303697);
INSERT INTO Administracion.Hospital (codHospital, nombre, ciudad, telefono, DNI_Director) VALUES (3, 'Hospital Japonés', 'Santa Cruz', '+591 3 3446261', 58807118);
INSERT INTO Administracion.Hospital (codHospital, nombre, ciudad, telefono, DNI_Director) VALUES (4, 'Hospital San Juan de Dios', 'Santa Cruz', '+591 3 3350053', 26775577);
INSERT INTO Administracion.Hospital (codHospital, nombre, ciudad, telefono, DNI_Director) VALUES (5, 'Hospital de Clínicas', 'La Paz', '+591 2 2241420', 3357301);
INSERT INTO Administracion.Hospital (codHospital, nombre, ciudad, telefono, DNI_Director) VALUES (6, 'Hospital Viedma', 'Cochabamba', '+591 4 4525523', 23456901);
INSERT INTO Administracion.Hospital (codHospital, nombre, ciudad, telefono, DNI_Director) VALUES (7, 'Hospital del Niño', 'La Paz', '+591 2 2244567', 25089541);
INSERT INTO Administracion.Hospital (codHospital, nombre, ciudad, telefono, DNI_Director) VALUES (8, 'Hospital Boliviano Holandés', 'El Alto', '+591 2 2850909', 1237997);
INSERT INTO Administracion.Hospital (codHospital, nombre, ciudad, telefono, DNI_Director) VALUES (9, 'Hospital Materno Infantil', 'Tarija', '+591 4 6645321', 6467537);
INSERT INTO Administracion.Hospital (codHospital, nombre, ciudad, telefono, DNI_Director) VALUES (10, 'Hospital Daniel Bracamonte', 'Potosí', '+591 2 6222245', 36413869);


-- 4. Pacientes
PRINT 'Populating Pacientes.Paciente table';
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


-- 5. Historia Clínica (antes que Visita Médica)
PRINT 'Populating Pacientes.HistoriaClinica table';

PRINT 'Populating Pacientes.HistoriaClinica table';
SET NOCOUNT ON;

SET IDENTITY_INSERT Pacientes.HistoriaClinica ON;

INSERT INTO Pacientes.HistoriaClinica (codHist, DNI_Paciente)
VALUES
    (1, '40487706'),
    (2, '85297971'),
    (3, '69094818'),
    (4, '87739144'),
    (5, '71218551'),
    (6, '65495872'),
    (7, '51145684'),
    (8, '73059940'),
    (9, '22694583'),
    (10, '49511432'),
    (11, '89576638'),
    (12, '23027480'),
    (13, '80766024'),
    (14, '17350097'),
    (15, '84890623'),
    (16, '40487706'),
    (17, '85297971'),
    (18, '69094818'),
    (19, '87739144'),
    (20, '71218551'),
    (21, '65495872'),
    (22, '51145684'),
    (23, '73059940'),
    (24, '22694583'),
    (25, '49511432'),
    (26, '89576638'),
    (27, '23027480'),
    (28, '80766024'),
    (29, '17350097'),
    (30, '84890623'),
    (32, '85297971'),
    (33, '69094818'),
    (34, '87739144'),
    (35, '71218551'),
    (36, '65495872'),
    (37, '51145684'),
    (38, '73059940'),
    (39, '22694583'),
    (40, '49511432'),
    (41, '89576638'),
    (42, '23027480'),
    (43, '80766024'),
    (44, '17350097'),
    (45, '84890623'),
    (46, '40487706'),
    (47, '85297971'),
    (48, '69094818'),
    (49, '87739144'),
    (50, '71218551'),
    (51, '65495872'),
    (52, '51145684'),
    (53, '73059940'),
    (54, '22694583'),
    (55, '49511432'),
    (56, '89576638'),
    (57, '23027480'),
    (58, '80766024'),
    (59, '17350097'),
    (60, '84890623'),
    (61, '40487706'),
    (62, '85297971'),
    (63, '69094818'),
    (64, '87739144'),
    (66, '65495872'),
    (67, '51145684'),
    (68, '73059940'),
    (69, '22694583'),
    (70, '49511432'),
    (71, '89576638'),
    (73, '80766024'),
    (74, '17350097'),
    (75, '84890623'),
    (76, '40487706'),
    (78, '69094818'),
    (79, '87739144'),
    (80, '71218551'),
    (81, '65495872'),
    (82, '51145684'),
    (86, '89576638'),
    (87, '23027480'),
    (88, '80766024'),
    (89, '17350097'),
    (90, '84890623'),
    (91, '40487706'),
    (92, '85297971'),
    (93, '69094818'),
    (94, '87739144'),
    (95, '71218551'),
    (96, '65495872'),
    (97, '51145684'),
    (98, '73059940'),
    (99, '22694583'),
    (100, '49511432'),
    (101, '89576638'),
    (103, '80766024'),
    (105, '84890623'),
    (106, '40487706'),
    (107, '85297971'),
    (108, '69094818'),
    (109, '87739144'),
    (110, '71218551'),
    (112, '51145684'),
    (114, '22694583'),
    (115, '49511432'),
    (116, '89576638'),
    (117, '23027480'),
    (118, '80766024'),
    (120, '84890623'),
    (121, '40487706'),
    (122, '85297971'),
    (123, '69094818'),
    (125, '71218551'),
    (126, '65495872'),
    (127, '51145684'),
    (128, '73059940'),
    (129, '22694583'),
    (130, '49511432'),
    (131, '89576638'),
    (133, '80766024'),
    (134, '17350097'),
    (135, '84890623'),
    (136, '40487706'),
    (137, '85297971'),
    (138, '69094818'),
    (139, '87739144'),
    (140, '71218551'),
    (141, '65495872'),
    (142, '51145684'),
    (143, '73059940'),
    (144, '22694583'),
    (145, '49511432'),
    (146, '89576638'),
    (147, '23027480'),
    (148, '80766024'),
    (149, '17350097'),
    (150, '84890623'),
    (151, '40487706'),
    (152, '85297971'),
    (153, '69094818'),
    (154, '87739144'),
    (155, '71218551'),
    (156, '65495872'),
    (157, '51145684'),
    (158, '73059940'),
    (159, '22694583'),
    (160, '49511432'),
    (162, '23027480'),
    (163, '80766024'),
    (164, '17350097'),
    (165, '84890623'),
    (166, '40487706'),
    (167, '85297971'),
    (168, '69094818'),
    (169, '87739144'),
    (170, '71218551'),
    (171, '65495872'),
    (172, '51145684'),
    (173, '73059940'),
    (174, '22694583'),
    (175, '49511432'),
    (176, '89576638'),
    (177, '23027480'),
    (178, '80766024'),
    (179, '17350097'),
    (180, '84890623'),
    (181, '40487706'),
    (182, '85297971'),
    (183, '69094818'),
    (184, '87739144'),
    (185, '71218551'),
    (186, '65495872'),
    (187, '51145684'),
    (188, '73059940'),
    (189, '22694583'),
    (190, '49511432'),
    (191, '89576638'),
    (192, '23027480'),
    (193, '80766024'),
    (194, '17350097'),
    (195, '84890623'),
    (196, '40487706'),
    (197, '85297971'),
    (198, '69094818'),
    (199, '87739144'),
    (200, '71218551');

SET IDENTITY_INSERT Pacientes.HistoriaClinica OFF;
PRINT 'Pacientes.HistoriaClinica table populated successfully!';


-- 6. Relación Hospital-Servicio
PRINT 'Populating Servicios.Hospital_Servicio table';
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


-- 7. Relación Médico-Servicio
PRINT 'Populating Administracion.Medico_Servicio table';
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


-- 8. Visita Médica (se inserta al final porque depende de HistoriaClinica)
PRINT 'Populating Pacientes.VisitaMedica table';
PRINT 'Populating Pacientes.VisitaMedica table';
SET NOCOUNT ON;
SET IDENTITY_INSERT Pacientes.VisitaMedica ON;
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (1, '2025-03-08 05:57:08', 5, 'SERV02', '86909002', 126, 'Diagnóstico 1', 'Tratamiento 1', 266, '2025-01-11');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (2, '2025-01-05 03:53:21', 8, 'SERV04', '99484137', 197, 'Diagnóstico 2', 'Tratamiento 2', 281, '2025-02-07');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (3, '2025-02-10 19:15:04', 3, 'SERV05', '29273251', 10, 'Diagnóstico 3', 'Tratamiento 3', 173, '2025-01-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (4, '2025-01-18 05:01:33', 10, 'SERV05', '3357301', 145, 'Diagnóstico 4', 'Tratamiento 4', 359, '2025-01-31');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (5, '2025-01-21 23:02:37', 7, 'SERV02', '27217280', 70, 'Diagnóstico 5', 'Tratamiento 5', 493, '2025-01-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (6, '2025-02-02 04:30:15', 8, 'SERV01', '3357301', 34, 'Diagnóstico 6', 'Tratamiento 6', 425, '2025-02-10');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (7, '2025-01-02 23:28:40', 4, 'SERV05', '65510215', 126, 'Diagnóstico 7', 'Tratamiento 7', 380, '2025-02-13');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (8, '2025-01-13 04:56:56', 6, 'SERV02', '29273251', 7, 'Diagnóstico 8', 'Tratamiento 8', 489, '2025-01-25');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (9, '2025-02-14 04:26:46', 6, 'SERV01', '17253062', 136, 'Diagnóstico 9', 'Tratamiento 9', 425, '2025-02-17');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (10, '2025-02-25 02:27:17', 1, 'SERV03', '98741936', 23, 'Diagnóstico 10', 'Tratamiento 10', 386, '2025-02-10');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (11, '2025-03-02 19:34:57', 4, 'SERV03', '98741936', 5, 'Diagnóstico 11', 'Tratamiento 11', 402, '2025-01-30');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (12, '2025-02-04 11:39:53', 1, 'SERV02', '25089541', 138, 'Diagnóstico 12', 'Tratamiento 12', 410, '2025-02-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (13, '2025-02-11 20:05:44', 3, 'SERV01', '69385561', 81, 'Diagnóstico 13', 'Tratamiento 13', 375, '2025-02-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (14, '2025-03-01 16:10:16', 6, 'SERV04', '59339518', 41, 'Diagnóstico 14', 'Tratamiento 14', 464, '2025-01-22');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (15, '2025-02-15 20:36:03', 9, 'SERV02', '3357301', 7, 'Diagnóstico 15', 'Tratamiento 15', 455, '2025-02-18');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (16, '2025-02-19 00:56:45', 5, 'SERV03', '17253062', 19, 'Diagnóstico 16', 'Tratamiento 16', 200, '2025-02-06');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (17, '2025-01-08 10:44:51', 3, 'SERV02', '69385561', 148, 'Diagnóstico 17', 'Tratamiento 17', 426, '2025-02-18');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (18, '2025-01-18 20:00:53', 8, 'SERV02', '86909002', 194, 'Diagnóstico 18', 'Tratamiento 18', 257, '2025-01-31');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (19, '2025-01-01 13:03:11', 3, 'SERV03', '85449907', 88, 'Diagnóstico 19', 'Tratamiento 19', 214, '2025-02-10');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (20, '2025-02-02 12:36:26', 7, 'SERV03', '27110702', 172, 'Diagnóstico 20', 'Tratamiento 20', 286, '2025-02-19');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (21, '2025-02-14 14:47:04', 1, 'SERV03', '6467537', 200, 'Diagnóstico 21', 'Tratamiento 21', 292, '2025-01-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (22, '2025-01-24 07:55:45', 9, 'SERV04', '35066437', 35, 'Diagnóstico 22', 'Tratamiento 22', 150, '2025-01-22');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (23, '2025-01-07 22:05:56', 6, 'SERV01', '27217280', 50, 'Diagnóstico 23', 'Tratamiento 23', 436, '2025-01-10');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (24, '2025-03-04 22:31:12', 9, 'SERV02', '65510215', 195, 'Diagnóstico 24', 'Tratamiento 24', 243, '2025-01-19');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (25, '2025-01-30 02:33:28', 9, 'SERV05', '27110702', 57, 'Diagnóstico 25', 'Tratamiento 25', 402, '2025-02-16');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (26, '2025-01-26 07:33:09', 7, 'SERV04', '3357301', 89, 'Diagnóstico 26', 'Tratamiento 26', 209, '2025-01-11');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (27, '2025-02-23 22:50:29', 6, 'SERV04', '25089541', 174, 'Diagnóstico 27', 'Tratamiento 27', 262, '2025-01-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (28, '2025-03-04 07:43:52', 6, 'SERV01', '35303697', 58, 'Diagnóstico 28', 'Tratamiento 28', 288, '2025-01-06');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (29, '2025-02-02 17:58:28', 6, 'SERV05', '7402147', 172, 'Diagnóstico 29', 'Tratamiento 29', 357, '2025-01-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (30, '2025-02-17 01:05:44', 2, 'SERV03', '27110702', 167, 'Diagnóstico 30', 'Tratamiento 30', 190, '2025-01-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (31, '2025-01-12 08:42:58', 10, 'SERV05', '29273251', 149, 'Diagnóstico 31', 'Tratamiento 31', 257, '2025-01-13');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (32, '2025-01-23 15:34:14', 6, 'SERV02', '25089541', 91, 'Diagnóstico 32', 'Tratamiento 32', 262, '2025-02-26');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (33, '2025-01-17 13:48:37', 10, 'SERV05', '85449907', 23, 'Diagnóstico 33', 'Tratamiento 33', 363, '2025-02-21');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (34, '2025-03-08 23:43:23', 3, 'SERV03', '29273251', 141, 'Diagnóstico 34', 'Tratamiento 34', 104, '2025-02-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (35, '2025-02-26 23:20:11', 5, 'SERV02', '7402147', 108, 'Diagnóstico 35', 'Tratamiento 35', 412, '2025-02-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (36, '2025-02-19 17:33:03', 2, 'SERV02', '25089541', 1, 'Diagnóstico 36', 'Tratamiento 36', 288, '2025-03-07');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (37, '2025-03-07 03:07:43', 7, 'SERV01', '3357301', 1, 'Diagnóstico 37', 'Tratamiento 37', 164, '2025-01-31');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (38, '2025-01-13 20:09:47', 7, 'SERV03', '17253062', 179, 'Diagnóstico 38', 'Tratamiento 38', 173, '2025-02-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (39, '2025-01-23 13:34:25', 2, 'SERV03', '99484137', 110, 'Diagnóstico 39', 'Tratamiento 39', 370, '2025-01-27');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (40, '2025-01-17 13:37:44', 7, 'SERV03', '25089541', 47, 'Diagnóstico 40', 'Tratamiento 40', 157, '2025-02-25');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (41, '2025-01-27 14:37:57', 3, 'SERV04', '99484137', 164, 'Diagnóstico 41', 'Tratamiento 41', 279, '2025-02-22');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (42, '2025-01-19 05:40:17', 4, 'SERV02', '52194975', 59, 'Diagnóstico 42', 'Tratamiento 42', 439, '2025-01-27');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (43, '2025-03-06 17:31:43', 2, 'SERV02', '53269785', 176, 'Diagnóstico 43', 'Tratamiento 43', 272, '2025-02-24');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (44, '2025-01-29 14:59:56', 4, 'SERV03', '27110702', 95, 'Diagnóstico 44', 'Tratamiento 44', 230, '2025-01-03');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (45, '2025-02-24 20:59:37', 1, 'SERV05', '35066437', 82, 'Diagnóstico 45', 'Tratamiento 45', 293, '2025-01-13');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (46, '2025-01-16 12:13:15', 9, 'SERV01', '98741936', 60, 'Diagnóstico 46', 'Tratamiento 46', 277, '2025-02-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (47, '2025-02-06 11:30:54', 9, 'SERV03', '59339518', 53, 'Diagnóstico 47', 'Tratamiento 47', 261, '2025-01-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (48, '2025-02-04 14:00:02', 6, 'SERV01', '27217280', 14, 'Diagnóstico 48', 'Tratamiento 48', 216, '2025-01-15');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (49, '2025-02-12 18:34:27', 7, 'SERV01', '35066437', 117, 'Diagnóstico 49', 'Tratamiento 49', 363, '2025-01-11');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (50, '2025-02-02 01:05:29', 4, 'SERV04', '25089541', 116, 'Diagnóstico 50', 'Tratamiento 50', 364, '2025-01-23');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (51, '2025-03-05 00:22:11', 2, 'SERV01', '12107986', 33, 'Diagnóstico 51', 'Tratamiento 51', 158, '2025-02-25');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (52, '2025-02-12 16:42:38', 5, 'SERV01', '7402147', 88, 'Diagnóstico 52', 'Tratamiento 52', 458, '2025-01-19');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (53, '2025-02-23 04:41:05', 2, 'SERV04', '86909002', 134, 'Diagnóstico 53', 'Tratamiento 53', 340, '2025-01-21');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (54, '2025-01-09 20:35:10', 4, 'SERV02', '27217280', 81, 'Diagnóstico 54', 'Tratamiento 54', 147, '2025-01-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (55, '2025-01-18 04:27:20', 5, 'SERV05', '25089541', 21, 'Diagnóstico 55', 'Tratamiento 55', 165, '2025-01-22');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (56, '2025-01-30 05:26:48', 2, 'SERV02', '27110702', 196, 'Diagnóstico 56', 'Tratamiento 56', 384, '2025-01-24');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (57, '2025-02-06 18:52:58', 4, 'SERV03', '98741936', 118, 'Diagnóstico 57', 'Tratamiento 57', 203, '2025-01-18');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (58, '2025-01-21 21:45:31', 9, 'SERV02', '27217280', 58, 'Diagnóstico 58', 'Tratamiento 58', 119, '2025-02-27');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (59, '2025-01-24 13:55:59', 6, 'SERV05', '27110702', 190, 'Diagnóstico 59', 'Tratamiento 59', 497, '2025-01-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (60, '2025-02-15 17:23:20', 8, 'SERV05', '17253062', 137, 'Diagnóstico 60', 'Tratamiento 60', 203, '2025-02-25');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (61, '2025-02-11 11:38:04', 5, 'SERV01', '98741936', 179, 'Diagnóstico 61', 'Tratamiento 61', 472, '2025-02-11');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (62, '2025-01-23 20:57:28', 5, 'SERV01', '17253062', 135, 'Diagnóstico 62', 'Tratamiento 62', 495, '2025-03-03');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (63, '2025-02-23 20:32:45', 5, 'SERV04', '65510215', 54, 'Diagnóstico 63', 'Tratamiento 63', 492, '2025-01-09');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (64, '2025-01-06 00:46:50', 2, 'SERV05', '3357301', 26, 'Diagnóstico 64', 'Tratamiento 64', 376, '2025-01-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (65, '2025-02-20 19:33:34', 7, 'SERV01', '12107986', 189, 'Diagnóstico 65', 'Tratamiento 65', 118, '2025-01-06');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (66, '2025-02-06 18:35:23', 4, 'SERV01', '69385561', 66, 'Diagnóstico 66', 'Tratamiento 66', 131, '2025-02-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (67, '2025-02-25 18:41:58', 4, 'SERV02', '6467537', 186, 'Diagnóstico 67', 'Tratamiento 67', 152, '2025-02-18');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (68, '2025-01-21 02:57:20', 10, 'SERV05', '25089541', 114, 'Diagnóstico 68', 'Tratamiento 68', 472, '2025-01-31');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (69, '2025-01-03 19:55:43', 3, 'SERV03', '29273251', 136, 'Diagnóstico 69', 'Tratamiento 69', 371, '2025-03-03');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (70, '2025-03-07 08:40:47', 8, 'SERV05', '25089541', 42, 'Diagnóstico 70', 'Tratamiento 70', 261, '2025-01-22');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (71, '2025-01-30 13:11:24', 3, 'SERV04', '65510215', 143, 'Diagnóstico 71', 'Tratamiento 71', 359, '2025-03-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (72, '2025-02-01 04:43:49', 3, 'SERV03', '53269785', 82, 'Diagnóstico 72', 'Tratamiento 72', 234, '2025-03-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (73, '2025-02-11 08:28:18', 1, 'SERV02', '86909002', 163, 'Diagnóstico 73', 'Tratamiento 73', 261, '2025-02-15');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (74, '2025-03-04 14:12:57', 10, 'SERV01', '69385561', 98, 'Diagnóstico 74', 'Tratamiento 74', 284, '2025-03-03');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (75, '2025-01-01 18:37:54', 9, 'SERV03', '98741936', 174, 'Diagnóstico 75', 'Tratamiento 75', 188, '2025-01-29');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (76, '2025-01-12 07:30:35', 6, 'SERV03', '27110702', 51, 'Diagnóstico 76', 'Tratamiento 76', 398, '2025-01-19');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (77, '2025-03-05 20:40:22', 10, 'SERV05', '85449907', 155, 'Diagnóstico 77', 'Tratamiento 77', 136, '2025-02-16');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (78, '2025-02-08 06:38:14', 2, 'SERV03', '99484137', 133, 'Diagnóstico 78', 'Tratamiento 78', 282, '2025-01-17');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (79, '2025-02-23 07:33:40', 6, 'SERV04', '17253062', 179, 'Diagnóstico 79', 'Tratamiento 79', 210, '2025-02-24');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (80, '2025-02-05 12:25:47', 3, 'SERV05', '52194975', 56, 'Diagnóstico 80', 'Tratamiento 80', 119, '2025-01-25');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (81, '2025-02-09 05:24:27', 2, 'SERV02', '99484137', 165, 'Diagnóstico 81', 'Tratamiento 81', 150, '2025-02-09');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (82, '2025-02-24 01:03:30', 8, 'SERV03', '12107986', 26, 'Diagnóstico 82', 'Tratamiento 82', 460, '2025-02-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (83, '2025-01-31 09:23:03', 3, 'SERV03', '35303697', 91, 'Diagnóstico 83', 'Tratamiento 83', 157, '2025-02-16');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (84, '2025-02-18 20:39:19', 3, 'SERV03', '17253062', 157, 'Diagnóstico 84', 'Tratamiento 84', 155, '2025-01-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (85, '2025-01-11 09:52:43', 1, 'SERV01', '99484137', 159, 'Diagnóstico 85', 'Tratamiento 85', 149, '2025-02-10');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (86, '2025-01-15 12:16:43', 7, 'SERV04', '27110702', 14, 'Diagnóstico 86', 'Tratamiento 86', 269, '2025-02-28');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (87, '2025-01-22 17:16:22', 2, 'SERV04', '98741936', 118, 'Diagnóstico 87', 'Tratamiento 87', 198, '2025-02-10');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (88, '2025-01-04 06:23:52', 6, 'SERV02', '35303697', 80, 'Diagnóstico 88', 'Tratamiento 88', 140, '2025-03-09');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (89, '2025-02-21 12:34:24', 3, 'SERV02', '27110702', 27, 'Diagnóstico 89', 'Tratamiento 89', 251, '2025-01-22');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (90, '2025-03-08 17:12:00', 2, 'SERV01', '6467537', 199, 'Diagnóstico 90', 'Tratamiento 90', 110, '2025-01-09');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (91, '2025-02-21 10:28:50', 9, 'SERV05', '6467537', 55, 'Diagnóstico 91', 'Tratamiento 91', 380, '2025-02-24');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (92, '2025-02-03 21:45:37', 10, 'SERV04', '3357301', 42, 'Diagnóstico 92', 'Tratamiento 92', 206, '2025-01-11');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (93, '2025-02-15 19:37:09', 4, 'SERV03', '7402147', 182, 'Diagnóstico 93', 'Tratamiento 93', 119, '2025-03-03');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (94, '2025-03-09 23:47:31', 10, 'SERV03', '52194975', 148, 'Diagnóstico 94', 'Tratamiento 94', 296, '2025-03-06');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (95, '2025-01-13 23:09:41', 8, 'SERV05', '25089541', 15, 'Diagnóstico 95', 'Tratamiento 95', 244, '2025-02-10');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (96, '2025-03-02 19:33:53', 7, 'SERV01', '35066437', 91, 'Diagnóstico 96', 'Tratamiento 96', 102, '2025-01-12');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (97, '2025-02-11 20:30:51', 2, 'SERV04', '35066437', 169, 'Diagnóstico 97', 'Tratamiento 97', 334, '2025-02-04');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (98, '2025-02-27 21:37:16', 7, 'SERV01', '98741936', 5, 'Diagnóstico 98', 'Tratamiento 98', 116, '2025-01-27');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (99, '2025-02-10 08:08:03', 7, 'SERV03', '17253062', 82, 'Diagnóstico 99', 'Tratamiento 99', 292, '2025-01-21');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (100, '2025-01-08 01:50:04', 4, 'SERV03', '86909002', 88, 'Diagnóstico 100', 'Tratamiento 100', 485, '2025-02-23');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (101, '2025-01-12 03:22:47', 4, 'SERV03', '98741936', 190, 'Diagnóstico 101', 'Tratamiento 101', 288, '2025-01-17');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (102, '2025-03-09 07:28:57', 4, 'SERV05', '29273251', 123, 'Diagnóstico 102', 'Tratamiento 102', 200, '2025-02-26');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (103, '2025-01-12 22:03:39', 6, 'SERV04', '35066437', 34, 'Diagnóstico 103', 'Tratamiento 103', 402, '2025-02-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (104, '2025-01-16 00:25:00', 5, 'SERV02', '17253062', 80, 'Diagnóstico 104', 'Tratamiento 104', 430, '2025-02-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (105, '2025-03-08 14:15:25', 8, 'SERV03', '85449907', 133, 'Diagnóstico 105', 'Tratamiento 105', 400, '2025-02-13');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (106, '2025-03-03 23:17:47', 5, 'SERV01', '27110702', 154, 'Diagnóstico 106', 'Tratamiento 106', 398, '2025-03-06');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (107, '2025-01-31 05:28:12', 10, 'SERV05', '59339518', 105, 'Diagnóstico 107', 'Tratamiento 107', 488, '2025-02-12');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (108, '2025-02-24 22:05:06', 5, 'SERV02', '53269785', 12, 'Diagnóstico 108', 'Tratamiento 108', 444, '2025-01-14');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (109, '2025-02-02 01:10:40', 1, 'SERV01', '17253062', 141, 'Diagnóstico 109', 'Tratamiento 109', 379, '2025-03-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (110, '2025-02-13 23:41:21', 8, 'SERV02', '52194975', 8, 'Diagnóstico 110', 'Tratamiento 110', 483, '2025-01-18');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (111, '2025-02-10 19:44:10', 3, 'SERV05', '27110702', 187, 'Diagnóstico 111', 'Tratamiento 111', 410, '2025-02-15');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (112, '2025-01-19 08:32:24', 3, 'SERV02', '59339518', 131, 'Diagnóstico 112', 'Tratamiento 112', 326, '2025-01-21');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (113, '2025-01-03 18:39:48', 7, 'SERV04', '6467537', 22, 'Diagnóstico 113', 'Tratamiento 113', 244, '2025-02-09');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (114, '2025-01-07 00:27:29', 1, 'SERV04', '99484137', 175, 'Diagnóstico 114', 'Tratamiento 114', 401, '2025-01-03');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (115, '2025-01-10 18:18:15', 7, 'SERV02', '12107986', 61, 'Diagnóstico 115', 'Tratamiento 115', 111, '2025-01-15');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (116, '2025-02-01 02:39:10', 5, 'SERV04', '35303697', 26, 'Diagnóstico 116', 'Tratamiento 116', 495, '2025-02-27');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (117, '2025-01-18 17:25:33', 4, 'SERV05', '7402147', 27, 'Diagnóstico 117', 'Tratamiento 117', 343, '2025-03-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (118, '2025-02-12 02:14:30', 9, 'SERV05', '69385561', 172, 'Diagnóstico 118', 'Tratamiento 118', 334, '2025-01-25');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (119, '2025-01-29 14:57:34', 3, 'SERV05', '7402147', 148, 'Diagnóstico 119', 'Tratamiento 119', 419, '2025-03-07');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (120, '2025-02-20 16:27:52', 2, 'SERV05', '25089541', 176, 'Diagnóstico 120', 'Tratamiento 120', 418, '2025-02-15');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (121, '2025-02-28 12:07:36', 6, 'SERV04', '99484137', 15, 'Diagnóstico 121', 'Tratamiento 121', 421, '2025-03-09');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (122, '2025-01-29 04:04:07', 3, 'SERV04', '3357301', 42, 'Diagnóstico 122', 'Tratamiento 122', 131, '2025-01-13');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (123, '2025-01-21 07:13:27', 7, 'SERV05', '3357301', 120, 'Diagnóstico 123', 'Tratamiento 123', 420, '2025-02-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (124, '2025-01-08 00:31:30', 10, 'SERV03', '53269785', 196, 'Diagnóstico 124', 'Tratamiento 124', 393, '2025-01-07');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (125, '2025-02-09 17:19:36', 9, 'SERV05', '99484137', 40, 'Diagnóstico 125', 'Tratamiento 125', 485, '2025-02-11');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (126, '2025-03-09 08:08:32', 2, 'SERV04', '29273251', 55, 'Diagnóstico 126', 'Tratamiento 126', 169, '2025-01-11');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (127, '2025-03-03 14:51:15', 10, 'SERV04', '35303697', 148, 'Diagnóstico 127', 'Tratamiento 127', 237, '2025-02-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (128, '2025-02-23 21:35:55', 4, 'SERV01', '65510215', 163, 'Diagnóstico 128', 'Tratamiento 128', 327, '2025-02-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (129, '2025-01-02 11:45:28', 2, 'SERV04', '65510215', 128, 'Diagnóstico 129', 'Tratamiento 129', 367, '2025-01-12');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (130, '2025-02-22 13:40:55', 8, 'SERV03', '3357301', 94, 'Diagnóstico 130', 'Tratamiento 130', 189, '2025-02-11');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (131, '2025-02-16 05:03:12', 10, 'SERV02', '29273251', 109, 'Diagnóstico 131', 'Tratamiento 131', 221, '2025-01-30');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (132, '2025-01-27 12:12:50', 7, 'SERV04', '53269785', 103, 'Diagnóstico 132', 'Tratamiento 132', 279, '2025-01-18');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (133, '2025-02-23 13:23:27', 5, 'SERV03', '27110702', 157, 'Diagnóstico 133', 'Tratamiento 133', 372, '2025-01-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (134, '2025-01-31 06:02:41', 1, 'SERV03', '69385561', 196, 'Diagnóstico 134', 'Tratamiento 134', 375, '2025-01-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (135, '2025-01-17 00:23:34', 10, 'SERV05', '29273251', 12, 'Diagnóstico 135', 'Tratamiento 135', 226, '2025-02-23');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (136, '2025-01-11 00:57:03', 5, 'SERV01', '27217280', 177, 'Diagnóstico 136', 'Tratamiento 136', 116, '2025-02-26');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (137, '2025-02-15 02:08:17', 6, 'SERV04', '35303697', 135, 'Diagnóstico 137', 'Tratamiento 137', 490, '2025-01-24');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (138, '2025-01-27 02:48:53', 5, 'SERV05', '65510215', 79, 'Diagnóstico 138', 'Tratamiento 138', 476, '2025-02-03');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (139, '2025-02-19 22:23:56', 9, 'SERV02', '65510215', 100, 'Diagnóstico 139', 'Tratamiento 139', 360, '2025-02-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (140, '2025-01-26 23:24:21', 10, 'SERV02', '12107986', 170, 'Diagnóstico 140', 'Tratamiento 140', 314, '2025-02-21');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (141, '2025-02-11 04:31:56', 7, 'SERV03', '99484137', 54, 'Diagnóstico 141', 'Tratamiento 141', 355, '2025-02-26');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (142, '2025-02-23 18:07:56', 3, 'SERV05', '35066437', 193, 'Diagnóstico 142', 'Tratamiento 142', 186, '2025-02-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (143, '2025-01-21 04:15:41', 6, 'SERV04', '98741936', 135, 'Diagnóstico 143', 'Tratamiento 143', 352, '2025-02-04');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (144, '2025-01-10 09:54:28', 10, 'SERV05', '29273251', 5, 'Diagnóstico 144', 'Tratamiento 144', 192, '2025-01-15');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (145, '2025-02-15 22:27:32', 10, 'SERV01', '98741936', 75, 'Diagnóstico 145', 'Tratamiento 145', 469, '2025-03-09');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (146, '2025-02-17 03:45:58', 6, 'SERV03', '86909002', 9, 'Diagnóstico 146', 'Tratamiento 146', 307, '2025-01-31');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (147, '2025-01-17 11:33:50', 8, 'SERV05', '3357301', 90, 'Diagnóstico 147', 'Tratamiento 147', 347, '2025-02-23');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (148, '2025-01-03 19:44:07', 4, 'SERV02', '59339518', 122, 'Diagnóstico 148', 'Tratamiento 148', 353, '2025-01-26');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (149, '2025-02-26 22:20:30', 5, 'SERV04', '25089541', 27, 'Diagnóstico 149', 'Tratamiento 149', 397, '2025-01-21');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (150, '2025-01-30 13:11:34', 2, 'SERV03', '35066437', 82, 'Diagnóstico 150', 'Tratamiento 150', 386, '2025-01-10');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (151, '2025-01-23 04:10:16', 6, 'SERV05', '25089541', 45, 'Diagnóstico 151', 'Tratamiento 151', 250, '2025-01-22');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (152, '2025-02-27 10:35:15', 7, 'SERV01', '3357301', 81, 'Diagnóstico 152', 'Tratamiento 152', 454, '2025-02-18');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (153, '2025-01-21 15:11:17', 3, 'SERV04', '35303697', 70, 'Diagnóstico 153', 'Tratamiento 153', 434, '2025-03-04');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (154, '2025-02-07 20:49:09', 7, 'SERV02', '3357301', 175, 'Diagnóstico 154', 'Tratamiento 154', 475, '2025-01-12');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (155, '2025-03-07 22:02:57', 8, 'SERV05', '98741936', 129, 'Diagnóstico 155', 'Tratamiento 155', 454, '2025-02-28');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (156, '2025-02-15 10:11:20', 8, 'SERV03', '3357301', 35, 'Diagnóstico 156', 'Tratamiento 156', 215, '2025-02-28');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (157, '2025-01-07 22:35:26', 3, 'SERV05', '35303697', 67, 'Diagnóstico 157', 'Tratamiento 157', 199, '2025-02-03');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (158, '2025-01-26 09:08:31', 10, 'SERV05', '59339518', 105, 'Diagnóstico 158', 'Tratamiento 158', 343, '2025-03-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (159, '2025-02-24 22:33:48', 8, 'SERV02', '6467537', 98, 'Diagnóstico 159', 'Tratamiento 159', 388, '2025-01-27');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (160, '2025-01-24 01:14:03', 1, 'SERV05', '35066437', 42, 'Diagnóstico 160', 'Tratamiento 160', 469, '2025-02-11');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (161, '2025-01-30 17:45:46', 10, 'SERV05', '3357301', 173, 'Diagnóstico 161', 'Tratamiento 161', 372, '2025-01-24');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (162, '2025-01-02 04:55:17', 1, 'SERV01', '52194975', 107, 'Diagnóstico 162', 'Tratamiento 162', 106, '2025-01-14');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (163, '2025-01-15 21:58:03', 9, 'SERV04', '98741936', 180, 'Diagnóstico 163', 'Tratamiento 163', 473, '2025-03-09');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (164, '2025-02-20 01:38:52', 7, 'SERV01', '27110702', 146, 'Diagnóstico 164', 'Tratamiento 164', 390, '2025-02-07');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (165, '2025-01-09 19:25:26', 4, 'SERV05', '59339518', 40, 'Diagnóstico 165', 'Tratamiento 165', 303, '2025-01-19');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (166, '2025-03-05 04:54:15', 7, 'SERV05', '17253062', 71, 'Diagnóstico 166', 'Tratamiento 166', 155, '2025-01-22');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (167, '2025-01-21 19:28:56', 1, 'SERV05', '27217280', 78, 'Diagnóstico 167', 'Tratamiento 167', 136, '2025-01-17');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (168, '2025-01-10 08:33:01', 3, 'SERV04', '35303697', 97, 'Diagnóstico 168', 'Tratamiento 168', 214, '2025-02-15');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (169, '2025-02-01 14:23:49', 5, 'SERV04', '53269785', 28, 'Diagnóstico 169', 'Tratamiento 169', 199, '2025-02-26');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (170, '2025-01-05 09:38:05', 2, 'SERV03', '53269785', 92, 'Diagnóstico 170', 'Tratamiento 170', 268, '2025-01-06');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (171, '2025-02-14 03:30:43', 1, 'SERV05', '35303697', 115, 'Diagnóstico 171', 'Tratamiento 171', 388, '2025-02-10');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (172, '2025-01-12 07:14:49', 1, 'SERV02', '25089541', 141, 'Diagnóstico 172', 'Tratamiento 172', 137, '2025-02-28');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (173, '2025-01-25 10:00:04', 6, 'SERV02', '12107986', 56, 'Diagnóstico 173', 'Tratamiento 173', 479, '2025-01-18');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (174, '2025-01-12 07:13:56', 9, 'SERV01', '6467537', 180, 'Diagnóstico 174', 'Tratamiento 174', 462, '2025-03-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (175, '2025-01-19 13:45:17', 6, 'SERV05', '3357301', 94, 'Diagnóstico 175', 'Tratamiento 175', 104, '2025-02-24');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (176, '2025-03-06 01:36:10', 7, 'SERV03', '27217280', 71, 'Diagnóstico 176', 'Tratamiento 176', 167, '2025-02-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (177, '2025-02-08 14:37:31', 8, 'SERV05', '35066437', 159, 'Diagnóstico 177', 'Tratamiento 177', 327, '2025-02-27');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (178, '2025-02-28 06:03:31', 10, 'SERV02', '29273251', 32, 'Diagnóstico 178', 'Tratamiento 178', 457, '2025-02-10');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (179, '2025-02-15 11:15:28', 5, 'SERV04', '52194975', 53, 'Diagnóstico 179', 'Tratamiento 179', 134, '2025-02-17');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (180, '2025-01-17 17:18:30', 8, 'SERV02', '85449907', 11, 'Diagnóstico 180', 'Tratamiento 180', 336, '2025-01-12');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (181, '2025-03-04 01:21:58', 2, 'SERV05', '27217280', 110, 'Diagnóstico 181', 'Tratamiento 181', 249, '2025-03-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (182, '2025-03-06 11:56:20', 7, 'SERV04', '52194975', 195, 'Diagnóstico 182', 'Tratamiento 182', 283, '2025-01-11');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (183, '2025-02-16 11:37:30', 5, 'SERV03', '17253062', 184, 'Diagnóstico 183', 'Tratamiento 183', 234, '2025-03-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (184, '2025-02-01 05:04:21', 9, 'SERV03', '25089541', 13, 'Diagnóstico 184', 'Tratamiento 184', 149, '2025-02-19');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (185, '2025-02-07 18:07:54', 7, 'SERV04', '99484137', 45, 'Diagnóstico 185', 'Tratamiento 185', 391, '2025-01-30');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (186, '2025-02-01 11:43:22', 3, 'SERV04', '7402147', 170, 'Diagnóstico 186', 'Tratamiento 186', 403, '2025-01-25');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (187, '2025-03-05 21:06:56', 7, 'SERV03', '59339518', 163, 'Diagnóstico 187', 'Tratamiento 187', 263, '2025-03-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (188, '2025-03-02 10:11:50', 4, 'SERV05', '35066437', 182, 'Diagnóstico 188', 'Tratamiento 188', 246, '2025-02-19');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (189, '2025-02-01 22:30:19', 8, 'SERV03', '35066437', 89, 'Diagnóstico 189', 'Tratamiento 189', 426, '2025-01-09');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (190, '2025-01-07 09:20:55', 10, 'SERV05', '7402147', 96, 'Diagnóstico 190', 'Tratamiento 190', 291, '2025-02-25');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (191, '2025-01-14 10:05:44', 10, 'SERV04', '17253062', 168, 'Diagnóstico 191', 'Tratamiento 191', 263, '2025-02-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (192, '2025-03-03 11:37:06', 1, 'SERV04', '35303697', 142, 'Diagnóstico 192', 'Tratamiento 192', 383, '2025-02-23');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (193, '2025-02-14 23:18:50', 4, 'SERV04', '98741936', 17, 'Diagnóstico 193', 'Tratamiento 193', 315, '2025-02-18');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (194, '2025-01-24 15:42:38', 9, 'SERV01', '3357301', 180, 'Diagnóstico 194', 'Tratamiento 194', 340, '2025-01-11');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (195, '2025-02-19 12:23:46', 6, 'SERV02', '35303697', 67, 'Diagnóstico 195', 'Tratamiento 195', 401, '2025-02-21');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (196, '2025-03-01 08:20:36', 9, 'SERV01', '35066437', 64, 'Diagnóstico 196', 'Tratamiento 196', 455, '2025-02-15');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (197, '2025-01-08 20:26:32', 2, 'SERV05', '53269785', 100, 'Diagnóstico 197', 'Tratamiento 197', 299, '2025-02-11');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (198, '2025-02-04 16:12:21', 9, 'SERV04', '69385561', 91, 'Diagnóstico 198', 'Tratamiento 198', 353, '2025-01-14');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (199, '2025-02-08 23:41:27', 7, 'SERV04', '3357301', 183, 'Diagnóstico 199', 'Tratamiento 199', 494, '2025-02-17');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (200, '2025-01-08 18:55:29', 9, 'SERV01', '35066437', 61, 'Diagnóstico 200', 'Tratamiento 200', 282, '2025-01-21');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (201, '2025-02-01 09:33:50', 7, 'SERV05', '99484137', 144, 'Diagnóstico 201', 'Tratamiento 201', 467, '2025-03-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (202, '2025-02-11 17:02:53', 3, 'SERV04', '52194975', 89, 'Diagnóstico 202', 'Tratamiento 202', 186, '2025-02-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (203, '2025-02-23 19:54:13', 3, 'SERV01', '65510215', 121, 'Diagnóstico 203', 'Tratamiento 203', 492, '2025-01-17');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (204, '2025-02-27 02:14:21', 4, 'SERV02', '53269785', 185, 'Diagnóstico 204', 'Tratamiento 204', 237, '2025-03-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (205, '2025-02-12 23:17:27', 7, 'SERV01', '69385561', 188, 'Diagnóstico 205', 'Tratamiento 205', 419, '2025-02-07');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (206, '2025-01-23 14:52:00', 10, 'SERV04', '6467537', 200, 'Diagnóstico 206', 'Tratamiento 206', 157, '2025-02-10');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (207, '2025-01-16 23:05:23', 2, 'SERV04', '7402147', 126, 'Diagnóstico 207', 'Tratamiento 207', 144, '2025-01-03');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (208, '2025-01-31 04:51:28', 9, 'SERV04', '99484137', 152, 'Diagnóstico 208', 'Tratamiento 208', 448, '2025-03-03');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (209, '2025-02-07 20:01:22', 8, 'SERV04', '25089541', 15, 'Diagnóstico 209', 'Tratamiento 209', 396, '2025-01-30');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (210, '2025-01-02 03:51:21', 7, 'SERV04', '35066437', 73, 'Diagnóstico 210', 'Tratamiento 210', 105, '2025-01-25');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (211, '2025-03-06 23:28:19', 2, 'SERV03', '25089541', 155, 'Diagnóstico 211', 'Tratamiento 211', 270, '2025-02-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (212, '2025-02-22 20:14:26', 3, 'SERV02', '12107986', 82, 'Diagnóstico 212', 'Tratamiento 212', 375, '2025-03-06');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (213, '2025-03-09 21:29:59', 1, 'SERV05', '65510215', 106, 'Diagnóstico 213', 'Tratamiento 213', 208, '2025-01-17');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (214, '2025-02-04 03:41:31', 6, 'SERV05', '98741936', 95, 'Diagnóstico 214', 'Tratamiento 214', 351, '2025-02-21');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (215, '2025-02-28 01:16:17', 2, 'SERV03', '7402147', 157, 'Diagnóstico 215', 'Tratamiento 215', 174, '2025-01-24');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (216, '2025-01-04 17:15:28', 5, 'SERV03', '6467537', 185, 'Diagnóstico 216', 'Tratamiento 216', 218, '2025-02-04');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (217, '2025-02-16 06:30:04', 5, 'SERV05', '29273251', 67, 'Diagnóstico 217', 'Tratamiento 217', 124, '2025-02-03');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (218, '2025-01-05 18:50:04', 7, 'SERV04', '65510215', 147, 'Diagnóstico 218', 'Tratamiento 218', 123, '2025-01-06');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (219, '2025-03-01 20:06:09', 4, 'SERV01', '99484137', 5, 'Diagnóstico 219', 'Tratamiento 219', 221, '2025-01-24');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (220, '2025-02-12 23:58:06', 2, 'SERV01', '29273251', 162, 'Diagnóstico 220', 'Tratamiento 220', 124, '2025-02-07');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (221, '2025-03-05 03:02:28', 2, 'SERV03', '12107986', 76, 'Diagnóstico 221', 'Tratamiento 221', 417, '2025-01-11');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (222, '2025-01-14 13:19:08', 10, 'SERV04', '98741936', 73, 'Diagnóstico 222', 'Tratamiento 222', 104, '2025-01-14');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (223, '2025-02-08 09:45:24', 1, 'SERV04', '99484137', 34, 'Diagnóstico 223', 'Tratamiento 223', 285, '2025-02-28');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (224, '2025-01-12 07:47:58', 2, 'SERV02', '65510215', 28, 'Diagnóstico 224', 'Tratamiento 224', 464, '2025-02-26');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (225, '2025-03-07 03:50:06', 8, 'SERV01', '65510215', 171, 'Diagnóstico 225', 'Tratamiento 225', 277, '2025-02-10');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (226, '2025-02-03 04:47:32', 9, 'SERV02', '25089541', 6, 'Diagnóstico 226', 'Tratamiento 226', 333, '2025-01-12');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (227, '2025-01-26 19:36:39', 3, 'SERV04', '98741936', 43, 'Diagnóstico 227', 'Tratamiento 227', 417, '2025-03-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (228, '2025-03-08 12:22:14', 9, 'SERV02', '52194975', 42, 'Diagnóstico 228', 'Tratamiento 228', 429, '2025-01-13');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (229, '2025-03-02 13:35:20', 4, 'SERV02', '27217280', 114, 'Diagnóstico 229', 'Tratamiento 229', 248, '2025-02-03');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (230, '2025-01-12 23:13:11', 6, 'SERV03', '25089541', 59, 'Diagnóstico 230', 'Tratamiento 230', 385, '2025-02-04');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (231, '2025-01-09 07:29:51', 4, 'SERV02', '86909002', 131, 'Diagnóstico 231', 'Tratamiento 231', 271, '2025-02-14');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (232, '2025-03-06 12:42:43', 6, 'SERV01', '25089541', 78, 'Diagnóstico 232', 'Tratamiento 232', 183, '2025-02-15');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (233, '2025-02-11 05:51:05', 4, 'SERV05', '85449907', 177, 'Diagnóstico 233', 'Tratamiento 233', 310, '2025-02-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (234, '2025-01-06 20:46:34', 5, 'SERV05', '17253062', 117, 'Diagnóstico 234', 'Tratamiento 234', 306, '2025-02-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (235, '2025-01-26 20:06:16', 8, 'SERV03', '99484137', 26, 'Diagnóstico 235', 'Tratamiento 235', 496, '2025-02-13');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (236, '2025-02-07 07:34:12', 9, 'SERV05', '53269785', 182, 'Diagnóstico 236', 'Tratamiento 236', 463, '2025-01-27');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (237, '2025-01-21 12:56:34', 7, 'SERV02', '25089541', 33, 'Diagnóstico 237', 'Tratamiento 237', 229, '2025-01-09');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (238, '2025-02-07 03:50:36', 7, 'SERV01', '29273251', 25, 'Diagnóstico 238', 'Tratamiento 238', 231, '2025-01-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (239, '2025-01-27 05:57:43', 2, 'SERV03', '3357301', 191, 'Diagnóstico 239', 'Tratamiento 239', 185, '2025-01-13');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (240, '2025-01-10 20:22:31', 9, 'SERV01', '6467537', 182, 'Diagnóstico 240', 'Tratamiento 240', 236, '2025-03-07');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (241, '2025-02-04 12:42:25', 9, 'SERV04', '29273251', 179, 'Diagnóstico 241', 'Tratamiento 241', 477, '2025-03-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (242, '2025-01-05 03:25:55', 7, 'SERV03', '85449907', 39, 'Diagnóstico 242', 'Tratamiento 242', 275, '2025-03-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (243, '2025-02-02 22:56:36', 7, 'SERV03', '35303697', 151, 'Diagnóstico 243', 'Tratamiento 243', 106, '2025-02-19');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (244, '2025-01-05 05:18:46', 9, 'SERV04', '98741936', 160, 'Diagnóstico 244', 'Tratamiento 244', 458, '2025-03-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (245, '2025-02-12 20:18:47', 6, 'SERV04', '52194975', 177, 'Diagnóstico 245', 'Tratamiento 245', 439, '2025-01-09');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (246, '2025-01-01 19:34:30', 5, 'SERV02', '85449907', 62, 'Diagnóstico 246', 'Tratamiento 246', 436, '2025-02-25');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (247, '2025-01-01 11:56:38', 4, 'SERV05', '98741936', 93, 'Diagnóstico 247', 'Tratamiento 247', 259, '2025-01-15');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (248, '2025-02-13 22:33:16', 7, 'SERV02', '52194975', 165, 'Diagnóstico 248', 'Tratamiento 248', 360, '2025-02-12');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (249, '2025-03-03 23:15:55', 8, 'SERV01', '29273251', 13, 'Diagnóstico 249', 'Tratamiento 249', 429, '2025-01-11');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (250, '2025-02-14 20:11:01', 1, 'SERV02', '69385561', 139, 'Diagnóstico 250', 'Tratamiento 250', 452, '2025-01-10');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (251, '2025-02-04 16:31:20', 9, 'SERV04', '85449907', 50, 'Diagnóstico 251', 'Tratamiento 251', 103, '2025-02-14');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (252, '2025-01-07 01:54:11', 10, 'SERV04', '35303697', 44, 'Diagnóstico 252', 'Tratamiento 252', 365, '2025-02-21');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (253, '2025-01-27 05:45:07', 1, 'SERV04', '29273251', 46, 'Diagnóstico 253', 'Tratamiento 253', 114, '2025-01-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (254, '2025-01-06 17:12:08', 6, 'SERV04', '17253062', 87, 'Diagnóstico 254', 'Tratamiento 254', 399, '2025-02-12');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (255, '2025-02-09 17:30:26', 7, 'SERV04', '99484137', 16, 'Diagnóstico 255', 'Tratamiento 255', 227, '2025-01-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (256, '2025-02-09 00:50:11', 6, 'SERV01', '7402147', 115, 'Diagnóstico 256', 'Tratamiento 256', 214, '2025-01-17');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (257, '2025-01-26 07:11:36', 10, 'SERV05', '52194975', 71, 'Diagnóstico 257', 'Tratamiento 257', 495, '2025-02-17');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (258, '2025-01-02 02:36:02', 2, 'SERV03', '86909002', 82, 'Diagnóstico 258', 'Tratamiento 258', 316, '2025-01-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (259, '2025-01-03 15:17:12', 10, 'SERV01', '17253062', 73, 'Diagnóstico 259', 'Tratamiento 259', 247, '2025-01-25');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (260, '2025-02-24 11:32:52', 9, 'SERV05', '59339518', 25, 'Diagnóstico 260', 'Tratamiento 260', 315, '2025-02-28');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (261, '2025-02-07 19:27:22', 10, 'SERV04', '85449907', 195, 'Diagnóstico 261', 'Tratamiento 261', 405, '2025-01-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (262, '2025-03-03 01:32:27', 6, 'SERV05', '65510215', 174, 'Diagnóstico 262', 'Tratamiento 262', 254, '2025-02-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (263, '2025-02-17 07:24:32', 3, 'SERV02', '98741936', 27, 'Diagnóstico 263', 'Tratamiento 263', 213, '2025-02-23');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (264, '2025-02-18 13:03:51', 4, 'SERV04', '69385561', 19, 'Diagnóstico 264', 'Tratamiento 264', 206, '2025-01-25');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (265, '2025-02-02 22:08:53', 2, 'SERV03', '65510215', 18, 'Diagnóstico 265', 'Tratamiento 265', 260, '2025-01-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (266, '2025-02-11 00:36:36', 1, 'SERV04', '85449907', 169, 'Diagnóstico 266', 'Tratamiento 266', 256, '2025-01-23');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (267, '2025-02-27 23:21:37', 7, 'SERV05', '53269785', 96, 'Diagnóstico 267', 'Tratamiento 267', 255, '2025-01-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (268, '2025-01-16 07:36:51', 4, 'SERV02', '17253062', 25, 'Diagnóstico 268', 'Tratamiento 268', 405, '2025-02-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (269, '2025-01-29 17:53:54', 2, 'SERV02', '29273251', 5, 'Diagnóstico 269', 'Tratamiento 269', 360, '2025-02-09');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (270, '2025-01-30 10:15:47', 9, 'SERV03', '27110702', 21, 'Diagnóstico 270', 'Tratamiento 270', 240, '2025-02-12');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (271, '2025-01-30 16:21:49', 6, 'SERV02', '27217280', 81, 'Diagnóstico 271', 'Tratamiento 271', 201, '2025-02-04');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (272, '2025-01-07 17:09:13', 10, 'SERV02', '25089541', 48, 'Diagnóstico 272', 'Tratamiento 272', 225, '2025-02-07');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (273, '2025-01-13 19:24:43', 7, 'SERV02', '86909002', 121, 'Diagnóstico 273', 'Tratamiento 273', 488, '2025-02-24');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (274, '2025-01-05 00:05:04', 6, 'SERV03', '25089541', 57, 'Diagnóstico 274', 'Tratamiento 274', 106, '2025-01-07');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (275, '2025-02-27 01:21:20', 6, 'SERV03', '17253062', 54, 'Diagnóstico 275', 'Tratamiento 275', 324, '2025-01-09');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (276, '2025-02-08 00:29:56', 3, 'SERV01', '85449907', 178, 'Diagnóstico 276', 'Tratamiento 276', 265, '2025-01-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (277, '2025-01-13 12:25:23', 3, 'SERV01', '6467537', 106, 'Diagnóstico 277', 'Tratamiento 277', 249, '2025-01-27');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (278, '2025-01-20 04:26:46', 8, 'SERV02', '6467537', 43, 'Diagnóstico 278', 'Tratamiento 278', 450, '2025-02-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (279, '2025-01-24 04:24:00', 7, 'SERV05', '53269785', 62, 'Diagnóstico 279', 'Tratamiento 279', 160, '2025-01-28');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (280, '2025-01-21 14:54:58', 7, 'SERV04', '86909002', 125, 'Diagnóstico 280', 'Tratamiento 280', 195, '2025-01-18');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (281, '2025-01-11 01:39:23', 1, 'SERV02', '27110702', 159, 'Diagnóstico 281', 'Tratamiento 281', 203, '2025-01-19');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (282, '2025-01-10 19:34:39', 1, 'SERV05', '52194975', 183, 'Diagnóstico 282', 'Tratamiento 282', 466, '2025-03-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (283, '2025-02-07 07:25:16', 9, 'SERV03', '17253062', 105, 'Diagnóstico 283', 'Tratamiento 283', 340, '2025-01-10');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (284, '2025-03-02 05:22:18', 5, 'SERV02', '59339518', 184, 'Diagnóstico 284', 'Tratamiento 284', 376, '2025-01-21');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (285, '2025-01-16 11:23:56', 5, 'SERV03', '35066437', 125, 'Diagnóstico 285', 'Tratamiento 285', 468, '2025-02-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (286, '2025-01-23 10:29:24', 8, 'SERV05', '98741936', 81, 'Diagnóstico 286', 'Tratamiento 286', 211, '2025-02-16');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (287, '2025-02-20 14:53:06', 8, 'SERV04', '85449907', 56, 'Diagnóstico 287', 'Tratamiento 287', 231, '2025-01-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (288, '2025-03-08 08:06:43', 1, 'SERV05', '53269785', 153, 'Diagnóstico 288', 'Tratamiento 288', 466, '2025-01-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (289, '2025-01-12 01:43:33', 8, 'SERV04', '35303697', 36, 'Diagnóstico 289', 'Tratamiento 289', 341, '2025-01-17');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (290, '2025-01-13 16:43:12', 6, 'SERV05', '59339518', 67, 'Diagnóstico 290', 'Tratamiento 290', 257, '2025-02-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (291, '2025-01-14 17:24:08', 1, 'SERV03', '53269785', 127, 'Diagnóstico 291', 'Tratamiento 291', 156, '2025-01-16');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (292, '2025-02-16 21:14:53', 9, 'SERV03', '65510215', 151, 'Diagnóstico 292', 'Tratamiento 292', 415, '2025-02-17');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (293, '2025-02-14 18:08:49', 7, 'SERV04', '69385561', 62, 'Diagnóstico 293', 'Tratamiento 293', 231, '2025-01-31');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (294, '2025-01-08 00:25:22', 5, 'SERV01', '35066437', 127, 'Diagnóstico 294', 'Tratamiento 294', 387, '2025-01-07');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (295, '2025-01-18 08:53:31', 3, 'SERV02', '27110702', 176, 'Diagnóstico 295', 'Tratamiento 295', 410, '2025-01-13');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (296, '2025-03-03 17:38:37', 4, 'SERV04', '29273251', 42, 'Diagnóstico 296', 'Tratamiento 296', 439, '2025-03-07');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (297, '2025-02-23 09:44:13', 3, 'SERV01', '27110702', 197, 'Diagnóstico 297', 'Tratamiento 297', 112, '2025-01-19');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (298, '2025-02-22 21:58:26', 6, 'SERV05', '53269785', 158, 'Diagnóstico 298', 'Tratamiento 298', 460, '2025-02-18');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (299, '2025-01-20 09:19:24', 5, 'SERV05', '86909002', 73, 'Diagnóstico 299', 'Tratamiento 299', 237, '2025-03-09');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (300, '2025-01-28 06:42:15', 6, 'SERV02', '99484137', 149, 'Diagnóstico 300', 'Tratamiento 300', 128, '2025-01-09');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (301, '2025-02-08 03:53:11', 9, 'SERV01', '59339518', 103, 'Diagnóstico 301', 'Tratamiento 301', 205, '2025-02-10');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (302, '2025-01-09 14:32:14', 1, 'SERV03', '86909002', 1, 'Diagnóstico 302', 'Tratamiento 302', 450, '2025-03-04');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (303, '2025-02-24 17:28:22', 9, 'SERV01', '99484137', 167, 'Diagnóstico 303', 'Tratamiento 303', 414, '2025-01-06');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (304, '2025-01-05 01:20:51', 7, 'SERV02', '7402147', 44, 'Diagnóstico 304', 'Tratamiento 304', 449, '2025-02-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (305, '2025-03-09 04:13:01', 7, 'SERV05', '35066437', 126, 'Diagnóstico 305', 'Tratamiento 305', 233, '2025-02-22');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (306, '2025-01-18 18:51:27', 7, 'SERV02', '59339518', 117, 'Diagnóstico 306', 'Tratamiento 306', 265, '2025-01-04');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (307, '2025-01-19 16:24:50', 6, 'SERV03', '29273251', 29, 'Diagnóstico 307', 'Tratamiento 307', 204, '2025-01-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (308, '2025-02-07 17:59:44', 2, 'SERV04', '27217280', 82, 'Diagnóstico 308', 'Tratamiento 308', 175, '2025-01-26');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (309, '2025-01-30 03:05:16', 4, 'SERV04', '27110702', 130, 'Diagnóstico 309', 'Tratamiento 309', 196, '2025-01-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (310, '2025-01-09 13:31:59', 4, 'SERV04', '52194975', 175, 'Diagnóstico 310', 'Tratamiento 310', 133, '2025-03-04');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (311, '2025-02-22 20:57:40', 6, 'SERV04', '65510215', 23, 'Diagnóstico 311', 'Tratamiento 311', 419, '2025-01-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (312, '2025-01-02 08:01:28', 8, 'SERV03', '25089541', 176, 'Diagnóstico 312', 'Tratamiento 312', 367, '2025-02-22');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (313, '2025-01-01 09:23:49', 6, 'SERV05', '3357301', 138, 'Diagnóstico 313', 'Tratamiento 313', 353, '2025-02-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (314, '2025-01-27 12:45:52', 3, 'SERV03', '12107986', 188, 'Diagnóstico 314', 'Tratamiento 314', 203, '2025-01-15');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (315, '2025-02-21 16:47:44', 10, 'SERV05', '85449907', 79, 'Diagnóstico 315', 'Tratamiento 315', 216, '2025-01-04');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (316, '2025-01-01 06:55:15', 8, 'SERV04', '7402147', 185, 'Diagnóstico 316', 'Tratamiento 316', 127, '2025-01-14');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (317, '2025-02-25 05:13:38', 5, 'SERV05', '6467537', 46, 'Diagnóstico 317', 'Tratamiento 317', 441, '2025-02-24');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (318, '2025-01-28 17:58:21', 1, 'SERV03', '69385561', 114, 'Diagnóstico 318', 'Tratamiento 318', 369, '2025-01-17');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (319, '2025-02-05 20:09:20', 6, 'SERV04', '99484137', 66, 'Diagnóstico 319', 'Tratamiento 319', 304, '2025-01-13');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (320, '2025-02-08 05:30:50', 5, 'SERV01', '7402147', 15, 'Diagnóstico 320', 'Tratamiento 320', 190, '2025-01-10');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (321, '2025-03-08 01:44:14', 7, 'SERV04', '6467537', 86, 'Diagnóstico 321', 'Tratamiento 321', 193, '2025-02-17');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (322, '2025-02-14 03:05:20', 6, 'SERV04', '35303697', 56, 'Diagnóstico 322', 'Tratamiento 322', 228, '2025-01-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (323, '2025-01-08 14:29:53', 2, 'SERV03', '59339518', 140, 'Diagnóstico 323', 'Tratamiento 323', 152, '2025-03-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (324, '2025-02-11 17:19:41', 8, 'SERV01', '35066437', 17, 'Diagnóstico 324', 'Tratamiento 324', 175, '2025-03-03');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (325, '2025-01-15 12:14:44', 9, 'SERV02', '59339518', 114, 'Diagnóstico 325', 'Tratamiento 325', 352, '2025-03-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (326, '2025-02-11 06:17:38', 10, 'SERV05', '52194975', 125, 'Diagnóstico 326', 'Tratamiento 326', 325, '2025-01-27');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (327, '2025-01-22 14:28:20', 10, 'SERV03', '7402147', 95, 'Diagnóstico 327', 'Tratamiento 327', 102, '2025-02-14');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (328, '2025-01-09 20:22:53', 7, 'SERV02', '35303697', 71, 'Diagnóstico 328', 'Tratamiento 328', 194, '2025-02-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (329, '2025-02-16 23:38:59', 10, 'SERV04', '35303697', 130, 'Diagnóstico 329', 'Tratamiento 329', 423, '2025-01-19');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (330, '2025-02-22 13:21:22', 9, 'SERV03', '17253062', 157, 'Diagnóstico 330', 'Tratamiento 330', 366, '2025-01-28');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (331, '2025-01-16 18:47:39', 6, 'SERV05', '17253062', 52, 'Diagnóstico 331', 'Tratamiento 331', 451, '2025-03-07');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (332, '2025-02-14 00:23:40', 2, 'SERV03', '29273251', 58, 'Diagnóstico 332', 'Tratamiento 332', 459, '2025-01-10');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (333, '2025-02-15 22:58:58', 2, 'SERV01', '86909002', 67, 'Diagnóstico 333', 'Tratamiento 333', 383, '2025-01-14');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (334, '2025-02-04 10:19:00', 5, 'SERV05', '29273251', 37, 'Diagnóstico 334', 'Tratamiento 334', 305, '2025-02-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (335, '2025-01-18 21:48:20', 6, 'SERV05', '99484137', 135, 'Diagnóstico 335', 'Tratamiento 335', 401, '2025-02-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (336, '2025-01-10 23:52:43', 7, 'SERV02', '12107986', 146, 'Diagnóstico 336', 'Tratamiento 336', 149, '2025-03-07');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (337, '2025-02-08 03:56:42', 1, 'SERV04', '59339518', 43, 'Diagnóstico 337', 'Tratamiento 337', 194, '2025-03-06');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (338, '2025-03-02 06:43:00', 3, 'SERV01', '53269785', 2, 'Diagnóstico 338', 'Tratamiento 338', 274, '2025-03-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (339, '2025-02-25 04:48:49', 2, 'SERV01', '35066437', 49, 'Diagnóstico 339', 'Tratamiento 339', 196, '2025-02-04');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (340, '2025-02-18 23:44:29', 8, 'SERV05', '35303697', 51, 'Diagnóstico 340', 'Tratamiento 340', 192, '2025-03-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (341, '2025-01-12 20:41:01', 8, 'SERV01', '35303697', 32, 'Diagnóstico 341', 'Tratamiento 341', 334, '2025-02-18');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (342, '2025-02-15 22:24:00', 2, 'SERV02', '35066437', 20, 'Diagnóstico 342', 'Tratamiento 342', 163, '2025-01-30');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (343, '2025-01-14 12:36:26', 9, 'SERV03', '52194975', 193, 'Diagnóstico 343', 'Tratamiento 343', 487, '2025-03-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (344, '2025-03-02 11:50:41', 1, 'SERV03', '12107986', 137, 'Diagnóstico 344', 'Tratamiento 344', 109, '2025-01-07');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (345, '2025-01-16 09:28:55', 7, 'SERV01', '27217280', 153, 'Diagnóstico 345', 'Tratamiento 345', 315, '2025-01-26');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (346, '2025-01-15 06:32:56', 9, 'SERV04', '65510215', 175, 'Diagnóstico 346', 'Tratamiento 346', 401, '2025-02-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (347, '2025-01-08 03:03:20', 9, 'SERV05', '35066437', 3, 'Diagnóstico 347', 'Tratamiento 347', 212, '2025-02-03');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (348, '2025-01-06 23:40:51', 5, 'SERV03', '29273251', 61, 'Diagnóstico 348', 'Tratamiento 348', 186, '2025-01-12');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (349, '2025-02-20 22:29:12', 6, 'SERV03', '86909002', 19, 'Diagnóstico 349', 'Tratamiento 349', 434, '2025-02-18');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (350, '2025-01-17 03:19:26', 10, 'SERV05', '53269785', 187, 'Diagnóstico 350', 'Tratamiento 350', 222, '2025-02-25');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (351, '2025-01-30 06:22:34', 4, 'SERV01', '35303697', 23, 'Diagnóstico 351', 'Tratamiento 351', 165, '2025-01-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (352, '2025-01-23 07:43:25', 5, 'SERV01', '25089541', 37, 'Diagnóstico 352', 'Tratamiento 352', 124, '2025-01-14');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (353, '2025-01-12 22:28:36', 4, 'SERV05', '65510215', 136, 'Diagnóstico 353', 'Tratamiento 353', 452, '2025-01-07');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (354, '2025-01-13 10:41:54', 4, 'SERV03', '27217280', 196, 'Diagnóstico 354', 'Tratamiento 354', 114, '2025-02-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (355, '2025-01-23 13:27:25', 1, 'SERV02', '35303697', 198, 'Diagnóstico 355', 'Tratamiento 355', 458, '2025-01-18');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (356, '2025-02-06 18:21:16', 4, 'SERV05', '29273251', 8, 'Diagnóstico 356', 'Tratamiento 356', 154, '2025-01-23');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (357, '2025-01-28 22:20:54', 3, 'SERV02', '53269785', 182, 'Diagnóstico 357', 'Tratamiento 357', 264, '2025-01-15');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (358, '2025-02-18 11:05:56', 10, 'SERV02', '3357301', 187, 'Diagnóstico 358', 'Tratamiento 358', 357, '2025-03-06');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (359, '2025-01-21 20:06:09', 10, 'SERV02', '52194975', 97, 'Diagnóstico 359', 'Tratamiento 359', 481, '2025-02-10');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (360, '2025-02-12 22:13:17', 2, 'SERV05', '17253062', 145, 'Diagnóstico 360', 'Tratamiento 360', 337, '2025-01-31');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (361, '2025-02-26 16:10:48', 1, 'SERV05', '53269785', 55, 'Diagnóstico 361', 'Tratamiento 361', 287, '2025-03-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (362, '2025-01-05 16:14:12', 3, 'SERV01', '25089541', 30, 'Diagnóstico 362', 'Tratamiento 362', 145, '2025-02-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (363, '2025-03-02 22:54:41', 5, 'SERV05', '52194975', 155, 'Diagnóstico 363', 'Tratamiento 363', 402, '2025-01-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (364, '2025-02-14 23:45:40', 9, 'SERV04', '12107986', 169, 'Diagnóstico 364', 'Tratamiento 364', 103, '2025-01-27');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (365, '2025-03-01 18:58:55', 3, 'SERV01', '27110702', 109, 'Diagnóstico 365', 'Tratamiento 365', 148, '2025-02-25');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (366, '2025-03-09 18:24:17', 7, 'SERV05', '29273251', 172, 'Diagnóstico 366', 'Tratamiento 366', 481, '2025-02-18');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (367, '2025-02-17 20:16:06', 8, 'SERV05', '35066437', 5, 'Diagnóstico 367', 'Tratamiento 367', 320, '2025-03-07');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (368, '2025-01-03 22:21:01', 2, 'SERV05', '12107986', 162, 'Diagnóstico 368', 'Tratamiento 368', 170, '2025-02-07');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (369, '2025-01-22 14:19:49', 9, 'SERV01', '27217280', 94, 'Diagnóstico 369', 'Tratamiento 369', 477, '2025-02-17');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (370, '2025-01-02 11:01:06', 7, 'SERV03', '52194975', 32, 'Diagnóstico 370', 'Tratamiento 370', 366, '2025-02-28');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (371, '2025-02-15 13:02:04', 4, 'SERV02', '52194975', 181, 'Diagnóstico 371', 'Tratamiento 371', 202, '2025-03-07');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (372, '2025-02-23 00:28:45', 3, 'SERV01', '69385561', 183, 'Diagnóstico 372', 'Tratamiento 372', 334, '2025-01-22');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (373, '2025-02-04 12:11:49', 1, 'SERV02', '59339518', 14, 'Diagnóstico 373', 'Tratamiento 373', 305, '2025-02-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (374, '2025-02-26 23:39:09', 8, 'SERV01', '59339518', 172, 'Diagnóstico 374', 'Tratamiento 374', 310, '2025-02-28');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (375, '2025-01-13 14:21:53', 3, 'SERV02', '7402147', 38, 'Diagnóstico 375', 'Tratamiento 375', 216, '2025-01-10');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (376, '2025-01-26 22:10:28', 2, 'SERV04', '12107986', 175, 'Diagnóstico 376', 'Tratamiento 376', 150, '2025-02-18');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (377, '2025-02-27 03:35:11', 7, 'SERV02', '52194975', 146, 'Diagnóstico 377', 'Tratamiento 377', 449, '2025-01-24');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (378, '2025-01-12 05:28:37', 5, 'SERV01', '12107986', 47, 'Diagnóstico 378', 'Tratamiento 378', 223, '2025-02-17');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (379, '2025-01-05 04:11:11', 8, 'SERV01', '35066437', 86, 'Diagnóstico 379', 'Tratamiento 379', 296, '2025-01-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (380, '2025-01-18 08:01:05', 8, 'SERV03', '27217280', 120, 'Diagnóstico 380', 'Tratamiento 380', 435, '2025-03-03');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (381, '2025-02-08 20:02:01', 4, 'SERV04', '6467537', 92, 'Diagnóstico 381', 'Tratamiento 381', 282, '2025-01-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (382, '2025-02-01 10:28:02', 9, 'SERV03', '27110702', 17, 'Diagnóstico 382', 'Tratamiento 382', 346, '2025-01-12');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (383, '2025-01-07 22:33:02', 8, 'SERV03', '53269785', 149, 'Diagnóstico 383', 'Tratamiento 383', 313, '2025-02-18');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (384, '2025-02-25 14:43:40', 10, 'SERV05', '6467537', 167, 'Diagnóstico 384', 'Tratamiento 384', 223, '2025-02-09');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (385, '2025-02-13 12:24:02', 9, 'SERV05', '69385561', 94, 'Diagnóstico 385', 'Tratamiento 385', 117, '2025-01-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (386, '2025-02-18 12:42:50', 7, 'SERV05', '27110702', 157, 'Diagnóstico 386', 'Tratamiento 386', 442, '2025-01-29');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (387, '2025-01-12 04:38:31', 6, 'SERV01', '35066437', 196, 'Diagnóstico 387', 'Tratamiento 387', 358, '2025-02-10');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (388, '2025-02-08 23:58:45', 8, 'SERV04', '6467537', 170, 'Diagnóstico 388', 'Tratamiento 388', 374, '2025-02-16');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (389, '2025-03-08 05:53:10', 3, 'SERV03', '6467537', 45, 'Diagnóstico 389', 'Tratamiento 389', 451, '2025-01-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (390, '2025-02-26 20:39:12', 1, 'SERV04', '27110702', 129, 'Diagnóstico 390', 'Tratamiento 390', 146, '2025-03-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (391, '2025-01-06 07:01:04', 7, 'SERV04', '53269785', 159, 'Diagnóstico 391', 'Tratamiento 391', 426, '2025-02-15');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (392, '2025-02-07 17:34:22', 5, 'SERV04', '29273251', 57, 'Diagnóstico 392', 'Tratamiento 392', 153, '2025-03-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (393, '2025-01-26 10:21:43', 8, 'SERV02', '99484137', 18, 'Diagnóstico 393', 'Tratamiento 393', 489, '2025-02-19');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (394, '2025-02-24 10:26:19', 5, 'SERV02', '59339518', 11, 'Diagnóstico 394', 'Tratamiento 394', 476, '2025-02-07');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (395, '2025-01-12 08:47:03', 9, 'SERV03', '85449907', 2, 'Diagnóstico 395', 'Tratamiento 395', 269, '2025-01-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (396, '2025-02-24 09:43:59', 9, 'SERV03', '35303697', 149, 'Diagnóstico 396', 'Tratamiento 396', 123, '2025-02-09');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (397, '2025-02-10 12:13:07', 1, 'SERV02', '52194975', 168, 'Diagnóstico 397', 'Tratamiento 397', 434, '2025-02-15');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (398, '2025-02-18 17:58:24', 10, 'SERV02', '35066437', 75, 'Diagnóstico 398', 'Tratamiento 398', 228, '2025-03-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (399, '2025-02-26 15:30:11', 2, 'SERV02', '7402147', 14, 'Diagnóstico 399', 'Tratamiento 399', 445, '2025-01-28');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (400, '2025-02-01 12:50:54', 6, 'SERV03', '53269785', 166, 'Diagnóstico 400', 'Tratamiento 400', 395, '2025-02-06');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (401, '2025-02-28 12:39:29', 7, 'SERV02', '17253062', 188, 'Diagnóstico 401', 'Tratamiento 401', 298, '2025-01-21');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (402, '2025-02-14 12:42:09', 7, 'SERV01', '35303697', 10, 'Diagnóstico 402', 'Tratamiento 402', 429, '2025-02-04');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (403, '2025-02-19 09:21:05', 9, 'SERV04', '35066437', 4, 'Diagnóstico 403', 'Tratamiento 403', 167, '2025-02-12');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (404, '2025-01-09 05:58:22', 10, 'SERV02', '35303697', 21, 'Diagnóstico 404', 'Tratamiento 404', 382, '2025-01-29');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (405, '2025-03-02 18:44:23', 8, 'SERV01', '3357301', 73, 'Diagnóstico 405', 'Tratamiento 405', 432, '2025-01-31');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (406, '2025-01-01 03:04:25', 5, 'SERV03', '29273251', 153, 'Diagnóstico 406', 'Tratamiento 406', 396, '2025-01-04');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (407, '2025-01-22 00:35:31', 1, 'SERV05', '35066437', 146, 'Diagnóstico 407', 'Tratamiento 407', 213, '2025-01-23');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (408, '2025-03-02 17:05:58', 4, 'SERV04', '7402147', 101, 'Diagnóstico 408', 'Tratamiento 408', 362, '2025-02-25');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (409, '2025-01-08 06:57:39', 8, 'SERV03', '6467537', 103, 'Diagnóstico 409', 'Tratamiento 409', 474, '2025-02-27');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (410, '2025-01-07 00:46:52', 6, 'SERV05', '53269785', 9, 'Diagnóstico 410', 'Tratamiento 410', 268, '2025-01-04');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (411, '2025-02-18 14:55:27', 8, 'SERV02', '69385561', 118, 'Diagnóstico 411', 'Tratamiento 411', 231, '2025-03-06');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (412, '2025-02-01 13:44:00', 6, 'SERV05', '35066437', 42, 'Diagnóstico 412', 'Tratamiento 412', 311, '2025-01-13');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (413, '2025-02-02 06:45:11', 4, 'SERV05', '27110702', 167, 'Diagnóstico 413', 'Tratamiento 413', 180, '2025-02-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (414, '2025-02-17 21:51:11', 7, 'SERV01', '69385561', 155, 'Diagnóstico 414', 'Tratamiento 414', 487, '2025-01-21');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (415, '2025-03-06 13:49:48', 6, 'SERV04', '53269785', 179, 'Diagnóstico 415', 'Tratamiento 415', 265, '2025-03-06');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (416, '2025-02-01 19:14:50', 5, 'SERV03', '27110702', 141, 'Diagnóstico 416', 'Tratamiento 416', 146, '2025-02-04');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (417, '2025-02-19 01:40:53', 1, 'SERV02', '65510215', 178, 'Diagnóstico 417', 'Tratamiento 417', 150, '2025-01-30');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (418, '2025-01-11 16:16:39', 1, 'SERV05', '12107986', 59, 'Diagnóstico 418', 'Tratamiento 418', 244, '2025-01-24');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (419, '2025-01-03 14:57:25', 8, 'SERV03', '86909002', 116, 'Diagnóstico 419', 'Tratamiento 419', 460, '2025-02-09');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (420, '2025-01-25 09:43:47', 3, 'SERV03', '35066437', 18, 'Diagnóstico 420', 'Tratamiento 420', 435, '2025-01-13');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (421, '2025-02-10 11:36:44', 3, 'SERV05', '86909002', 165, 'Diagnóstico 421', 'Tratamiento 421', 356, '2025-02-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (422, '2025-01-21 22:17:27', 10, 'SERV04', '17253062', 30, 'Diagnóstico 422', 'Tratamiento 422', 293, '2025-01-22');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (423, '2025-01-24 10:24:33', 3, 'SERV05', '27217280', 137, 'Diagnóstico 423', 'Tratamiento 423', 387, '2025-01-14');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (424, '2025-01-06 05:54:55', 8, 'SERV04', '3357301', 114, 'Diagnóstico 424', 'Tratamiento 424', 484, '2025-02-14');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (425, '2025-01-31 09:48:09', 4, 'SERV01', '35303697', 182, 'Diagnóstico 425', 'Tratamiento 425', 438, '2025-02-11');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (426, '2025-01-30 09:15:03', 7, 'SERV04', '6467537', 69, 'Diagnóstico 426', 'Tratamiento 426', 227, '2025-02-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (427, '2025-02-27 22:14:12', 3, 'SERV02', '29273251', 24, 'Diagnóstico 427', 'Tratamiento 427', 259, '2025-01-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (428, '2025-03-07 07:20:06', 3, 'SERV04', '65510215', 19, 'Diagnóstico 428', 'Tratamiento 428', 462, '2025-02-11');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (429, '2025-01-08 20:19:15', 9, 'SERV03', '85449907', 99, 'Diagnóstico 429', 'Tratamiento 429', 374, '2025-03-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (430, '2025-03-06 07:42:43', 7, 'SERV05', '99484137', 103, 'Diagnóstico 430', 'Tratamiento 430', 250, '2025-02-26');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (431, '2025-01-20 14:39:12', 10, 'SERV01', '52194975', 150, 'Diagnóstico 431', 'Tratamiento 431', 138, '2025-03-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (432, '2025-02-01 20:42:01', 6, 'SERV03', '27110702', 37, 'Diagnóstico 432', 'Tratamiento 432', 414, '2025-03-07');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (433, '2025-01-12 01:56:49', 2, 'SERV02', '6467537', 103, 'Diagnóstico 433', 'Tratamiento 433', 107, '2025-01-27');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (434, '2025-01-06 16:12:46', 9, 'SERV04', '27217280', 158, 'Diagnóstico 434', 'Tratamiento 434', 405, '2025-03-06');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (435, '2025-01-10 12:33:23', 7, 'SERV05', '6467537', 127, 'Diagnóstico 435', 'Tratamiento 435', 187, '2025-01-22');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (436, '2025-02-21 10:15:30', 5, 'SERV03', '25089541', 96, 'Diagnóstico 436', 'Tratamiento 436', 289, '2025-01-21');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (437, '2025-01-11 20:34:21', 3, 'SERV01', '59339518', 169, 'Diagnóstico 437', 'Tratamiento 437', 311, '2025-01-30');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (438, '2025-01-28 17:39:27', 10, 'SERV01', '69385561', 2, 'Diagnóstico 438', 'Tratamiento 438', 313, '2025-01-03');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (439, '2025-02-13 22:31:32', 9, 'SERV02', '27217280', 167, 'Diagnóstico 439', 'Tratamiento 439', 232, '2025-01-13');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (440, '2025-03-03 22:50:11', 1, 'SERV04', '85449907', 131, 'Diagnóstico 440', 'Tratamiento 440', 168, '2025-03-03');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (441, '2025-03-09 08:55:28', 8, 'SERV04', '35066437', 63, 'Diagnóstico 441', 'Tratamiento 441', 173, '2025-03-04');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (442, '2025-02-14 06:19:41', 5, 'SERV03', '12107986', 75, 'Diagnóstico 442', 'Tratamiento 442', 176, '2025-01-30');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (443, '2025-01-22 21:42:59', 2, 'SERV01', '3357301', 73, 'Diagnóstico 443', 'Tratamiento 443', 385, '2025-03-03');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (444, '2025-03-04 01:29:12', 7, 'SERV03', '99484137', 141, 'Diagnóstico 444', 'Tratamiento 444', 398, '2025-02-16');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (445, '2025-01-06 10:20:07', 9, 'SERV05', '29273251', 135, 'Diagnóstico 445', 'Tratamiento 445', 471, '2025-02-04');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (446, '2025-02-12 13:03:15', 7, 'SERV03', '29273251', 130, 'Diagnóstico 446', 'Tratamiento 446', 255, '2025-01-19');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (447, '2025-02-20 17:27:08', 3, 'SERV03', '52194975', 153, 'Diagnóstico 447', 'Tratamiento 447', 130, '2025-01-28');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (448, '2025-01-19 16:37:23', 7, 'SERV02', '29273251', 168, 'Diagnóstico 448', 'Tratamiento 448', 310, '2025-01-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (449, '2025-01-08 19:29:06', 6, 'SERV01', '25089541', 19, 'Diagnóstico 449', 'Tratamiento 449', 149, '2025-02-24');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (450, '2025-02-01 05:48:38', 4, 'SERV04', '29273251', 8, 'Diagnóstico 450', 'Tratamiento 450', 156, '2025-01-27');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (451, '2025-01-05 17:05:05', 7, 'SERV05', '3357301', 73, 'Diagnóstico 451', 'Tratamiento 451', 143, '2025-02-21');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (452, '2025-01-07 18:02:54', 8, 'SERV01', '17253062', 26, 'Diagnóstico 452', 'Tratamiento 452', 279, '2025-01-30');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (453, '2025-03-03 10:59:08', 2, 'SERV03', '85449907', 137, 'Diagnóstico 453', 'Tratamiento 453', 482, '2025-01-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (454, '2025-01-05 00:21:09', 1, 'SERV01', '35303697', 47, 'Diagnóstico 454', 'Tratamiento 454', 302, '2025-02-26');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (455, '2025-02-21 01:49:04', 9, 'SERV03', '27110702', 91, 'Diagnóstico 455', 'Tratamiento 455', 356, '2025-02-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (456, '2025-01-06 09:54:37', 1, 'SERV03', '86909002', 173, 'Diagnóstico 456', 'Tratamiento 456', 281, '2025-01-30');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (457, '2025-01-30 11:01:01', 8, 'SERV03', '35303697', 182, 'Diagnóstico 457', 'Tratamiento 457', 449, '2025-02-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (458, '2025-01-12 23:36:36', 10, 'SERV05', '98741936', 171, 'Diagnóstico 458', 'Tratamiento 458', 380, '2025-01-11');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (459, '2025-01-01 16:47:43', 3, 'SERV03', '6467537', 195, 'Diagnóstico 459', 'Tratamiento 459', 188, '2025-01-21');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (460, '2025-01-13 20:35:53', 8, 'SERV05', '85449907', 82, 'Diagnóstico 460', 'Tratamiento 460', 330, '2025-03-02');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (461, '2025-01-11 01:02:15', 3, 'SERV04', '65510215', 112, 'Diagnóstico 461', 'Tratamiento 461', 128, '2025-02-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (462, '2025-01-25 05:58:42', 5, 'SERV03', '53269785', 135, 'Diagnóstico 462', 'Tratamiento 462', 395, '2025-02-18');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (463, '2025-03-06 02:58:55', 2, 'SERV01', '86909002', 109, 'Diagnóstico 463', 'Tratamiento 463', 213, '2025-01-06');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (464, '2025-02-09 22:40:18', 5, 'SERV05', '65510215', 61, 'Diagnóstico 464', 'Tratamiento 464', 174, '2025-02-12');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (465, '2025-01-24 03:23:47', 9, 'SERV02', '69385561', 168, 'Diagnóstico 465', 'Tratamiento 465', 441, '2025-01-26');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (466, '2025-01-08 06:00:11', 9, 'SERV01', '99484137', 61, 'Diagnóstico 466', 'Tratamiento 466', 405, '2025-03-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (467, '2025-02-05 22:17:17', 2, 'SERV04', '6467537', 129, 'Diagnóstico 467', 'Tratamiento 467', 465, '2025-02-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (468, '2025-02-07 15:52:08', 10, 'SERV04', '99484137', 73, 'Diagnóstico 468', 'Tratamiento 468', 360, '2025-01-17');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (469, '2025-01-13 07:26:28', 7, 'SERV04', '29273251', 74, 'Diagnóstico 469', 'Tratamiento 469', 158, '2025-02-25');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (470, '2025-02-05 05:19:35', 9, 'SERV03', '85449907', 68, 'Diagnóstico 470', 'Tratamiento 470', 466, '2025-02-22');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (471, '2025-03-07 02:51:30', 4, 'SERV02', '25089541', 28, 'Diagnóstico 471', 'Tratamiento 471', 210, '2025-01-22');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (472, '2025-01-11 16:48:43', 2, 'SERV02', '69385561', 82, 'Diagnóstico 472', 'Tratamiento 472', 105, '2025-03-03');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (473, '2025-01-26 14:54:22', 10, 'SERV03', '6467537', 109, 'Diagnóstico 473', 'Tratamiento 473', 463, '2025-02-11');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (474, '2025-01-28 22:43:40', 6, 'SERV02', '35066437', 51, 'Diagnóstico 474', 'Tratamiento 474', 110, '2025-03-04');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (475, '2025-01-26 20:57:08', 3, 'SERV05', '6467537', 48, 'Diagnóstico 475', 'Tratamiento 475', 488, '2025-03-07');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (476, '2025-03-08 00:09:54', 5, 'SERV01', '52194975', 47, 'Diagnóstico 476', 'Tratamiento 476', 152, '2025-02-24');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (477, '2025-01-02 12:12:52', 1, 'SERV01', '6467537', 37, 'Diagnóstico 477', 'Tratamiento 477', 189, '2025-01-08');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (478, '2025-01-24 04:47:09', 5, 'SERV01', '17253062', 33, 'Diagnóstico 478', 'Tratamiento 478', 307, '2025-02-17');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (479, '2025-02-01 22:27:08', 2, 'SERV05', '53269785', 50, 'Diagnóstico 479', 'Tratamiento 479', 372, '2025-03-06');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (480, '2025-03-09 18:52:22', 6, 'SERV03', '7402147', 35, 'Diagnóstico 480', 'Tratamiento 480', 412, '2025-01-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (481, '2025-02-14 06:27:17', 9, 'SERV01', '17253062', 103, 'Diagnóstico 481', 'Tratamiento 481', 202, '2025-02-22');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (482, '2025-01-03 01:58:03', 4, 'SERV05', '35303697', 179, 'Diagnóstico 482', 'Tratamiento 482', 399, '2025-02-10');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (483, '2025-01-12 22:22:40', 10, 'SERV02', '7402147', 40, 'Diagnóstico 483', 'Tratamiento 483', 477, '2025-01-19');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (484, '2025-01-27 03:06:52', 2, 'SERV01', '98741936', 192, 'Diagnóstico 484', 'Tratamiento 484', 177, '2025-01-20');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (485, '2025-02-18 10:18:34', 5, 'SERV03', '7402147', 48, 'Diagnóstico 485', 'Tratamiento 485', 135, '2025-01-29');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (486, '2025-03-05 10:17:34', 1, 'SERV01', '59339518', 144, 'Diagnóstico 486', 'Tratamiento 486', 409, '2025-02-09');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (487, '2025-01-24 15:19:06', 4, 'SERV03', '86909002', 174, 'Diagnóstico 487', 'Tratamiento 487', 337, '2025-01-06');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (488, '2025-02-24 23:22:10', 1, 'SERV02', '85449907', 16, 'Diagnóstico 488', 'Tratamiento 488', 334, '2025-02-01');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (489, '2025-02-11 18:44:46', 8, 'SERV05', '99484137', 156, 'Diagnóstico 489', 'Tratamiento 489', 212, '2025-01-14');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (490, '2025-01-29 22:41:16', 3, 'SERV05', '25089541', 27, 'Diagnóstico 490', 'Tratamiento 490', 343, '2025-02-18');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (491, '2025-03-08 02:33:54', 1, 'SERV04', '59339518', 97, 'Diagnóstico 491', 'Tratamiento 491', 258, '2025-01-31');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (492, '2025-01-07 03:55:13', 8, 'SERV03', '17253062', 18, 'Diagnóstico 492', 'Tratamiento 492', 412, '2025-02-22');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (493, '2025-02-04 10:31:11', 9, 'SERV04', '17253062', 131, 'Diagnóstico 493', 'Tratamiento 493', 285, '2025-02-11');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (494, '2025-01-16 06:09:51', 2, 'SERV01', '6467537', 18, 'Diagnóstico 494', 'Tratamiento 494', 309, '2025-02-19');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (495, '2025-02-13 17:48:53', 7, 'SERV04', '6467537', 105, 'Diagnóstico 495', 'Tratamiento 495', 490, '2025-02-26');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (496, '2025-01-26 14:55:35', 9, 'SERV03', '7402147', 3, 'Diagnóstico 496', 'Tratamiento 496', 143, '2025-01-31');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (497, '2025-01-17 20:37:42', 1, 'SERV03', '98741936', 142, 'Diagnóstico 497', 'Tratamiento 497', 295, '2025-03-05');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (498, '2025-02-04 05:27:42', 4, 'SERV05', '12107986', 191, 'Diagnóstico 498', 'Tratamiento 498', 308, '2025-01-27');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (499, '2025-01-04 14:47:00', 4, 'SERV01', '17253062', 168, 'Diagnóstico 499', 'Tratamiento 499', 129, '2025-01-26');
INSERT INTO Pacientes.VisitaMedica (idVisita, fecha_hora, codHospital, idServicio, DNI_Medico, codHist, diagnostico, tratamiento, num_habitacion, fecha_alta) VALUES (500, '2025-01-06 15:29:22', 6, 'SERV02', '35066437', 170, 'Diagnóstico 500', 'Tratamiento 500', 362, '2025-02-21');
SET IDENTITY_INSERT Pacientes.VisitaMedica OFF;


PRINT 'Data insertion completed.';
GO

GO
PRINT N'Actualización completada.';


GO
