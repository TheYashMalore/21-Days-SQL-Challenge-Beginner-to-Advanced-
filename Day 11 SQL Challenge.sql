-- Practice Question 1. List all unique services in the patients table.
SELECT DISTINCT service FROM patients;

-- Practice Question 2. Find all unique staff roles in the hospital.
select distinct role from staff;

-- Practice Question 3. Get distinct months from the services_weekly table.
select distinct month from services_weekly;

-- Daily Challenge Question: Find all unique combinations of service and event type from the services_weekly 
-- table where events are not null or none, along with the count of occurrences for each combination. Order by 
-- count descending.
select service, event, count(*) as occurrence_count 
from services_weekly
where event is not null and event != 'none'
group by service, event
order by occurrence_count desc ;