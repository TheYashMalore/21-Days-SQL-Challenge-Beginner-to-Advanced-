-- Practice Question 1. Rank patients by satisfaction score within each service.
SELECT p.patient_id, p.name, p.service, p.satisfaction,
    RANK() OVER (PARTITION BY p.service ORDER BY p.satisfaction DESC) AS service_satisfaction_rank
FROM patients AS p
ORDER BY p.service, service_satisfaction_rank;

-- Practice Question 2. Assign row numbers to staff ordered by their name.
SELECT s.staff_id, s.staff_name, s.role,
    ROW_NUMBER() OVER (ORDER BY s.staff_name ASC) AS staff_row_number
FROM staff AS s
ORDER BY staff_row_number;

-- Practice Question 3. Rank services by total patients admitted.
WITH ServiceAdmissions AS (
    SELECT sw.service, SUM(sw.patients_admitted) AS total_admitted
    FROM services_weekly AS sw
    GROUP BY sw.service)
SELECT SA.service, SA.total_admitted,
    RANK() OVER (ORDER BY SA.total_admitted DESC) AS admission_rank
FROM ServiceAdmissions AS SA
ORDER BY admission_rank;

-- Daily Challenge Question: For each service, rank the weeks by patient satisfaction score (highest first).
-- Show service, week, patient_satisfaction, patients_admitted, and the rank. Include only the top 3 weeks per service.
WITH RankedWeeks AS (
    SELECT sw.service, sw.week, sw.patient_satisfaction, sw.patients_admitted,
        RANK() OVER (PARTITION BY sw.service ORDER BY sw.patient_satisfaction DESC) AS service_week_rank
    FROM services_weekly AS sw)
SELECT RW.service, RW.week, RW.patient_satisfaction, RW.patients_admitted, RW.service_week_rank
FROM RankedWeeks AS RW WHERE RW.service_week_rank <= 3 
ORDER BY RW.service, RW.service_week_rank;