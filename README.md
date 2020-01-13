# pharmacyStudy
A SQL project that simulates the collection and processing of data during patients' visits for a pharmacy that tests experimental drugs . This project uses stored procedures, transactions, views, and cursors to add patients to the study at screening, assign them a random drug kit (placebo/active) on the next visit, or process the patient's withdrawal if screen test results are negative or the study is complete. Study 12345 distributes random codes from a list in sequential order. Study 54321 uses a random generator to assign placebo/active treatment.

### Scripts
The [scripts](https://github.com/kezizhou/pharmacyStudy/tree/master/scripts) folder contains the main script for this SQL Project, [pharmacyStudy.sql](https://github.com/kezizhou/pharmacyStudy/blob/master/scripts/pharmacyStudy.sql). This script creates the tables, views, and stored procedures that allow for patient processing. 

### Sample Results
The [sampleResults](https://github.com/kezizhou/pharmacyStudy/tree/master/sampleResults) folder contains sample results and view content for this SQL project. [CallsToUSP.sql](https://github.com/kezizhou/pharmacyStudy/blob/master/sampleResults/CallsToUSP.sql) is executed to insert data by calling the stored procedures. Sample views that result from these calls can be found in this folder.
