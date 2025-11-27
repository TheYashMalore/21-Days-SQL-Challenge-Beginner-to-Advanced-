-- Practice Question 1. Calculate running total of patients admitted by week for each service.
SELECT sw.service, sw.week, sw.patients_admitted, SUM(sw.patients_admitted) OVER (
			PARTITION BY sw.service
			ORDER BY sw.week
			ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_admitted
FROM services_weekly AS sw
ORDER BY sw.service, sw.week;

-- Practice Question 2. Find the moving average of patient satisfaction over 4-week periods.
SELECT sw.service, sw.week, sw.patient_satisfaction, AVG(sw.patient_satisfaction) OVER (
        PARTITION BY sw.service
        ORDER BY sw.week
        ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS four_week_moving_average_sat
FROM services_weekly AS sw
ORDER BY sw.service, sw.week;

-- Practice Question 3. Show cumulative patient refusals by week across all services.
SELECT sw.week, SUM(sw.patients_refused) AS weekly_refusals_total, SUM(SUM(sw.patients_refused)) OVER (
        ORDER BY sw.week
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_hospital_refusals
FROM services_weekly AS sw
GROUP BY sw.week 
ORDER BY sw.week;

-- Daily Challenge Question: Create a trend analysis showing for each service and week: week number, patients_admitted, 
-- running total of patients admitted (cumulative), 3-week moving average of patient satisfaction (current week and 2 prior weeks), 
-- and the difference between current week admissions and the service average. Filter for weeks 10-20 only.
WITH ServiceAverages AS (
    SELECT sw.service, AVG(sw.patients_admitted) AS avg_service_admissions FROM services_weekly AS sw
    GROUP BY sw.service)
SELECT sw.service, sw.week, sw.patients_admitted, SUM(sw.patients_admitted) OVER (
        PARTITION BY sw.service
        ORDER BY sw.week
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_admitted,
    AVG(sw.patient_satisfaction) OVER (
        PARTITION BY sw.service
        ORDER BY sw.week
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS three_week_moving_avg_sat,
    sw.patients_admitted - SA.avg_service_admissions AS difference_from_service_avg
FROM services_weekly AS sw
INNER JOIN ServiceAverages AS SA ON sw.service = SA.service 
WHERE sw.week BETWEEN 10 AND 20 
ORDER BY sw.service, sw.week;