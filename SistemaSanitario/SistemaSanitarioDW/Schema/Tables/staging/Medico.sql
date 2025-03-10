CREATE TABLE [staging].[Medico]
(
    [DNI_MedicoSK]       [int]          NOT NULL,
    [apellidos_nombre]   [varchar](255) NULL,
    [fecha_nacimiento]   [date]         NULL,
    [codHospital]        [int]          NULL,
    [direccion_hospital] [varchar](255) NULL,
    [es_director]        [bit]          NULL
);
GO