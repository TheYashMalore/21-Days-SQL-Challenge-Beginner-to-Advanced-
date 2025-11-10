USE hospital;

-- Practice Question 1. Find services that have admitted more than 500 patients in total.
SELECT service, sum(patients_admitted) from services_weekly group by service
having sum(patients_admitted) >500 ;

-- Practice Question 2. Show services where average patient satisfaction is below 75.
select service, avg(satisfaction) from patients group by service having avg(satisfaction) < 75;

-- Practice Question 3. List weeks where total staff presence across all services was less than 50. 
select week, sum(present) from staff_schedule group by week having sum(present) < 50;

-- Daily Challenge Question: Identify services that refused more than 100 patients in total and had an average
-- patient satisfaction below 80. Show service name, total refused, and average satisfaction.
select service, sum(patients_refused) ,avg(patient_satisfaction) 
from services_weekly 
group by service 
having sum(patients_refused)>100 and avg(patient_satisfaction)<80;




