# 19 · Ranking attrition drivers

**You will learn:** to ask the assistant to **plan the analysis before writing SQL**, to read a query that stacks results with `UNION ALL`, and to use a **goal line** in a Metabase chart.

## The HR question

> "Of all the factors we track (overtime, travel, job level, stock options, satisfaction…), which ones are linked to the highest attrition? Give me one ranked chart, not ten separate ones."

## Why this is harder

Each factor has its own column with its own values. To rank them together you need to compute the attrition rate for **every value of every factor**, stack all the results into **one long list**, and compare each with the company rate. The comparison is called **lift**: lift 2.0 means "twice the company attrition rate".

For bigger analyses like this, ask for a **plan first**. It's much easier to spot a wrong approach in a few lines of English than in 60 lines of SQL.

## Step 1: Ask for a plan

```text
I want to rank attrition drivers. Don't write SQL yet. Propose a plan for a single query that:
- covers these factors: over_time, business_travel, marital_status, job_level,
  stock_option_level, job_satisfaction, environment_satisfaction, work_life_balance,
  job_involvement
- computes, for each value of each factor: headcount, attrition rate, and lift
  (rate divided by the overall attrition rate of the same population)
- leaves out groups with fewer than 30 employees
- returns one row per factor value with a label like "Overtime: Yes", sorted by lift
Explain the plan in plain English, and tell me which SQL features you'll use.
```

Read the plan. Does it compute the overall rate **from the same filtered population** when someone picks a department? If not, say so, and only then ask for the SQL.

## Step 2: Check the answer

- **Overtime: Yes** should have 416 employees. Check with `SELECT COUNT(*) FROM employees WHERE over_time;`.
- For each factor, the headcounts of its values add up to 1,470. Ask the assistant for a check query that proves this for every factor at once.
- The lift of **Overtime: Yes** should be about 30.5 ÷ 16.1 ≈ **1.89**.

## Step 3: Build the chart

1. Visualization → **Row** chart, with the label on the Y-axis and **Lift** as the value.
2. ⚙️ **Display** → turn on **Goal line** at **1** and label it "Company average". Bars past the line are above-average risk.
3. Make sure it's sorted by lift, highest first.
4. Add it to **People analytics → Attrition drivers**.

**Try it:** filter the dashboard to *Sales*. Does the ranking change?

## Check your answers

Top 8 with no department filter:

| Factor value                         | Headcount | Attrition % | Lift |
|--------------------------------------|-----------|-------------|------|
| Job involvement: Low                 | 83        | 33.7        | 2.09 |
| Work-life balance: Bad               | 80        | 31.3        | 1.94 |
| Overtime: Yes                        | 416       | 30.5        | 1.89 |
| Job level: 1                         | 543       | 26.3        | 1.63 |
| Marital status: Single               | 470       | 25.5        | 1.58 |
| Environment satisfaction: Low        | 284       | 25.4        | 1.57 |
| Business travel: Travel_Frequently   | 277       | 24.9        | 1.55 |
| Stock option level: 0                | 631       | 24.4        | 1.51 |

**What the chart doesn't tell you:** these factors overlap. Junior staff are more often single and more often have no stock options. A ranking like this shows *where to look*, not *what causes* attrition. Ask the assistant why, and see if it mentions **confounding**.

<details>
<summary>Reference query</summary>

```sql
WITH base AS (
    SELECT *
    FROM employees
    WHERE {{department}}
),
factors AS (
    SELECT 'Overtime' AS factor, CASE WHEN over_time THEN 'Yes' ELSE 'No' END AS value, attrition FROM base
    UNION ALL SELECT 'Business travel',          business_travel,          attrition FROM base
    UNION ALL SELECT 'Marital status',           marital_status,           attrition FROM base
    UNION ALL SELECT 'Job level',                job_level::text,          attrition FROM base
    UNION ALL SELECT 'Stock option level',       stock_option_level::text, attrition FROM base
    UNION ALL SELECT 'Job satisfaction',         job_satisfaction,         attrition FROM base
    UNION ALL SELECT 'Environment satisfaction', environment_satisfaction, attrition FROM base
    UNION ALL SELECT 'Work-life balance',        work_life_balance,        attrition FROM base
    UNION ALL SELECT 'Job involvement',          job_involvement,          attrition FROM base
),
overall AS (
    SELECT AVG(attrition::int) AS rate FROM base
)
SELECT f.factor || ': ' || f.value                       AS "Factor",
       COUNT(*)                                          AS "Headcount",
       ROUND(100.0 * AVG(f.attrition::int), 1)           AS "Attrition %",
       ROUND(AVG(f.attrition::int) / o.rate, 2)          AS "Lift"
FROM factors f
CROSS JOIN overall o
GROUP BY f.factor, f.value, o.rate
HAVING COUNT(*) >= 30
ORDER BY "Lift" DESC;
```

New pieces:
- `UNION ALL` stacks the results of several `SELECT`s on top of each other. They must have the same columns.
- `attrition::int` turns true/false into 1/0, so `AVG` of it is the attrition rate.
- `job_level::text` turns a number into text so it fits the same column as the text values.
- `CROSS JOIN overall` attaches the single overall-rate row to every row.

</details>
