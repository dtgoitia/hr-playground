# 06 · Exploring values and searching text

**You will learn:** how to list the distinct values in a column with `DISTINCT`, and how to search text with `LIKE` and `ILIKE`.

## The HR question

> "What job roles do we actually have? And who has 'Director' in their title?"

## New concepts

**`DISTINCT`** removes duplicate rows. It's the quickest way to find out which values a column contains, like the list you see when you open a filter in Excel.

```sql
SELECT DISTINCT job_role
FROM employees
ORDER BY job_role;
```

**`LIKE`** matches text against a pattern:

- `%` means "any text, of any length, including none".
- `'%Director%'` matches anything that *contains* "Director".
- `'M%'` matches anything that *starts with* "M".
- `'%Representative'` matches anything that *ends with* "Representative".

```sql
WHERE job_role LIKE '%Director%'
```

`LIKE` is **case-sensitive**. **`ILIKE`** works the same way but ignores case. It's a PostgreSQL feature, and very handy:

```sql
WHERE job_role ILIKE '%sales%'   -- matches 'Sales Executive' too
```

## Your turn

1. List the distinct **job roles**. How many are there?
2. List the distinct **education fields**.
3. Notice that **"Human Resources"** appears as a department, a job role *and* an education field. Why does that matter when you filter?
4. List employees whose job role contains **"Director"**.
5. Try `WHERE job_role LIKE '%sales%'` (lower-case s) and then `ILIKE`. Compare the row counts.
6. List employees whose **education field starts with "M"**.
7. Using `<>`, list everyone **not** in Research & Development.

## Check your answers

| Task | Answer |
|------|--------|
| 1    | 9 roles |
| 2    | 6 fields: Human Resources, Life Sciences, Marketing, Medical, Other, Technical Degree |
| 3    | `WHERE department = 'Human Resources'` and `WHERE job_role = 'Human Resources'` are different questions. Always check which column you are filtering. |
| 4    | 225 rows (Manufacturing Director + Research Director) |
| 5    | `LIKE`: 0 rows. `ILIKE`: 409 rows |
| 6    | 623 rows (Marketing + Medical) |
| 7    | 509 rows |

<details>
<summary>Solutions</summary>

```sql
-- Task 1
SELECT DISTINCT job_role
FROM employees
ORDER BY job_role;

-- Task 2
SELECT DISTINCT education_field
FROM employees
ORDER BY education_field;

-- Task 4
SELECT employee_number, job_role
FROM employees
WHERE job_role LIKE '%Director%';

-- Task 5
SELECT employee_number, job_role
FROM employees
WHERE job_role ILIKE '%sales%';

-- Task 6
SELECT employee_number, education_field
FROM employees
WHERE education_field LIKE 'M%';

-- Task 7
SELECT employee_number, department
FROM employees
WHERE department <> 'Research & Development';
```

</details>
