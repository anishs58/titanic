
------------------------------------------------
---STORED PROC FOR LOADING FACT TABLE
------------------------------------------------
CREATE PROCEDURE DATAMART.DATA_QUALITY_CHECKS
AS
	DECLARE @totalStagingCount Int;
	DECLARE @totalFactCount Int;
	select @totalFactCount= count(*) from DATAMART.FACT_TITANIC
	select @totalStagingCount= count(*) from STAGING.STG_TITANIC_SOURCE_DATA_HISTORY
	
	 IF (@totalStagingCount != @totalFactCount)
    BEGIN
        INSERT INTO DATAMART.DATA_QUALITY_ERRORS (ERROR_DESCRIPTION)
        VALUES('Records counts mismatch between DATAMART.FACT_TITANIC and STAGING.STG_TITANIC_SOURCE_DATA_HISTORY tables');
		
		RAISERROR('Data Quality Checks Failed', 16, 1);
		
    END
	
	

GO;
