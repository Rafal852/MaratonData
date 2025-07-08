SELECT * 
FROM Marathon.dbo.clean_ff_race_100_output


--How many states are in the race
SELECT Count(Distinct State) as distinct_count
FROM Marathon.dbo.clean_ff_race_100_output

-- Average time of Men vs Women
SELECT Gender, AVG(TotalMinutes) as avg_time
FROM Marathon.dbo.clean_ff_race_100_output
GROUP BY Gender

-- Youngest and oldest ages in the race
SELECT Gender, Min(age) as youngest, Max(age) as oldest
FROM Marathon.dbo.clean_ff_race_100_output
GROUP BY gender

-- Average time for each age group
WITH age_buckets as(
SELECT TotalMinutes, 
		case when age < 30 then 'age_18-29'
			 when age < 40 then 'age_30-39'
			 when age < 50 then 'age_40-49'
			 when age < 60 then 'age_50-59'
		else 'age_60+' end as age_group
FROM Marathon.dbo.clean_ff_race_100_output
)
SELECT age_group, AVG(TotalMinutes) avg_race_time 
FROM age_buckets
GROUP BY age_group

--Top 3 males and females
WITH gender_rank as(
SELECT rank() over (partition by Gender order by TotalMinutes asc) as gender_rank,
FullName,
Gender, 
TotalMinutes
FROM Marathon.dbo.clean_ff_race_100_output
)
SELECT *
FROM gender_rank
WHERE gender_rank < 4
ORDER BY TotalMinutes