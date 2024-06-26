
CREATE PROCEDURE STAGING.UPDATE_TITANIC_SOURCE_DATA_HISTORY
AS
MERGE STAGING.STG_TITANIC_SOURCE_DATA_HISTORY AS Target
    USING STAGING.STG_TITANIC_SOURCE_DATA	AS Source
    ON Source.PASSENGER_ID = Target.PASSENGER_ID
    -- For Inserts
    WHEN NOT MATCHED BY Target THEN
        INSERT (
			PASSENGER_ID,
			SURVIVED ,
			PASSENGER_CLASS,
			PASSENGER_NAME,
			PASSENGER_SEX,
			PASSENGER_AGE,
			SIBLING_SPOUSES,
			PARENTS_CHILDREN,
			TICKET_ID,
			FARE,
			CABIN,
			EMBARKED,
			INGESTION_ID,
			RECORD_PROCESSSED_FLAG,
			RECORD_CHECKSUM
		) 
        VALUES (
			Source.PASSENGER_ID,
			Source.SURVIVED ,
			Source.PASSENGER_CLASS,
			Source.PASSENGER_NAME,
			Source.PASSENGER_SEX,
			Source.PASSENGER_AGE,
			Source.SIBLING_SPOUSES,
			Source.PARENTS_CHILDREN,
			Source.TICKET_ID,
			Source.FARE,
			Source.CABIN,
			Source.EMBARKED,
			Source.INGESTION_ID,
			'N',
			CHECKSUM(
				Source.PASSENGER_ID,
				Source.SURVIVED ,
				Source.PASSENGER_CLASS,
				Source.PASSENGER_NAME,
				Source.PASSENGER_SEX,
				Source.PASSENGER_AGE,
				Source.SIBLING_SPOUSES,
				Source.PARENTS_CHILDREN,
				Source.TICKET_ID,
				Source.FARE,
				Source.CABIN,
				Source.EMBARKED
			)
		)
    
    -- For Updates
    WHEN MATCHED AND CHECKSUM(
				Source.PASSENGER_ID,
				Source.SURVIVED ,
				Source.PASSENGER_CLASS,
				Source.PASSENGER_NAME,
				Source.PASSENGER_SEX,
				Source.PASSENGER_AGE,
				Source.SIBLING_SPOUSES,
				Source.PARENTS_CHILDREN,
				Source.TICKET_ID,
				Source.FARE,
				Source.CABIN,
				Source.EMBARKED
			) != Target.RECORD_CHECKSUM
		THEN UPDATE SET
			Target.PASSENGER_NAME	= Source.PASSENGER_NAME,
			Target.SURVIVED = Source.SURVIVED ,
			Target.PASSENGER_CLASS = Source.PASSENGER_CLASS,
			Target.PASSENGER_SEX = Source.PASSENGER_SEX,
			Target.PASSENGER_AGE = Source.PASSENGER_AGE,
			Target.SIBLING_SPOUSES = Source.SIBLING_SPOUSES,
			Target.PARENTS_CHILDREN = Source.PARENTS_CHILDREN,
			Target.TICKET_ID = Source.TICKET_ID,
			Target.FARE = Source.FARE,
			Target.CABIN = Source.CABIN,
			Target.EMBARKED = Source.EMBARKED,
			Target.INGESTION_ID = Source.INGESTION_ID,
			Target.RECORD_CHECKSUM = CHECKSUM(
				Source.PASSENGER_ID,
				Source.SURVIVED ,
				Source.PASSENGER_CLASS,
				Source.PASSENGER_NAME,
				Source.PASSENGER_SEX,
				Source.PASSENGER_AGE,
				Source.SIBLING_SPOUSES,
				Source.PARENTS_CHILDREN,
				Source.TICKET_ID,
				Source.FARE,
				Source.CABIN,
				Source.EMBARKED
			),
			Target.RECORD_PROCESSSED_FLAG = 'N',
			Target.UPDATED_DATE = CURRENT_TIMESTAMP;
GO;


