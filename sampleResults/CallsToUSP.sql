-- -----------------------------------------------------------------------------------------
-- Options
-- -----------------------------------------------------------------------------------------
USE dbSQL1;


DECLARE @intVisitID AS INTEGER, @intPatientID AS INTEGER, @intDrugKitID AS INTEGER, @intRandomCodeID AS INTEGER
-- -----------------------------------------------------------------------------------------
--  8 patients for each study for screening.
-- -----------------------------------------------------------------------------------------
-- Study 1 (Sites 1 - 3)
EXECUTE uspScreenPatient @intPatientID OUTPUT, @intVisitID OUTPUT, 101001, 1, '1/13/1962', 2, 205, '3/01/2019'
EXECUTE uspScreenPatient @intPatientID OUTPUT, @intVisitID OUTPUT, 111001, 2, '2/24/1973', 1, 115, '3/02/2019'
EXECUTE uspScreenPatient @intPatientID OUTPUT, @intVisitID OUTPUT, 121001, 3, '7/22/1978', 2, 170, '2/27/2019'
EXECUTE uspScreenPatient @intPatientID OUTPUT, @intVisitID OUTPUT, 101002, 1, '10/01/1968', 1, 105, '3/04/2019'
EXECUTE uspScreenPatient @intPatientID OUTPUT, @intVisitID OUTPUT, 111002, 2, '5/17/1957', 2, 190, '3/03/2019'
EXECUTE uspScreenPatient @intPatientID OUTPUT, @intVisitID OUTPUT, 121002, 3, '3/27/1986', 1, 130, '3/01/2019'
EXECUTE uspScreenPatient @intPatientID OUTPUT, @intVisitID OUTPUT, 101003, 1, '8/19/1979', 2, 200, '3/05/2019'
EXECUTE uspScreenPatient @intPatientID OUTPUT, @intVisitID OUTPUT, 111003, 2, '12/07/1993', 1, 110, '3/02/2019'
-- Study 2 (Sites 4 - 6)
EXECUTE uspScreenPatient @intPatientID OUTPUT, @intVisitID OUTPUT, 501001, 4, '8/23/1973', 2, 176, '3/02/2019'
EXECUTE uspScreenPatient @intPatientID OUTPUT, @intVisitID OUTPUT, 511001, 5, '12/27/1964', 1, 103, '3/06/2019'
EXECUTE uspScreenPatient @intPatientID OUTPUT, @intVisitID OUTPUT, 521001, 6, '3/16/1986', 2, 157, '2/25/2019'
EXECUTE uspScreenPatient @intPatientID OUTPUT, @intVisitID OUTPUT, 501002, 4, '11/25/1983', 1, 132, '2/28/2019'
EXECUTE uspScreenPatient @intPatientID OUTPUT, @intVisitID OUTPUT, 511002, 5, '6/17/1989', 2, 167, '3/05/2019'
EXECUTE uspScreenPatient @intPatientID OUTPUT, @intVisitID OUTPUT, 521002, 6, '9/17/1976', 1, 117, '2/20/2019'
EXECUTE uspScreenPatient @intPatientID OUTPUT, @intVisitID OUTPUT, 501003, 4, '10/22/1978', 2, 174, '3/04/2019'
EXECUTE uspScreenPatient @intPatientID OUTPUT, @intVisitID OUTPUT, 511003, 5, '2/17/1993', 1, 109, '2/17/2019'


-- -----------------------------------------------------------------------------------------
--  5 patients randomized for each study. (including assigning drug kit)
-- -----------------------------------------------------------------------------------------
-- Study 12345
EXECUTE uspRandomizePatient12345 @intVisitID OUTPUT, @intRandomCodeID OUTPUT, @intDrugKitID OUTPUT, 2
EXECUTE uspRandomizePatient12345 @intVisitID OUTPUT, @intRandomCodeID OUTPUT, @intDrugKitID OUTPUT, 3
EXECUTE uspRandomizePatient12345 @intVisitID OUTPUT, @intRandomCodeID OUTPUT, @intDrugKitID OUTPUT, 6
EXECUTE uspRandomizePatient12345 @intVisitID OUTPUT, @intRandomCodeID OUTPUT, @intDrugKitID OUTPUT, 7
EXECUTE uspRandomizePatient12345 @intVisitID OUTPUT, @intRandomCodeID OUTPUT, @intDrugKitID OUTPUT, 8

-- Study 54321
EXECUTE uspRandomizePatient54321 @intVisitID OUTPUT, @intRandomCodeID OUTPUT, @intDrugKitID OUTPUT, 9
EXECUTE uspRandomizePatient54321 @intVisitID OUTPUT, @intRandomCodeID OUTPUT, @intDrugKitID OUTPUT, 10
EXECUTE uspRandomizePatient54321 @intVisitID OUTPUT, @intRandomCodeID OUTPUT, @intDrugKitID OUTPUT, 11
EXECUTE uspRandomizePatient54321 @intVisitID OUTPUT, @intRandomCodeID OUTPUT, @intDrugKitID OUTPUT, 14
EXECUTE uspRandomizePatient54321 @intVisitID OUTPUT, @intRandomCodeID OUTPUT, @intDrugKitID OUTPUT, 15


-- -----------------------------------------------------------------------------------------
--  4 patients (2 randomized and 2 not randomized patients) withdrawn from each 
-- study.
-- -----------------------------------------------------------------------------------------
-- Study 12345
-- Randomized
EXECUTE uspWithdrawPatient @intVisitID OUTPUT, 3, '3/01/2019', 6
EXECUTE uspWithdrawPatient @intVisitID OUTPUT, 8, '3/06/2019', 6
-- Not Randomized
EXECUTE uspWithdrawPatient @intVisitID OUTPUT, 1, '3/04/2019', 3
EXECUTE uspWithdrawPatient @intVisitID OUTPUT, 4, '3/07/2019', 4

-- Study 54321
-- Randomized
EXECUTE uspWithdrawPatient @intVisitID OUTPUT, 15, '3/07/2019', 6
EXECUTE uspWithdrawPatient @intVisitID OUTPUT, 10, '3/09/2019', 6
-- Not Randomized
EXECUTE uspWithdrawPatient @intVisitID OUTPUT, 12, '3/03/2019', 1
EXECUTE uspWithdrawPatient @intVisitID OUTPUT, 16, '2/28/2019', 5