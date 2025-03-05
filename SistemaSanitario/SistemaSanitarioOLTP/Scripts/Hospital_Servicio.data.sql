PRINT 'Populating Hospital_Servicio table';
SET NOCOUNT ON;

INSERT INTO Hospital_Servicio (codHospital, idServicio, num_camas)
VALUES 
    ('H1000', 'S001', 25),
    ('H1000', 'S002', 30),
    ('H1001', 'S001', 20),
    ('H1001', 'S003', 15),
    ('H1002', 'S002', 10),
    ('H1003', 'S004', 50),
    ('H1003', 'S005', 40);