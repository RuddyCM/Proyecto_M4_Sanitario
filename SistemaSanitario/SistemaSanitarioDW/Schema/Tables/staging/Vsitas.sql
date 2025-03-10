CREATE TABLE [staging].[Visitas]
(
    [VisitaSK]        [int]          NOT NULL,
    [PacienteSK]      [int]          NULL,
    [MedicoSK]        [int]          NULL,
    [HospitalSK]      [int]          NULL,
    [ServicioSK]      [int]          NULL,
    [TiempoSK]        [int]          NULL,
    [num_habitacion]  [int]          NULL,
    [fecha_hora]      [datetime]     NULL,
    [fecha_alta]      [datetime]     NULL,
    [diagnostico]     [varchar](MAX) NULL,
    [tratamiento]     [varchar](MAX) NULL,
    [dias_ingreso]    [int]          NULL
);
GO