-- analysing sleep data: how people nap during the day
-- Assuming that a nap is any time someone sleeps but goes to sleep and wakes up on the same day

DECLARE
 MORNING_START, MORNING_END, AFTERNOON_END, EVENING_END INT64;
 -- Set the times for the times of the day
SET
 MORNING_START = 6;
SET
 MORNING_END = 12;
SET
 AFTERNOON_END = 18;
SET
 EVENING_END = 22;

 
SELECT -- this table aggregates data by id and sleep date
  Id,
  DATE(sleep_start) AS sleep_date,
  CASE 
      WHEN time_nap BETWEEN TIME(MORNING_START, 0, 0) AND TIME(MORNING_END, 0, 0) THEN "Morning"
      WHEN time_nap BETWEEN TIME(MORNING_END,0, 0) AND TIME(AFTERNOON_END, 0, 0) THEN "Afternoon"
      WHEN time_nap BETWEEN TIME(AFTERNOON_END, 0, 0) AND TIME(EVENING_END, 0, 0) THEN "Evening"
      WHEN time_nap >= TIME(EVENING_END, 0, 0) OR time_nap <= TIME(MORNING_START, 0, 0) THEN "Night"
    ELSE "ERROR" END AS nap_start_period,
  COUNT(logId) AS number_naps,
  SUM(EXTRACT(HOUR FROM time_sleeping)) AS total_time_sleeping_hours
FROM 
    ( -- this table aggregates data by id and logid

      SELECT
        Id,
        logId,
        MIN(DATE(CAST(date AS DATETIME))) AS sleep_start,
        MAX(DATE(CAST(date AS DATETIME))) AS sleep_end,
        MIN(TIME(CAST(date AS DATETIME))) AS time_nap,
        TIME(TIMESTAMP_DIFF(MAX(CAST(date AS DATETIME)),MIN(CAST(date AS DATETIME)),HOUR),
            MOD(TIMESTAMP_DIFF(MAX(CAST(date AS DATETIME)),MIN(CAST(date AS DATETIME)),MINUTE),60),
            MOD(MOD(TIMESTAMP_DIFF(MAX(CAST(date AS DATETIME)),MIN(CAST(date AS DATETIME)),SECOND),3600),60) ) AS time_sleeping
      FROM
        `minuteSleep`
      WHERE
        value=1 -- corresponds to being in light sleep state 
      GROUP BY
        1,
        2
    )
WHERE
  sleep_start=sleep_end -- criteria to consider a sleep session as nap
GROUP BY
  1,
  2,
  3
ORDER BY
  2,3,4,
  CASE 
  WHEN nap_start_period = "Morning" THEN 0
  WHEN nap_start_period = "Afternoon" THEN 1
  WHEN nap_start_period = "Evening" THEN 2
  WHEN nap_start_period = "Night" THEN 3
  END 

 


