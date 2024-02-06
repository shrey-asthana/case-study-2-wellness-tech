-- using information schema to find details about tables in database 
-- it is a standardized schema (collection of database objects) that provides access to metadata about the database itself.

-- looking up the column names of columns table in information schema
SELECT 
  * 
FROM 
  `case-studies-408613.case_study_2_wellness_tech.INFORMATION_SCHEMA.COLUMNS`;

-- identifying the common column in tables

SELECT
 column_name,
 COUNT(table_name) as table_count
FROM
 `case-studies-408613.case_study_2_wellness_tech.INFORMATION_SCHEMA.COLUMNS`
GROUP BY
 1;

-- Id column is common across all tables

-- confirming that Id is in every table
SELECT
 table_name,
 SUM(
     CASE WHEN column_name = "Id" THEN 1 ELSE 0
     END
    ) AS has_id_column
FROM
 `case-studies-408613.case_study_2_wellness_tech.INFORMATION_SCHEMA.COLUMNS`
GROUP BY
 1
ORDER BY
 1 ASC;

-- query below checks to make sure that each table has a column of a date or time related type
-- expected output:- the table should be empty
SELECT
 table_name,
 SUM(CASE
     WHEN data_type IN ("TIMESTAMP", "DATETIME", "TIME", "DATE") THEN 1 ELSE 0
     END) AS has_time_info
FROM
  `case-studies-408613.case_study_2_wellness_tech.INFORMATION_SCHEMA.COLUMNS`
WHERE
 data_type IN ("TIMESTAMP",
               "DATETIME",
               "DATE")
GROUP BY
 1
HAVING
 has_time_info = 0; -- this clause filters for those tables which do not have date time info

-- the resultant table is empty, hence every table has date time info


-- idenifying column names in each table with date-time information 
SELECT
 CONCAT(table_catalog,".",table_schema,".",table_name) AS table_path,
 table_name,
 column_name
FROM
 `case-studies-408613.case_study_2_wellness_tech.INFORMATION_SCHEMA.COLUMNS`
WHERE
 data_type IN ("TIMESTAMP",
   "DATETIME",
   "DATE");






