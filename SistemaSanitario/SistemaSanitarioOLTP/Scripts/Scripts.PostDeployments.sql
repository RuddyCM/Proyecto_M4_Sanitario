PRINT 'Populating database with initial data...';
SET NOCOUNT ON;
:r "D:\programas para la maestria\proyecto modulo 4\SistemaSanitario\SistemaSanitarioOLTP\Scripts\Clean.sql"
-- 1. Servicios
PRINT 'Populating Servicios.Servicio table';
:r "D:\programas para la maestria\proyecto modulo 4\SistemaSanitario\SistemaSanitarioOLTP\Scripts\Servicio.data.sql"

-- 2. Médicos
PRINT 'Populating Administracion.Medico table';
:r "D:\programas para la maestria\proyecto modulo 4\SistemaSanitario\SistemaSanitarioOLTP\Scripts\Medico.data.sql"

-- 3. Hospitales (ahora después de los médicos para evitar errores de FK)
PRINT 'Populating Administracion.Hospital table';
:r "D:\programas para la maestria\proyecto modulo 4\SistemaSanitario\SistemaSanitarioOLTP\Scripts\Hospital.data.sql"

-- 4. Pacientes
PRINT 'Populating Pacientes.Paciente table';
:r "D:\programas para la maestria\proyecto modulo 4\SistemaSanitario\SistemaSanitarioOLTP\Scripts\Paciente.data.sql"

-- 5. Historia Clínica (antes que Visita Médica)
PRINT 'Populating Pacientes.HistoriaClinica table';
:r "D:\programas para la maestria\proyecto modulo 4\SistemaSanitario\SistemaSanitarioOLTP\Scripts\HistoriaClinica.data.sql"

-- 6. Relación Hospital-Servicio
PRINT 'Populating Servicios.Hospital_Servicio table';
:r "D:\programas para la maestria\proyecto modulo 4\SistemaSanitario\SistemaSanitarioOLTP\Scripts\Hospital_Servicio.data.sql"

-- 7. Relación Médico-Servicio
PRINT 'Populating Administracion.Medico_Servicio table';
:r "D:\programas para la maestria\proyecto modulo 4\SistemaSanitario\SistemaSanitarioOLTP\Scripts\Medico_Servicio.data.sql"

-- 8. Visita Médica (se inserta al final porque depende de HistoriaClinica)
PRINT 'Populating Pacientes.VisitaMedica table';
:r "D:\programas para la maestria\proyecto modulo 4\SistemaSanitario\SistemaSanitarioOLTP\Scripts\VisitaMedica.data.sql"

PRINT 'Data insertion completed.';
