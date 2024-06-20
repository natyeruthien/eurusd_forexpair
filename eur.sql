/*
Update the date column of the tables eurusd_minute and 
eurusd_news to store only the date part
*/
ALTER TABLE eurusd_minute
ALTER COLUMN date TYPE DATE using date::DATE;

ALTER TABLE eurusd_news
ALTER COLUMN date TYPE DATE using date::DATE;

-- Print the 3 first rows of each table
SELECT * FROM eurusd_hour LIMIT 3;
SELECT * FROM eurusd_minute LIMIT 3;
SELECT * FROM eurusd_news LIMIT 3;

-- Verify that the datatype of date columns is date
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE column_name IN ('date');

SELECT table_name FROM information_schema.tables
WHERE table_schema='public'

/*markdown
### Pre-processing
*/

/*markdown
**Check for duplicates and nulls**
*/

-- Combined query to get the number of duplicate rows, total rows, and null counts in one result
WITH 
-- eurusd_hour table
temp_hour AS (
    SELECT date, time, bo, bh, bl, bc, bch, ao, ah, al, ac, ach
    FROM eurusd_hour
    GROUP BY date, time, bo, bh, bl, bc, bch, ao, ah, al, ac, ach
    HAVING COUNT(*) > 1
), 
duplicates_count_hour AS (
    SELECT COUNT(*) AS number_of_duplicates
    FROM temp_hour
), 
rows_count_hour AS (
    SELECT COUNT(*) AS number_of_rows
    FROM eurusd_hour
),
nulls_count_hour AS (
    SELECT COUNT(*) AS number_of_nulls
    FROM eurusd_hour
    WHERE bo IS NULL OR bh IS NULL OR bl IS NULL OR bc IS NULL OR bch IS NULL
       OR ao IS NULL OR ah IS NULL OR al IS NULL OR ac IS NULL OR ach IS NULL
),
-- eurusd_minute table
temp_minute AS (
    SELECT date, time
    FROM eurusd_minute
    GROUP BY date, time
    HAVING COUNT(*) > 1
),
duplicates_count_minute AS (
    SELECT COUNT(*) AS number_of_duplicates
    FROM temp_minute
),
rows_count_minute AS (
    SELECT COUNT(*) AS number_of_rows
    FROM eurusd_minute
),
nulls_count_minute AS (
    SELECT COUNT(*) AS number_of_nulls
    FROM eurusd_minute
    WHERE bo IS NULL OR bh IS NULL OR bl IS NULL OR bc IS NULL OR bch IS NULL
       OR ao IS NULL OR ah IS NULL OR al IS NULL OR ac IS NULL OR ach IS NULL
),
-- eurusd_news table
temp_news AS (
    SELECT id
    FROM eurusd_news
    GROUP BY id
    HAVING COUNT(*) > 1
),
duplicates_count_news AS (
    SELECT COUNT(*) AS number_of_duplicates
    FROM temp_news
),
rows_count_news AS (
    SELECT COUNT(*) AS number_of_rows
    FROM eurusd_news
),
nulls_count_news AS (
    SELECT COUNT(*) AS number_of_nulls
    FROM eurusd_news
    WHERE id IS NULL OR date IS NULL OR title IS NULL OR article IS NULL
)
-- Show the results from each table
SELECT 
    'eurusd_hour' AS table_name,
    (SELECT number_of_duplicates FROM duplicates_count_hour) AS "number of duplicates",
    (SELECT number_of_rows FROM rows_count_hour) AS "number of rows",
    (SELECT number_of_nulls FROM nulls_count_hour) AS "number of nulls"
UNION ALL
SELECT 
    'eurusd_minute' AS table_name,
    (SELECT number_of_duplicates FROM duplicates_count_minute) AS "number of duplicates",
    (SELECT number_of_rows FROM rows_count_minute) AS "number of rows",
    (SELECT number_of_nulls FROM nulls_count_minute) AS "number of nulls"
UNION ALL
SELECT 
    'eurusd_news' AS table_name,
    (SELECT number_of_duplicates FROM duplicates_count_news) AS "number of duplicates",
    (SELECT number_of_rows FROM rows_count_news) AS "number of rows",
    (SELECT number_of_nulls FROM nulls_count_news) AS "number of nulls";

-- Retrieve the number of distinct dates of each table, the max, and the min
SELECT 
    'eurusd_hour' AS table_name,
    (SELECT COUNT(DISTINCT date) AS "number of distinct dates" FROM eurusd_hour),
    (SELECT MAX(date) AS "maximum date" FROM eurusd_hour),
    (SELECT MIN(date) AS "minimum date" FROM eurusd_hour)
UNION ALL
SELECT
    'eurusd_minute' AS table_name,
    (SELECT COUNT(DISTINCT date) AS "number of distinct dates" FROM eurusd_minute),
    (SELECT MAX(date) AS "maximum date" FROM eurusd_minute),
    (SELECT MIN(date) AS "minimum date" FROM eurusd_minute);




-- Check if we have same dates in both eurusd_hour and eurusd_minute
WITH 
-- eurusd_hour
temp_hour AS (
    SELECT * FROM eurusd_hour
WHERE date NOT IN (
    SELECT DISTINCT date FROM eurusd_minute
)
),
count_dates_hour AS (
    SELECT COUNT(*) AS number_of_dates_hour FROM temp_hour 
),
-- eurusd_minute
temp_minute AS (
    SELECT * FROM eurusd_minute
WHERE date::date NOT IN (
    SELECT DISTINCT date FROM eurusd_hour
)
),
count_dates_minute AS (
    SELECT COUNT(*) AS number_of_dates_minute FROM temp_minute 
)
-- Show the results from each table
SELECT 
    'eurusd_hour' AS table_name,
    (SELECT number_of_dates_hour FROM count_dates_hour) AS "number of extra dates"
UNION ALL
SELECT 
    'eurusd_minute' AS table_name,
    (SELECT number_of_dates_minute FROM count_dates_minute) AS "number of extra dates"



-- Check for gaps in eurusd_hour and eurusd_minute tables
WITH all_dates_hour AS (
    SELECT date::date
    FROM generate_series(
        (SELECT MIN(date) FROM eurusd_hour),
        (SELECT MAX(date) FROM eurusd_hour),
        '1 day'::interval
    ) AS date
),
missing_dates_hour AS (
    SELECT date
    FROM all_dates_hour
    WHERE date NOT IN (SELECT DISTINCT date FROM eurusd_hour)
),
check_gaps_hour AS (
    SELECT
        CASE
            WHEN COUNT(*) = 0 THEN 'false'
            ELSE 'true'
        END AS gaps_in_hour
    FROM missing_dates_hour
),
all_dates_minute AS (
    SELECT date::date
    FROM generate_series(
        (SELECT MIN(date) FROM eurusd_minute),
        (SELECT MAX(date) FROM eurusd_minute),
        '1 day'::interval
    ) AS date
),
missing_dates_minute AS (
    SELECT date
    FROM all_dates_minute
    WHERE date NOT IN (SELECT DISTINCT date FROM eurusd_minute)
),
check_gaps_minute AS (
    SELECT
        CASE
            WHEN COUNT(*) = 0 THEN 'false'
            ELSE 'true'
        END AS gaps_in_minute
    FROM missing_dates_minute
)
-- Combine results
SELECT 
    'eurusd_hour' AS table_name,
    gaps_in_hour AS gaps_present
FROM check_gaps_hour
UNION ALL
SELECT 
    'eurusd_minute' AS table_name,
    gaps_in_minute AS gaps_present
FROM check_gaps_minute;





