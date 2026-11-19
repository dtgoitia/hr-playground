# 24 · A flight-risk score, built responsibly

**You will learn:** to have the assistant **review the ethics and fairness** of an analysis, to **rank within groups** with window functions, and to build an action list with conditional formatting and a 100% stacked bar.

## The HR question

> "Give each manager a short list of current team members who look at risk of leaving, so they can have a stay conversation. And show us the score actually works."

## Why this is harder

The SQL is the easy part. The hard parts are:

- **Fairness.** A score that flags people because of **age, gender or marital status** is discriminatory, even if those factors correlate with attrition in the data (exercise 19 showed *Single* employees leave more). The score must use only **work-related factors** that a manager can act on.
- **Proof.** A score is only useful if higher scores really mean more leavers. You check this by looking at the actual attrition rate for each score.
- **Hindsight.** If you pick factors by looking at this data and then test the score on the same data, it will look better than it really is. Be honest about that on the dashboard.

## Step 1: Design the score with the assistant

```text
I want a simple, transparent, points-based flight-risk score (not a machine-learning model)
that HR and managers can understand. First, list which columns you would use and which you
must NOT use for legal and ethical reasons in HR (explain why). Then propose points.
```

Compare its answer with this design, which the rest of the exercise uses:

| Factor (work-related only)                | Points |
|-------------------------------------------|--------|
| Works overtime                            | 2      |
| Job level 1                               | 1      |
| No stock options (level 0)                | 1      |
| Job involvement = Low                     | 1      |
| Work-life balance = Bad                   | 1      |
| Environment satisfaction = Low            | 1      |
| Job satisfaction = Low                    | 1      |
| Travels frequently                        | 1      |
| Less than 2 years at the company          | 1      |

**Excluded on purpose:** age, gender, marital status, distance from home. Note this on the dashboard.

## Step 2: Ask for three queries

```text
Using that points table:
1. Validation: for each risk score, headcount and actual attrition rate (all employees, including leavers).
2. Action list: CURRENT employees only (attrition = false) with score >= 5, showing department,
   employee_number, job_role, the score, and which factors triggered it as a readable text
   (e.g. "Overtime, Low job satisfaction"). Rank them within each department by score
   using a window function.
3. For a 100% stacked bar: per department, the number of CURRENT employees in each tier:
   Low (0-2), Medium (3-4), High (5+).
Use the department field filter in each.
```

## Step 3: Check the answer

- Total in the validation query = **1,470**. The current employees in query 3 = **1,233**.
- Pick one employee from the action list and check their factors by hand with a simple `SELECT … WHERE employee_number = …`.
- **The key check:** in the validation query, does the attrition rate go **up** as the score goes up? If not, the score doesn't work.

## Step 4: Visualize

1. **Validation:** a **Bar** chart of attrition % by score. Title it *"Does the score work?"*. This chart earns trust in the list next to it.
2. **Action list:** a **Table** with conditional formatting on the score column, a color range from yellow to red. Add a **Text** card with the excluded factors and the hindsight caveat.
3. **Tiers:** a **Bar** chart → ⚙️ **Stack – 100%**, coloured green, amber, red.
4. Add all of them to a new **Flight risk** tab.

## Check your answers

| Risk score | Headcount | Attrition % |
|------------|-----------|-------------|
| 0          | 173       | 4.6         |
| 1          | 334       | 3.6         |
| 2          | 411       | 5.8         |
| 3          | 284       | 20.4        |
| 4          | 156       | 38.5        |
| 5          | 79        | 58.2        |
| 6          | 24        | 87.5        |
| 7          | 9         | 88.9        |

| Tier          | All employees | Of whom left | Attrition % | Current employees |
|---------------|---------------|--------------|-------------|-------------------|
| Low (0-2)     | 918           | 44           | 4.8         | 874               |
| Medium (3-4)  | 440           | 118          | 26.8        | 322               |
| High (5+)     | 112           | 75           | 67.0        | **37**            |

- The action list has **37** current employees. The top of R&D is employee **1242** (Research Director, score 7).
- Share of current employees in the High tier: R&D 4.0%, Human Resources 2.0%, Sales 0.8%.

**Before you celebrate the score:** the factors were chosen by looking at this same data, so the validation chart flatters it. Ask the assistant how you'd test the score properly. The answer you're looking for: check it on **new data**, e.g. next year's leavers.

<details>
<summary>Reference queries</summary>

```sql
-- Shared scoring logic (used as the first CTE in each query)
WITH scored AS (
    SELECT *,
           (CASE WHEN over_time                              THEN 2 ELSE 0 END
          + CASE WHEN job_level = 1                          THEN 1 ELSE 0 END
          + CASE WHEN stock_option_level = 0                 THEN 1 ELSE 0 END
          + CASE WHEN job_involvement = 'Low'                THEN 1 ELSE 0 END
          + CASE WHEN work_life_balance = 'Bad'              THEN 1 ELSE 0 END
          + CASE WHEN environment_satisfaction = 'Low'       THEN 1 ELSE 0 END
          + CASE WHEN job_satisfaction = 'Low'               THEN 1 ELSE 0 END
          + CASE WHEN business_travel = 'Travel_Frequently'  THEN 1 ELSE 0 END
          + CASE WHEN years_at_company < 2                   THEN 1 ELSE 0 END) AS risk_score
    FROM employees
    WHERE {{department}}
)
-- 1. Validation
SELECT risk_score                               AS "Risk score",
       COUNT(*)                                 AS "Headcount",
       ROUND(100.0 * AVG(attrition::int), 1)    AS "Attrition %"
FROM scored
GROUP BY risk_score
ORDER BY risk_score;
```

```sql
-- 2. Action list (start with the same "WITH scored AS (…)" block as above, then:)
SELECT department                                                  AS "Department",
       RANK() OVER (PARTITION BY department ORDER BY risk_score DESC) AS "Rank in department",
       employee_number                                             AS "Employee #",
       job_role                                                    AS "Job role",
       risk_score                                                  AS "Risk score",
       CONCAT_WS(', ',
           CASE WHEN over_time                             THEN 'Overtime' END,
           CASE WHEN job_level = 1                         THEN 'Job level 1' END,
           CASE WHEN stock_option_level = 0                THEN 'No stock options' END,
           CASE WHEN job_involvement = 'Low'               THEN 'Low involvement' END,
           CASE WHEN work_life_balance = 'Bad'             THEN 'Bad work-life balance' END,
           CASE WHEN environment_satisfaction = 'Low'      THEN 'Low environment satisfaction' END,
           CASE WHEN job_satisfaction = 'Low'              THEN 'Low job satisfaction' END,
           CASE WHEN business_travel = 'Travel_Frequently' THEN 'Frequent travel' END,
           CASE WHEN years_at_company < 2                  THEN 'Under 2 years tenure' END
       )                                                           AS "Risk factors"
FROM scored
WHERE NOT attrition
  AND risk_score >= 5
ORDER BY department, "Rank in department";
```

```sql
-- 3. Tier mix per department (same "WITH scored AS (…)" block, then:)
SELECT department                                               AS "Department",
       COUNT(*) FILTER (WHERE risk_score <= 2)                  AS "Low (0-2)",
       COUNT(*) FILTER (WHERE risk_score BETWEEN 3 AND 4)       AS "Medium (3-4)",
       COUNT(*) FILTER (WHERE risk_score >= 5)                  AS "High (5+)"
FROM scored
WHERE NOT attrition
GROUP BY department
ORDER BY department;
```

New pieces:
- `RANK() OVER (PARTITION BY department ORDER BY …)` numbers rows **within each department** separately. That's the window-function version of "rank within group".
- `CONCAT_WS(', ', …)` joins texts with a separator and skips the empty ones, which turns the triggered factors into a readable list.

</details>
