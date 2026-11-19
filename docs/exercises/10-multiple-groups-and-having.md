# 10 · Grouping by several columns, and filtering groups with HAVING

**You will learn:** how to break results down by two columns at once, and how to filter the *groups* (not the rows) with `HAVING`.

## The HR question

> "What's the gender split in each department? And which job roles pay more than 10,000 on average?"

## New concepts

**Several grouping columns.** List them all in `GROUP BY`. You get one row per *combination*:

```sql
SELECT department, gender, COUNT(*) AS headcount
FROM employees
GROUP BY department, gender
ORDER BY department, gender;
```

**`HAVING` filters groups after they are summarised.** `WHERE` can't do this, because it runs *before* the grouping, when the averages don't exist yet.

```sql
SELECT job_role, ROUND(AVG(monthly_income)) AS avg_income
FROM employees
GROUP BY job_role
HAVING AVG(monthly_income) > 10000;
```

| | `WHERE` | `HAVING` |
|---|---|---|
| Filters | individual rows | groups |
| Runs | before `GROUP BY` | after `GROUP BY` |
| Can use `COUNT`, `AVG`… | no | yes |

You can use both in one query: `WHERE` picks the rows, `GROUP BY` groups them, `HAVING` picks the groups.

Order: `SELECT` → `FROM` → `WHERE` → `GROUP BY` → `HAVING` → `ORDER BY` → `LIMIT`.

> **Metabase tip:** with two grouping columns, try **Visualization → Bar** and then the **stacked** option in the chart settings (⚙️) to see the gender split inside each department bar.

## Your turn

1. Show headcount by **department and gender**.
2. Show the job roles whose **average monthly income is above 10,000**.
3. Show the job roles with **30 or more leavers**. (You need `WHERE` *and* `HAVING`.)
4. Show headcount by **department and job role**. Which roles exist in more than one department?

## Check your answers

- Task 1: 6 rows. For example, Human Resources has **20** women and **43** men.
- Task 2: **Manager** (17,182) and **Research Director** (16,034).
- Task 3: Laboratory Technician **62**, Sales Executive **57**, Research Scientist **47**, Sales Representative **33**.
- Task 4: **Manager** appears in all three departments.

<details>
<summary>Solutions</summary>

```sql
-- Task 1
SELECT department, gender, COUNT(*) AS headcount
FROM employees
GROUP BY department, gender
ORDER BY department, gender;

-- Task 2
SELECT job_role, ROUND(AVG(monthly_income)) AS avg_income
FROM employees
GROUP BY job_role
HAVING AVG(monthly_income) > 10000
ORDER BY avg_income DESC;

-- Task 3
SELECT job_role, COUNT(*) AS leavers
FROM employees
WHERE attrition = true
GROUP BY job_role
HAVING COUNT(*) >= 30
ORDER BY leavers DESC;

-- Task 4
SELECT department, job_role, COUNT(*) AS headcount
FROM employees
GROUP BY department, job_role
ORDER BY job_role, department;
```

</details>
