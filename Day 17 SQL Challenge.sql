-- Practice Question 1. Show each patient with their service's average satisfaction as an additional column.
SELECT p.patient_id, p.name, p.service, p.satisfaction AS patient_satisfaction, T2.avg_service_sat FROM
patients AS p INNER JOIN(
        SELECT sw.service, AVG(sw.patient_satisfaction) AS avg_service_sat FROM services_weekly AS sw
        GROUP BY sw.service) AS T2
ON p.service = T2.service;

-- Practice Question 2. Create a derived table of service statistics and query from it.
WITH ServiceStats AS (
    SELECT sw.service, SUM(sw.patients_admitted) AS total_admitted, AVG(sw.patient_satisfaction) AS avg_satisfaction,
        SUM(sw.patients_refused) AS total_refused FROM services_weekly AS sw GROUP BY sw.service)
	SELECT ss.service, ss.total_admitted, ss.avg_satisfaction FROM ServiceStats AS SS WHERE ss.total_admitted > 500 
	ORDER BY ss.total_admitted DESC;      
    
-- Practice Question 3. Display staff with their service's total patient count as a calculated field.
SELECT s.staff_id, s.staff_name, s.service, T2.total_admissions_for_service FROM staff AS s
INNER JOIN(
        SELECT sw.service, SUM(sw.patients_admitted) AS total_admissions_for_service FROM services_weekly AS sw
        GROUP BY sw.service) AS T2
ON s.service = T2.service
ORDER BY T2.total_admissions_for_service DESC;       
 
-- Daily Challenge Question: Create a report showing each service with: service name, total patients admitted, the difference between their 
-- total admissions and the average admissions across all services, and a rank indicator ('Above Average', 'Average', 'Below Average').
-- Order by total patients admitted descending.
WITH ServiceAdmissions AS (
    SELECT sw.service, SUM(sw.patients_admitted) AS total_admitted FROM services_weekly AS sw GROUP BY sw.service),
OverallAverage AS (
	SELECT AVG(total_admitted) AS avg_hospital_admissions FROM ServiceAdmissions)
	SELECT SA.service, SA.total_admitted, SA.total_admitted - OA.avg_hospital_admissions AS difference_from_average,
    CASE
        WHEN SA.total_admitted > OA.avg_hospital_admissions THEN 'Above Average'
        WHEN SA.total_admitted = OA.avg_hospital_admissions THEN 'Average'
        ELSE 'Below Average'
    END AS admission_rank
FROM ServiceAdmissions AS SA
CROSS JOIN OverallAverage AS OA 
ORDER BY SA.total_admitted DESC;