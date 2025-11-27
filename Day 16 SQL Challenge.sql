-- Practice Question 1. Find patients who are in services with above-average staff count.
select p.* from patients p where p.service in (
	select service from staff group by service having count(*) > (
		select avg(staff_cnt) from ( select count(*) as staff_cnt from staff group by service) as t
        ));
        
-- Practice Question 2. List staff who work in services that had any week with patient satisfaction below 70.
select distinct s.* from staff s where s.service in (select distinct service from services_weekly 
		where patient_satisfaction < 70);
        
-- Practice Question 3. Show patients from services where total admitted patients exceed 1000.
select p.* from patients p where p.service in (SELECT service FROM services_weekly GROUP BY service
        HAVING SUM(patients_admitted) > 1000);
        
-- Daily Challenge Question: Find all patients who were admitted to services that had at least one week where patients were 
-- refused AND the average patient satisfaction for that service was below the overall hospital average satisfaction. Show patient_id, 
-- name, service, and their personal satisfaction score.
SELECT p.patient_id, p.name, p.service, p.satisfaction AS patient_satisfaction FROM patients AS p WHERE p.service IN (
        SELECT sw.service FROM services_weekly AS sw GROUP BY sw.service
        HAVING AVG(sw.patient_satisfaction) < ( SELECT AVG(patient_satisfaction) FROM services_weekly)
            AND SUM(CASE WHEN sw.patients_refused > 0 THEN 1 ELSE 0 END) >= 1);