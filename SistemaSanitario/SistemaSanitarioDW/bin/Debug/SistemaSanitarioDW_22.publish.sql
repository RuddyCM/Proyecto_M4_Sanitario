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
PRINT N'Creando Procedimiento [dbo].[DW_MergeDimHospital]...';


GO
CREATE PROCEDURE [dbo].[DW_MergeDimHospital]
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO [dbo].[DimHospital] AS dh
    USING [staging].[Hospitalst] AS sh
    ON dh.[HospitalSK] = sh.[codHospital]
    WHEN MATCHED THEN
        UPDATE SET 
            dh.[nombre] = sh.[nombre],
            dh.[ciudad] = sh.[ciudad],
            dh.[telefono] = sh.[telefono],
            dh.[director] = sh.[director],
            dh.[numero_total_camas] = sh.[numero_total_camas]
    WHEN NOT MATCHED THEN
        INSERT ([HospitalSK], [nombre], [ciudad], [telefono], [director], [numero_total_camas])
        VALUES (sh.[codHospital], sh.[nombre], sh.[ciudad], sh.[telefono], sh.[director], sh.[numero_total_camas]);

END
GO
PRINT N'Creando Procedimiento [dbo].[DW_MergeDimMedico]...';


GO
CREATE PROCEDURE [dbo].[DW_MergeDimMedico]
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO [dbo].[DimMedico] AS dm
    USING [staging].[Medicost] AS sm
    ON dm.[MedicoSK] = sm.[DNI_Medico]
    WHEN MATCHED THEN
        UPDATE SET 
            dm.[apellidos_nombre] = sm.[apellidos_nombre],
            dm.[fecha_nacimiento] = sm.[fecha_nacimiento],
            dm.[codHospital] = sm.[codHospital],
            dm.[direccion_hospital] = sm.[direccion_hospital],
            dm.[es_director] = sm.[es_director]
    WHEN NOT MATCHED THEN
        INSERT ([MedicoSK], [apellidos_nombre], [fecha_nacimiento], [codHospital], [direccion_hospital], [es_director])
        VALUES (sm.[DNI_Medico], sm.[apellidos_nombre], sm.[fecha_nacimiento], sm.[codHospital], sm.[direccion_hospital], sm.[es_director]);

END
GO
PRINT N'Creando Procedimiento [dbo].[DW_MergeDimPaciente]...';


GO
CREATE PROCEDURE [dbo].[DW_MergeDimPaciente]
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO [dbo].[DimPaciente] AS dp
    USING [staging].[Pacientest] AS sp
    ON dp.[PacienteSK] = sp.[DNI_PacienteSK]
    WHEN MATCHED THEN
        UPDATE SET 
            dp.[apellidos_nombre] = sp.[apellidos_nombre],
            dp.[fecha_nacimiento] = sp.[fecha_nacimiento],
            dp.[num_seguridad_social] = sp.[num_seguridad_social],
            dp.[otros_datos] = sp.[otros_datos]
    WHEN NOT MATCHED THEN
        INSERT ([PacienteSK], [apellidos_nombre], [fecha_nacimiento], [num_seguridad_social], [otros_datos])
        VALUES (sp.[DNI_PacienteSK], sp.[apellidos_nombre], sp.[fecha_nacimiento], sp.[num_seguridad_social], sp.[otros_datos]);

END
GO
PRINT N'Creando Procedimiento [dbo].[DW_MergeDimServicio]...';


GO
CREATE PROCEDURE [dbo].[DW_MergeDimServicio]
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO [dbo].[DimServicio] AS ds
    USING [staging].[Serviciost] AS ss
    ON ds.[ServicioSK] = ss.[idServicio]
    WHEN MATCHED THEN
        UPDATE SET 
            ds.[nombre_servicio] = ss.[nombre_servicio]
    WHEN NOT MATCHED THEN
        INSERT ([ServicioSK], [idServicio], [nombre_servicio])
        VALUES (ss.[idServicio], ss.[idServicio], ss.[nombre_servicio]);

END
GO
PRINT N'Creando Procedimiento [dbo].[DW_MergeFactVisitas]...';


GO
CREATE PROCEDURE [dbo].[DW_MergeFactVisitas]
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO [dbo].[FactVisitas] AS fv
    USING [staging].[Visitasst] AS sv
    ON fv.[VisitaSK] = sv.[idVisita]
    WHEN MATCHED THEN
        UPDATE SET 
            fv.[PacienteSK] = sv.[DNI_Paciente],
            fv.[MedicoSK] = sv.[DNI_Medico],
            fv.[HospitalSK] = sv.[codHospital],
            fv.[ServicioSK] = sv.[idServicio],
            fv.[TiempoSK] = sv.[fecha_hora],
            fv.[num_habitacion] = sv.[num_habitacion],
            fv.[fecha_hora] = sv.[fecha_hora],
            fv.[fecha_alta] = sv.[fecha_alta],
            fv.[diagnostico] = sv.[diagnostico],
            fv.[tratamiento] = sv.[tratamiento],
            fv.[dias_ingreso] = sv.[dias_ingreso]
    WHEN NOT MATCHED THEN
        INSERT ([VisitaSK], [PacienteSK], [MedicoSK], [HospitalSK], [ServicioSK], [TiempoSK], [num_habitacion], [fecha_hora], [fecha_alta], [diagnostico], [tratamiento], [dias_ingreso])
        VALUES (sv.[idVisita], sv.[DNI_Paciente], sv.[DNI_Medico], sv.[codHospital], sv.[idServicio], sv.[fecha_hora], sv.[num_habitacion], sv.[fecha_hora], sv.[fecha_alta], sv.[diagnostico], sv.[tratamiento], sv.[dias_ingreso]);

END
GO
PRINT N'Actualización completada.';


GO
