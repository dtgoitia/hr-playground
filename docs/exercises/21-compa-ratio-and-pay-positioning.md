# 21 · Compa-ratio: where does each person sit in their pay range?

**You will learn:** to **fix errors with the assistant** by pasting the exact error message back, plus two new chart types: a **histogram** shown as a combo chart, and a **scatter plot**.

## The HR question

> "How is each employee paid compared with peers in the same role and level? Are people below the midpoint more likely to leave? And does pay keep growing with experience for everyone?"

## Why this is harder

**Compa-ratio** is a standard compensation metric:

```
compa-ratio = employee's pay ÷ midpoint of their pay range
```

1.00 means "paid exactly at the midpoint", 0.85 means "15% below". This dataset has no official pay ranges, so you'll use the **median pay of the same job role and job level** as the midpoint. That needs a summary per role and level (26 combinations), joined back to every employee, which is the pattern from exercise 14, one step further.

## Step 1: Ask the assistant

```text
Compute a compa-ratio for every employee: monthly_income divided by the MEDIAN monthly_income
of all employees with the same job_role AND job_level (calculate the medians on the whole company,
not on the filtered department). Then group employees into compa-ratio bands:
'< 0.80', '0.80-0.89', '0.90-1.09', '1.10-1.19', '1.20+'
and show per band: headcount and attrition rate. Sort the bands from low to high.
The department field filter should only filter which employees are counted.
```

### When it fails

Assistant-written SQL often fails on the first run, usually on Metabase's field filter or a data-type detail. Don't fix it yourself and don't start over. **Copy the exact red error message from Metabase** and paste it back:

```text
Metabase gives this error: <paste the error here>
```

Common ones:
- *missing FROM-clause entry for table "employees"*: an alias on the table where the field filter is (see rule 4).
- *function round(double precision, integer) does not exist*: the median is a floating-point number. It needs `::numeric` before `ROUND`.

## Step 2: Check the answer

- Employee **1** is a Sales Executive, level 2, earning 5,993. Check the midpoint for that group yourself:
  ```sql
  SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY monthly_income)
  FROM employees WHERE job_role = 'Sales Executive' AND job_level = 2;
  ```
  → **5,454**, so employee 1's compa-ratio is 5,993 ÷ 5,454 ≈ **1.10**.
- The band headcounts must add up to 1,470.

## Step 3: Histogram + attrition line

1. Visualization → **Combo**: headcount as **bars**, attrition % as a **line** on the **right axis**.
2. This is a **histogram**: it shows how employees are spread across the pay range, with the risk line on top.

## Step 4: Scatter plot: experience vs. pay

Ask the assistant for a second query:

```text
For a scatter plot: one row per employee with total_working_years, and monthly_income
split into two columns, "Stayed" (income if attrition is false, otherwise NULL)
and "Left" (income if attrition is true, otherwise NULL).
```

Splitting into two columns is a trick that makes Metabase draw two colours of dots.

1. Visualization → **Scatter**. X-axis = total working years. Y-axis = both *Stayed* and *Left*.
2. Pick contrasting colours. Do the "Left" dots cluster in a particular area?

Add both charts to **People analytics → Pay**.

## Check your answers

| Compa-ratio band | Headcount | Attrition % |
|------------------|-----------|-------------|
| < 0.80           | 185       | 21.6        |
| 0.80-0.89        | 237       | 19.4        |
| 0.90-1.09        | 633       | 14.2        |
| 1.10-1.19        | 171       | 12.9        |
| 1.20+            | 244       | 16.0        |

**What it says:** attrition falls as people move up towards and past the midpoint, but rises again at 1.20+. Ask the assistant for possible reasons, then test them. Ask it for a query that splits the 1.20+ band by job level. You'll find that 133 of its 244 people are **level 1** juniors, whose attrition is high whatever they're paid. That's a mix effect again (exercise 20), not "being paid too much makes people leave".

The scatter plot shows the "Left" dots concentrated at **low experience and low pay**. 35% of leavers had at most 5 years' experience and earned under 4,000, compared with 14% of those who stayed.

<details>
<summary>Reference queries</summary>

```sql
-- Compa-ratio bands
WITH midpoints AS (
    SELECT job_role, job_level,
           PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY monthly_income) AS midpoint
    FROM employees
    GROUP BY job_role, job_level
),
population AS (
    SELECT *
    FROM employees
    WHERE {{department}}
),
compa AS (
    SELECT p.employee_number, p.attrition,
           p.monthly_income / m.midpoint AS compa_ratio
    FROM population p
    JOIN midpoints m ON m.job_role = p.job_role AND m.job_level = p.job_level
)
SELECT CASE
           WHEN compa_ratio < 0.8 THEN '< 0.80'
           WHEN compa_ratio < 0.9 THEN '0.80-0.89'
           WHEN compa_ratio < 1.1 THEN '0.90-1.09'
           WHEN compa_ratio < 1.2 THEN '1.10-1.19'
           ELSE '1.20+'
       END                                                  AS "Compa-ratio",
       COUNT(*)                                             AS "Headcount",
       ROUND(100.0 * AVG(attrition::int), 1)                AS "Attrition %"
FROM compa
GROUP BY 1
ORDER BY MIN(compa_ratio);

-- Scatter: experience vs pay
SELECT total_working_years                                     AS "Total working years",
       CASE WHEN NOT attrition THEN monthly_income END         AS "Stayed",
       CASE WHEN attrition     THEN monthly_income END         AS "Left"
FROM employees
WHERE {{department}};
```

`midpoints` deliberately reads from `employees` **without** the filter, so a Sales employee is still compared with the company-wide median for their role and level.

</details>
