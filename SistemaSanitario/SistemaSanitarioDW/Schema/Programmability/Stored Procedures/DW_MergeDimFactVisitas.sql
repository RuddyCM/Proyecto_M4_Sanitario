CREATE PROCEDURE [dbo].[DW_MergeFactVisitas]
AS
BEGIN
    SET NOCOUNT ON;

    -- 🔹 1️⃣ Asegurar que todas las fechas existen en `Dim_Tiempo`
    INSERT INTO BDSanitarioDW.dbo.Dim_Tiempo (TiempoSK, Fecha)
    SELECT DISTINCT 
        CONVERT(INT, CONVERT(VARCHAR, FechaHora, 112)) AS TiempoSK,
        FechaHora
    FROM staging.Visitast AS sv
    WHERE FechaHora IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM BDSanitarioDW.dbo.Dim_Tiempo dt 
        WHERE dt.TiempoSK = CONVERT(INT, CONVERT(VARCHAR, sv.FechaHora, 112))
    );

    INSERT INTO BDSanitarioDW.dbo.Dim_Tiempo (TiempoSK, Fecha)
    SELECT DISTINCT 
        CONVERT(INT, CONVERT(VARCHAR, FechaAlta, 112)) AS TiempoSK,
        FechaAlta
    FROM staging.Visitast AS sv
    WHERE FechaAlta IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM BDSanitarioDW.dbo.Dim_Tiempo dt 
        WHERE dt.TiempoSK = CONVERT(INT, CONVERT(VARCHAR, sv.FechaAlta, 112))
    );

    -- 🔹 2️⃣ MERGE INTO Fact_Visitas
    MERGE INTO dbo.Fact_Visitas AS fv
    USING (
        SELECT 
            sv.VisitaSK,
            sv.PacienteSK,
            sv.MedicoSK,
            sv.HospitalSK,
            sv.ServicioSK,
            dt_hora.TiempoSK AS TiempoSK_FechaHora,
            dt_alta.TiempoSK AS TiempoSK_FechaAlta,
            sv.num_habitacion,
            sv.FechaHora,
            sv.FechaAlta,
            sv.diagnostico,
            sv.tratamiento,
            sv.dias_ingreso
        FROM staging.Visitast AS sv
        LEFT JOIN dbo.Dim_Tiempo AS dt_hora ON dt_hora.Fecha = sv.FechaHora
        LEFT JOIN dbo.Dim_Tiempo AS dt_alta ON dt_alta.Fecha = sv.FechaAlta
    ) AS sv
    ON fv.VisitaSK = sv.VisitaSK

    WHEN MATCHED THEN 
        UPDATE 
        SET fv.PacienteSK        = sv.PacienteSK,
            fv.MedicoSK          = sv.MedicoSK,
            fv.HospitalSK        = sv.HospitalSK,
            fv.ServicioSK        = sv.ServicioSK,
            fv.TiempoSK_FechaHora = sv.TiempoSK_FechaHora,
            fv.TiempoSK_FechaAlta = sv.TiempoSK_FechaAlta,
            fv.num_habitacion    = sv.num_habitacion,
            fv.fecha_hora        = sv.FechaHora,
            fv.fecha_alta        = sv.FechaAlta,
            fv.diagnostico       = sv.diagnostico,
            fv.tratamiento       = sv.tratamiento,
            fv.dias_ingreso      = sv.dias_ingreso

    WHEN NOT MATCHED THEN 
        INSERT (VisitaSK, PacienteSK, MedicoSK, HospitalSK, ServicioSK, 
                TiempoSK_FechaHora, TiempoSK_FechaAlta, num_habitacion, 
                fecha_hora, fecha_alta, diagnostico, tratamiento, dias_ingreso)
        VALUES (sv.VisitaSK, sv.PacienteSK, sv.MedicoSK, sv.HospitalSK, sv.ServicioSK, 
                sv.TiempoSK_FechaHora, sv.TiempoSK_FechaAlta,
                sv.num_habitacion, sv.FechaHora, sv.FechaAlta, sv.diagnostico, sv.tratamiento, sv.dias_ingreso);

END;
GO
