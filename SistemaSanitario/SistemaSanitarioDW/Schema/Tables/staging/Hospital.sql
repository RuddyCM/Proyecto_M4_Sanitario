CREATE TABLE [staging].[Hospital]
(
    [HospitalSK]         [int]          NOT NULL,
    [codHospital]        [int]          NULL,
    [nombre]             [varchar](255) NULL,
    [ciudad]             [varchar](255) NULL,
    [telefono]           [varchar](50)  NULL,
    [director]           [varchar](255) NULL,
    [numero_total_camas] [int]          NULL
);
GO