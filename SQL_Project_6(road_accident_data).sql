use college13;
select * from road_accident_data;

-- 1. Total accidents by city
select location, count(*) as total_accidents from road_accident_data
group by location order by total_accidents desc;


-- 2. Average speed and casualties per vehicle type
select vehicle_type, round(avg(speed_kmph),2) as avg_speed, round(avg(number_of_casualties),2) as avg_casualties 
from road_accident_data
group by vehicle_type order by avg_speed desc;
 

-- 3. Find accidents where location name starts with “M”
select accident_id, location, vehicle_type, accident_severity
from road_accident_data
where location like 'M%';


-- 4. Most common weather condition per city
select location, weather_condition, total from
(select location, weather_condition, count(*) as total, row_number() over (partition by location order by count(*) desc) as rn 
from road_accident_data group by location, weather_condition) as NT 
where rn=1;



-- 5. Ranking cities by accident count
select location, count(*) as total_accidents, rank() over(order by count(*) desc) as city_rnk
from road_accident_data group by location;


-- 6. Find top 5 months with highest number of fatal accidents
select month, count(*) as fatal_count from road_accident_data
where accident_severity='Fatal' group by month order by fatal_count desc limit 5;


-- 7. Average driver age by accident severity
select accident_severity, round(avg(driver_age),1) as avg_driver_age 
from road_accident_data group by accident_severity order by avg_driver_age;



-- 8. Percentage of accidents involving alcohol by city
select location, round(100* sum(case
								when alcohol_involved='Yes' then 1
                                else 0 end) / count(*),2) as alcohol_involvement_rate
from road_accident_data group by location 
order by alcohol_involvement_rate desc;                                



-- 9. Find cities where average speed > overall average speed
select location, round(avg(speed_kmph),2) as avg_speed from road_accident_data
group by location 
having avg(speed_kmph) > (select avg(speed_kmph) from road_accident_data)
order by avg_speed desc;



-- 10. Running total of accidents by date
select date, count(*) as daily_accidents, sum(count(*)) over(order by date) as running_total
from road_accident_data group by date order by date;



-- 11. Identify top accident-prone vehicle types by severity
select * from 
(select vehicle_type, accident_severity, count(*) as total_cases,
rank() over( partition by accident_severity order by count(*) desc) as rnk
from road_accident_data 
group by vehicle_type, accident_severity) as NT
where rnk =1;



-- 12. Find the most dangerous weather condition overall
select weather_condition, count(*) as fatal_accidents
from road_accident_data where accident_severity='Fatal'
group by weather_condition
order by fatal_accidents desc limit 1;



-- 13. Hourly pattern: peak accident hours
select hour(time) as Hour, count(*) as total_accidents
from road_accident_data
group by Hour
order by total_accidents limit 5;



-- 14. Correlation between driver age and accident severity
select case 
when driver_age < 20 then 'Below 20'
when driver_age between 20 and 30 then '20-30'
when driver_age between 31 and 50 then '30-50'
else 'Above 50'
end as age_group,
accident_severity, count(*) as total_accidents
from road_accident_data group by age_group,accident_severity
order by age_group; 




-- 15. Month-over-month accident growth rate
select month, count(*) as total_accidents, lag(count(*)) over(order by month) as prev_month_accidents,
round(100 * (count(*) - lag(count(*)) over(order by month)) / lag(count(*)) over(order by month),2) as growth_rate_percent
from road_accident_data group by month
order by month;












































 