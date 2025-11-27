#Day 18
-- Practice Questions:
-- 1. Combine patient names and staff names into a single list.
SELECT name, 'Patient' AS source FROM patients UNION ALL SELECT staff_name, 'Staff' AS source FROM staff;
-- 2. Create a union of high satisfaction patients (>90) and low satisfaction patients (<50).
SELECT * FROM (SELECT * FROM patients WHERE satisfaction > 90 UNION SELECT * FROM patients WHERE satisfaction < 50) as t ORDER BY satisfaction DESC;
-- 3. List all unique names from both patients and staff tables.
SELECT name FROM patients UNION SELECT staff_name FROM staff;

-- Daily Challenge
-- Question: Create a comprehensive personnel and patient list showing: identifier (patient_id or staff_id), full name, type ('Patient' or 'Staff'), 
-- and associated service. Include only those in 'surgery' or 'emergency' services. Order by type, then service, then name.
SELECT * FROM (SELECT patient_id AS 'ID', name, service,'Patient' AS type FROM patients WHERE service='surgery' OR service='emergency' UNION SELECT 
staff_id, staff_name, service,'Staff' AS type FROM staff WHERE service='surgery' OR service='emergency') as t ORDER BY type, service, name;