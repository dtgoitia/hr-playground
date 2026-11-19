# 12 · Building bands with CASE

**You will learn:** how to create your own categories (age bands, tenure bands, salary bands) with `CASE`, and how to summarise by them.

## The HR question

> "Is attrition higher among younger employees, or among new joiners?"

Looking at 43 separate ages isn't useful. HR reporting groups them into **bands**.

## New concepts

**`CASE`** is SQL's version of a nested `IF` in Excel. It checks conditions from top to bottom and uses the **first** one that is true:

```sql
SELECT employee_number,
       age,
       CASE
           WHEN age < 30 THEN 'Under 30'
           WHEN age < 40 THEN '30-39'
           WHEN age < 50 THEN '40-49'
           ELSE '50+'
       END AS age_band
FROM employees;
```

Because the checks run in order, the `'30-39'` line only needs `age < 40`. Anyone under 30 was already caught by the line above.

`ELSE` catches everything left over. Every `CASE` must close with `END`.

**Grouping by the new column.** You can `GROUP BY` the name you gave the `CASE` column:

```sql
SELECT CASE
           WHEN age < 30 THEN 'Under 30'
           WHEN age < 40 THEN '30-39'
           WHEN age < 50 THEN '40-49'
           ELSE '50+'
       END AS age_band,
       COUNT(*) AS headcount
FROM employees
GROUP BY age_band
ORDER BY MIN(age);
```

**Sorting bands in a sensible order.** `ORDER BY age_band` would sort alphabetically ("30-39" before "Under 30"). `ORDER BY MIN(age)` sorts each band by the youngest person in it, which gives the natural order.

## Your turn

1. Show headcount and **attrition rate per age band** (bands as above).
2. Create **tenure bands** from `years_at_company`: `0-1 years`, `2-4 years`, `5-9 years`, `10+ years`. Show headcount and attrition rate per band.
3. Create **income bands** of your choice (for example under 3,000 / 3,000–6,999 / 7,000–11,999 / 12,000+) and show the attrition rate per band.
4. Chart task 2 as a bar chart. What story does it tell?

## Check your answers

Task 1:

| Age band | Headcount | Attrition % |
|----------|-----------|-------------|
| Under 30 | 326       | 27.9        |
| 30-39    | 622       | 14.3        |
| 40-49    | 349       | 9.7         |
| 50+      | 173       | 13.3        |

Task 2:

| Tenure band | Headcount | Attrition % |
|-------------|-----------|-------------|
| 0-1 years   | 215       | 34.9        |
| 2-4 years   | 365       | 18.1        |
| 5-9 years   | 524       | 11.1        |
| 10+ years   | 366       | 10.4        |

Task 4: about a third of people in their first two years leave. Early retention is where to focus.

<details>
<summary>Solutions</summary>

```sql
-- Task 1
SELECT CASE
           WHEN age < 30 THEN 'Under 30'
           WHEN age < 40 THEN '30-39'
           WHEN age < 50 THEN '40-49'
           ELSE '50+'
       END AS age_band,
       COUNT(*) AS headcount,
       ROUND(100.0 * COUNT(*) FILTER (WHERE attrition) / COUNT(*), 1) AS attrition_rate_pct
FROM employees
GROUP BY age_band
ORDER BY MIN(age);

-- Task 2
SELECT CASE
           WHEN years_at_company < 2  THEN '0-1 years'
           WHEN years_at_company < 5  THEN '2-4 years'
           WHEN years_at_company < 10 THEN '5-9 years'
           ELSE '10+ years'
       END AS tenure_band,
       COUNT(*) AS headcount,
       ROUND(100.0 * COUNT(*) FILTER (WHERE attrition) / COUNT(*), 1) AS attrition_rate_pct
FROM employees
GROUP BY tenure_band
ORDER BY MIN(years_at_company);

-- Task 3
SELECT CASE
           WHEN monthly_income < 3000  THEN 'Under 3,000'
           WHEN monthly_income < 7000  THEN '3,000-6,999'
           WHEN monthly_income < 12000 THEN '7,000-11,999'
           ELSE '12,000+'
       END AS income_band,
       COUNT(*) AS headcount,
       ROUND(100.0 * COUNT(*) FILTER (WHERE attrition) / COUNT(*), 1) AS attrition_rate_pct
FROM employees
GROUP BY income_band
ORDER BY MIN(monthly_income);
```

</details>
