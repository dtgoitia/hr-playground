# 13 · Comparing against an average: subqueries

**You will learn:** how to use the result of one query inside another (a **subquery**).

## The HR question

> "Who earns less than the company average? And are those people more likely to leave?"

## New concepts

You could do this in two steps: first run `SELECT AVG(monthly_income) FROM employees`, write down 6,502.93, then filter with `WHERE monthly_income < 6502.93`. But the number changes whenever the data changes.

A **subquery** does both steps at once. Put the first query in parentheses where the number would go:

```sql
SELECT employee_number, job_role, monthly_income
FROM employees
WHERE monthly_income < (SELECT AVG(monthly_income) FROM employees);
```

SQL runs the inner query first, gets one number, then uses it in the outer query.

A subquery can also return **a list** for use with `IN`:

```sql
-- Employees in roles whose average pay is above 10,000
SELECT employee_number, job_role
FROM employees
WHERE job_role IN (
    SELECT job_role
    FROM employees
    GROUP BY job_role
    HAVING AVG(monthly_income) > 10000
);
```

> **Tip:** build subqueries from the inside out. Write and run the inner query on its own first. Once it gives the right answer, wrap it in parentheses and plug it into the outer query.

## Your turn

1. What is the company's **average monthly income** (2 decimals)?
2. How many employees earn **more than** the average?
3. Among employees earning **less than** the average, how many are there, how many left, and what is their attrition rate? Compare it with the overall 16.1%.
4. How many employees work in roles whose **average pay is above 10,000**? (Use the `IN` example.)
5. *(Bonus)* What is the **average age of leavers**? How many employees are **older** than that?

## Check your answers

| Task | Answer |
|------|--------|
| 1    | 6,502.93 |
| 2    | 493 |
| 3    | 977 employees, 185 left, 18.9%. That's higher than the 16.1% company-wide. |
| 4    | 182 |
| 5    | Leavers' average age is 33.6. 896 employees are older than that. |

<details>
<summary>Solutions</summary>

```sql
-- Task 1
SELECT ROUND(AVG(monthly_income), 2) AS avg_income
FROM employees;

-- Task 2
SELECT COUNT(*) AS above_average
FROM employees
WHERE monthly_income > (SELECT AVG(monthly_income) FROM employees);

-- Task 3
SELECT COUNT(*)                          AS below_average,
       COUNT(*) FILTER (WHERE attrition) AS leavers,
       ROUND(100.0 * COUNT(*) FILTER (WHERE attrition) / COUNT(*), 1) AS attrition_rate_pct
FROM employees
WHERE monthly_income < (SELECT AVG(monthly_income) FROM employees);

-- Task 4
SELECT COUNT(*) AS employees_in_high_pay_roles
FROM employees
WHERE job_role IN (
    SELECT job_role
    FROM employees
    GROUP BY job_role
    HAVING AVG(monthly_income) > 10000
);

-- Task 5
SELECT ROUND(AVG(age), 1) AS avg_age_leavers
FROM employees
WHERE attrition = true;

SELECT COUNT(*) AS older_than_avg_leaver
FROM employees
WHERE age > (SELECT AVG(age) FROM employees WHERE attrition = true);
```

</details>
