# 23 · Retention curve: how many joiners are still here after N years?

**You will learn:** to use the assistant for an analysis you couldn't design yourself (a **retention curve** using **window functions**), to **verify complex logic step by step**, and to show a KPI against a target with a **Progress** card.

## The HR question

> "Out of 100 people who join us, how many are still here after 1, 2, 5 and 10 years? And in which year do we lose the most?"

## Why this is harder

This is a **survival analysis**, the method behind retention curves. For each tenure year it works out:

- **At risk:** employees who reached at least that year (`years_at_company >= year`).
- **Left that year:** leavers whose tenure was exactly that year.
- **Year's leaving rate** = left ÷ at risk.
- **Retention** = the share still here, multiplied year after year: (1 − rate in year 0) × (1 − rate in year 1) × …

That running multiplication needs a **window function**: a calculation that looks at the rows before the current one, like a running total in Excel.

> **Caveat to put on the dashboard:** this dataset is a single snapshot, not a history of joiners followed over time. The curve is an **approximation**. With real HR data you'd use hire and exit dates.

## Step 1: Ask the assistant

```text
Build a tenure-based retention curve (Kaplan-Meier style) for years_at_company 0 to 20:
- one row per tenure year
- at_risk = employees with years_at_company >= that year
- leavers = employees with attrition = true and years_at_company = that year
- leaving rate % = leavers / at_risk
- retention % = cumulative product of (1 - leaving rate) up to and including that year
Explain how you calculate a cumulative product in PostgreSQL, since there is no PRODUCT function.
```

The assistant will probably use `EXP(SUM(LN(…)))`, a mathematical trick that turns a running product into a running sum. Ask it to explain this in plain words. This is a good example of something you'd never invent yourself but **can check**.

## Step 2: Check it step by step

Don't trust the final column until the first few rows check out by hand:

1. Year 0: at risk must be **1,470** (everyone has at least 0 years). Leavers in year 0 = `SELECT COUNT(*) FROM employees WHERE attrition AND years_at_company = 0;` → **16**.
2. Year 0 retention = 1 − 16/1,470 = **98.9%**.
3. Year 1: at risk **1,426**, leavers **59**. Retention = 98.9% × (1 − 59/1,426) ≈ **94.8%**.

If those three match, the logic is right for the other years too.

## Step 3: Visualize

1. **Retention curve:** Visualization → **Line**, X = tenure year, Y = retention %. ⚙️ Y-axis range 0–100, so the drop isn't exaggerated.
2. Better still, use a **Combo**: leaving rate % as **bars** on the right axis and retention % as a **line**. The bars show *when* people leave, the line the cumulative effect.
3. **Progress card:** ask for a query that returns only the **2-year retention %**. Visualization → **Progress**, goal **95**. It shows how far you are from target.
4. Add them to a new **Retention** tab, with a **Text** card containing the snapshot caveat.

## Check your answers

| Tenure year | At risk | Leavers | Leaving rate % | Retention % |
|-------------|---------|---------|----------------|-------------|
| 0           | 1,470   | 16      | 1.1            | 98.9        |
| 1           | 1,426   | 59      | 4.1            | 94.8        |
| 2           | 1,255   | 27      | 2.2            | 92.8        |
| 3           | 1,128   | 20      | 1.8            | 91.1        |
| 4           | 1,000   | 19      | 1.9            | 89.4        |
| 5           | 890     | 21      | 2.4            | 87.3        |
| …           |         |         |                |             |
| 10          | 366     | 18      | 4.9            | 77.7        |

**What it says:** year 1 is the most dangerous year, losing about 4% of those still here, and there's a second spike at year 10. That's a finding to explore. Is it a career plateau? Vesting of long-term benefits?

<details>
<summary>Reference queries</summary>

```sql
-- Retention curve
WITH base AS (
    SELECT *
    FROM employees
    WHERE {{department}}
),
years AS (
    SELECT generate_series(0, 20) AS tenure_year
),
by_year AS (
    SELECT y.tenure_year,
           (SELECT COUNT(*) FROM base b WHERE b.years_at_company >= y.tenure_year)                  AS at_risk,
           (SELECT COUNT(*) FROM base b WHERE b.attrition AND b.years_at_company = y.tenure_year)   AS leavers
    FROM years y
)
SELECT tenure_year                                                    AS "Tenure year",
       at_risk                                                        AS "At risk",
       leavers                                                        AS "Leavers",
       ROUND(100.0 * leavers / NULLIF(at_risk, 0), 1)                 AS "Leaving rate %",
       ROUND(100 * EXP(SUM(LN(1 - leavers::numeric / NULLIF(at_risk, 0)))
                       OVER (ORDER BY tenure_year)), 1)               AS "Retention %"
FROM by_year
WHERE at_risk > 0
ORDER BY tenure_year;

-- 2-year retention for the Progress card
WITH base AS (
    SELECT *
    FROM employees
    WHERE {{department}}
),
by_year AS (
    SELECT y AS tenure_year,
           (SELECT COUNT(*) FROM base b WHERE b.years_at_company >= y)                AS at_risk,
           (SELECT COUNT(*) FROM base b WHERE b.attrition AND b.years_at_company = y) AS leavers
    FROM generate_series(0, 1) AS y
)
SELECT ROUND(100 * EXP(SUM(LN(1 - leavers::numeric / at_risk))), 1) AS "2-year retention %"
FROM by_year;
```

New pieces:
- `generate_series(0, 20)` creates the numbers 0 to 20 as rows, so every year appears, even years with no leavers.
- `SUM(...) OVER (ORDER BY tenure_year)` is a **window function**: a running total in year order.
- `EXP(SUM(LN(x)))` = x₁ × x₂ × x₃ …, a running product.
- "2-year retention" means still here after completing years 0 and 1, hence `generate_series(0, 1)`. The result is **94.8%**.

</details>
