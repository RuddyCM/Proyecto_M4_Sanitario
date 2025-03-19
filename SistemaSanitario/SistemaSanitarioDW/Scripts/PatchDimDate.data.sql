IF NOT EXISTS(SELECT TOP(1) 1
              FROM [dbo].[Dim_Tiempo]
              WHERE TiempoSK = 0)
BEGIN
    INSERT INTO [dbo].[Dim_Tiempo]
               ([TiempoSK]
               ,[fecha]
               ,[anio]
               ,[trimestre]
               ,[mes]
               ,[dia]
               ,[semana]
               ,[dia_mes])
         VALUES
               (0
               ,GETDATE()
               ,0
               ,0
               ,0
               ,0
               ,1
               ,0);
END
GO
