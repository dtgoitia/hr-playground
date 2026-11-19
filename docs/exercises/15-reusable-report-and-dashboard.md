# 15 · Capstone: a reusable report and an attrition dashboard

**You will learn:** how to add a filter box to a SQL question with Metabase **variables**, and how to put your saved questions on a **dashboard**. This exercise also brings together everything from 01–14.

## The HR question

> "I want a page my managers can open, pick their department, and see where people are leaving, plus a list of current employees who may be at risk."

## New concepts

### Variables: `{{ }}`

Typing a name in double curly braces in Metabase's SQL editor creates a **variable**. Metabase adds a filter box above the query, and whatever someone types there replaces the variable when the query runs.

```sql
SELECT job_role,
       COUNT(*) AS headcount,
       ROUND(100.0 * COUNT(*) FILTER (WHERE attrition) / COUNT(*), 1) AS attrition_rate_pct
FROM employees
WHERE department = {{department}}
GROUP BY job_role
ORDER BY attrition_rate_pct DESC;
```

1. Type the query. As soon as you type `{{department}}`, a **Variables** side panel opens.
2. Set **Variable type** to **Text**.
3. A **department** box appears above the editor. Type `Sales` there and run the query.

You don't type quotes in the box. Metabase adds them for you.

### Optional filters: `[[ ]]`

With the query above, an empty box gives an error. Wrap the filter in **double square brackets** to make it optional: if the box is empty, Metabase leaves out everything between `[[` and `]]`.

```sql
WHERE 1 = 1
  [[AND department = {{department}}]]
```

`WHERE 1 = 1` is always true. It's a common trick so every optional filter can start with `AND`.

### Dashboards

1. **Save** a question (top right).
2. Metabase offers to **add it to a dashboard**. Create a new one, e.g. *Attrition overview*.
3. On the dashboard, click the **filter icon** to add a filter, then connect it to each card's `department` variable. One filter box then drives every card.

## Your turn

Build an **Attrition overview** dashboard with these four saved questions. Each one should use an optional `{{department}}` filter.

1. **KPI cards:** headcount, leavers and attrition rate (exercises 07 and 11). Save each as its own question so they show as Number cards.
2. **Attrition rate by job role:** a bar chart (the example above, made optional).
3. **Attrition rate by tenure band:** a bar chart (exercise 12).
4. **Flight-risk list:** **current** employees (did not leave) who work **overtime**, have **Low** job satisfaction, and have had **no promotion for 3+ years**. Show employee number, department, job role, monthly income, years at company and years since last promotion.

Then add one dashboard filter connected to all of them, and try switching between departments.

## Check your answers

- Task 2 with `Sales`: Sales Representative **39.8%** (83 people), Sales Executive **17.5%** (326), Manager **5.4%** (37).
- Task 4 with no department chosen: **15** current employees. In total, 21 people match the risk profile, and 6 of them have already left. That suggests the profile is worth watching.

<details>
<summary>Solutions</summary>

```sql
-- Task 1 (one of the three KPI questions)
SELECT ROUND(100.0 * COUNT(*) FILTER (WHERE attrition) / COUNT(*), 1) AS attrition_rate_pct
FROM employees
WHERE 1 = 1
  [[AND department = {{department}}]];

-- Task 2
SELECT job_role,
       COUNT(*) AS headcount,
       ROUND(100.0 * COUNT(*) FILTER (WHERE attrition) / COUNT(*), 1) AS attrition_rate_pct
FROM employees
WHERE 1 = 1
  [[AND department = {{department}}]]
GROUP BY job_role
ORDER BY attrition_rate_pct DESC;

-- Task 3
SELECT CASE
           WHEN years_at_company < 2  THEN '0-1 years'
           WHEN years_at_company < 5  THEN '2-4 years'
           WHEN years_at_company < 10 THEN '5-9 years'
           ELSE '10+ years'
       END AS tenure_band,
       ROUND(100.0 * COUNT(*) FILTER (WHERE attrition) / COUNT(*), 1) AS attrition_rate_pct
FROM employees
WHERE 1 = 1
  [[AND department = {{department}}]]
GROUP BY tenure_band
ORDER BY MIN(years_at_company);

-- Task 4
SELECT employee_number,
       department,
       job_role,
       monthly_income,
       years_at_company,
       years_since_last_promotion
FROM employees
WHERE attrition = false
  AND over_time = true
  AND job_satisfaction = 'Low'
  AND years_since_last_promotion >= 3
  [[AND department = {{department}}]]
ORDER BY years_since_last_promotion DESC;
```

</details>

## What next?

You now know the core of SQL that covers most day-to-day HR reporting. Good next topics:

- **Window functions** (`RANK() OVER (PARTITION BY …)`): rank employees by pay within each department, or calculate running totals.
- **Dates** (`date_trunc`, `age()`, `interval`): headcount over time, monthly hires and leavers, time to fill. This dataset has no dates, so practise on your own HR data.
- **`LEFT JOIN`**: keep rows that have no match, e.g. positions with no one in them, or employees with no absence records.
