# 08 · Sums, averages, minimums and maximums

**You will learn:** the other summary functions (`SUM`, `AVG`, `MIN`, `MAX`) and how to tidy decimals with `ROUND`.

## The HR question

> "What's our monthly payroll, and what does the average employee earn?"

## New concepts

Like `COUNT`, these functions turn many rows into one number. They are often called **aggregate functions**:

| Function    | What it gives you             | Excel equivalent |
|-------------|-------------------------------|------------------|
| `COUNT(*)`  | number of rows                | `COUNTA`         |
| `SUM(col)`  | total                         | `SUM`            |
| `AVG(col)`  | average (mean)                | `AVERAGE`        |
| `MIN(col)`  | smallest value                | `MIN`            |
| `MAX(col)`  | largest value                 | `MAX`            |

```sql
SELECT SUM(monthly_income) AS monthly_payroll,
       AVG(monthly_income) AS average_income
FROM employees;
```

Averages often come with many decimals. **`ROUND(value, digits)`** tidies them up:

```sql
ROUND(AVG(monthly_income))      -- whole number
ROUND(AVG(monthly_income), 2)   -- 2 decimals
```

Notice that one function sits *inside* another, like nested formulas in Excel. SQL works from the inside out: first the average, then the rounding.

## Your turn

1. What is the total **monthly payroll**?
2. What is the **average monthly income**, rounded to a whole number? And rounded to 2 decimals?
3. What are the **lowest and highest monthly incomes**?
4. What are the **youngest and oldest ages**?
5. What is the **average tenure** (`years_at_company`), rounded to 1 decimal?
6. What is the **average monthly income of people who left**, compared with everyone? (Use `WHERE`.)

## Check your answers

| Task | Answer |
|------|--------|
| 1    | 9,559,309 |
| 2    | 6,503 (or 6,502.93) |
| 3    | 1,009 to 19,999 |
| 4    | 18 to 60 |
| 5    | 7.0 years |
| 6    | Leavers: 4,787. Everyone: 6,503. People who left earned noticeably less. |

<details>
<summary>Solutions</summary>

```sql
-- Task 1
SELECT SUM(monthly_income) AS monthly_payroll
FROM employees;

-- Task 2
SELECT ROUND(AVG(monthly_income))    AS avg_income,
       ROUND(AVG(monthly_income), 2) AS avg_income_2dp
FROM employees;

-- Tasks 3 and 4
SELECT MIN(monthly_income) AS lowest_income,
       MAX(monthly_income) AS highest_income,
       MIN(age)            AS youngest,
       MAX(age)            AS oldest
FROM employees;

-- Task 5
SELECT ROUND(AVG(years_at_company), 1) AS avg_tenure_years
FROM employees;

-- Task 6
SELECT ROUND(AVG(monthly_income)) AS avg_income_leavers
FROM employees
WHERE attrition = true;
```

</details>
