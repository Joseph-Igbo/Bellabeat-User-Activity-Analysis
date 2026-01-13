-- File: data_cleaning.sql
-- Author: Joseph Igbo
-- Purpose: Clean and unify daily activity data for Bellabeat analysis
-- Environment: DuckDB (Portable, local CSV-based)

-- Step 0: Load raw CSVs as DuckDB tables
CREATE OR REPLACE TABLE daily_activity_raw AS
SELECT * FROM read_csv_auto('data/raw/daily_activity_raw.csv');

CREATE OR REPLACE TABLE daily_steps_raw AS
SELECT * FROM read_csv_auto('data/raw/daily_steps_raw.csv');

CREATE OR REPLACE TABLE daily_calories_raw AS
SELECT * FROM read_csv_auto('data/raw/daily_calories_raw.csv');

CREATE OR REPLACE TABLE daily_intensities_raw AS
SELECT * FROM read_csv_auto('data/raw/daily_intensities_raw.csv');

-- Step 1: Segment 1 (up to 2016-04-11) - Removing negatives and NULLs
segment1 AS (
  SELECT
    Id,
    DATE(ActivityDate) AS ActivityDate,
    TotalSteps,
    Calories,
    VeryActiveMinutes,
    FairlyActiveMinutes,
    LightlyActiveMinutes,
    SedentaryMinutes
  FROM daily_activity_raw
  WHERE ActivityDate <= '2016-04-11'
    AND TotalSteps >= 0
    AND Calories > 0
    AND Id IS NOT NULL
    AND ActivityDate IS NOT NULL
    AND VeryActiveMinutes IS NOT NULL
    AND FairlyActiveMinutes IS NOT NULL
    AND LightlyActiveMinutes IS NOT NULL
    AND SedentaryMinutes IS NOT NULL
),

-- Step 2: Segment 2 (2016-04-12 to 2016-05-12) - Join steps, calories, and intensities
segment2 AS (
  SELECT
    s.Id,
    DATE(s.ActivityDay) AS ActivityDate,
    s.StepTotal AS TotalSteps,
    c.Calories,
    i.VeryActiveMinutes,
    i.FairlyActiveMinutes,
    i.LightlyActiveMinutes,
    i.SedentaryMinutes
  FROM daily_steps_raw s
  LEFT JOIN daily_calories_raw c
    ON s.Id = c.Id AND s.ActivityDay = c.ActivityDay
  LEFT JOIN daily_intensities_raw i
    ON s.Id = i.Id AND s.ActivityDay = i.ActivityDay
  WHERE s.ActivityDay >= '2016-04-12'
    AND s.StepTotal >= 0
    AND c.Calories > 0
    AND s.Id IS NOT NULL
    AND s.ActivityDay IS NOT NULL
    AND i.VeryActiveMinutes IS NOT NULL
    AND i.FairlyActiveMinutes IS NOT NULL
    AND i.LightlyActiveMinutes IS NOT NULL
    AND i.SedentaryMinutes IS NOT NULL
),

-- Step 3: Combining segments
combined AS (
  SELECT * FROM segment1
  UNION ALL
  SELECT * FROM segment2
),

-- Step 4: Removing duplicates (Id + ActivityDate)
deduplicated AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY Id, ActivityDate ORDER BY ActivityDate) AS row_num
  FROM combined
),

-- Step 5: Add weekday/weekend classification
final AS (
  SELECT
    Id,
    ActivityDate,
    TotalSteps,
    Calories,
    VeryActiveMinutes,
    FairlyActiveMinutes,
    LightlyActiveMinutes,
    SedentaryMinutes,
    CASE
      WHEN EXTRACT(DAYOFWEEK FROM ActivityDate) IN (1,7) THEN 'Weekend'
      ELSE 'Weekday'
    END AS day_type
  FROM deduplicated
  WHERE row_num = 1
)

-- Step 6: Export cleaned data for R analysis
SELECT *
INTO 'data/processed/daily_activity_clean.csv'
FROM final;
