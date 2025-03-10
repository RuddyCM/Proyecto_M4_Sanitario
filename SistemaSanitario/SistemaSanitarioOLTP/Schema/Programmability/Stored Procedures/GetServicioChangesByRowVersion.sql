 CREATE PROCEDURE [dbo].[GetServicioChangesByRowVersion]
(
   @startRow BIGINT, 
   @endRow  BIGINT 
)
AS
BEGIN
    SELECT [idServicio],
           [nombre],
           [descripcion]
    FROM [Servicios].[Servicio]
    WHERE [rowversion] > CONVERT(ROWVERSION,@startRow) 
      AND [rowversion] <= CONVERT(ROWVERSION,@endRow);
END
GO
