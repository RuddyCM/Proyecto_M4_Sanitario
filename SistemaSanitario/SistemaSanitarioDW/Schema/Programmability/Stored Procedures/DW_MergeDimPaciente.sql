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
