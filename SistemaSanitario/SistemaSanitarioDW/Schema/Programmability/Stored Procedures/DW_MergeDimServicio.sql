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
