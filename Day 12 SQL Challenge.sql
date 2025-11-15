-- Practice Question 1. Find all weeks in services_weekly where no special event occurred.
select week from services_weekly where event is null ;

-- Practice Question 2. Count how many records have null or empty event values.
select count(*) as total_events, count(event) as not_null_events, count(*) - count(event) as null_events 
from services_weekly;

-- Practice Question 3. List all services that had at least one week with a special event.
select  service, count(event) as special_event from services_weekly where event is not null
group by service;

 -- Daily Challenge Question: Analyze the event impact by comparing weeks with events vs weeks without events. 
 -- Show: event status ('With Event' or 'No Event'), count of weeks, average patient satisfaction, and average 
 -- staff morale. Order by average patient satisfaction descending.
 select case
			when event is not null and event !=' ' and event != 'none' then 'With Event'
            else 'No Event'
		end as event_status,
        count(*) as week_count,
        Round(avg(patient_satisfaction),2) as avg_sat,
        Round(avg(staff_morale),2) as avg_morale
from services_weekly
group by event_status
order by Round(avg(patient_satisfaction),2) desc;