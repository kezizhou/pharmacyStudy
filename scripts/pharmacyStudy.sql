-- -----------------------------------------------------------------------------------------
-- Options
-- -----------------------------------------------------------------------------------------
USE dbSQL1;
SET NOCOUNT ON; -- Report only errors

-- -----------------------------------------------------------------------------------------
--  Drop tables
-- -----------------------------------------------------------------------------------------

IF OBJECT_ID ('TDrugKits')			 		  IS NOT NULL DROP TABLE TDrugKits
IF OBJECT_ID ('TVisits')				   	  IS NOT NULL DROP TABLE TVisits
IF OBJECT_ID ('TPatients')					  IS NOT NULL DROP TABLE TPatients
IF OBJECT_ID ('TSites')						  IS NOT NULL DROP TABLE TSites
IF OBJECT_ID ('TRandomCodes')			  	  IS NOT NULL DROP TABLE TRandomCodes
IF OBJECT_ID ('TVisitTypes')				  IS NOT NULL DROP TABLE TVisitTypes
IF OBJECT_ID ('TWithdrawReasons')			  IS NOT NULL DROP TABLE TWithdrawReasons
IF OBJECT_ID ('TStudies')				      IS NOT NULL DROP TABLE TStudies
IF OBJECT_ID ('TGenders')					  IS NOT NULL DROP TABLE TGenders
IF OBJECT_ID ('TStates')					  IS NOT NULL DROP TABLE TStates

-- -----------------------------------------------------------------------------------------
--  Drop views
-- -----------------------------------------------------------------------------------------
IF OBJECT_ID( 'VStudy12345Patients' )		  	IS NOT NULL DROP VIEW VStudy12345Patients
IF OBJECT_ID( 'VStudy54321Patients' )		  	IS NOT NULL DROP VIEW VStudy54321Patients
IF OBJECT_ID( 'VRandomizedStudy12345Patients' ) IS NOT NULL DROP VIEW VRandomizedStudy12345Patients
IF OBJECT_ID( 'VRandomizedStudy54321Patients' )	IS NOT NULL DROP VIEW VRandomizedStudy54321Patients
IF OBJECT_ID( 'VNextRandomCode12345' )		  	IS NOT NULL DROP VIEW VNextRandomCode12345
IF OBJECT_ID( 'VNextRandomCode54321' )		  	IS NOT NULL DROP VIEW VNextRandomCode54321
IF OBJECT_ID( 'VAllAvailableDrugKits' )		 	IS NOT NULL DROP VIEW VAllAvailableDrugKits
IF OBJECT_ID( 'VAllWithdrawnPatients' )		  	IS NOT NULL DROP VIEW VAllWithdrawnPatients
IF OBJECT_ID( 'VSumTreatmentsTaken' )		  	IS NOT NULL DROP VIEW VSumTreatmentsTaken

-- -----------------------------------------------------------------------------------------
--  Drop stored procedures
-- -----------------------------------------------------------------------------------------
IF OBJECT_ID( 'uspScreenPatient' )			  IS NOT NULL DROP PROCEDURE uspScreenPatient
IF OBJECT_ID( 'uspWithdrawPatient' )		  IS NOT NULL DROP PROCEDURE uspWithdrawPatient
IF OBJECT_ID( 'uspRandomizePatient12345' )	  IS NOT NULL DROP PROCEDURE uspRandomizePatient12345 
IF OBJECT_ID( 'uspRandomizePatient54321' )	  IS NOT NULL DROP PROCEDURE uspRandomizePatient54321

-- -----------------------------------------------------------------------------------------
--	Create tables
-- -----------------------------------------------------------------------------------------

CREATE TABLE TStates
(
	 intStateID				INTEGER				NOT NULL
	,strStateDesc			VARCHAR(255)		NOT NULL
	,CONSTRAINT TStates_PK PRIMARY KEY ( intStateID )
)

CREATE TABLE TGenders
(
	 intGenderID			INTEGER				NOT NULL
	,strGender				VARCHAR(255)		NOT NULL
	,CONSTRAINT TGenders_PK PRIMARY KEY ( intGenderID )
)

CREATE TABLE TWithdrawReasons
(
	 intWithdrawReasonID	INTEGER				NOT NULL
	,strWithdrawDesc		VARCHAR(255)		NOT NULL
	,CONSTRAINT TWithdrawReasons_PK PRIMARY KEY ( intWithdrawReasonID )
)

CREATE TABLE TDrugKits
(
	 intDrugKitID			INTEGER				NOT NULL
	,intDrugKitNumber		INTEGER				NOT NULL
	,intSiteID				INTEGER				NOT NULL
	,strTreatment			VARCHAR(1)			NOT NULL
	,intVisitID				INTEGER		
	,CONSTRAINT TDrugKits_PK PRIMARY KEY ( intDrugKitID )
)

CREATE TABLE TRandomCodes
(
	 intRandomCodeID		INTEGER				NOT NULL
	,intRandomCode			INTEGER				NOT NULL
	,intStudyID				INTEGER				NOT NULL
	,strTreatment			VARCHAR(1)			NOT NULL
	,blnAvailable			VARCHAR(1)			NOT NULL
	,CONSTRAINT TRandomCodes_PK PRIMARY KEY ( intRandomCodeID )
)

CREATE TABLE TVisits
(
	 intVisitID				INTEGER	 IDENTITY	NOT NULL
	,intPatientID			INTEGER				NOT NULL
	,dtmVisit				DATETIME			NOT NULL
	,intVisitTypeID			INTEGER				NOT NULL
	,intWithdrawReasonID	INTEGER
	,CONSTRAINT TVisits_PK PRIMARY KEY ( intVisitID )
)

CREATE TABLE TVisitTypes
(
	 intVisitTypeID			INTEGER				NOT NULL
	,strVisitDesc			VARCHAR(255)		NOT NULL
	,CONSTRAINT TVisitTypes_PK PRIMARY KEY ( intVisitTypeID )
)

CREATE TABLE TPatients
(
	 intPatientID			INTEGER	 IDENTITY	NOT NULL
	,intPatientNumber		INTEGER				NOT NULL
	,intSiteID				INTEGER				NOT NULL
	,dtmDOB					DATE				NOT NULL
	,intGenderID			INTEGER				NOT NULL
	,intWeight				INTEGER				NOT NULL
	,intRandomCodeID		INTEGER
	,CONSTRAINT TPatients_PK PRIMARY KEY ( intPatientID )
)

CREATE TABLE TSites
(
	 intSiteID				INTEGER				NOT NULL
	,intSiteNumber			INTEGER				NOT NULL
	,intStudyID				INTEGER				NOT NULL
	,strSiteName			VARCHAR(255)		NOT NULL 
	,strAddress				VARCHAR(255)		NOT NULL
	,strCity				VARCHAR(255)		NOT NULL
	,intStateID				INTEGER				NOT NULL
	,strZip					VARCHAR(255)		NOT NULL
	,strPhone				VARCHAR(255)		NOT NULL
	,CONSTRAINT TSites_PK PRIMARY KEY ( intSiteID )
)

CREATE TABLE TStudies
(
	 intStudyID				INTEGER				NOT NULL
	,strStudyDesc			VARCHAR(255)		NOT NULL
	,CONSTRAINT TStudies_PK PRIMARY KEY ( intStudyID )
)


-- -----------------------------------------------------------------------------------------
--	Foreign key table showing child, parent and column used to create relationship
-- -----------------------------------------------------------------------------------------
--
-- #	Child							Parent						Column
-- -	-----							------						---------
-- 1	TSites							TStudies					intStudyID
-- 2	TSites							TStates						intStateID
-- 3	TPatients						TSites						intSiteID
-- 4	TPatients						TGenders					intGenderID
-- 5	TVisits							TVisitTypes					intVisitTypeID
-- 6	TVisits							TWithdrawReasons			intWithdrawReasonID
-- 7	TVisits							TPatients					intPatientID
-- 8	TRandomCodes					TStudies					intStudyID
-- 9	TDrugKits						TSites						intSiteID
-- 10	TDrugKits						TVisits						intVisitID


-- -----------------------------------------------------------------------------------------
--	Create foreign keys
-- -----------------------------------------------------------------------------------------

-- 1
ALTER TABLE TSites ADD CONSTRAINT TSites_TStudies_FK
FOREIGN KEY ( intStudyID ) REFERENCES TStudies ( intStudyID )

-- 2
ALTER TABLE TSites ADD CONSTRAINT TSites_TStates_FK
FOREIGN KEY ( intStateID ) REFERENCES TStates ( intStateID )

-- 3
ALTER TABLE TPatients ADD CONSTRAINT TPatients_TSites_FK
FOREIGN KEY ( intSiteID ) REFERENCES TSites ( intSiteID )

-- 4
ALTER TABLE TPatients ADD CONSTRAINT TPatients_TGenders_FK
FOREIGN KEY ( intGenderID ) REFERENCES TGenders ( intGenderID )

-- 5
ALTER TABLE TVisits ADD CONSTRAINT TVisits_TVisitTypes_FK
FOREIGN KEY ( intVisitTypeID ) REFERENCES TVisitTypes ( intVisitTypeID )

-- 6
ALTER TABLE TVisits ADD CONSTRAINT TVisits_TWithdrawReasons_FK
FOREIGN KEY ( intWithdrawReasonID ) REFERENCES TWithdrawReasons ( intWithdrawReasonID )

-- 7
ALTER TABLE TVisits ADD CONSTRAINT TVisits_TPatients_FK
FOREIGN KEY ( intPatientID ) REFERENCES TPatients ( intPatientID )

-- 8
ALTER TABLE TRandomCodes ADD CONSTRAINT TRandomCodes_TStudies_FK
FOREIGN KEY ( intStudyID ) REFERENCES TStudies ( intStudyID )

-- 9
ALTER TABLE TDrugKits ADD CONSTRAINT TDrugKits_TSites_FK
FOREIGN KEY ( intSiteID ) REFERENCES TSites ( intSiteID )

-- 10
ALTER TABLE TDrugKits ADD CONSTRAINT TDrugKits_TVisits_FK
FOREIGN KEY ( intVisitID ) REFERENCES TVisits ( intVisitID )


-- -----------------------------------------------------------------------------------------
--	Insert data into tables
-- -----------------------------------------------------------------------------------------

INSERT INTO TStates( intStateID, strStateDesc )
VALUES	 ( 1, 'Ohio' )
		,( 2, 'Kentucky' )
		,( 3, 'Indiana' )
		,( 4, 'New Jersey' )
		,( 5, 'Virginia' )
		,( 6, 'Georgia' )
		,( 7, 'Iowa' )

INSERT INTO TGenders( intGenderID, strGender )
VALUES	 ( 1, 'Female' )
		,( 2, 'Male' )

INSERT INTO TStudies( intStudyID, strStudyDesc )
VALUES	 ( 1, 'Study 12345' )
		,( 2, 'Study 54321' )

INSERT INTO TWithdrawReasons( intWithdrawReasonID, strWithdrawDesc )
VALUES	 ( 1, 'Patient withdrew consent' )
		,( 2, 'Adverse event' )
		,( 3, 'Health issue - related to study' )
		,( 4, 'Health issue - unrelated to study' )
		,( 5, 'Personal reason' )
		,( 6, 'Completed the study' )

INSERT INTO TVisitTypes( intVisitTypeID, strVisitDesc )
VALUES	 ( 1, 'Screening' )
		,( 2, 'Randomization' )
		,( 3, 'Withdrawal' )

INSERT INTO TRandomCodes( intRandomCodeID, intRandomCode, intStudyID, strTreatment, blnAvailable )
VALUES	 ( 1, 1000, 1, 'A', 'T' )
		,( 2, 1001, 1, 'P', 'T' )
		,( 3, 1002, 1, 'A', 'T' )
		,( 4, 1003, 1, 'P', 'T' )
		,( 5, 1004, 1, 'P', 'T' )
		,( 6, 1005, 1, 'A', 'T' )
		,( 7, 1006, 1, 'A', 'T' )
		,( 8, 1007, 1, 'P', 'T' )
		,( 9, 1008, 1, 'A', 'T' )
		,( 10, 1009, 1, 'P', 'T' )
		,( 11, 1010, 1, 'P', 'T' )
		,( 12, 1011, 1, 'A', 'T' )
		,( 13, 1012, 1, 'P', 'T' )
		,( 14, 1013, 1, 'A', 'T' )
		,( 15, 1014, 1, 'A', 'T' )
		,( 16, 1015, 1, 'A', 'T' )
		,( 17, 1016, 1, 'P', 'T' )
		,( 18, 1017, 1, 'P', 'T' )
		,( 19, 1018, 1, 'A', 'T' )
		,( 20, 1019, 1, 'P', 'T' )
		,( 21, 5000, 2, 'A', 'T' )
		,( 22, 5001, 2, 'A', 'T' )
		,( 23, 5002, 2, 'A', 'T' )
		,( 24, 5003, 2, 'A', 'T' )
		,( 25, 5004, 2, 'A', 'T' )
		,( 26, 5005, 2, 'A', 'T' )
		,( 27, 5006, 2, 'A', 'T' )
		,( 28, 5007, 2, 'A', 'T' )
		,( 29, 5008, 2, 'A', 'T' )
		,( 30, 5009, 2, 'A', 'T' )
		,( 31, 5010, 2, 'P', 'T' )
		,( 32, 5011, 2, 'P', 'T' )
		,( 33, 5012, 2, 'P', 'T' )
		,( 34, 5013, 2, 'P', 'T' )
		,( 35, 5014, 2, 'P', 'T' )
		,( 36, 5015, 2, 'P', 'T' )
		,( 37, 5016, 2, 'P', 'T' )
		,( 38, 5017, 2, 'P', 'T' )
		,( 39, 5018, 2, 'P', 'T' )
		,( 40, 5019, 2, 'P', 'T' )

INSERT INTO TSites( intSiteID, intSiteNumber, intStudyID, strSiteName, strAddress, strCity, intStateID, strZip, strPhone )
VALUES	 ( 1, 101, 1, 'Dr. Stewart Nelson', '123 E. Main St.', 'Atlanta', 6, '25869', '1234567890' )
		,( 2, 111, 1, 'Mercy Hospital', '8129 Lakeview Dr.', 'Secaucus', 4, '32659', '5013629564' )
		,( 3, 121, 1, 'St. Elizabeth Hospital', '976 Jackson Way', 'Ft. Thomas', 2, '41258', '3026521478' )
		,( 4, 501, 2, 'Dr. Joe Smith', '2491 Oakwood Ct.', 'Cedar Rapids', 7, '42365', '6149652574' )
		,( 5, 511, 2, 'Dr. Tim Schmitz', '4539 Helena Run', 'Mason', 1, '45040', '5136987462' )
		,( 6, 521, 2, 'Dr. Natalie Williams', '9201 NW. Washington Blvd.', 'Bristol', 5, '20163', '3876510249' )

INSERT INTO TDrugKits( intDrugKitID, intDrugKitNumber, intSiteID, strTreatment, intVisitID )
VALUES	 ( 1, 10000, 1, 'A', NULL )
		,( 2, 10001, 1, 'A', NULL )
		,( 3, 10002, 1, 'A', NULL )
		,( 4, 10003, 1, 'P', NULL )
		,( 5, 10004, 1, 'P', NULL )
		,( 6, 10005, 1, 'P', NULL )
		,( 7, 10006, 2, 'A', NULL )
		,( 8, 10007, 2, 'A', NULL )
		,( 9, 10008, 2, 'A', NULL )
		,( 10, 10009, 2, 'P', NULL )
		,( 11, 10010, 2, 'P', NULL )
		,( 12, 10011, 2, 'P', NULL )
		,( 13, 10012, 3, 'A', NULL )
		,( 14, 10013, 3, 'A', NULL )
		,( 15, 10014, 3, 'A', NULL )
		,( 16, 10015, 3, 'P', NULL )
		,( 17, 10016, 3, 'P', NULL )
		,( 18, 10017, 3, 'P', NULL )
		,( 19, 10018, 4, 'A', NULL )
		,( 20, 10019, 4, 'A', NULL )
		,( 21, 10020, 4, 'A', NULL )
		,( 22, 10021, 4, 'P', NULL )
		,( 23, 10022, 4, 'P', NULL )
		,( 24, 10023, 4, 'P', NULL )
		,( 25, 10024, 5, 'A', NULL )
		,( 26, 10025, 5, 'A', NULL )
		,( 27, 10026, 5, 'A', NULL )
		,( 28, 10027, 5, 'P', NULL )
		,( 29, 10028, 5, 'P', NULL )
		,( 30, 10029, 5, 'P', NULL )
		,( 31, 10030, 6, 'A', NULL )
		,( 32, 10031, 6, 'A', NULL )
		,( 33, 10032, 6, 'A', NULL )
		,( 34, 10033, 6, 'P', NULL )
		,( 35, 10034, 6, 'P', NULL )
		,( 36, 10035, 6, 'P', NULL )


-- -----------------------------------------------------------------------------------------
--  Show all patients for both studies
-- -----------------------------------------------------------------------------------------

-- Study 12345
GO

CREATE VIEW VStudy12345Patients AS
SELECT TP.intPatientID, TP.intPatientNumber, TP.dtmDOB, TP.intWeight, TP.intSiteID, TS.strSiteName
FROM TPatients AS TP JOIN TSites AS TS
	ON TP.intSiteID = TS.intSiteID
WHERE TS.intStudyID = 1

GO

-- Study 54321
GO

CREATE VIEW VStudy54321Patients AS
SELECT TP.intPatientID, TP.intPatientNumber, TP.dtmDOB, TP.intWeight, TP.intSiteID, TS.strSiteName
FROM TPatients AS TP JOIN TSites AS TS
	ON TP.intSiteID = TS.intSiteID
WHERE TS.intStudyID = 2

GO


-- -----------------------------------------------------------------------------------------
--  Show all randomized patients, their site and their treatment for both studies
-- -----------------------------------------------------------------------------------------

-- Study 12345
GO

CREATE VIEW VRandomizedStudy12345Patients AS
SELECT TP.intPatientID, TP.intPatientNumber, TS.strSiteName, TRC.strTreatment
FROM TVisits AS TV JOIN TPatients AS TP
	ON TV.intPatientID = TP.intPatientID

	JOIN TSites AS TS
	ON TP.intSiteID = TS.intSiteID

	JOIN TRandomCodes AS TRC
	ON TP.intRandomCodeID = TRC.intRandomCodeID
WHERE TS.intStudyID = 1 AND TV.intVisitTypeID = 2

GO

-- Study 54321
GO

CREATE VIEW VRandomizedStudy54321Patients AS
SELECT TP.intPatientID, TP.intPatientNumber, TS.strSiteName, TRC.strTreatment
FROM TVisits AS TV JOIN TPatients AS TP
	ON TV.intPatientID = TP.intPatientID

	JOIN TSites AS TS
	ON TP.intSiteID = TS.intSiteID

	JOIN TRandomCodes AS TRC
	ON TP.intRandomCodeID = TRC.intRandomCodeID
WHERE TS.intStudyID = 2 AND TV.intVisitTypeID = 2

GO


-- -----------------------------------------------------------------------------------------
-- Show the next available random codes for both studies. 
-- -----------------------------------------------------------------------------------------

-- Study 12345
GO

CREATE VIEW VNextRandomCode12345 AS
SELECT MIN( TRC.intRandomCodeID ) AS intRandomCodeID
FROM TRandomCodes AS TRC
WHERE TRC.intStudyID = 1 AND TRC.blnAvailable = 'T'

GO

-- Study 54321
GO

CREATE VIEW VNextRandomCode54321 AS
SELECT MIN( TRC.intRandomCodeID ) AS intRandomCodeID, TRC.strTreatment
FROM TRandomCodes AS TRC
WHERE TRC.intStudyID = 2 AND TRC.blnAvailable = 'T'
GROUP BY TRC.strTreatment

GO


-- -----------------------------------------------------------------------------------------
--  Show all available drug kits
-- -----------------------------------------------------------------------------------------

GO

CREATE VIEW VAllAvailableDrugKits AS
SELECT TDK.intDrugKitID, TDK.intDrugKitNumber, TDK.strTreatment, TDK.intSiteID
FROM TDrugKits AS TDK
WHERE TDK.intVisitID IS NULL

GO


-- -----------------------------------------------------------------------------------------
--  Show all withdrawn patients, their site, withdrawal date and withdrawal reason
-- -----------------------------------------------------------------------------------------

GO

CREATE VIEW VAllWithdrawnPatients AS
SELECT TP.intPatientID, TP.intPatientNumber, TS.strSiteName, TV.dtmVisit, TWR.strWithdrawDesc
FROM TPatients AS TP JOIN TVisits AS TV
	ON TP.intPatientID = TV.intPatientID

	JOIN TWithdrawReasons AS TWR
	ON TV.intWithdrawReasonID = TWR.intWithdrawReasonID

	JOIN TSites AS TS
	ON TP.intSiteID = TS.intSiteID
WHERE TV.intVisitTypeID = 3

GO


-- -----------------------------------------------------------------------------------------
--  Number of treatments already taken
-- -----------------------------------------------------------------------------------------
GO

CREATE VIEW VSumTreatmentsTaken AS
SELECT COUNT(intRandomCodeID) AS intNumberTaken, TRC.strTreatment
FROM TRandomCodes AS TRC
WHERE TRC.intStudyID = 2 AND TRC.blnAvailable = 'F'
GROUP BY TRC.strTreatment

GO


-- -----------------------------------------------------------------------------------------
--  Screen a patient
-- -----------------------------------------------------------------------------------------

GO

CREATE PROCEDURE uspScreenPatient
	 @intPatientID			AS INTEGER OUTPUT
	,@intVisitID			AS INTEGER OUTPUT
	,@intPatientNumber		AS INTEGER
	,@intSiteID				AS INTEGER
	,@dtmDOB				AS DATE
	,@intGenderID			AS INTEGER
	,@intWeight				AS INTEGER
	,@dtmVisit				AS DATETIME

AS
SET NOCOUNT ON		-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error

BEGIN TRANSACTION

	-- Insert patient record data
	INSERT INTO TPatients WITH(TABLOCK) ( intPatientNumber, intSiteID, dtmDOB, intGenderID, intWeight )
	VALUES( @intPatientNumber, @intSiteID, @dtmDOB, @intGenderID, @intWeight )

	SELECT @intPatientID = MAX(intPatientID) FROM TPatients


	-- Create new visit
	INSERT INTO TVisits WITH(TABLOCK) ( intPatientID, dtmVisit, intVisitTypeID )
	VALUES( @intPatientID, @dtmVisit, 1 )

	SELECT @intVisitID = MAX(intVisitID) FROM TVisits

COMMIT TRANSACTION

GO


-- -----------------------------------------------------------------------------------------
--  Withdraw a patient
-- -----------------------------------------------------------------------------------------
GO

CREATE PROCEDURE uspWithdrawPatient
	 @intVisitID			AS INTEGER OUTPUT
    ,@intPatientID			AS INTEGER
	,@dtmVisit				AS DATETIME
	,@intWithdrawReasonID	AS INTEGER

AS
SET NOCOUNT ON		-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error

BEGIN TRANSACTION

	-- Create new visit
	INSERT INTO TVisits WITH(TABLOCK) ( intPatientID, dtmVisit, intVisitTypeID, intWithdrawReasonID )
	VALUES( @intPatientID, @dtmVisit, 3, @intWithdrawReasonID )

	SELECT @intVisitID = MAX(intVisitID) FROM TVisits

COMMIT TRANSACTION

GO


-- -----------------------------------------------------------------------------------------
--  Randomize a patient for both studies
-- -----------------------------------------------------------------------------------------
-- Study 12345
GO

CREATE PROCEDURE uspRandomizePatient12345
	 @intVisitID			AS INTEGER OUTPUT
	,@intRandomCodeID		AS INTEGER OUTPUT
	,@intDrugKitID			AS INTEGER OUTPUT
    ,@intPatientID			AS INTEGER

AS
SET NOCOUNT ON		-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error

BEGIN TRANSACTION
	DECLARE @dtmVisit AS DATETIME
	DECLARE @intSiteID AS INTEGER
	DECLARE @strTreatment AS VARCHAR(255)

	-- Create new visit
	SET @dtmVisit = GETDATE()
	INSERT INTO TVisits WITH(TABLOCK) ( intPatientID, dtmVisit, intVisitTypeID )
	VALUES( @intPatientID, @dtmVisit, 2 )

	SELECT @intVisitID = MAX(intVisitID) FROM TVisits

	-- Get next available random code from view using cursor
	BEGIN	

		DECLARE RandomCode12345 CURSOR LOCAL FOR
		SELECT intRandomCodeID FROM VNextRandomCode12345

		OPEN RandomCode12345

		FETCH FROM RandomCode12345
		INTO @intRandomCodeID	
		
	END

	-- Add random code to patient record
	UPDATE TPatients 
	SET intRandomCodeID = @intRandomCodeID
	WHERE @intPatientID = intPatientID

	-- Change available to false
	UPDATE TRandomCodes
	SET blnAvailable = 'F'
	WHERE @intRandomCodeID = intRandomCodeID

	-- Get site ID of patient
	BEGIN

		DECLARE SiteID CURSOR LOCAL FOR
		SELECT intSiteID FROM VStudy12345Patients
		WHERE @intPatientID = intPatientID

		OPEN SiteID

		FETCH FROM SiteID
		INTO @intSiteID

	END

	-- Check which treatment was assigned
	BEGIN 

		DECLARE Treatment CURSOR LOCAL FOR
		SELECT strTreatment FROM VRandomizedStudy12345Patients
		WHERE @intPatientID = intPatientID

		OPEN Treatment

		FETCH FROM Treatment
		INTO @strTreatment

	END

	-- Assign drug kit
	BEGIN
		
		DECLARE DrugKit CURSOR LOCAL FOR
		SELECT MIN(intDrugKitID) FROM VAllAvailableDrugKits
		WHERE @intSiteID = intSiteID AND @strTreatment = strTreatment

		OPEN DrugKit

		FETCH FROM DrugKit
		INTO @intDrugKitID

	END

	-- Change visit ID for drug kit
	UPDATE TDrugKits
	SET intVisitID = @intVisitID
	WHERE @intDrugKitID = intDrugKitID


COMMIT TRANSACTION

GO


-- Study 54321
GO

CREATE PROCEDURE uspRandomizePatient54321
	 @intVisitID			AS INTEGER OUTPUT
	,@intRandomCodeID		AS INTEGER OUTPUT
	,@intDrugKitID			AS INTEGER OUTPUT
    ,@intPatientID			AS INTEGER

AS
SET NOCOUNT ON		-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error

BEGIN TRANSACTION
	DECLARE @dtmVisit AS DATETIME
	DECLARE @intSiteID AS INTEGER
	DECLARE @strTreatment AS VARCHAR(255)
	DECLARE @ATreatmentNumber AS INTEGER
	DECLARE @PTreatmentNumber AS INTEGER
	DECLARE @decRandom AS DECIMAL(5, 3)

	-- Create new visit
	SET @dtmVisit = GETDATE()
	INSERT INTO TVisits WITH(TABLOCK) ( intPatientID, dtmVisit, intVisitTypeID )
	VALUES( @intPatientID, @dtmVisit, 2 )

	SELECT @intVisitID = MAX(intVisitID) FROM TVisits

	-- Get number of treatments assigned for active and placebo
	BEGIN 
		DECLARE ATreatmentsTaken CURSOR LOCAL FOR
		SELECT intNumberTaken FROM VSumTreatmentsTaken
		WHERE strTreatment = 'A'

		OPEN ATreatmentsTaken

		FETCH FROM ATreatmentsTaken
		INTO @ATreatmentNumber
	END

	BEGIN
		DECLARE PTreatmentsTaken CURSOR LOCAL FOR
		SELECT intNumberTaken FROM VSumTreatmentsTaken
		WHERE strTreatment = 'P'

		OPEN PTreatmentsTaken

		FETCH FROM PTreatmentsTaken
		INTO @PTreatmentNumber

	END
	
	-- Check if active/placebo outnumber the other by 2
	IF @ATreatmentNumber = @PTreatmentNumber + 2
		BEGIN
			SET @strTreatment = 'P'
		END
	ELSE IF @PTreatmentNumber = @ATreatmentNumber + 2
		BEGIN
			SET @strTreatment = 'A'
		END
	-- If not, use random generator
	ELSE
		SET @decRandom = RAND()
		IF @decRandom < 0.5
			BEGIN
				SET @strTreatment = 'P'
			END
		ELSE IF @decRandom > 0.5
			BEGIN
				SET @strTreatment = 'A'
			END

	-- Get next available random code from view using cursor and according to treatment
	BEGIN	

		DECLARE RandomCode54321 CURSOR LOCAL FOR
		SELECT intRandomCodeID FROM VNextRandomCode54321
		WHERE @strTreatment = strTreatment

		OPEN RandomCode54321

		FETCH FROM RandomCode54321
		INTO @intRandomCodeID	
		
	END

	-- Add random code to patient record
	UPDATE TPatients 
	SET intRandomCodeID = @intRandomCodeID
	WHERE @intPatientID = intPatientID

	-- Change available to false
	UPDATE TRandomCodes
	SET blnAvailable = 'F'
	WHERE @intRandomCodeID = intRandomCodeID

	-- Get site ID of patient
	BEGIN

		DECLARE SiteID CURSOR LOCAL FOR
		SELECT intSiteID FROM VStudy54321Patients
		WHERE @intPatientID = intPatientID

		OPEN SiteID

		FETCH FROM SiteID
		INTO @intSiteID

	END

	-- Assign drug kit
	BEGIN
		
		DECLARE DrugKit CURSOR LOCAL FOR
		SELECT MIN(intDrugKitID) FROM VAllAvailableDrugKits
		WHERE @intSiteID = intSiteID AND @strTreatment = strTreatment

		OPEN DrugKit

		FETCH FROM DrugKit
		INTO @intDrugKitID

	END

	-- Change visit ID for drug kit
	UPDATE TDrugKits
	SET intVisitID = @intVisitID
	WHERE @intDrugKitID = intDrugKitID


COMMIT TRANSACTION

GO