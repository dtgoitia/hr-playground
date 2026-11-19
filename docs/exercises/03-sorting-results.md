# 03 · Sorting results

**You will learn:** how to sort with `ORDER BY` and combine it with `LIMIT` to get "top N" lists.

## The HR question

> "Who are our 10 highest-paid employees?"

## New concepts

`ORDER BY` sorts the results. It goes **after** `FROM`.

- `ASC` = ascending (smallest first, A→Z). This is the default, so you can leave it out.
- `DESC` = descending (largest first, Z→A).

```sql
SELECT employee_number, job_role, monthly_income
FROM employees
ORDER BY monthly_income DESC
LIMIT 10;
```

`ORDER BY` + `LIMIT` is how you build any "top 10" or "bottom 5" list.

You can sort by **several columns**: SQL sorts by the first, and uses the second only to break ties, like a multi-level sort in Excel:

```sql
ORDER BY department, monthly_income DESC
```

> **Order of the parts matters.** SQL expects them in this order:
> `SELECT` → `FROM` → `ORDER BY` → `LIMIT`. In later exercises you'll add new parts in between.

## Your turn

1. List the **10 highest-paid** employees (employee number, job role, monthly income).
2. List the **5 youngest** employees (employee number, age, department).
3. List all employees sorted **by department (A→Z)**, and **within each department by monthly income, highest first**.
4. Who has been at the company the **longest**? Show the top 5 by `years_at_company`.

## Check your answers

- Task 1: the top earner is employee **259**, a **Manager** earning **19,999**.
- Task 2: the youngest employees are **18**. Several are tied, so your 5 may differ from someone else's, and that's fine.
- Task 3: the first rows should be in **Human Resources**, starting with the highest earner in that department.
- Task 4: the longest tenure is **40** years.

<details>
<summary>Solutions</summary>

```sql
-- Task 1
SELECT employee_number, job_role, monthly_income
FROM employees
ORDER BY monthly_income DESC
LIMIT 10;

-- Task 2
SELECT employee_number, age, department
FROM employees
ORDER BY age
LIMIT 5;

-- Task 3
SELECT department, employee_number, job_role, monthly_income
FROM employees
ORDER BY department, monthly_income DESC;

-- Task 4
SELECT employee_number, job_role, years_at_company
FROM employees
ORDER BY years_at_company DESC
LIMIT 5;
```

</details>
