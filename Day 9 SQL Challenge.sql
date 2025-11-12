-- Practice Question 1. Extract the year from all patient arrival dates.
select patient_id, name , year(arrival_date) as arrival_year from patients;

-- Practice Question 2. Calculate the length of stay for each patient (departure_date - arrival_date).
select patient_id, name, datediff(departure_date,arrival_date) as length_of_stay from patients;

-- Practice Question 3. Find all patients who arrived in a specific month.
select patient_id, name, arrival_date from patients where month(arrival_date) = 09;

-- Daily Challenge Question: Calculate the average length of stay (in days) for each service, showing only 
-- services where the average stay is more than 7 days. Also show the count of patients and order by average stay descending.
select service, round(avg(datediff(departure_date,arrival_date)),1)  as avg_stay,
	    count(patient_id) as patient_count 
from patients
group by service
having round(avg(datediff(departure_date,arrival_date)),1) > 7
order by avg_stay desc;



