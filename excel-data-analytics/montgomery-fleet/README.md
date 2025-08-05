# Montgomery Fleet Equipment Inventory – Excel Data Cleaning & Analysis

## Project Overview

This project demonstrates essential data cleaning and analysis techniques using **Microsoft Excel for the Web (Microsoft 365)**. The workflow simulates the responsibilities of a Junior Data Analyst preparing a municipal fleet inventory dataset for reporting and decision-making.

The original data, modeled on public records from Montgomery County, Maryland, was provided in CSV format and underwent structured cleaning, formatting, and summarization through pivot tables.

---

## Tools and Data Source

- **Tool Used:** Microsoft Excel for the Web (Microsoft 365)
- **Data Source:** [Montgomery County Open Data Portal – Fleet Equipment Inventory](https://data.montgomerycountymd.gov/Government/Fleet-Equipment-Inventory/93vc-wpdr)  
  *(Note: All data in this project has been fictionalized or anonymized for demonstration purposes.)*

---

## Project Files

- `rawdata_montgomery_fleet_equipment_inventory.csv` – Original raw dataset
- `part1_montgomery_fleet_equipment_inventory.xlsx` – Cleaned and prepped data
- `cleaned_montgomery_fleet_equipment_inventory.xlsx` – Final cleaned dataset
- `part2_montgomery_fleet_equipment_inventory.xlsx` – Pivot tables and summary analysis
- `project_documentation.txt` – Step-by-step documentation of all tasks

---

## Part 1: Data Cleaning

### 1. File Format Conversion
- Opened `.csv` file in Excel for the Web
- Converted to `.xlsx` format using Excel's **Convert** function

### 2. Column Adjustments
- Applied **AutoFit** to columns to display full content

### 3. Data Quality Fixes
- **Removed Empty Rows:** Used filters to detect and delete
- **Removed Duplicates:** Applied Excel's **Remove Duplicates** feature with headers preserved
- **Corrected Spelling & Text Inconsistencies:**
  - Ran spell check
  - Manually reviewed department-specific terms and abbreviations
  - Cleaned up extra spaces using **Find & Replace**

### 4. Department Name Reconstruction
- Merged split department names using **Flash Fill**
- Verified accuracy against an official list
- Removed redundant or fragmented columns

---

## Part 2: Data Analysis with Pivot Tables

### 1. Table Formatting
- Converted cleaned dataset to an Excel **Table** for structured referencing

### 2. Summary Statistics (Using AutoSum)
- `SUM`: Total fleet count
- `AVERAGE`: Mean equipment count per record
- `MIN` / `MAX`: Range of equipment counts
- `COUNT`: Total number of records

### 3. Pivot Table 1 – Equipment by Department
- Rows: `Department`
- Values: `Equipment Count` (Summed)
- Sorted by descending equipment total

### 4. Pivot Table 2 – Equipment Class under Department
- Rows: `Department > Equipment Class`
- Used collapse/expand to focus view on `Transportation` department

### 5. Pivot Table 3 – Department under Equipment Class
- Rows: `Equipment Class > Department`
- Collapsed all items except `CUV` class for detailed focus

---

## Conclusion

This project highlights key data preparation and summarization steps used in real-world analysis tasks. From raw CSV import to structured insights via pivot tables, all steps were completed using Excel for the Web. The result is a clean, organized view of a municipal fleet that can support reporting, auditing, or decision-making.

---

## License

This project is for educational and demonstration purposes only. The data is fictionalized and not representative of actual county records.
