USE hospital;

-- Practice Question 1.Find all patients who are older than 60 years.
SELECT * FROM patients WHERE age > 60 ;

-- Practice Question 2.Retrieve all staff members who work in the 'Emergency' service.
SELECT staff_id, staff_name FROM staff WHERE service = 'emergency';

-- Practice Question 3.List all weeks where more than 100 patients equested admission in any service.
SELECT week, service, patients_request FROM services_weekly 
WHERE patients_request>100;

-- Daily Challenge Question:Find all patients admitted to 'Surgery' service with a satisfaction score 
-- below 70, showing their patient_id, name, age, and satisfaction score.
SELECT patient_id, name, age, satisfaction 
FROM patients 
WHERE service= 'surgery' AND satisfaction<70;