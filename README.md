Healthcare Claims & Cost Analytics

Project Overview

I developed this project to analyse healthcare claims, understand the key drivers of medical and pharmacy expenses, identify claim denials, and explore member-level healthcare utilisation. The project combines SQL, Excel, and Power BI to turn raw healthcare data into useful business insights.

The main objective was to look beyond basic reporting and answer practical questions that a healthcare payer or revenue-cycle team may ask, such as:

- How much are we spending on healthcare claims?
- Which claim types and provider specialties contribute most to paid amounts?
- What are the most common reasons for claim denials?
- Which member groups have higher healthcare costs?
- How do pharmacy expenses vary by therapeutic class?
- Are there members or medication classes with low adherence?

Business Problem

Healthcare organisations handle large volumes of medical and pharmacy claims. Without structured analysis, it can be difficult to monitor financial performance, understand denial patterns, identify high-cost areas, and track medication adherence.

I used the available datasets to build a reporting solution that brings these areas together and helps users explore the data through SQL analysis, Excel reporting, and interactive Power BI dashboards.

Dataset Description

The project uses five CSV files:

| Dataset | Description |
|---|---|
| `medical_claims.csv` | Medical claim details, service dates, claim type, provider information, billed/allowed/paid amounts, member cost-sharing, claim status, and denial details. |
| `members.csv` | Member demographics, payer and plan information, income band, risk score, and enrollment dates. |
| `providers.csv` | Provider identifiers, provider type, specialty, taxonomy, state, and network status. |
| `pharmacy_claims.csv` | Prescription claim details, drug information, therapeutic class, days supply, ingredient cost, dispensing fee, and plan/member payments. |
| `adherence.csv` | Medication adherence measures, including proportion of days covered (PDC), medication possession ratio (MPR), fill count, and days supply. |

I check data types, missing values, duplicate records, and key-field consistency before using them in calculations. Any findings should be interpreted in the context of the supplied dataset and its definitions.

Tools & Technologies

- PostgreSQL / pgAdmin – data loading, querying, joins, aggregations, CTEs, and window functions.
- Microsoft Excel – data review, PivotTables, Power Pivot, relationships, and summary reporting.
- Power BI Desktop – Power Query transformations, data modelling, DAX measures, and interactive dashboards.
- GitHub – project documentation and version control.

Project Workflow

1. Data Preparation

I reviewed the five source files and prepared them for analysis. The preparation process included:

- Checking row counts, column names, data types, and data quality.
- Converting date fields into valid date formats.
- Reviewing missing values and duplicate identifiers.
- Checking that member and provider keys could be used consistently across datasets.
- Keeping medical and pharmacy claim facts separate to avoid double-counting when combining data.

2. SQL Analysis

I used PostgreSQL to practise and apply SQL concepts to business questions. The analysis includes:

- `SELECT`, `WHERE`, `ORDER BY`, and `DISTINCT`
- Aggregate functions and `GROUP BY`
- `CASE` expressions and conditional calculations
- Joins between claims, members, and providers
- Common Table Expressions (CTEs)
- Subqueries
- Window functions such as `ROW_NUMBER`, `RANK`, and `SUM() OVER`
- Running totals and time-based analysis

Example business questions explored in SQL:

- Which claim types have the highest total paid amount?
- Which denial reasons occur most frequently?
- Which providers have higher denial percentages?
- Which member groups have higher healthcare costs?
- How do paid amounts change over time?
- Which therapeutic classes have higher pharmacy expenses?

3. Excel Analysis

I used Excel to review the data and create summary reports using:

- PivotTables and PivotCharts
- Power Pivot data model and table relationships

The Excel analysis covers medical claim expenses, denied claims, member costs, pharmacy expenses, and medication adherence.

4. Power BI Dashboard

I designed the Power BI report as a set of focused pages so that users can move from an overall view to more detailed analysis.

Page 1 – Executive Overview

Provides a high-level view of claim volume and financial performance.

Suggested KPIs and visuals:
- Total Claims
- Total Billed Amount
- Total Allowed Amount
- Total Paid Amount
- Denial Rate
- Average Paid per Claim
- Monthly paid amount trend
- Claim status distribution
- Paid amount by claim type
- Top denial reasons

Page 2 – Denial Analytics

Focuses on denial volume, denial reasons, and potential revenue-cycle improvement areas.

Suggested KPIs and visuals:
- Denied Claims
- Denial Rate
- Denied Billed Amount
- Denials by reason and denial code
- Monthly denial trend
- Denial percentage by provider
- Denials by claim type and network status

Page 3 – Member & Provider Analytics

Explores differences in healthcare utilisation and spending across member and provider groups.

Suggested visuals:
- Paid amount by age band
- Claims by payer type and plan type
- Average paid amount by member group
- Paid amount by provider specialty
- High-cost member analysis
- Healthcare cost compared with member risk score

Page 4 – Pharmacy & Adherence

Examines prescription spending and medication adherence patterns.

Suggested KPIs and visuals:
- Prescription Claims
- Total Pharmacy Paid
- Average PDC
- Average MPR
- Pharmacy expenses by therapeutic class
- Adherence by therapeutic class
- Pharmacy type and formulary tier analysis

Data Model

I use a dimensional modelling approach with shared dimensions and separate fact tables.

Core tables:
- `Members`
- `Providers`
- `MedicalClaims`
- `PharmacyClaims`
- `Adherence`
- `DimDate`

Key relationship approach:
- `Members[member_id]` → `MedicalClaims[member_id]`
- `Members[member_id]` → `PharmacyClaims[member_id]`
- `Members[member_id]` → `Adherence[member_id]`
- `Providers[provider_npi]` → `MedicalClaims[rendering_npi]`
- `DimDate[Date]` → `MedicalClaims[service_date_from]`

For pharmacy time analysis, I use a separate pharmacy date table or an appropriate date relationship to `PharmacyClaims[fill_date]`. I avoid directly joining fact tables to one another because that can multiply rows and inflate totals.

Key Measures

The following are examples of the core Power BI measures used in the report. Column names should match the imported model.

```DAX
Total Claims =
DISTINCTCOUNT(MedicalClaims[claim_id])

Total Billed Amount =
SUM(MedicalClaims[billed_amount])

Total Allowed Amount =
SUM(MedicalClaims[allowed_amount])

Total Paid Amount =
SUM(MedicalClaims[paid_amount])

Average Paid per Claim =
DIVIDE([Total Paid Amount], [Total Claims], 0)

Denied Claims =
CALCULATE(
    [Total Claims],
    MedicalClaims[claim_status] = "Denied"
)

Denial Rate =
DIVIDE([Denied Claims], [Total Claims], 0)

Denied Billed Amount =
CALCULATE(
    [Total Billed Amount],
    MedicalClaims[claim_status] = "Denied"
)

Total Pharmacy Paid =
SUM(PharmacyClaims[plan_paid])

Prescription Claims =
DISTINCTCOUNT(PharmacyClaims[rx_claim_id])

Average PDC =
AVERAGE(Adherence[pdc])

Average MPR =
AVERAGE(Adherence[mpr])
```

Initial Business Observations

During my initial review, I focused on three areas:

1. Claim type and financial impact: I compared Institutional Inpatient, Institutional Outpatient, and Professional claims to understand which category contributes more to healthcare spending. The comparison should be based on total paid amount and, where useful, average paid amount per claim.
2. Denial reasons: I reviewed denial codes and descriptions. Missing authorisation appeared as an important denial reason in my initial analysis, making it a potential area for revenue-cycle process improvement.
3. Provider denial performance: I compared denial percentages across providers to identify where further investigation may be useful. Provider comparisons should include claim volume, since a high percentage based on a small number of claims can be misleading.

These are dataset-specific observations, not conclusions about every healthcare organisation. I validate the figures and filters in the final report before presenting them as confirmed findings.

## How to Use the Project

1. Download or clone this repository.
2. Import the CSV files into PostgreSQL or Power BI.
3. Review and clean the data types, especially date and numeric columns.
4. Run the SQL analysis scripts in PostgreSQL.
5. Open the Excel workbook to review PivotTables and the Power Pivot model.
6. Open the Power BI `.pbix` file, refresh the data, and use the slicers to explore the report.

Repository Structure

 text

healthcare-claims-analytics/
│
├── data/
│   ├── medical_claims.csv
│   ├── members.csv
│   ├── providers.csv
│   ├── pharmacy_claims.csv
│   └── adherence.csv
│
├── sql/
│   ├── data_validation.sql
│   ├── claims_analysis.sql
│   ├── denial_analysis.sql
│   ├── member_cost_analysis.sql
│   └── pharmacy_analysis.sql
│
├── excel/
│   └── healthcare_claims_analysis.xlsx
│
├── powerbi/
│   └── healthcare_claims_dashboard.pbix
│
└── README.md


The folder and file names above are a suggested structure; I will update them to match the actual files included in the repository.

## Skills Demonstrated

- SQL querying and analytical problem-solving
- Data cleaning and transformation
- Relational data modelling
- Excel PivotTables and Power Pivot
- Power BI dashboard design
- DAX measures and KPI development
- Healthcare claims and denial analysis
- Pharmacy cost and medication adherence analysis
- Translating data into business questions and insights

Conclusion

This project gave me an opportunity to work through a healthcare analytics use case from raw data preparation to business reporting. I used SQL to investigate the data, Excel to build analytical summaries, and Power BI to present the results in an interactive format.

My focus was not only on creating charts, but also on understanding what the numbers mean for claim costs, denials, providers, members, and pharmacy performance.

---

Create By: Shubham Vahile  
Project: Healthcare Claims & Cost Analytics  
Tools: PostgreSQL, Excel, Power BI, GitHub
