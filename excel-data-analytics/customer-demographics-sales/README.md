# Excel Data Cleaning – Customer Demographics & Sales

## Project Overview

This project demonstrates data cleaning techniques applied to a customer demographics and sales dataset using **Microsoft Excel**. The dataset, a modified version of a sample provided by IBM, contains fictional customer and transaction records. The goal was to enhance data quality, consistency, and structure to prepare it for future analysis or import into other tools.

---

## Tools

- **Software:** Microsoft Excel (Desktop or Web)
- **Source Dataset:** Modified sample from IBM

---

## Project Files

- `customer_demographics_and_sales_data.csv` – Raw dataset
- `cleaned_customer_data.csv` – Final cleaned version

---

## Key Data Cleaning Techniques

### 1. Spelling Corrections
- Ran Excel’s spell checker on the `CREDITCARD_TYPE` column.
- Manually corrected misspelled values.
- Skipped known lowercase abbreviation `"jcb"` to preserve consistency for future transformations.

### 2. Removing Empty Rows
- Applied filters on the `CUST_NAME` column to isolate blank entries.
- Deleted all rows with missing customer names to ensure data completeness.

### 3. Removing Duplicates
- Highlighted potential duplicates in the `ORDER_ID` column using conditional formatting.
- Used **Remove Duplicates** with all columns selected to eliminate fully duplicate records.
- Ensured that header rows were preserved during this process.

### 4. Text Standardization
- Applied `PROPER()`, `UPPER()`, and `LOWER()` functions to standardize text case across key columns.
- Replaced formulas with static values after transformation.
- Removed helper columns post-conversion to maintain a clean structure.

### 5. Date Format Standardization
- Applied a consistent long-date format to the `Order_Ship_Date` column (e.g., Wednesday, March 14, 2012).
- Adjusted locale settings to **English (United States)** for consistency.

### 6. Whitespace Cleanup
- Used **Find & Replace** to remove excess spaces and ensure uniform text entries.

### 7. Parsing and Restructuring Fields
- Split full customer names into `First Name` and `Last Name` using `LEFT()`, `RIGHT()`, `SEARCH()`, and `LEN()` functions.
- Used **Flash Fill** to auto-detect and apply formatting patterns to name columns and other structured fields.
- Enabled easier sorting, filtering, and personalization in future reporting.

---

## Outcome

The dataset is now fully cleaned, standardized, and ready for use in data analysis, dashboards, or business intelligence tools. All transformations were completed using built-in Excel formulas and features—no third-party tools or scripting was required.

---

## License

This project is for educational and demonstration purposes only. The dataset has been anonymized and is not representative of real customer information.
