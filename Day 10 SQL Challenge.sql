-- Practice Question 1. Categorise patients as 'High', 'Medium', or 'Low' satisfaction based on their scores.
select name, satisfaction,Case
							when satisfaction >= 90 then 'High'
							when satisfaction >= 70 then 'Medium'
							else 'low'
						end as satisfaction_category
from patients;

-- Practice Question 2. Label staff roles as 'Medical' or 'Support' based on role type.
select service, staff_name,case when role in ('doctor','nurse') then 'Medical'
							else 'Support'
							end as role_type
from staff;

-- Practice Question 3. Create age groups for patients (0-18, 19-40, 41-65, 65+).
select patient_id,name, age, case 
								when age between 0 and 18 then '0-18'
                                when age between 19 and 40 then '19-40'
                                when age between 41 and 65 then '41-65'
                                else '65+' 
							 end as age_group
from patients;
-- Daily Challenge Question:Create a service performance report showing service name, total patients admitted, 
-- and a performance category based on the following: 'Excellent' if avg satisfaction >= 85, 'Good' if >= 75, 'Fair' 
-- if >= 65, otherwise 'Needs Improvement'. Order by average satisfaction descending.
SELECT service, ROUND(AVG(patient_satisfaction), 2) AS avg_satisfaction,
				SUM(patients_admitted) AS total_patients_admitted,
CASE
	WHEN AVG(patient_satisfaction) >= 85 THEN 'Excellent'
	WHEN AVG(patient_satisfaction) >= 75 THEN 'Good'
	WHEN AVG(patient_satisfaction) >= 65 THEN 'Fair'
	ELSE 'Needs Improvement'
 END AS satisfaction_category
 FROM services_weekly
GROUP BY service
ORDER BY AVG(patient_satisfaction) DESC;