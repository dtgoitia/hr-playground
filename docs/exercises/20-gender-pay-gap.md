# 20 · Gender pay gap: unadjusted vs. like-for-like

**You will learn:** to **challenge the assistant's conclusions** (medians vs. averages, small groups, comparing like with like), and to build a **combo chart**: bars and a line on two axes.

## The HR question

> "We need to report our gender pay gap. What is it, and is it fair to compare men and women in the same job level?"

## Why this is harder

There are two different gender pay gap numbers, and mixing them up leads to wrong conclusions:

- **Unadjusted gap:** the median pay of all men vs. all women. This is the figure pay-transparency rules usually ask for. It reflects *who is in which jobs* as much as *how people are paid*.
- **Like-for-like (adjusted) gap:** the same comparison **within** groups doing comparable work, here **within each job level**.

Pay gaps are normally reported on the **median**, not the average, because a few very high salaries pull the average up. The gap is expressed as a **percentage of men's pay**: `(median men − median women) / median men × 100`. A positive gap means men earn more.

## Step 1: Ask the assistant

```text
Calculate the gender pay gap on monthly_income using MEDIANS.
One row per job_level (1-5) plus a final "All employees" row.
Columns: number of women, number of men, median women, median men,
and gap % = (median men - median women) / median men * 100, rounded to 1 decimal.
```

Then **challenge** the result:

```text
1. Why did you use that function for the median? What would change if we used AVG?
2. Is any group too small to report a reliable median?
3. The "All employees" gap has a different sign from most job levels. Explain how that is possible.
```

Question 3 is the lesson of this exercise. If the assistant's explanation doesn't mention **job mix** (how many women vs. men are at each level), push back. This effect even has a name: **Simpson's paradox**.

## Step 2: Check the answer

- Women + men = 588 + 882 = **1,470**.
- Check the median for level-1 women yourself:
  ```sql
  SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY monthly_income)
  FROM employees WHERE job_level = 1 AND gender = 'Female';
  ```
  → **2,659**.
- Check the gap's direction: if men earn more, the gap must be **positive**.

## Step 3: Build the combo chart

1. Keep only the 5 job-level rows (leave out "All employees", which you'll show separately).
2. Visualization → **Combo**.
3. ⚙️ **Data**: X-axis = job level. Series: median women and median men as **bars**, gap % as a **line**.
4. ⚙️ **Axes** → put the gap % on the **right-hand axis**. Salaries and percentages on one axis would flatten the line to zero.
5. Add a **Number** card for the unadjusted (all-employees) gap next to it, so readers see both figures.
6. Add both to a new tab in **People analytics**: **Pay**.

## Check your answers

| Job level | Women | Men | Median women | Median men | Gap % |
|-----------|-------|-----|--------------|------------|-------|
| 1         | 199   | 344 | 2,659        | 2,678.5    | 0.7   |
| 2         | 220   | 314 | 5,247.5      | 5,383.5    | 2.5   |
| 3         | 94    | 124 | 10,052       | 9,854      | -2.0  |
| 4         | 51    | 55  | 16,064       | 16,328     | 1.6   |
| 5         | 24    | 45  | 19,071.5     | 19,246     | 0.9   |
| All       | 588   | 882 | 5,081.5      | 4,837.5    | **-5.0** |

**What it says:** within levels the gaps are small, between −2% and +2.5%. Overall, women's median pay is **5% higher** than men's, because proportionally more of the men are at the junior level 1 (344 of 882, compared with 199 of 588 women). Neither number alone tells the full story, which is why the dashboard shows both.

<details>
<summary>Reference query</summary>

```sql
WITH base AS (
    SELECT *
    FROM employees
    WHERE {{department}}
),
gaps AS (
    SELECT COALESCE(job_level::text, 'All employees')                       AS level,
           COUNT(*) FILTER (WHERE gender = 'Female')                        AS women,
           COUNT(*) FILTER (WHERE gender = 'Male')                          AS men,
           PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY monthly_income)
               FILTER (WHERE gender = 'Female')                             AS median_women,
           PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY monthly_income)
               FILTER (WHERE gender = 'Male')                               AS median_men
    FROM base
    GROUP BY ROLLUP (job_level)
)
SELECT level                                                        AS "Job level",
       women                                                        AS "Women",
       men                                                          AS "Men",
       median_women                                                 AS "Median women",
       median_men                                                   AS "Median men",
       ROUND(((median_men - median_women) / median_men * 100)::numeric, 1) AS "Gap %"
FROM gaps
ORDER BY level;
```

New pieces:
- `PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY …)` is the median in PostgreSQL.
- `GROUP BY ROLLUP (job_level)` adds a grand-total row, where `job_level` is empty. `COALESCE` replaces the empty value with "All employees".
- `::numeric` is needed because `PERCENTILE_CONT` returns a floating-point number, and PostgreSQL's `ROUND(x, 1)` only accepts the `numeric` type.

</details>
