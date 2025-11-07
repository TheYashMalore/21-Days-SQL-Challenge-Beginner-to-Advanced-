USE hospital;

-- Practice Question 1. Count the total number of patients in the hospital.
SELECT COUNT(patient_id) FROM patients;

-- Practice Question 2. Calculate the average satisfaction score of all patients.
SELECT AVG(satisfaction) AS avg_satisfaction_score FROM patients;
 
-- Practice Question 3. Find the minimum and maximum age of patients.
SELECT MAX(age) AS max_age, MIN(age) AS min_age FROM patients;

-- Daily Challenge Question: Calculate the total number of patients admitted, total patients refused, and the 
-- average patient satisfaction across all services and weeks. Round the average satisfaction to 2 decimal places.
SELECT SUM(patients_admitted) AS TOTAL_patients_admitted,
	   SUM(patients_refused) AS total_patient_refused,
	   ROUND(avg(patient_satisfaction),2) AS avg_satisfaction
FROM services_weekly;


