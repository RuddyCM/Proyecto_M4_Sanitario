CREATE PROCEDURE [dbo].[DW_MergeDimHospital]
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO [dbo].[Dim_Hospital] AS dh
    USING [staging].[Hospitalest] AS sh
    ON dh.[HospitalSK] = sh.[codHospital]
    WHEN MATCHED THEN
        UPDATE SET 
            dh.[nombre] = sh.[nombre],
            dh.[ciudad] = sh.[ciudad],
            dh.[telefono] = sh.[telefono],
            dh.[director] = sh.[director],
            dh.[numero_total_camas] = sh.[numero_total_camas]
    WHEN NOT MATCHED THEN
        INSERT ([nombre], [ciudad], [telefono], [director], [numero_total_camas])
        VALUES (sh.[nombre], sh.[ciudad], sh.[telefono], sh.[director], sh.[numero_total_camas]);

END
GO
