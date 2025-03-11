CREATE PROCEDURE [dbo].[DW_MergeDimServicio]
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO [dbo].[Dim_Servicio] AS ds
    USING [staging].[Serviciost] AS ss
    ON ds.[nombre_servicio] = ss.[nombre_servicio]  -- Usa otro campo para la coincidencia
    WHEN MATCHED THEN
        UPDATE SET 
            ds.[nombre_servicio] = ss.[nombre_servicio]
    WHEN NOT MATCHED THEN
        INSERT ([nombre_servicio])  -- ❌ QUITAMOS ServicioSK porque es IDENTITY
        VALUES (ss.[nombre_servicio]);

END
GO
