IF NOT EXISTS(SELECT TOP(1) 1
              FROM [dbo].[Dim_Tiempo])
BEGIN
    BEGIN TRAN 
        DECLARE @startdate DATE = '2016-01-01',
                @enddate   DATE = '2030-12-31'; 
        DECLARE @datelist TABLE(FullDate DATE);

        -- Si @startdate es NULL, tomar la fecha más antigua en Dim_Tiempo
        IF @startdate IS NULL
        BEGIN
            SELECT TOP 1 
                   @startdate = fecha
            FROM dbo.Dim_Tiempo 
            ORDER By TiempoSK ASC;
        END

        -- Generar todas las fechas en el rango
        WHILE (@startdate <= @enddate)
        BEGIN 
            INSERT INTO @datelist(FullDate)
            SELECT @startdate

            SET @startdate = DATEADD(dd,1,@startdate);
        END

        -- Insertar en Dim_Tiempo evitando duplicados
        INSERT INTO dbo.Dim_Tiempo(TiempoSK, fecha, anio, trimestre, mes, dia, semana, dia_mes)
        SELECT DISTINCT 
            CONVERT(INT, CONVERT(VARCHAR, dl.FullDate, 112)),  -- Generamos un identificador único para TiempoSK
            dl.FullDate,
            YEAR(dl.FullDate),
            DATEPART(QUARTER, dl.FullDate),
            MONTH(dl.FullDate),
            DAY(dl.FullDate),
            DATEPART(WEEK, dl.FullDate),
            DAY(dl.FullDate)
        FROM @datelist dl
        LEFT OUTER JOIN dbo.Dim_Tiempo dt ON (dl.FullDate = dt.fecha)
        WHERE dt.fecha IS NULL;
    
    COMMIT TRAN
END
GO
