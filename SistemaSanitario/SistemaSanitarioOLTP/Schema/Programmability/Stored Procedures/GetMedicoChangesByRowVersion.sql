CREATE PROCEDURE [dbo].[GetMedicoChangesByRowVersion]
(
   @startRow BIGINT, 
   @endRow  BIGINT 
)
AS
BEGIN
    SELECT [DNI_Medico],
           [apellidos_nombre],
           [fecha_nacimiento],
           [codHospital],
           [esDirector]
    FROM [Administracion].[Medico]
    WHERE [rowversion] > CONVERT(ROWVERSION,@startRow) 
      AND [rowversion] <= CONVERT(ROWVERSION,@endRow);
END
GO