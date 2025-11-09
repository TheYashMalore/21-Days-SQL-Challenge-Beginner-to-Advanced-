USE hospital;

-- Practice Question 1. Count the number of patients by each service.
SELECT service, COUNT(*) AS total_patients FROM patients GROUP BY service;

-- Practice Question 2. Calculate the average age of patients grouped by service.
 SELECT service, AVG(age) AS avg_age FROM patients GROUP BY service;

-- Practice Question 3. Find the total number of staff members per role.
SELECT role, COUNT(staff_id) AS total_staff_members FROM staff GROUP BY role;

-- Daily Challenge Question: For each hospital service, calculate the total number of patients admitted, total patients refused,
-- and the admission rate (percentage of requests that were admitted). Order by admission rate descending.
SELECT service, SUM(patients_admitted) AS total_admitted,
				SUM(patients_refused) AS total_refused,
                ROUND(
						((SUM(patients_admitted))*100.00 / SUM(patients_request)),2
                        ) AS admission_rate
FROM services_weekly
GROUP BY service
ORDER BY admission_rate DESC;
