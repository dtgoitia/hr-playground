# 14 · Pay equity check: WITH and JOIN

**You will learn:** how to name an intermediate result with `WITH`, and how to combine two tables side by side with `JOIN`.

## The HR question

> "For each employee, how does their pay compare with the average for **their own job role**? Are people paid well below their role average more likely to leave?"

Comparing a Laboratory Technician with the company average isn't fair. They should be compared with other Laboratory Technicians. To do that, each employee row needs their **role's average** next to it.

## New concepts

**`WITH` gives a query a name** so you can use it like a table further down. It's like putting a pivot table on its own sheet and referring to it from another one:

```sql
WITH role_avg AS (
    SELECT job_role, AVG(monthly_income) AS avg_income
    FROM employees
    GROUP BY job_role
)
SELECT * FROM role_avg;
```

**`JOIN` puts two tables side by side**, matching rows on a shared column. If you know **VLOOKUP**, it's the same idea: for each employee, look up their `job_role` in `role_avg` and bring back `avg_income`.

```sql
WITH role_avg AS (
    SELECT job_role, AVG(monthly_income) AS avg_income
    FROM employees
    GROUP BY job_role
)
SELECT e.employee_number,
       e.job_role,
       e.monthly_income,
       ROUND(r.avg_income) AS role_avg_income,
       ROUND(100.0 * e.monthly_income / r.avg_income) AS pct_of_role_avg
FROM employees AS e
JOIN role_avg  AS r ON r.job_role = e.job_role;
```

- `employees AS e` gives the table a short nickname, so `e.monthly_income` means "the `monthly_income` column from employees".
- `ON r.job_role = e.job_role` is the matching rule, the equivalent of VLOOKUP's lookup value.
- When two tables have a column with the same name (`job_role` here), you **must** say which one you mean, with `e.` or `r.`.

`JOIN` keeps only rows that find a match. Here every employee's role exists in `role_avg`, so no one is lost. In real HR databases you'll join employees to departments, positions, absences and so on. The pattern is always the same.

## Your turn

1. Run the example. Employee **1** is a Sales Executive. What percentage of the Sales Executive average do they earn?
2. Add `WHERE` to list only employees earning **below 80% of their role average**. How many are there?
3. Using a `CASE` (exercise 12), split everyone into `'Below 80% of role average'` and `'80% or more'`, and show the headcount and **attrition rate** of each group.
4. *(Bonus)* Repeat task 3 with **department + job level** instead of job role. (Join on both columns: `ON r.department = e.department AND r.job_level = e.job_level`.)

## Check your answers

| Task | Answer |
|------|--------|
| 1    | 5,993 vs. a role average of 6,924, so **87%** |
| 2    | 495 employees |
| 3    | Below 80%: 495 people, **20.4%** attrition. 80% or more: 975 people, **13.9%** attrition. |

<details>
<summary>Solutions</summary>

```sql
-- Task 2
WITH role_avg AS (
    SELECT job_role, AVG(monthly_income) AS avg_income
    FROM employees
    GROUP BY job_role
)
SELECT e.employee_number,
       e.job_role,
       e.monthly_income,
       ROUND(r.avg_income) AS role_avg_income
FROM employees AS e
JOIN role_avg  AS r ON r.job_role = e.job_role
WHERE e.monthly_income < 0.8 * r.avg_income
ORDER BY e.job_role, e.monthly_income;

-- Task 3
WITH role_avg AS (
    SELECT job_role, AVG(monthly_income) AS avg_income
    FROM employees
    GROUP BY job_role
)
SELECT CASE
           WHEN e.monthly_income < 0.8 * r.avg_income THEN 'Below 80% of role average'
           ELSE '80% or more'
       END AS pay_position,
       COUNT(*) AS headcount,
       ROUND(100.0 * COUNT(*) FILTER (WHERE e.attrition) / COUNT(*), 1) AS attrition_rate_pct
FROM employees AS e
JOIN role_avg  AS r ON r.job_role = e.job_role
GROUP BY pay_position;

-- Task 4
WITH level_avg AS (
    SELECT department, job_level, AVG(monthly_income) AS avg_income
    FROM employees
    GROUP BY department, job_level
)
SELECT CASE
           WHEN e.monthly_income < 0.8 * r.avg_income THEN 'Below 80% of level average'
           ELSE '80% or more'
       END AS pay_position,
       COUNT(*) AS headcount,
       ROUND(100.0 * COUNT(*) FILTER (WHERE e.attrition) / COUNT(*), 1) AS attrition_rate_pct
FROM employees AS e
JOIN level_avg AS r ON r.department = e.department AND r.job_level = e.job_level
GROUP BY pay_position;
```

</details>
