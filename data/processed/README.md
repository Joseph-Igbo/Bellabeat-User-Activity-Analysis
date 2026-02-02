# Processed Data
This folder contains the cleaned and processed dataset used in the Bellabeat User Activity Analysis.  

## Files
**daily_activity_clean.csv**  
  - Combined and cleaned dataset covering **2016-03-12 to 2016-05-12**  
  - Columns: `Id`, `ActivityDate`, `TotalSteps`, `Calories`, `VeryActiveMinutes`, `FairlyActiveMinutes`, `LightlyActiveMinutes`, `SedentaryMinutes`, `day_type`  
  - `day_type` indicates whether the date is a **Weekday** or **Weekend**  

## Purpose
The processed dataset is generated from the original raw datasets (sourced from [Kaggle Fitbit Activity Data](https://www.kaggle.com/datasets/arashnic/fitbit)) using the SQL cleaning script (`sql/data_cleaning.sql`).  
It is used directly in the R Markdown analysis for generating insights, plots, and tables.  

## Notes
- This dataset is **ready for analysis** and does not require further cleaning.  
- Maintains consistency and integrity of user activity metrics across both time periods.  
