# Air Quality Analysis (2019-2023)

**A comprehensive data engineering project demonstrating systematic data cleaning, statistical analysis, and methodical documentation of a complex analytical workflow.**

---

## 🎯 Project Overview

Analysis of global air quality data spanning 616 cities across 95 countries, demonstrating systematic data engineering from raw CSV imports through statistical transformation to final visualization-ready datasets.

**Key Achievement:** Transformed 24 variables of incomplete, messy air quality data into statistically normalized, WHO-guideline-referenced analysis using weighted rolling averages and composite scoring.

---

## 📊 Dataset

- **Source:** [World Air Quality Index COVID-19 Dataset](https://aqicn.org/data-platform/covid19/)
- **Temporal Coverage:** Q1 2019 - Q2 2023
- **Geographic Coverage:** 616 cities, 95 countries
- **Variables:** 9 pollutants + 15 weather metrics
- **Volume:** Multi-year daily measurements with city-level aggregation

---

## 🔬 Methodology Highlights

### Data Engineering
- **Completeness Threshold:** Only cities with ≥75% data coverage retained
- **Missing Data:** Linear interpolation for gaps ≤8 days
- **Quality Control:** Multi-stage validation removing erroneous measurements, duplicates, and insufficient sample sizes

### Statistical Approach
- **Weighted 30-day Rolling Averages:** Accounts for data completeness in temporal smoothing
- **Z-Score Normalization:** Both city-specific and dataset-wide for multi-scale analysis
- **Composite Magnitude Scoring:** Balances pollution exceedance frequency and amplitude

### WHO Guideline Integration
- Automated flagging of days exceeding WHO air quality thresholds
- Magnitude scoring quantifies severity of guideline violations
- Both acute (single-day) and chronic (sustained) pollution patterns identified

---

## 💡 What This Demonstrates

**Systems Thinking in Data Engineering:**
- Layered approach to data quality (sampling → completeness → outlier detection)
- Decision-making documented with external research backing (EPA standards, WHO guidelines)
- Methodology designed for reproducibility and transparency

**Technical Capabilities:**
- PostgreSQL for data transformation and aggregation
- Python/Pandas for interpolation and exploratory analysis
- Matplotlib/Seaborn for quality visualization
- Jupyter notebooks for process documentation
- SQL query organization for multi-stage pipeline

**Problem-Solving Approach:**
- Identified Q1 2022 data gap, adapted methodology to split analysis periods
- Discovered misplaced wind variables, systematically verified and corrected
- Used statistical methods (Z-scores) to identify remaining outliers after cleaning

---

## 📁 Repository Structure

```
├── 01_data/                      # Raw and generated data
│   ├── 01_raw_data/              # Original CSV files
│   ├── 02_generated_from_SQL/    # Query outputs
│   └── 04_support_data/          # WHO guidelines, reference data
├── 02_SQL_queries/               # All transformation queries
│   ├── 01_data_exploration/      # Initial data profiling
│   ├── 02_data_cleaning/         # Quality control queries
│   ├── 03_data_transformation/   # Statistical calculations
│   └── 04_data_visualization/    # Final export queries
├── 03_python/                    # Scripts and notebooks
│   ├── 01_portable_scripts/      # Reusable utilities
│   └── 02_jupyter_notebooks/     # Analysis documentation
├── images/                       # Documentation images
├── docs/                         # PDF references (EPA standards)
├── README.md                     # This file
└── DOCUMENTATION.md              # Complete technical walkthrough
```

---

## 📖 Documentation

**[→ View Complete Technical Documentation](./DOCUMENTATION.md)**

The documentation provides:
- Step-by-step methodology with rationale
- All SQL queries with explanations
- Data quality decision-making process
- Statistical transformations and formulas
- Jupyter notebook links for reproducible analysis
- Visual diagrams of workflow and data structure

---

## 🛠️ Technologies Used

**Data Storage & Transformation:**
- PostgreSQL (materialized views, CTEs, window functions)

**Analysis & Visualization:**
- Python 3.x
- Pandas (data manipulation, interpolation)
- Matplotlib & Seaborn (exploratory visualization)
- Jupyter Notebooks (analysis documentation)
- Tableau (final visualizations)

**Database Interaction:**
- psycopg2 (Python-PostgreSQL connector)
- Batch CSV loading scripts

---

## 🎓 Key Learnings

**Data Quality > Data Quantity:**
The 75% completeness threshold and 18-sample minimum meant losing cities, but ensured statistical validity of remaining analysis.

**Weighted Approaches Handle Reality:**
Simple rolling averages ignore data gaps. Weighting by completeness score produces more accurate temporal smoothing.

**Documentation = Future Efficiency:**
Comprehensive notes on why decisions were made (backed by EPA/WHO standards) makes methodology defensible and adaptable.

**Outlier Detection Requires Domain Knowledge:**
Z-scores flagged high pollution readings, but research into forest fires validated them as real events, not data errors. Statistics + context = good judgment.

---

## 📈 Results & Insights

- Identified cities with chronic WHO guideline violations using magnitude scoring
- Quantified relationship between weather patterns and pollution levels
- Documented data quality issues in global air monitoring networks
- Created analysis-ready dataset for visualization in Tableau

*For detailed findings and visualizations, see the [complete documentation](./DOCUMENTATION.md).*

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🔗 Connect

This project demonstrates capabilities in:
- Data engineering and pipeline design
- Statistical analysis and methodology
- Documentation and knowledge transfer
- Problem-solving with incomplete data

**View other projects:** [GitHub Profile](https://github.com/illtellyouwhat)

---

*This analysis was conducted independently using publicly available air quality data. Methodology adheres to EPA sampling standards and WHO pollution guidelines.*
