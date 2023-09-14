--Explore the dataset table overview--

select * from `cyclistic_bike_Data.cyclistic_bike_share`; 

-- Checking the duplicate values in Table
select count(*) as total_row,
count(distinct(ride_id)) as unique_row 
from `cyclistic_bike_Data.cyclistic_bike_share`;

--They are no any duplicate values in Table

--checking any null value in each columns by changeing in where caluse columns
select count(ride_id)
 from `cyclistic_bike_Data.cyclistic_bike_share` 
 where start_station_id is null; --run each columns name to know the null values in columns

 --Found the some columns was contained null values( start_station_name,start_station_id,end_station_name,end_station_id)


--checking the any Incorrect values intable
select * from `cyclistic_bike_Data.cyclistic_bike_share`
where started_at > ended_at; -- found few row in end_at less than start_at time

-- delete row in incorrect data
delete from  `cyclistic_bike_Data.cyclistic_bike_share`
where started_at > ended_at; 

--Completed the Data Cleaning and Check data integrity 

--Create some cloumn to analysis
select * ,
round((timestamp_DIFF(ended_at, started_at ,SECOND)/60),2) as ride_length_mnt,
format_timestamp('%A', timestamp (started_at)) as week_day
from `cyclistic_bike_Data.cyclistic_bike_share`
where round((timestamp_DIFF(ended_at, started_at ,SECOND)/60),2) > 0;


-- I'm create few row to Ride_length(subtract ended_at & strated_at ), onther one week_day (booking_week_day)
-- saveing Result table for further usage 


-- Fing some insights in like max(), min(), avg() ride_length member Vs casual

SELECT member_casual,
concat(round(avg(ride_length_mnt),2),' ', 'mintues') as avg_ride_length,
concat(min(ride_length_mnt)," ","mintues") as min_ride_length,
concat(round((max(ride_length_mnt)/60),2)," ",'hours') as max_ride_length
from `cyclistic_bike_Data.cyclistic_bike_share_v01`
where ride_length_mnt > 0.5 -- Reason for using where clasue min 50 sec will consider as real Ride
group by member_casual;

-- Total booking contribution Member Vs Casual ride
select member_casual,concat(round(count(ride_id)/(select count(*) from `cyclistic_bike_Data.cyclistic_bike_share_v01`) * 100,2)," ","%") as total_booking
from  `cyclistic_bike_Data.cyclistic_bike_share_v01`
group by member_casual;

-- diffrent week's day booking Member Vs Casual Riders

-- week wise booking from the Member
select week_day,concat(round(count(ride_id)/(select count(*) from `cyclistic_bike_Data.cyclistic_bike_share_v01`
where member_casual = 'member') * 100,2)," ","%") as booking_percentage 
from `cyclistic_bike_Data.cyclistic_bike_share_v01`
where member_casual = 'member'
group by week_day
order by booking_percentage desc;

---week wise booking from  the Casual rider 
select week_day,concat(round(count(ride_id)/(select count(*) from `cyclistic_bike_Data.cyclistic_bike_share_v01` where member_casual = "casual") * 100,2)," ","%") as booking_percentage 
from `cyclistic_bike_Data.cyclistic_bike_share_v01`
where member_casual = 'casual'
group by week_day
order by booking_percentage desc;


-- find different bike's used by Member Vs Casual Rider
-- Casual Riders
select rideable_type,concat(round(count(*)/(select count(rideable_type) from `cyclistic_bike_Data.cyclistic_bike_share_v01` where member_casual="casual")*100,2)," ","%") as num_bike
from `cyclistic_bike_Data.cyclistic_bike_share_v01`
where member_casual= 'casual'
group by rideable_type;
-- Member Riders
select rideable_type,concat(round(count(*)/(select count(rideable_type) from `cyclistic_bike_Data.cyclistic_bike_share_v01` where member_casual="member")*100,2)," ","%") as num_bike
from `cyclistic_bike_Data.cyclistic_bike_share_v01`
where member_casual= 'member'
group by rideable_type;
-- Most frequently vistied station in Members Vs Casual 
-- Casual Riders
select start_station_name,end_station_name,count(*) as num_trip 
from `cyclistic_bike_Data.cyclistic_bike_share_v01`
where start_station_name is not null and end_station_name is not null and  member_casual ='casual'
group by start_station_name,end_station_name
order by num_trip desc;
--Memeber Riders 
select start_station_name,end_station_name,count(*) as num_trip 
from `cyclistic_bike_Data.cyclistic_bike_share_v01`
where start_station_name is not null and end_station_name is not null and  member_casual ='member'
group by start_station_name,end_station_name
order by num_trip desc 
---After finding some key insight Next genrate the visual to share our finding or insights to stake holders(Power Bi)
