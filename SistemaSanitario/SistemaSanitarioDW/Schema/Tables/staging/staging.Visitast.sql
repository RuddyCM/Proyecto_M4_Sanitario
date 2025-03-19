CREATE TABLE [staging].[Visitast]
(
    [VisitaSK]        [int]          NOT NULL,
    [PacienteSK]      VARCHAR(50)          NULL,
    [MedicoSK]        VARCHAR(50)          NULL,
    [HospitalSK]      [int]          NULL,
    [ServicioSK]      NVARCHAR(50)          NULL,
    [num_habitacion]  [int]          NULL,
    [TiempoSK_FechaHora]      int     NULL,
    [TiempoSK_FechaAlta]      int     NULL,
    [diagnostico]     [varchar](MAX) NULL,
    [tratamiento]     [varchar](MAX) NULL,
    [dias_ingreso]    [int]          NULL,
    [FechaHora] datetime null,
    [FechaAlta] date null
);
GO