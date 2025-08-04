Excel Data Cleaning – Step-by-Step Documentation

Software Used:
- Microsoft Excel

Dataset:
- Customer_demographics_and_sales_Lab5.xlsx (Modified sample dataset by IBM)

Overview:
This dataset contains fictitious customer demographic and sales data. Several cleaning techniques were applied to improve data quality, consistency, and usability for future analysis.

---

1. Spelling Correction
   - Ran spell check on the 'CREDITCARD_TYPE' column to identify typographical errors.
   - Corrected spelling suggestions manually through Excel's spell checker.
   - Skipped intentionally lowercase value "jcb" to preserve its consistency for further replacement.

2. Removing Empty Rows
   - Used filters on the 'CUST_NAME' column to isolate rows where the customer name was missing.
   - Deleted all identified blank rows to ensure completeness of records.
   - Cleared filters afterward to return to the full dataset view.

3. Removing Duplicate Records
   - Applied conditional formatting on the 'ORDER_ID' column to visually identify duplicate order entries.
   - Used the "Remove Duplicates" feature with all columns selected to ensure only fully identical rows were removed.
   - Confirmed that headers were recognized during this process to avoid incorrect deletions.

4. Standardizing Text Case
   - Used the `PROPER` function to convert all header text and data fields from uppercase to proper case (e.g., “ALLEN PERL” → “Allen Perl”).
   - Converted individual columns to UPPER and lower case where appropriate using `UPPER()` and `LOWER()` functions.
   - Replaced formulas with values to preserve results and then removed helper columns.

5. Standardizing Date Formats
   - Selected the 'Order_Ship_Date' column and applied a consistent long-date format (e.g., Wednesday, March 14, 2012).
   - Locale settings were adjusted to English (United States) to ensure format consistency across users.

6. Trimming Extra Whitespace
   - Used Find & Replace to locate and reduce double spaces throughout the dataset.
   - This ensured that entries were clean and didn’t contain formatting issues that could affect filtering or analysis.

7. Parsing and Restructuring Text Fields
   - Used string functions (`LEFT`, `RIGHT`, `SEARCH`, `LEN`) to split full customer names into first and last name columns.
   - This transformation allowed for more granular sorting, filtering, and personalization in potential reporting scenarios.
   - Also demonstrated Excel’s Flash Fill feature to auto-detect patterns and restructure names into a unified format (e.g., prefix + name).

---

Outcome:
The dataset is now cleaned, standardized, and ready for analysis, visualization, or import into other tools. All transformations were performed using Excel functions and built-in features, without external add-ons or scripting.
