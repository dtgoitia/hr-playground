# 02 · Choosing columns

**You will learn:** how to show only the columns you need, rename them, and calculate new ones.

## The HR question

> "Send me a list of employees with their department, role and monthly income. I don't need the other 25 columns."

## New concepts

Instead of `*`, list the columns you want after `SELECT`, separated by commas. They appear in the order you write them.

```sql
SELECT employee_number, department, job_role, monthly_income
FROM employees;
```

**Renaming a column** (an *alias*) with `AS`. If the new name has spaces or capitals, put it in double quotes:

```sql
SELECT employee_number AS "Employee #",
       monthly_income  AS "Monthly income"
FROM employees;
```

**Calculating** works like a spreadsheet formula: `+`, `-`, `*` (multiply), `/` (divide).

```sql
SELECT employee_number,
       monthly_income,
       monthly_income * 12 AS annual_income
FROM employees;
```

> **Tip:** In Metabase, the **Data reference** panel (the book icon 📖 to the right of the editor) lists every table and its columns. You can also start typing a column name and the editor will suggest it.

## Your turn

1. List each employee's `employee_number`, `age` and `gender`.
2. List `employee_number`, `job_role` and `monthly_income`, with the last two renamed to **"Role"** and **"Monthly income"**.
3. Add a calculated column **"Annual income"** (monthly income × 12).
4. Add a column showing how many years each employee had worked **before** joining this company (`total_working_years` minus `years_at_company`).

## Check your answers

- Task 3: employee **1** has an annual income of **71,916**.
- Task 4: employee **1** had worked **2** years before joining (8 − 6).

<details>
<summary>Solutions</summary>

```sql
-- Task 1
SELECT employee_number, age, gender
FROM employees;

-- Tasks 2 and 3
SELECT employee_number,
       job_role            AS "Role",
       monthly_income      AS "Monthly income",
       monthly_income * 12 AS "Annual income"
FROM employees;

-- Task 4
SELECT employee_number,
       total_working_years,
       years_at_company,
       total_working_years - years_at_company AS years_before_joining
FROM employees;
```

</details>
