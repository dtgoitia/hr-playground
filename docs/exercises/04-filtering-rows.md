# 04 · Filtering rows with WHERE

**You will learn:** how to keep only the rows that match a condition, using `WHERE`.

## The HR question

> "Give me everyone in the Sales department."

## New concepts

`WHERE` filters rows, much like a filter on a spreadsheet column. It goes right **after** `FROM`:

```sql
SELECT employee_number, department, job_role
FROM employees
WHERE department = 'Sales';
```

**Text** goes in **single quotes** (`'Sales'`) and must match **exactly**, including capitals and spaces. `'sales'` or `'Sales '` would match nothing.

**Numbers** need no quotes, and you can compare them:

| Operator | Meaning                  |
|----------|--------------------------|
| `=`      | equal to                 |
| `<>`     | not equal to             |
| `>`      | greater than             |
| `<`      | less than                |
| `>=`     | greater than or equal to |
| `<=`     | less than or equal to    |

```sql
WHERE monthly_income > 15000
```

**Yes/No columns.** `attrition` (did the employee leave?) and `over_time` hold `true` or `false`. You can write either form:

```sql
WHERE attrition = true     -- people who left
WHERE attrition            -- same thing, shorter
WHERE attrition = false    -- people who stayed
```

Remember the order: `SELECT` → `FROM` → `WHERE` → `ORDER BY` → `LIMIT`.

## Your turn

1. List everyone in **Sales**. How many rows are there?
2. List everyone in **Research & Development**. Watch the exact spelling: the `&` is part of the name.
3. List employees earning **more than 15,000** a month, highest first.
4. List the employees who **left** the company (`attrition` is true).
5. List employees aged **50 or older**.

## Check your answers

| Task | Rows  |
|------|-------|
| 1    | 446   |
| 2    | 961   |
| 3    | 133   |
| 4    | 237   |
| 5    | 173   |

<details>
<summary>Solutions</summary>

```sql
-- Task 1
SELECT employee_number, department, job_role
FROM employees
WHERE department = 'Sales';

-- Task 2
SELECT employee_number, department, job_role
FROM employees
WHERE department = 'Research & Development';

-- Task 3
SELECT employee_number, job_role, monthly_income
FROM employees
WHERE monthly_income > 15000
ORDER BY monthly_income DESC;

-- Task 4
SELECT employee_number, department, job_role
FROM employees
WHERE attrition = true;

-- Task 5
SELECT employee_number, age, department
FROM employees
WHERE age >= 50;
```

</details>
