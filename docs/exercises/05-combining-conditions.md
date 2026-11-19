# 05 · Combining conditions

**You will learn:** `AND`, `OR`, `IN` and `BETWEEN`, and why parentheses matter.

## The HR question

> "Which of the people who left had been working overtime?"

## New concepts

**`AND`**: *both* conditions must be true.

```sql
WHERE attrition = true AND over_time = true
```

**`OR`**: *at least one* must be true.

```sql
WHERE department = 'Sales' OR department = 'Human Resources'
```

**`IN`** is a shortcut for many `OR`s on the same column:

```sql
WHERE job_role IN ('Sales Executive', 'Sales Representative')
```

**`BETWEEN`** checks a range. Both ends are included:

```sql
WHERE age BETWEEN 25 AND 35      -- 25, 26, … 35
```

**`NOT`** flips a condition: `WHERE NOT over_time`, `WHERE job_role NOT IN (...)`.

### ⚠️ Parentheses

When you mix `AND` and `OR`, SQL handles `AND` **first**, the way multiplication comes before addition in maths. Compare these two:

```sql
-- What you meant: leavers who were in Sales or HR
WHERE (department = 'Sales' OR department = 'Human Resources') AND attrition

-- What SQL reads without parentheses:
-- "everyone in Sales" OR "leavers in HR"
WHERE department = 'Sales' OR department = 'Human Resources' AND attrition
```

Rule of thumb: **whenever you mix `AND` and `OR`, add parentheses.**

## Your turn

1. List employees who **left and worked overtime**.
2. Using `IN`, list everyone who is a **Sales Executive** or a **Sales Representative**.
3. Using `BETWEEN`, list employees aged **25 to 35**.
4. List **leavers from Sales or Human Resources**. Run it both with and without parentheses and compare the row counts.
5. *(Bonus)* List employees in R&D who **did not** work overtime and earn **under 3,000**.

## Check your answers

| Task | Rows |
|------|------|
| 1    | 127  |
| 2    | 409  |
| 3    | 632  |
| 4    | **104** with parentheses (correct), 458 without (wrong) |

<details>
<summary>Solutions</summary>

```sql
-- Task 1
SELECT employee_number, department, job_role
FROM employees
WHERE attrition = true AND over_time = true;

-- Task 2
SELECT employee_number, job_role
FROM employees
WHERE job_role IN ('Sales Executive', 'Sales Representative');

-- Task 3
SELECT employee_number, age
FROM employees
WHERE age BETWEEN 25 AND 35;

-- Task 4
SELECT employee_number, department
FROM employees
WHERE (department = 'Sales' OR department = 'Human Resources')
  AND attrition = true;

-- Task 5
SELECT employee_number, job_role, monthly_income
FROM employees
WHERE department = 'Research & Development'
  AND NOT over_time
  AND monthly_income < 3000;
```

</details>
