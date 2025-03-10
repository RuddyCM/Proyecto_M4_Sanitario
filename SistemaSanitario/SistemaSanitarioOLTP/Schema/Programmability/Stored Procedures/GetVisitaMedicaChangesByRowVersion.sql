CREATE PROCEDURE [dbo].[GetVisitaMedicaChangesByRowVersion]
(
   @startRow BIGINT,
   @endRow BIGINT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT vm.idVisita,
           vm.codHospital,
           vm.idServicio,
           hc.DNI_Paciente,  -- ← Se obtiene desde HistoriaClinica
           vm.DNI_Medico,
           vm.num_habitacion,
           TiempoSK_FechaHora = CONVERT(INT, FORMAT(vm.fecha_hora, 'yyyyMMdd')),
           TiempoSK_FechaAlta = CASE
               WHEN vm.fecha_alta IS NULL THEN 0
               ELSE CONVERT(INT, FORMAT(vm.fecha_alta, 'yyyyMMdd'))
           END
    FROM Pacientes.VisitaMedica vm
    JOIN Pacientes.HistoriaClinica hc ON vm.codHist = hc.codHist  -- ← Se une con HistoriaClinica para obtener DNI_Paciente
    WHERE (vm.rowversion > CONVERT(ROWVERSION, @startRow) 
       AND vm.rowversion <= CONVERT(ROWVERSION, @endRow))
END
GO
