-- Practice Question 1. Show all staff members and their schedule information (including those with no schedule entries).
select s.staff_id,s.staff_name,s.role, s.service, count(ss.week) as week_scheduled, sum(coalesce(present,0)) as  weeks_present from staff s
left join staff_schedule ss on s.staff_id = ss.staff_id
group by s.staff_id,s.staff_name,s.role, s.service;

-- Practice Question 2. List all services from services_weekly and their corresponding staff (show services even if no staff assigned).
select distinct sw.service, s.staff_name from services_weekly sw
left join staff s on sw.service = s.service;

-- Practice Question 3. Display all patients and their service's weekly statistics (if available).
select p.name as patient_name, p.arrival_date,p.service, sw.week, sw.available_beds,sw.patients_admitted,
    sw.patients_refused, sw.patient_satisfaction ,sw.staff_morale, sw.event from patients p 
left join services_weekly sw
on p.service=sw.service and week(p.arrival_date)=sw.week;

-- Daily Challenge Question: Create a staff utilisation report showing all staff members (staff_id, staff_name, role, service) and the count
-- of weeks they were present (from staff_schedule). Include staff members even if they have no schedule records. Order by weeks present descending.
select s.staff_id,s.staff_name,s.role,s.service, sum(coalesce(present,0)) as  weeks_present from staff s
left join staff_schedule ss
on s.staff_id=ss.staff_id
group by s.staff_id,s.staff_name,s.role, s.service
order by weeks_present desc;