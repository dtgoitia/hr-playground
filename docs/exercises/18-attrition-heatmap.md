# 18 · Attrition heatmap: two factors at once

**You will learn:** to ask the assistant for a **cross-tab** (one row per category, one column per second category), to have it **explain the query line by line**, and to turn the table into a heatmap with conditional formatting.

## The HR question

> "Low job satisfaction drives attrition, but is that equally true in every role? And does overtime hit frequent travellers harder?"

## Why this is harder

Comparing **two factors** at once needs a grid: job roles down the side, satisfaction levels across the top, and the attrition rate in each cell. In Excel you'd build a pivot table. In SQL, each column of the grid is a separate conditional calculation, and that's easy to get subtly wrong. For example, the assistant might divide by the *whole role's* headcount instead of the headcount *in that cell*.

## Step 1: Ask the assistant

```text
Build a cross-tab for a heatmap: one row per job_role, and four columns with the
attrition rate (%) for job_satisfaction = Low, Medium, High and Very High.
The rate in each cell must be leavers in that cell / employees in that cell.
Add a final column with the number of employees with Low job satisfaction in each role,
so I can see when a cell is based on few people. Avoid division-by-zero errors.
```

Then ask:

```text
Explain the line that calculates the "Low" column, piece by piece, as if I were new to SQL.
```

The explanation should mention `FILTER (WHERE …)` and `NULLIF` (which avoids dividing by zero). If you can't follow it, ask again in simpler words. You should understand every query you put on a dashboard.

## Step 2: Check the answer

- Spot-check one cell by hand:
  ```sql
  SELECT COUNT(*), COUNT(*) FILTER (WHERE attrition)
  FROM employees
  WHERE job_role = 'Laboratory Technician' AND job_satisfaction = 'Low';
  ```
  It should give **56** employees and **20** leavers, so the cell must show **35.7**.
- If the cell shows a much smaller number, the assistant divided by the whole role (all 259 Laboratory Technicians). Tell it what went wrong.

## Step 3: Build the heatmap

1. Keep the result as a **Table**.
2. ⚙️ **Conditional formatting** → **Add a rule** → pick **all four rate columns** → **Color range**, white to red. Because one rule covers all four columns, they share one colour scale, so the colours are comparable across the grid.
3. Add a second, grey **single-colour** rule on the count column: highlight cells **less than 20**. These are "too few people to trust".
4. Save it to **People analytics** on a new tab, **Attrition drivers**.

## Step 4: A second view: overtime × travel

Ask the assistant for the attrition rate for each **business_travel** category, split into **overtime yes / no** as two columns. Show it as a **Bar** chart (not stacked). Grouped bars make the comparison obvious. Add it to the same tab.

## Check your answers

| Job role                 | Low  | Medium | High | Very High | n (Low) |
|--------------------------|------|--------|------|-----------|---------|
| Healthcare Representative| 7.7  | 10.5   | 2.3  | 9.3       | 26      |
| Human Resources          | 50.0 | 12.5   | 23.1 | 15.4      | 10      |
| Laboratory Technician    | 35.7 | 16.7   | 28.0 | 16.3      | 56      |
| Manager                  | 4.8  | 9.5    | 3.7  | 3.0       | 21      |
| Manufacturing Director   | 7.7  | 6.3    | 8.2  | 5.3       | 26      |
| Research Director        | 0.0  | 6.3    | 3.7  | 0.0       | 15      |
| Research Scientist       | 24.1 | 18.9   | 16.7 | 9.5       | 54      |
| Sales Executive          | 23.2 | 16.7   | 19.8 | 12.5      | 69      |
| Sales Representative     | 58.3 | 47.6   | 33.3 | 30.4      | 12      |

Overtime × travel: Travel_Frequently **41.9%** with overtime vs **17.3%** without. Travel_Rarely 28.5% vs 9.6%. Non-Travel 20.0% vs 4.3%.

**What it says:** low satisfaction matters a lot for Laboratory Technicians and Research Scientists, and hardly at all for Managers and Directors. Overtime roughly doubles to quadruples attrition in every travel group. Also note the cells with few people: Human Resources at 50% is 5 people out of 10.

<details>
<summary>Reference queries</summary>

```sql
-- Heatmap
SELECT job_role AS "Job role",
       ROUND(100.0 * COUNT(*) FILTER (WHERE attrition AND job_satisfaction = 'Low')
             / NULLIF(COUNT(*) FILTER (WHERE job_satisfaction = 'Low'), 0), 1)       AS "Low",
       ROUND(100.0 * COUNT(*) FILTER (WHERE attrition AND job_satisfaction = 'Medium')
             / NULLIF(COUNT(*) FILTER (WHERE job_satisfaction = 'Medium'), 0), 1)    AS "Medium",
       ROUND(100.0 * COUNT(*) FILTER (WHERE attrition AND job_satisfaction = 'High')
             / NULLIF(COUNT(*) FILTER (WHERE job_satisfaction = 'High'), 0), 1)      AS "High",
       ROUND(100.0 * COUNT(*) FILTER (WHERE attrition AND job_satisfaction = 'Very High')
             / NULLIF(COUNT(*) FILTER (WHERE job_satisfaction = 'Very High'), 0), 1) AS "Very High",
       COUNT(*) FILTER (WHERE job_satisfaction = 'Low')                              AS "n (Low)"
FROM employees
WHERE {{department}}
GROUP BY job_role
ORDER BY job_role;

-- Overtime x travel
SELECT business_travel AS "Business travel",
       ROUND(100.0 * COUNT(*) FILTER (WHERE attrition AND over_time)
             / NULLIF(COUNT(*) FILTER (WHERE over_time), 0), 1)     AS "Overtime",
       ROUND(100.0 * COUNT(*) FILTER (WHERE attrition AND NOT over_time)
             / NULLIF(COUNT(*) FILTER (WHERE NOT over_time), 0), 1) AS "No overtime"
FROM employees
WHERE {{department}}
GROUP BY business_travel
ORDER BY CASE business_travel WHEN 'Non-Travel' THEN 1 WHEN 'Travel_Rarely' THEN 2 ELSE 3 END;
```

</details>
