CREATE TABLE [staging].[Pacientest]
(
	[DNI_PacienteSK] [int]          NOT NULL,
	[apellidos_nombre]  [varchar](255) NULL,
	[fecha_nacimiento]   [date] NULL,
	[num_seguridad_social]      [varchar](50)  NULL,
	[otros_datos]      [text] NULL,

);
GO