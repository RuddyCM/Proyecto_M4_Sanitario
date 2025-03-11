-- 📌 Tabla de Staging para Hospitales
CREATE TABLE staging.Hospitalest (
    codHospital INT PRIMARY KEY,
    nombre VARCHAR(255),
    ciudad VARCHAR(100),
    telefono VARCHAR(20),
    director VARCHAR(255),
    numero_total_camas INT
);
go