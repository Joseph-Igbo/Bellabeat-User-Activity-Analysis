# Raw Data
This folder contains the original unmodified CSV files used in the Bellabeat User Activity Analysis.
These datasets were sourced from Fitbit user activity tracking and cover two periods:

## Files 
1. **daily_activity_raw.csv**
   - Covers 2016-03-12 to 2016-04-11
   - Contains Id, ActivityDate, TotalSteps, Calories, VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, Sedentary Minutes.
2. **daily_steps_raw.csv, daily_calories_raw, daily_intensities_raw.csv**
   - Covers 2016-04-12 to 2016-05-12
   - Steps, calories, and intensity metrics are split across these tables.

## Purpose
These raw datasets are inputs to the SQL cleaning script (`sql/data_cleaning.sql`), which produces the cleaned dataet used for analysis (`data/processed/daily_activity_clean.csv`).
**Do not modify these files**; they serve as the baseline data for reproducible analysis.

## Source 
- Raw data sourced from [FitBit Fitness Tracker Data](https://www.kaggle.com/datasets/arashnic/fitbit)
- Used as-is for this project; no modifications were made to the original files.
