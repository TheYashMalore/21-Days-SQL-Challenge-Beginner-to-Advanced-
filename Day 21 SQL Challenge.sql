-- Practice Question 1. Create a CTE to calculate service statistics, then query from it.
WITH ServicePerformance AS (SELECT sw.service, SUM(sw.patients_admitted) AS total_admissions,
        ROUND(AVG(sw.patient_satisfaction), 2) AS avg_satisfaction_score, SUM(sw.patients_refused) AS total_refusals
    FROM services_weekly AS sw GROUP BY sw.service)
SELECT SP.service,SP.total_admissions, SP.avg_satisfaction_score, SP.total_refusals
FROM ServicePerformance AS SP WHERE SP.total_refusals > 0 
ORDER BY SP.total_admissions DESC;

-- Practice Question 2. Use multiple CTEs to break down a complex query into logical steps.
WITH WeeklyRequestAverages AS (SELECT sw.week, AVG(sw.patients_request) AS avg_weekly_request_hospital
    FROM services_weekly AS sw GROUP BY sw.week),
HighDemandWeeks AS (SELECT sw.service, sw.week, sw.patients_request
    FROM services_weekly AS sw
    INNER JOIN WeeklyRequestAverages AS WRA ON sw.week = WRA.week
    WHERE sw.patients_request > WRA.avg_weekly_request_hospital)
SELECT DISTINCT s.staff_id, s.staff_name,s.service,T2.week AS high_demand_week FROM staff AS s
INNER JOIN staff_schedule AS ss ON s.staff_id = ss.staff_id
INNER JOIN HighDemandWeeks AS T2 ON s.service = T2.service AND ss.week = T2.week
WHERE ss.present = 1 
ORDER BY s.staff_name, high_demand_week;

-- Practice Question 3. Build a CTE for staff utilization and join it with patient data.
WITH ServiceUtilization AS (SELECT ss.service, ROUND(AVG(ss.present), 4) AS avg_utilization_rate
    FROM staff_schedule AS ss
    GROUP BY ss.service)
SELECT p.patient_id, p.name, p.service, p.satisfaction, SU.avg_utilization_rate
FROM patients AS p
INNER JOIN ServiceUtilization AS SU ON p.service = SU.service
ORDER BY p.service, p.name;

-- Daily Challenge Question: Create a comprehensive hospital performance dashboard using CTEs. Calculate: 1) Service-level metrics
-- (total admissions, refusals, avg satisfaction), 2) Staff metrics per service (total staff, avg weeks present), 3) Patient demographics 
-- per service (avg age, count). Then combine all three CTEs to create a final report showing service name, all calculated metrics, and an 
-- overall performance score (weighted average of admission rate and satisfaction). Order by performance score descending.
WITH service_metrics AS (SELECT service, SUM(patients_admitted) AS total_admitted, SUM(patients_refused) AS total_refused,
        AVG(patient_satisfaction) AS avg_satisfaction
    FROM services_weekly GROUP BY service),
staff_metrics AS (SELECT service, COUNT(DISTINCT staff_id) AS total_staff, AVG(present) AS avg_weeks_present
    FROM staff_schedule GROUP BY service),
patient_metrics AS (SELECT service, COUNT(patient_id) AS total_patients, AVG(age) AS avg_age
    FROM patients GROUP BY service)
SELECT sm.service, sm.total_admitted, sm.total_refused, ROUND(sm.avg_satisfaction, 2) AS avg_satisfaction,
    ROUND(CASE
            WHEN (sm.total_admitted + sm.total_refused) = 0 THEN 0
            ELSE (sm.total_admitted * 100.0) / (sm.total_admitted + sm.total_refused)
        END, 2) AS admission_rate,
    COALESCE(st.total_staff, 0) AS total_staff, ROUND(COALESCE(st.avg_weeks_present, 0), 4) AS avg_weeks_present,
    COALESCE(pm.total_patients, 0) AS total_patients,ROUND(COALESCE(pm.avg_age, 0), 2) AS avg_age,
    ROUND(0.6 * COALESCE(sm.avg_satisfaction, 0) + 0.4 * (CASE
                WHEN (sm.total_admitted + sm.total_refused) = 0 THEN 0
                ELSE (sm.total_admitted * 100.0) / (sm.total_admitted + sm.total_refused)
            END), 2) AS performance_score
FROM service_metrics sm
LEFT JOIN staff_metrics st ON sm.service = st.service
LEFT JOIN patient_metrics pm ON sm.service = pm.service
ORDER BY performance_score DESC;
