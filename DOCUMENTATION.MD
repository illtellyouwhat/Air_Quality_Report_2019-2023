# Air Quality Analysis Documentation (2019-2023)

**Comprehensive technical walkthrough of data engineering, cleaning, and analysis methodology**

---

## Table of Contents
- [TLDR](#tldr)
- [Preparation](#preparation)
  - [Metadata](#metadata)
  - [Supporting Documentation](#supporting-documentation)
  - [Workflow](#workflow)
- [Process](#process)
  - [Initial Setup](#initial-setup)
  - [Data Exploration (1)](#data-exploration-1)
  - [Cleaning](#cleaning)
  - [Interpolation](#interpolation)
- [Analysis](#analysis)
  - [Calculated Fields](#calculated-fields)
  - [WHO Guidelines](#who-guidelines)
  - [Data Exploration (2)](#data-exploration-2)
- [Visualization](#python-script-for-web-app-visualization)
  - [Queries Used for Visualization](#queries-used-for-visualization)

---

# TLDR

- Dataset downloaded from: https://aqicn.org/data-platform/covid19/ as CSV
- Research was done to find what relevant sampling and external measures were to be used in analysis
- Data was loaded into a PostgreSQL database locally
- Python used to interact with database and Matplotlib was used in a Jupyter Notebook environment to visualize data integrity
- Fixed misplaced data and dropped unusable data
- Only cities/years with 75% complete data were used
- Rolling averages were weighted on the basis of complete data
- Statistical columns (Z_score, Composite index) were made for use in further data exploration
- Subsequent data exploration with statistical columns used to further identify unusable data
- Converted SQL queries to JSON file for use in web app visualization

---

# PREPARATION

## Metadata

- Data downloaded from: https://aqicn.org/data-platform/covid19/
  - Dates span 2015-2023
  - Countries: 95
  - Cities: 616
  - Variables: 24 (9 pollutants, 15 weather)

<details>
<summary><strong>📋 Metadata from website</strong></summary>

**The data for each major cities is based on the average (median) of several stations. The data set provides min, max, median and standard deviation for each of the air pollutant species (PM2.5, PM10, Ozone ...) as well as meteorological data (Wind, Temperature, ...).**

- All air pollutant species are converted to the US EPA standard (i.e. no raw concentrations). All dates are UTC based.
- The count column is the number of samples used for calculating the median and standard deviation.
- The city-median value is computed per day using all AQI values for available stations

</details>

<details>
<summary><strong>📊 Table Schema</strong></summary>

![AQI Table Schema](/images/00_initial_setup_table_aqi_schema.png)

</details>

## Supporting Documentation

<details>
<summary><strong>📏 Benchmark for Minimum Sampling</strong></summary>

From [Perplexity](/images/Perplexity.png):

![Minimum Sampling Requirements](/images/Min_Sampling.png)

[EPA Document Referenced](/docs/EPA_min_sampling_doc.pdf)

</details>

<details>
<summary><strong>✅ Benchmark for Complete Data</strong></summary>

From [Chat GPT](/images/Chat_GPT.png):

![Minimum Completeness Requirements](/images/MIn_Completeness.png)

[EPA Document Referenced](/docs/EPA_min_completeness_doc.pdf)

</details>

<details>
<summary><strong>🌍 WHO Pollution Guidelines</strong></summary>

From https://www.who.int/news-room/feature-stories/detail/what-are-the-who-air-quality-guidelines

![WHO Pollutant Guidelines](/images/WHO_pollutants_guidlines.png)

</details>

<details>
<summary><strong>📐 Units of Measurement for Variables</strong></summary>

**Pollutants:**

![Pollutant Units of Measure](/images/pollutant%20units%20of%20measure.png)

**Weather:**

![Weather Units of Measurement](/images/weather%20units%20of%20measurement.png)

</details>

<details>
<summary><strong>🌡️ Maximum Weather Measurements (from ChatGPT)</strong></summary>

### 1. Dew Point ("dew")
- **Maximum Value**: Around **35°C (95°F)**
- **Reason**: Dew point represents the temperature at which air becomes saturated with moisture. High values occur in very humid tropical conditions.

### 2. Humidity
- **Maximum Value**: **100%**
- **Reason**: Humidity is the measure of water vapor saturation in the air, and 100% represents fully saturated air (e.g., during fog, rain, or extremely humid conditions).

### 3. Precipitation
- **Maximum Value**:
  - **Daily Total**: Around **2,500 mm (98.4 inches)**
  - **Reason**: Record daily precipitation events (e.g., tropical cyclones, monsoons) have produced these totals, such as in tropical regions.
  - **Hourly Intensity**: Up to **300 mm (11.8 inches)**

### 4. Temperature
- **Maximum Value**: Around **56.7°C (134°F)**
- **Reason**: The hottest recorded temperature on Earth was measured in Death Valley, USA. Slightly higher values may occur under extreme artificial or isolated conditions.

### 5. Wind Direction ("wd")
- **Maximum Value**: **360 degrees**
- **Reason**: Wind direction is measured as an azimuthal angle from 0° to 360°, with 360° representing north.

### 6. Wind Gust
- **Maximum Value**: Around **400 km/h (250 mph)**
- **Reason**: The strongest wind gusts ever recorded are from tornadoes or extreme cyclones. Examples include the 407 km/h gust during Cyclone Olivia (1996).

### 7. Wind Speed
- **Maximum Value**: Around **300 km/h (186 mph)**
- **Reason**: Sustained wind speeds typically peak during strong tropical cyclones. Higher gusts are possible but are short-lived.

</details>

## Workflow

**Files used in repository follow this structure:**

![File Structure](/images/00_workflow_file_structure.png)

**Process workflow:**
- SQL queries loaded into pandas dataframes via psycopg2 for exploration
- Seaborn and Matplotlib used to visualize explorations
- Jupyter notebooks used to document process
- Created web app for final visualizations

![Workflow Diagram](/images/00_workflow_workflow.png)

---

# PROCESS

## Initial Setup

**Setup new database named PM25 in PostgreSQL with table named 'aqi'**

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/0_table_creation/01_aqi_CREATE_TABLE.sql" target="_blank">01_aqi_CREATE_TABLE</a></summary>

Creates the initial PostgreSQL table structure for loading raw CSV data.

</details>

**Uploaded CSV files to database from command line using:**

<details>
<summary><strong>View Python Script:</strong> <a href="./03_python/01_portable_scripts/02_Batch_upload_CSV.py" target="_blank">02_Batch_upload_CSV</a></summary>

Python script for batch uploading CSV files to PostgreSQL database.

</details>

**'aqi' table schema:**

![AQI Table Schema](/images/00_initial_setup_table_aqi_schema.png)

## Data Exploration (1)

Loaded initial SQL queries into pandas DataFrames and created scatter plots and heat maps to visualize data distribution.

**SQL queries used:**

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/01_data_exploration/03_aqi_date_count_YM.sql" target="_blank">03_aqi_date_count_YM</a></summary>

Counts data entries by year and month to identify temporal coverage.

</details>

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/01_data_exploration/04_aqi_date_count_YMD.sql" target="_blank">04_aqi_date_count_YMD</a></summary>

Counts data entries by year, month, and day for detailed temporal analysis.

</details>

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/01_data_exploration/05_aqi_variable_count_YM.sql" target="_blank">05_aqi_variable_count_YM</a></summary>

Counts variable coverage by year and month.

</details>

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/01_data_exploration/06_aqi_variable_count_YMD.sql" target="_blank">06_aqi_variable_count_YMD</a></summary>

Counts variable coverage by year, month, and day for granular analysis.

</details>

**Jupyter Notebook:**

[📓 Data Exploration Notebook (Part 1)](./03_python/02_jupyter_notebooks/07_aqi_data_exploration_1.ipynb)

### Insights

#### ⤵️ Missing Data: 2015-2018

Data from 2015-2018 found to be too sparse. Analysis limited to 2019-2023.

![Date Count Heatmap](/images/01_data_exploration_1_date_count.png)

#### ⤵️ Q1 2022 Missing

All countries missing Q1 2022 data. Subsequent queries and interpolation account for this gap.

![Variable Count Heatmap](/images/01_data_exploration_1_variable_count.png)

---

## Cleaning

### Misplaced Data

**Identified data recorded in wrong columns:**

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/02_data_cleaning/08_aqi_misplaced_find.sql" target="_blank">08_aqi_misplaced_find</a></summary>

Identifies data recorded in incorrect columns.

</details>

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/02_data_cleaning/09_aqi_misplaced_UPDATE.sql" target="_blank">09_aqi_misplaced_UPDATE</a></summary>

Moves misplaced data to correct columns.

</details>

### Minimum Sampling Requirements

**Applied EPA minimum sampling thresholds:**

Only months meeting the minimum daily sample count threshold were retained.

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/02_data_cleaning/10_aqi_min_samples_CREATE_VIEW.sql" target="_blank">10_aqi_min_samples_CREATE_VIEW</a></summary>

Creates view filtering to months meeting EPA minimum sampling requirements.

</details>

### Completeness Threshold

**Applied 75% completeness requirement per city/year:**

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/02_data_cleaning/11_aqi_completeness_YM_CREATE_VIEW.sql" target="_blank">11_aqi_completeness_YM_CREATE_VIEW</a></summary>

Calculates monthly completeness percentage per city.

</details>

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/02_data_cleaning/12_aqi_completeness_Y_CREATE_VIEW.sql" target="_blank">12_aqi_completeness_Y_CREATE_VIEW</a></summary>

Calculates annual completeness percentage per city.

</details>

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/02_data_cleaning/13_aqi_completeness_Y_pm25_CREATE_VIEW.sql" target="_blank">13_aqi_completeness_Y_pm25_CREATE_VIEW</a></summary>

Filters to cities meeting 75% annual completeness for PM2.5.

</details>

**Jupyter Notebook:**

[📓 Completeness Analysis Notebook](./03_python/02_jupyter_notebooks/14_aqi_completeness_analysis.ipynb)

### City/Year Selection

**Identified cities with sufficient data across 2019-2023:**

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/02_data_cleaning/15_aqi_cities_2019-22_pm25_CREATE_VIEW.sql" target="_blank">15_aqi_cities_2019-22_pm25_CREATE_VIEW</a></summary>

Identifies cities with complete data for 2019-2022.

</details>

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/02_data_cleaning/16_aqi_cities_2022-23_pm25_CREATE_VIEW.sql" target="_blank">16_aqi_cities_2022-23_pm25_CREATE_VIEW</a></summary>

Identifies cities with complete data for 2022-2023.

</details>

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/02_data_cleaning/17_aqi_cities_counts_CSV.sql" target="_blank">17_aqi_cities_counts_CSV</a></summary>

Exports city counts for external validation.

</details>

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/02_data_cleaning/18_aqi_2019-22_cities_CSV.sql" target="_blank">18_aqi_2019-22_cities_CSV</a></summary>

Exports 2019-2022 city list to CSV.

</details>

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/02_data_cleaning/19_aqi_2022-23_cities_CSV.sql" target="_blank">19_aqi_2022-23_cities_CSV</a></summary>

Exports 2022-2023 city list to CSV.

</details>

**Jupyter Notebook:**

[📓 City Selection Notebook](./03_python/02_jupyter_notebooks/20_aqi_city_selection.ipynb)

### Additional Cleaning

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/02_data_cleaning/21_aqi_negative_values_UPDATE.sql" target="_blank">21_aqi_negative_values_UPDATE</a></summary>

Nulls negative pollutant readings (physically impossible values).

</details>

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/02_data_cleaning/22_aqi_zero_values_UPDATE.sql" target="_blank">22_aqi_zero_values_UPDATE</a></summary>

Evaluates and handles zero-value readings.

</details>

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/02_data_cleaning/23_aqi_spikes_find.sql" target="_blank">23_aqi_spikes_find</a></summary>

Identifies anomalous spikes for manual review.

</details>

Two tables are created from the CSV output of the above queries and their intersection is used to create a new table of the cleaned data from 2019-2023:

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/0_table_creation/24_cities_2019-22__2022-23_CREATE_TABLE.sql" target="_blank">24_cities_2019-22__2022-23_CREATE_TABLE</a></summary>

Creates table from cities with complete data.

</details>

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/0_table_creation/25_aqi_cleaned_CREATE_TABLE.sql" target="_blank">25_aqi_cleaned_CREATE_TABLE</a></summary>

Creates final cleaned table.

</details>

## Interpolation

**Loaded contents of aqi_cleaned into pandas DataFrame:**

Used linear interpolation method to fill in only 8 days or less worth of missing data.

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/03_data_transformation/26_aqi_cleaned_ALL.sql" target="_blank">26_aqi_cleaned_ALL</a></summary>

Selects all data from cleaned table for interpolation.

</details>

**Jupyter Notebook:**

[📓 Interpolation Notebook](./03_python/02_jupyter_notebooks/25_aqi_2019-23_interpolate.ipynb)

**Data loaded back into aqi_cleaned after backup:**

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/03_data_transformation/27_aqi_cleaned_BACKUP_TABLE.sql" target="_blank">27_aqi_cleaned_BACKUP_TABLE</a></summary>

Creates backup before reloading interpolated data.

</details>

---

# ANALYSIS

## Calculated Fields

**Standard deviation column (SD) added for easier Z-score calculations:**

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/03_data_transformation/29_aqi_cleaned_sd_MATERIALIZED_VIEW.sql" target="_blank">29_aqi_cleaned_sd_MATERIALIZED_VIEW</a></summary>

Creates materialized view with standard deviation calculations.

</details>

**Completeness score calculated:**

Percentage of complete data for each variable by month over all years. This will be used to weight the 30 day rolling average for accuracy.

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/03_data_transformation/30_aqi_cleaned_weights_MATERIALIZED_VIEW.sql" target="_blank">30_aqi_cleaned_weights_MATERIALIZED_VIEW</a></summary>

Calculates completeness weights for rolling average.

</details>

**30-day weighted rolling average applied:**

![Weighted Rolling Average Formula](/images/WRA%20formula.png)

*This is the sum of (ε) the reading for the variable (x) multiplied by the completeness score (w) divided by the sum of the completeness score for 30 days (i)*

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/03_data_transformation/31_aqi_sd_ra_MATERIALIZED_VIEW.sql" target="_blank">31_aqi_sd_ra_MATERIALIZED_VIEW</a></summary>

Applies weighted 30-day rolling average to all variables.

</details>

**Z-scores calculated for normalization:**

By city and entire dataset. Two scores were made for overall analysis and city-specific to avoid losing finer-grained data to averaging.

![Z-Score Formula](/images/Z_score%20formual.png)

*This is the reading for the variable (x) minus the average of the 30-day rolling average (μ) divided by the standard deviation of μ (σ)*

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/03_data_transformation/32_aqi_sd_ra_z_MATERIALIZED_VIEW.sql" target="_blank">32_aqi_sd_ra_z_MATERIALIZED_VIEW</a></summary>

Calculates Z-scores for both city-level and dataset-level normalization.

</details>

## WHO Guidelines

**Table created detailing WHO pollution guidelines:**

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/0_table_creation/33_who_guidlines_CREATE_TABLE.sql" target="_blank">33_who_guidlines_CREATE_TABLE</a></summary>

Creates table with WHO guideline thresholds for each pollutant.

</details>

**Table joined to main table to tally days exceeding WHO guidelines:**

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/03_data_transformation/34_aqi_sd_ra_z_who_MATERIALIZED_VIEW.sql" target="_blank">34_aqi_sd_ra_z_who_MATERIALIZED_VIEW</a></summary>

Joins WHO guidelines and flags exceedances.

</details>

**Magnitude score calculated:**

Scales how "bad" the pollution is for a given data point. Both frequency and amplitude of occurrence are considered equally important (the amount the pollutant exceeds is as important as how many days it exceeds).

*This accounts for the fact that 10 days where pollution exceeds the limit by 1-2 points is not as bad as one day where it is 100 points in exceedance.*

![Magnitude Score Formula](/images/magnitude%20score%20formula.png)

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/03_data_transformation/35_aqi_sd_ra_z_who_magnitude_MATERIALIZED_VIEW.sql" target="_blank">35_aqi_sd_ra_z_who_magnitude_MATERIALIZED_VIEW</a></summary>

Calculates composite magnitude score for pollution severity.

</details>

## Data Exploration (2)

**Final data integrity check using Z-scores and magnitude scores:**

Looking at outliers to identify any remaining incorrectly gathered data before creating final analysis queries.

**Drop unused views/tables:**

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/03_data_transformation/37_final_tables_DROP_unused.sql" target="_blank">37_final_tables_DROP_unused</a></summary>

Cleans up intermediate tables and views.

</details>

**Create final combined view:**

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/03_data_transformation/38_final_tables_combined_MATERIALIZED_VIEW.sql" target="_blank">38_final_tables_combined_MATERIALIZED_VIEW</a></summary>

Creates final materialized view joining all calculated fields.

</details>

**Load into DataFrame and visualize with KDE charts:**

30-day rolling average, Z-scores (city & all), and magnitude scores plotted with each pollutant variable as a facet. KDE was chosen over histogram for readability.

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/01_data_exploration/39_aqi_full_report_find_outliers_pollutants.sql" target="_blank">39_aqi_full_report_find_outliers_pollutants</a></summary>

Query for extracting data for outlier visualization.

</details>

**Jupyter Notebook:**

[📓 Data Exploration Notebook (Part 2)](./03_python/02_jupyter_notebooks/40_aqi_full_report_data_exploration_2.ipynb)

### Insights

#### ⤵️ Outliers

**Chart shows sizable discrepancies in data clustering for Z-score and magnitude.**

Data examined at values above:
- 140 in the 30_day_rolling_avg
- 6 in z_score_all
- 4 in z_score_city
- 150 in magnitude_score

![Pollutant Data Exploration](/images/Data_Exploration_2_pollutant.png)

**Scatterplot created between magnitude score and Z-scores to identify abnormalities:**

![Pollution Outliers Analysis](/images/Pollution_outliers.png)

**For magnitude_score > 300:**

31 rows found. A high reading of 879 was recorded and repeated from interpolation as the likely cause. Further research indicated several forest and urban fires could validate such a high reading. Only the subsequent interpolated rows dropped (San Luis Potosi PM10 for 2022-08-21 - 28).

![Magnitude Score > 300](/images/magnitude_GT_300.png)

**For magnitude_score between 160-200 and z_score > 20(all)/4(city):**

No discernable discrepancies identified.

**Weather variable analysis:**

> ⚠️ **Note:** Since magnitude_score is irrelevant to weather variables and 'pressure' has different scaling, only z_scores were used to identify outliers.

![Weather Data Exploration](/images/Data_Exploration_2_weather.png)

**For weather variables with z_score > 2.5:**

Over 10k rows returned. These were matched against known maximum recordings (see [maximum weather measurements](#supporting-documentation)) and subsequently dropped.

<details>
<summary><strong>View SQL:</strong> <a href="./02_SQL_queries/02_data_cleaning/42_aqi_full_report_DELETE_weather_outliers.sql" target="_blank">42_aqi_full_report_DELETE_weather_outliers</a></summary>

Removes weather outliers based on validated thresholds.

</details>

---

## Python Script for Web App Visualization

Created Python scripts in Jupyter notebook to extract all aggregated data into a static JSON file for the interactive web app visualization.

[📓 JSON Export Notebook](https://github.com/illtellyouwhat/Air_Quality_Report_2019-2023/blob/main/03_python/02_jupyter_notebooks/43_aqi_full_report_xtract_json_for_viz.ipynb)

The script aggregates country, city, region, and world-level outputs into `aqi_data.json`, which is committed to the `docs/` folder and served statically via GitHub Pages. Region and world rollups are computed in Python from the query outputs below — no additional SQL is used for those aggregations.

### Queries Used for Visualization

<details>
<summary><strong>View SQL:</strong> Countries and Years</summary>

Returns distinct country/year combinations for PM2.5. Used to populate the `meta.countries` and `meta.years` fields in `aqi_data.json`.

```sql
SELECT DISTINCT country, EXTRACT(YEAR FROM date)::int AS year
FROM aqi_full_report
WHERE variable = 'pm25'
ORDER BY country, year
```

</details>

<details>
<summary><strong>View SQL:</strong> Country-Level Pollutant Exceedance Overview</summary>

Average exceedance rate per pollutant per year at the country level. Note: months where exceedance was zero are stored as null in source data and are excluded from averages — functionally equivalent given exceedance rates are well above zero across this dataset.

```sql
SELECT
    country,
    EXTRACT(YEAR FROM date)::int AS year,
    variable,
    AVG(monthly_percent_exceeded)::float AS avg_pct
FROM aqi_full_report
WHERE variable = ANY(%s)
  AND monthly_percent_exceeded IS NOT NULL
GROUP BY country, year, variable
ORDER BY country, year, variable
```

</details>

<details>
<summary><strong>View SQL:</strong> City-Level Pollutant Exceedance Overview</summary>

Average exceedance rate per pollutant per year at the city level. O3 excluded — `over_who_limit` flag was not computed for O3 in source data.

```sql
SELECT
    country,
    city,
    EXTRACT(YEAR FROM date)::int AS year,
    variable,
    AVG(monthly_percent_exceeded)::float AS avg_pct
FROM aqi_full_report
WHERE variable = ANY(%s)
  AND monthly_percent_exceeded IS NOT NULL
  AND over_who_limit IS NOT NULL
GROUP BY country, city, year, variable
ORDER BY country, city, year, variable
```

</details>

<details>
<summary><strong>View SQL:</strong> Country-Level Monthly PM2.5 Time Series</summary>

Monthly PM2.5 30-day rolling average by country. Q1 2022 forced to null in Python after fetch — completeness below 75% EPA threshold.

```sql
SELECT
    country,
    EXTRACT(YEAR FROM date)::int  AS year,
    EXTRACT(MONTH FROM date)::int AS month,
    AVG("30_day_rolling_avg")::float AS avg_rolling
FROM aqi_full_report
WHERE variable = 'pm25'
  AND "30_day_rolling_avg" IS NOT NULL
  AND "30_day_rolling_avg" > 0
GROUP BY country, year, month
ORDER BY country, year, month
```

</details>

<details>
<summary><strong>View SQL:</strong> Country-Level Annual PM2.5 Summary</summary>

Annual PM2.5 average, magnitude score, and percent of days exceeding WHO limit by country. Used to populate left-panel summary cards.

```sql
SELECT
    country,
    EXTRACT(YEAR FROM date)::int AS year,
    AVG("30_day_rolling_avg")::float    AS annual_avg,
    AVG(magnitude_score)::float          AS avg_magnitude,
    AVG(CASE WHEN over_who_limit = 1
             THEN 1.0 ELSE 0.0 END)::float AS pct_days_exceeded
FROM aqi_full_report
WHERE variable = 'pm25'
  AND "30_day_rolling_avg" IS NOT NULL
  AND "30_day_rolling_avg" > 0
GROUP BY country, year
ORDER BY country, year
```

</details>

<details>
<summary><strong>View SQL:</strong> City-Level Annual PM2.5 Summary</summary>

Annual PM2.5 average and magnitude score by city. Used to populate city-level summary cards when a city is selected.

```sql
SELECT
    country,
    city,
    EXTRACT(YEAR FROM date)::int AS year,
    AVG("30_day_rolling_avg")::float AS annual_avg,
    AVG(magnitude_score)::float      AS avg_magnitude
FROM aqi_full_report
WHERE variable = 'pm25'
  AND "30_day_rolling_avg" IS NOT NULL
  AND "30_day_rolling_avg" > 0
GROUP BY country, city, year
ORDER BY country, city, year
```

</details>

<details>
<summary><strong>View SQL:</strong> City-Level Monthly PM2.5 Time Series</summary>

Monthly PM2.5 30-day rolling average by city. Q1 2022 forced to null in Python after fetch — same completeness rule as country-level.

```sql
SELECT
    country,
    city,
    EXTRACT(YEAR FROM date)::int  AS year,
    EXTRACT(MONTH FROM date)::int AS month,
    AVG("30_day_rolling_avg")::float AS avg_rolling
FROM aqi_full_report
WHERE variable = 'pm25'
  AND "30_day_rolling_avg" IS NOT NULL
  AND "30_day_rolling_avg" > 0
GROUP BY country, city, year, month
ORDER BY country, city, year, month
```

</details>

---

**📊 For final visualizations and analysis results, see the project README.**
