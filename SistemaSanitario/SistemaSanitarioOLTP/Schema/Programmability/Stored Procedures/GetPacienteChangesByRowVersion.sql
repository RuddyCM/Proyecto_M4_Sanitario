CREATE PROCEDURE [dbo].[GetPacienteChangesByRowVersion]
(
   @startRow BIGINT, 
   @endRow  BIGINT 
)
AS
BEGIN
    SELECT [DNI_Paciente],
           [apellidos_nombre],
           [fecha_nacimiento],
           [num_seguridad_social]
    FROM [Pacientes].[Paciente]
    WHERE [rowversion] > CONVERT(ROWVERSION,@startRow) 
      AND [rowversion] <= CONVERT(ROWVERSION,@endRow);
END
GO