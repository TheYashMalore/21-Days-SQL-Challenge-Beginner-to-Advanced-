USE hospital;

-- Practice Question 1. List all patients sorted by age in descending order.
SELECT * FROM patients ORDER BY age DESC;

-- Practice Question 2. Show all services_weekly data sorted by week number ascending and patients_request descending.
SELECT * FROM services_weekly ORDER BY week ASC, patients_request DESC;

-- Practice Question 3. Display staff members sorted alphabetically by their names.
SELECT staff_name FROM staff ORDER BY staff_name ASC;

-- Daily Challenge Question: Retrieve the top 5 weeks with the highest patient refusals across all services,
-- showing week, service, patients_refused, and patients_request. Sort by patients_refused in descending order.

SELECT week, service, patients_request, patients_refused FROM services_weekly ORDER BY patients_refused DESC LIMIT 5;

