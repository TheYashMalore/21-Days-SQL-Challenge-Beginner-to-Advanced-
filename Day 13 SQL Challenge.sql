-- Practice Question 1. Join patients and staff based on their common service field (show patient and staff who work in same service).
select p.name as patient_name, staff_name, p.service, s.role from patients p
inner join staff s
on p.service = s.service order by p.service, p.name;

-- Practice Question 2. Join services_weekly with staff to show weekly service data with staff information.
select sw.*, staff_name, s.role from services_weekly sw
inner join staff s
on sw.service = s.service order by sw.week, s.staff_name;

-- Practice Question 3. Create a report showing patient information along with staff assigned to their service.
select p.*, staff_name, s.role from patients p
inner join staff s
on p.service = s.service order by p.service, p.name;

 -- Daily Challenge Question: Create a comprehensive report showing patient_id, patient name, age, service, and the total number of 
 -- staff members available in their service. Only include patients from services that have more than 5 staff members. Order by number
 -- of staff descending, then by patient name.
select p.name ,p.patient_id,p.age,p.service, count(s.staff_id) as total_staff from patients p
inner join staff s
on p.service = s.service
group by p.name ,p.patient_id,p.age,p.service
having count(s.staff_id) > 5 
order by total_staff desc, p.name;
