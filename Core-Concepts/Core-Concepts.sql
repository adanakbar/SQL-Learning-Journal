-------------------------------------------------------DDL------------------------------------------------------------------------------
CREATE DATABASE SmartClinicDB;

CREATE TABLE doctors(
	doctor_id VARCHAR(20) PRIMARY KEY,
	name VARCHAR(20) NOT NULL,
	specialization VARCHAR(50) NOT NULL,
	experience INT CHECK (experience >=0)
	
);

CREATE TABLE patients(
	patient_id VARCHAR(20) PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	gender VARCHAR(5) NOT NULL CHECK (gender IN('M','F','O')),
	dob DATE 
);

CREATE TABLE appointments(
	appointment_id VARCHAR(20) PRIMARY KEY,
	doctor_id VARCHAR(20),
	patient_id VARCHAR(20),
	date_of_appointment DATE,
	status VARCHAR(20) CHECK(status IN ('Scheduled','Completed','Cancelled')),
	FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
	FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
	
);

CREATE TABLE feedbacks(
	feedback_id VARCHAR(20) PRIMARY KEY,
	rating INT CHECK(rating BETWEEN 1 and 5),
	appointment_id VARCHAR(20),
	comment TEXT,
	FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);


DROP TABLE patients;
TRUNCATE patients;

ALTER TABLE doctors RENAME COLUMN specialization to speciality;
ALTER TABLE doctors DROP COLUMN experience;


-------------------------------------------------------DML-----------------------------------------------------------------------------
INSERT INTO doctors(doctor_id, name, speciality)
VALUES
('D0001','Huda Idrees','Heart Surgeon'),
('D0002','Maryam Faseeh','Dermatology');

INSERT INTO patients(patient_id, name, gender, dob)
VALUES
('P0001','Adan Akbar','F','2003-2-15'),
('P0002','Adan Akbar','F','2000-2-12');

INSERT INTO appointments(appointment_id, doctor_id, patient_id, date_of_appointment, status)
VALUES
('A0001','D0001','P0001', '2025-10-23','Scheduled'),
('A0002','D0002','P0001', '2025-10-26','Completed');

INSERT INTO feedbacks(feedback_id, rating, appointment_id, comment)
VALUES('F0001','5','A0001','Best experience');

UPDATE appointments
SET status = 'Completed' WHERE appointment_id ='A0001';

DELETE FROM feedbacks WHERE feedback_id ='F0001';

-------------------------------------------------------DQL-----------------------------------------------------------------------------
Select d.doctor_id AS Doctor_ID, d.name AS Doctor_Name
FROM doctors d
JOIN  appointments a ON d.doctor_id = a.doctor_id;

-------------------------------------------------------DCL-----------------------------------------------------------------------------
GRANT SELECT, INSERT ON appointments TO pg_database_owner;
REVOKE DELETE ON appointments FROM pg_database_owner;

-------------------------------------------------------TCL-----------------------------------------------------------------------------
BEGIN;
UPDATE patients 
SET name ='Maham'
WHERE patient_id ='P0001';
SAVEPOINT before_name_change;
UPDATE patients 
SET name ='Adan'
WHERE patient_id ='P0001';
ROLLBACK TO before_name_change;
COMMIT;
