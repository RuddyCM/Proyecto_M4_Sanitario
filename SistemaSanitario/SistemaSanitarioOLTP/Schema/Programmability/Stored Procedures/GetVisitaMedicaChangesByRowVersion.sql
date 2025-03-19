CREATE PROCEDURE [dbo].[GetVisitaMedicaChangesByRowVersion]
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
