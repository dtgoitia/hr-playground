# 09 · Breakdowns with GROUP BY, and your first chart

**You will learn:** how to get one summary row **per group** (per department, per role…) with `GROUP BY`, and how to turn the result into a chart.

## The HR question

> "What's the headcount per department? And the average salary per job role?"

## New concepts

In exercise 07, `COUNT(*)` gave one number for the whole company. **`GROUP BY`** splits the rows into groups first and gives one result **per group**. It's what a **pivot table** does in Excel.

```sql
SELECT department,
       COUNT(*) AS headcount
FROM employees
GROUP BY department
ORDER BY headcount DESC;
```

How SQL runs it:

1. Take all rows from `employees`.
2. Put them into piles, one per department.
3. Count each pile.
4. Sort the result.

**The golden rule:** every column in `SELECT` must either be in the `GROUP BY` **or** be inside an aggregate function (`COUNT`, `SUM`, `AVG`, …). If you forget, you'll get an error like *"column must appear in the GROUP BY clause"*. Read that as "you forgot to group by it".

Order of the parts: `SELECT` → `FROM` → `WHERE` → `GROUP BY` → `ORDER BY` → `LIMIT`.

## Make a chart in Metabase

1. Run the department query above.
2. Click **Visualization** at the bottom-left of the results.
3. Choose **Bar** (or **Pie**). Metabase uses the text column for the categories and the number column for the bar heights.
4. Click **Save** (top right) to keep the question. You'll be able to add it to a dashboard later.

## Your turn

1. Show the **headcount per department**, largest first, as a bar chart.
2. Show the **average monthly income per job role** (rounded), highest first.
3. Show the **headcount per business-travel category**.
4. Show the **number of leavers per department**. Hint: filter with `WHERE` before grouping.

## Check your answers

- Task 1: R&D **961**, Sales **446**, Human Resources **63**.
- Task 2: Manager is highest (**17,182**). Sales Representative is lowest (**2,626**).
- Task 3: Travel_Rarely **1,043**, Travel_Frequently **277**, Non-Travel **150**.
- Task 4: R&D **133**, Sales **92**, Human Resources **12**.

<details>
<summary>Solutions</summary>

```sql
-- Task 1
SELECT department, COUNT(*) AS headcount
FROM employees
GROUP BY department
ORDER BY headcount DESC;

-- Task 2
SELECT job_role, ROUND(AVG(monthly_income)) AS avg_income
FROM employees
GROUP BY job_role
ORDER BY avg_income DESC;

-- Task 3
SELECT business_travel, COUNT(*) AS headcount
FROM employees
GROUP BY business_travel
ORDER BY headcount DESC;

-- Task 4
SELECT department, COUNT(*) AS leavers
FROM employees
WHERE attrition = true
GROUP BY department
ORDER BY leavers DESC;
```

</details>
