# 11 · Percentages: the attrition rate

**You will learn:** how to calculate a rate (a percentage) per group. This is the most common HR metric pattern, and it comes with one classic trap.

## The HR question

> "What's our attrition rate, overall and by department?"

Attrition rate = people who left ÷ total people × 100.

## New concepts

**Counting only some rows inside a group: `FILTER`.** `COUNT(*) FILTER (WHERE …)` counts only the rows that match, while plain `COUNT(*)` next to it still counts all of them. That gives you both parts of the fraction in a single query:

```sql
SELECT COUNT(*)                              AS headcount,
       COUNT(*) FILTER (WHERE attrition)     AS leavers
FROM employees;
```

**⚠️ The whole-number trap.** Try this:

```sql
SELECT COUNT(*) FILTER (WHERE attrition) / COUNT(*) AS rate
FROM employees;
```

It returns **0**! When you divide one whole number by another, SQL throws away the decimals: 237 ÷ 1,470 = 0.16… becomes 0. The fix is to make one side a decimal number. Multiplying by `100.0` (with the `.0`) does that, and turns the result into a percentage at the same time:

```sql
SELECT ROUND(100.0 * COUNT(*) FILTER (WHERE attrition) / COUNT(*), 1) AS attrition_rate_pct
FROM employees;
```

Combine it with `GROUP BY` to get the rate per group.

## Your turn

1. Calculate the **overall attrition rate** (%), rounded to 1 decimal.
2. Calculate the **attrition rate per department**, with headcount and leavers alongside. Sort by rate, highest first.
3. Compare the attrition rate of people who **work overtime** and those who **don't**.
4. Find the **job role with the highest attrition rate** and the one with the lowest.
5. Chart task 4 as a bar chart and save it.

## Check your answers

| Task | Answer |
|------|--------|
| 1    | 16.1% |
| 2    | Sales 20.6% (92 of 446), Human Resources 19.0% (12 of 63), R&D 13.8% (133 of 961) |
| 3    | Overtime: 30.5%. No overtime: 10.4%. That's three times higher. |
| 4    | Highest: Sales Representative 39.8%. Lowest: Research Director 2.5% |

<details>
<summary>Solutions</summary>

```sql
-- Task 1
SELECT ROUND(100.0 * COUNT(*) FILTER (WHERE attrition) / COUNT(*), 1) AS attrition_rate_pct
FROM employees;

-- Task 2
SELECT department,
       COUNT(*)                          AS headcount,
       COUNT(*) FILTER (WHERE attrition) AS leavers,
       ROUND(100.0 * COUNT(*) FILTER (WHERE attrition) / COUNT(*), 1) AS attrition_rate_pct
FROM employees
GROUP BY department
ORDER BY attrition_rate_pct DESC;

-- Task 3
SELECT over_time,
       ROUND(100.0 * COUNT(*) FILTER (WHERE attrition) / COUNT(*), 1) AS attrition_rate_pct
FROM employees
GROUP BY over_time;

-- Task 4
SELECT job_role,
       ROUND(100.0 * COUNT(*) FILTER (WHERE attrition) / COUNT(*), 1) AS attrition_rate_pct
FROM employees
GROUP BY job_role
ORDER BY attrition_rate_pct DESC;
```

</details>
