# 22 · Building an engagement index

**You will learn:** to **agree on a metric definition with the assistant before any SQL**, to use the numeric-code table, and to show a KPI as a **Gauge**.

## The HR question

> "We have five separate survey scores. Leadership wants one engagement number, a target range, and proof that it actually relates to attrition."

## Why this is harder

There's no single correct engagement index. Someone has to **decide** what goes into it and how it's scaled. If you leave that to the assistant, it will make silent choices that you then report as fact. So this time you write the definition first, as a short **metric glossary entry**, and the SQL follows from it.

## Step 1: Agree on the definition

```text
I want to define an "Engagement index". Before writing SQL, discuss with me:
- which of these to include: environment_satisfaction, job_satisfaction,
  relationship_satisfaction, job_involvement, work_life_balance (all scored 1-4)
- whether to weight them equally
- how to rescale the total to 0-100
- sensible bands (e.g. Disengaged / Neutral / Engaged)
Then write a short glossary entry (name, definition, formula, bands) I can put on the dashboard.
```

Push back where you disagree. That's your HR expertise at work. For this exercise, settle on:

- **Raw score** = sum of the 5 scores → ranges 5–20.
- **Engagement index** = (raw score − 5) ÷ 15 × 100 → 0–100.
- **Bands** on the raw score: Disengaged 5–11, Neutral 12–14, Engaged 15–20.

## Step 2: Ask for the queries

```text
Using that definition and the employee_attrition table (numeric 1-4 codes), give me three queries:
1. Headcount and attrition rate for each raw score from 5 to 20.
2. Headcount and attrition rate per band.
3. A single number: the average engagement index (0-100), 1 decimal.
Use a department field filter on employee_attrition.
```

> **Note:** these queries read from `employee_attrition`, so in Metabase map the field filter to **Employee Attrition → Department**, not Employees.

## Step 3: Check the answer

- Pick one employee and calculate their score by hand:
  ```sql
  SELECT environment_satisfaction, job_satisfaction, relationship_satisfaction,
         job_involvement, work_life_balance
  FROM employee_attrition WHERE employee_number = 1;
  ```
  Add the five numbers yourself and compare with what the assistant's query gives for employee 1.
- The band headcounts add up to 1,470.

## Step 4: Visualize

1. **Score vs. attrition:** query 1 as a **Combo**, with headcount as bars and attrition % as a line on the right axis.
2. **Bands:** query 2 as a **Bar** chart of attrition % per band.
3. **Gauge:** query 3 → Visualization **Gauge**. In ⚙️, set the range 0–100 and colour segments: 0–40 red, 40–60 yellow, 60–100 green.
4. Add a **Text** card with your glossary entry from Step 1 next to the gauge. A KPI without a definition will be misread.
5. Put all of it on a new **Engagement** tab in **People analytics**.

## Check your answers

| Band                | Headcount | Attrition % |
|---------------------|-----------|-------------|
| Disengaged (5-11)   | 226       | 31.9        |
| Neutral (12-14)     | 715       | 15.4        |
| Engaged (15-20)     | 529       | 10.4        |

- Average engagement index: **57.7** overall. Human Resources 58.9, R&D 57.6, Sales 57.6.
- By raw score: the most common scores are 13–15. At the extremes (scores 6, 7, 19, 20) there are only 1–5 people, so the line jumps around there. That's noise, not a finding.

**What it says:** disengaged employees leave at **3×** the rate of engaged ones, so the index is worth tracking. On the other hand, departments barely differ on the average. A flat chart is a finding too, and it's better to report "no difference" than to over-read 58.9 vs 57.6.

<details>
<summary>Reference queries</summary>

```sql
-- 1. Attrition by raw score
WITH scored AS (
    SELECT attrition,
           environment_satisfaction + job_satisfaction + relationship_satisfaction
           + job_involvement + work_life_balance AS raw_score
    FROM employee_attrition
    WHERE {{department}}
)
SELECT raw_score                               AS "Engagement score (5-20)",
       COUNT(*)                                AS "Headcount",
       ROUND(100.0 * AVG(attrition::int), 1)   AS "Attrition %"
FROM scored
GROUP BY raw_score
ORDER BY raw_score;

-- 2. Attrition by band
WITH scored AS (
    SELECT attrition,
           environment_satisfaction + job_satisfaction + relationship_satisfaction
           + job_involvement + work_life_balance AS raw_score
    FROM employee_attrition
    WHERE {{department}}
)
SELECT CASE
           WHEN raw_score <= 11 THEN 'Disengaged (5-11)'
           WHEN raw_score <= 14 THEN 'Neutral (12-14)'
           ELSE 'Engaged (15-20)'
       END                                     AS "Engagement band",
       COUNT(*)                                AS "Headcount",
       ROUND(100.0 * AVG(attrition::int), 1)   AS "Attrition %"
FROM scored
GROUP BY 1
ORDER BY MIN(raw_score);

-- 3. Engagement index (0-100)
SELECT ROUND(AVG((environment_satisfaction + job_satisfaction + relationship_satisfaction
                  + job_involvement + work_life_balance - 5) / 15.0 * 100), 1) AS "Engagement index"
FROM employee_attrition
WHERE {{department}};
```

</details>
