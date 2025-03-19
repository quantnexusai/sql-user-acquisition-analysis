# SQL User Acquisition Analysis

A comprehensive SQL toolkit for analyzing marketing campaigns and user acquisition data. This project demonstrates various SQL techniques for deriving insights from user acquisition data.

## Project Overview

This repository contains SQL queries designed to analyze user acquisition performance, campaign effectiveness, and ROI. It demonstrates advanced SQL concepts including:

- Common Table Expressions (CTEs)
- Window functions
- Cohort analysis
- Join techniques
- Aggregation and grouping
- Conditional logic

## Database Structure

The analysis is based on three main tables:

1. **campaigns** - Information about marketing campaigns
2. **user_acquisitions** - Records of user acquisition events and their sources
3. **user_activities** - User actions like signups and purchases

## Analysis Capabilities

The SQL queries in this project can help answer questions such as:

- Which marketing channels deliver the best ROI?
- What is the average time from user acquisition to purchase?
- How do conversion rates vary by campaign?
- Which acquisition sources lead to the highest customer lifetime value?
- How do different user cohorts perform over time?

## Setup Instructions

1. Create a database in your preferred SQL engine (PostgreSQL recommended)
2. Run the `data/sample_data.sql` script to create and populate the sample tables
3. Execute the queries in `sql/campaign_analysis.sql` to see the analysis results

## Example Results

Check the `results/example_output.md` file for sample outputs from each analysis query.

## Customization

These queries can be adapted to work with your own user acquisition data by:

1. Modifying the table structures to match your schema
2. Adjusting the join conditions based on your data relationships
3. Changing the time periods or grouping criteria to suit your business cycle

## License

This project is available under the MIT License - see the LICENSE file for details.
