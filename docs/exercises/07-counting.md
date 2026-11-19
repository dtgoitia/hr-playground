# 07 · Counting: headcount

**You will learn:** how to count rows with `COUNT`, including counts of distinct values.

## The HR question

> "What's our total headcount? And how many people left?"

## New concepts

So far every query has returned a list of employees. **`COUNT(*)`** collapses all the matching rows into **a single number**:

```sql
SELECT COUNT(*) AS headcount
FROM employees;
```

Combine it with `WHERE` to count only some rows. The filter is applied **first**, then the remaining rows are counted:

```sql
SELECT COUNT(*) AS leavers
FROM employees
WHERE attrition = true;
```

**`COUNT(DISTINCT column)`** counts how many *different* values a column has:

```sql
SELECT COUNT(DISTINCT job_role) AS number_of_roles
FROM employees;
```

You can put several counts in the same query:

```sql
SELECT COUNT(*)                   AS headcount,
       COUNT(DISTINCT department) AS departments
FROM employees;
```

> **Metabase tip:** when a query returns a single number, Metabase shows it as a big **Number** card. That's a ready-made KPI tile for a dashboard.

## Your turn

1. What is the **total headcount**?
2. How many employees **left**?
3. How many employees in **Sales** left?
4. In one query, count the distinct **job roles**, **departments** and **education fields**.
5. How many employees work **overtime**?

## Check your answers

| Task | Answer |
|------|--------|
| 1    | 1,470 |
| 2    | 237 |
| 3    | 92 |
| 4    | 9 roles, 3 departments, 6 education fields |
| 5    | 416 |

<details>
<summary>Solutions</summary>

```sql
-- Task 1
SELECT COUNT(*) AS headcount
FROM employees;

-- Task 2
SELECT COUNT(*) AS leavers
FROM employees
WHERE attrition = true;

-- Task 3
SELECT COUNT(*) AS sales_leavers
FROM employees
WHERE department = 'Sales' AND attrition = true;

-- Task 4
SELECT COUNT(DISTINCT job_role)        AS roles,
       COUNT(DISTINCT department)      AS departments,
       COUNT(DISTINCT education_field) AS education_fields
FROM employees;

-- Task 5
SELECT COUNT(*) AS overtime_workers
FROM employees
WHERE over_time = true;
```

</details>
