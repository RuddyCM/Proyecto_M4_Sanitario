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
        INSERT ([apellidos_nombre], [fecha_nacimiento], [codHospital], [direccion_hospital], [es_director])
        VALUES (sm.[apellidos_nombre], sm.[fecha_nacimiento], sm.[codHospital], sm.[direccion_hospital], sm.[es_director]);

END
GO
