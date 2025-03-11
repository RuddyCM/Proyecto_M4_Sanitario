CREATE PROCEDURE [dbo].[DW_MergeFactVisitas]
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO [dbo].[Fact_Visitas] AS fv
    USING [staging].[Visitast] AS sv 
    ON fv.[VisitaSK] = sv.[VisitaSK]

    WHEN MATCHED THEN 
    UPDATE 
    SET fv.[PacienteSK]     = sv.[PacienteSK],
        fv.[MedicoSK]       = sv.[MedicoSK],
        fv.[HospitalSK]     = sv.[HospitalSK],
        fv.[ServicioSK]     = sv.[ServicioSK],
        fv.[TiempoSK]       = CONVERT(INT, FORMAT(sv.[fecha_hora], 'yyyyMMdd')),  -- 🔹 Conversión a INT
        fv.[num_habitacion] = sv.[num_habitacion],
        fv.[fecha_hora]     = sv.[fecha_hora],
        fv.[fecha_alta]     = sv.[fecha_alta],
        fv.[diagnostico]    = sv.[diagnostico],
        fv.[tratamiento]    = sv.[tratamiento],
        fv.[dias_ingreso]   = sv.[dias_ingreso]

    WHEN NOT MATCHED THEN 
    INSERT ([VisitaSK], [PacienteSK], [MedicoSK], [HospitalSK], [ServicioSK], [TiempoSK], [num_habitacion], [fecha_hora], [fecha_alta], [diagnostico], [tratamiento], [dias_ingreso])
    VALUES (sv.[VisitaSK], sv.[PacienteSK], sv.[MedicoSK], sv.[HospitalSK], sv.[ServicioSK], CONVERT(INT, FORMAT(sv.[fecha_hora], 'yyyyMMdd')), sv.[num_habitacion], sv.[fecha_hora], sv.[fecha_alta], sv.[diagnostico], sv.[tratamiento], sv.[dias_ingreso]);

END
GO
