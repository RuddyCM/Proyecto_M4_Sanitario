CREATE PROCEDURE [dbo].[GetHospitalChangesByRowVersion]
(
   @startRow BIGINT, 
   @endRow  BIGINT 
)
AS
BEGIN
    SELECT [codHospital],
           [nombre],
           [ciudad],
           [telefono],
           [DNI_Director]
    FROM [Administracion].[Hospital]
    WHERE [rowversion] > CONVERT(ROWVERSION,@startRow) 
      AND [rowversion] <= CONVERT(ROWVERSION,@endRow);
END
GO