# E-Commerce Sales Analysis with SQL

**Author:** Isaac Olufemi Adewumi  
**Tools:** PostgreSQL, SQL, pgAdmin  
**Project type:** Data exploration and business performance analysis

## Project Overview

This project demonstrates how SQL can be used to explore transactional sales data and turn it into business-focused insights. The analysis is designed around a retail or e-commerce dataset containing orders, products, customers, dates, quantities, prices, and sales amounts.

The project will use SQL queries to assess sales performance, product contribution, customer purchasing patterns, and trends over time. Findings will be documented after the dataset and query outputs are added.

## Business Questions

- What are total sales and order volumes over the period covered by the dataset?
- Which products or product categories contribute the most revenue?
- How does sales performance vary by month or other available time period?
- Which customers or customer segments account for the largest share of sales?
- What patterns, anomalies, or opportunities are visible in the data?

## Tools and Techniques

- PostgreSQL for querying and analysis
- pgAdmin for database management and query execution
- Filtering, sorting, aggregation, and grouping
- Joins across related tables, where applicable
- Common Table Expressions (CTEs) and subqueries, where useful
- Date-based analysis and window functions, where supported by the data
- Data-quality checks for missing, duplicated, or inconsistent records

## Planned Workflow

1. Inspect the dataset and understand its structure.
2. Load the data into PostgreSQL and check table relationships.
3. Assess data quality and document any cleaning decisions.
4. Write SQL queries to answer the business questions.
5. Validate calculations and review the query outputs.
6. Summarise evidence-based findings and recommendations.

## Repository Structure

```text
SQL-Projects/
├── README.md
├── data/                 # Add the dataset or a source/download note
├── sql/
│   ├── 01_data_quality.sql
│   ├── 02_sales_overview.sql
│   ├── 03_product_analysis.sql
│   └── 04_trend_and_customer_analysis.sql
└── results/              # Add exported query results or screenshots
```

## Deliverables

- SQL scripts organised by analysis task
- Data-quality checks
- Query outputs or screenshots
- A concise summary of findings and practical recommendations

## Results and Limitations

Results will be added after the dataset is loaded and the queries are executed. No sales figures or conclusions are claimed in this README before the analysis is completed. The scope of the final analysis will depend on the fields and quality of the selected dataset.

## How to Use

1. Review the dataset documentation and source.
2. Create or select a PostgreSQL database.
3. Import the data and adjust table or column names in the scripts as needed.
4. Run the SQL scripts in sequence.
5. Compare the outputs with the documented questions and record the findings.

## Author

**Isaac Olufemi Adewumi** — Data Analytics Educator, Trainer and Consultant.

[Portfolio](https://sites.google.com/view/isaacolufemiadewumi/home)
