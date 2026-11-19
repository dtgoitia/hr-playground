# 16 · Working with an AI assistant (Claude, ChatGPT…)

**You will learn:** how to give a web-based AI assistant the context it needs to write correct SQL for *your* database, and how to check what it gives you before you trust it.

From here on, the exercises are harder. The goal isn't to type every query yourself. You **describe the analysis**, the assistant **drafts the SQL**, and you **check it and turn it into a chart** in Metabase. Your SQL knowledge from exercises 01–15 is what lets you spot when the assistant gets it wrong, and it will sometimes get it wrong.

## ⚠️ Before you start: data privacy

This dataset is fictional, so you can paste anything. With **real** employee data, follow your company's AI policy, and as a rule:

- ✅ Share the **structure**: table and column names, the meaning of each column, the allowed values.
- ✅ Share **aggregated** results, like "attrition by department".
- ❌ Never paste **row-level** employee data (names, salaries, performance ratings of individuals) into a public AI tool.

The assistant doesn't need your data to write SQL. It only needs to know what the data looks like.

## Step 1: Give the assistant context

An AI assistant doesn't know your tables. If you just ask "write SQL for attrition by department", it will guess the table and column names, and the guess will be wrong.

Start every new chat by pasting this **context block**. Keep it in a note so you can reuse it.

````text
You are helping an HR analyst write SQL queries. Follow these rules.

ENVIRONMENT
- Database: PostgreSQL 17. Use PostgreSQL syntax only.
- Queries run in the Metabase (v0.65) SQL editor and are used for charts and dashboards.
- Read-only: only SELECT queries (WITH … SELECT is fine).

MAIN TABLE: employees  (1,470 rows, one per employee, fictional data, a single snapshot with no dates)
- employee_number integer: unique ID
- age integer (18-60), gender text ('Female','Male'), marital_status text ('Single','Married','Divorced')
- department text: 'Human Resources', 'Research & Development', 'Sales'
- job_role text: 'Healthcare Representative','Human Resources','Laboratory Technician','Manager',
  'Manufacturing Director','Research Director','Research Scientist','Sales Executive','Sales Representative'
- job_level integer 1-5 (1 = most junior)
- business_travel text: 'Non-Travel','Travel_Rarely','Travel_Frequently'
- distance_from_home integer (1-29)
- education text: 'Below College','College','Bachelor','Master','Doctor'
- education_field text: 'Human Resources','Life Sciences','Marketing','Medical','Other','Technical Degree'
- monthly_income integer, percent_salary_hike integer (11-25), stock_option_level integer 0-3
- over_time boolean
- environment_satisfaction, job_involvement, job_satisfaction, relationship_satisfaction text:
  'Low','Medium','High','Very High'
- work_life_balance text: 'Bad','Good','Better','Best'
- performance_rating text: only 'Excellent' or 'Outstanding' occur
- num_companies_worked, total_working_years, training_times_last_year, years_at_company,
  years_in_current_role, years_since_last_promotion, years_with_curr_manager: integers
- attrition boolean: true = the employee left the company

SECOND TABLE: employee_attrition
- Same rows and column names, but the satisfaction, involvement, work-life balance, education and
  performance columns are numeric codes 1-4 (education 1-5) instead of labels. Use it only when you
  need to do arithmetic on those scores.

RULES FOR THE QUERIES YOU WRITE
1. Percentages: 0-100 scale, ROUND(…, 1). Multiply by 100.0 to avoid integer division.
2. Give columns short, readable aliases. They become chart labels in Metabase.
3. Sort categories in a logical order (bands by their lower bound, levels 1→5), not alphabetically.
4. Add a Metabase field filter for department: write  WHERE {{department}}  (no "department ="),
   placed in a query or CTE that reads FROM employees with NO table alias on that FROM.
5. After the query, explain in 3-5 plain-English bullet points what it does, and give me one
   simple check query (e.g. totals that must add up) so I can verify it.
````

Two parts of this block do most of the work. **Rule 4** makes every query ready to sit on a dashboard with a department filter. **Rule 5** makes the assistant hand you a way to check its work.

## Step 2: Ask for your first analysis

After the context block, ask:

```text
Show headcount, number of leavers and attrition rate for every combination of
department and job level.
```

Copy the query into a new Metabase SQL question.

## Step 3: Connect the department filter

Because of rule 4, the query contains `{{department}}`, and Metabase opens the **Variables** panel:

1. **Variable type** → **Field Filter**.
2. **Field to map to** → **Employees** → **Department**.
3. **Filter widget type** → **String** (or Dropdown). Leave it optional (not required).

Run it with the filter empty (all departments), then pick *Sales*.

A **field filter** is smarter than the text variable from exercise 15. It shows a dropdown with the real values, can select several at once, and when it's empty Metabase removes the condition by itself, so you don't need `[[ ]]`.

> **Common error:** *"missing FROM-clause entry for table employees"*. This means the query gave the table an alias (`FROM employees e`) where the filter is. Field filters need the plain table name. Paste the error back to the assistant and remind it of rule 4.

## Step 4: Check before you trust

Do these checks every time, from now until the end of the course:

1. **Totals add up.** Run the assistant's check query, or your own. With no filter, the headcount column must sum to **1,470** and leavers to **237**.
2. **Spot-check one row by hand** with a simple query you could write in exercise 05:
   `SELECT COUNT(*) FROM employees WHERE department = 'Sales' AND job_level = 1;`
3. **Read the explanation.** Does it describe what *you* asked for? Watch for quietly added filters or a different definition than the one you meant.

## Step 5: Make it readable

Keep it as a **Table**, then open ⚙️ **Settings**:

- On the attrition-rate column, turn on **Show a mini bar chart**.
- **Conditional formatting** → add a rule → **Color range** on the attrition-rate column, white to red.

Save the question as *Attrition by department and level*.

## Check your answers

- 15 rows (3 departments × 5 levels). Headcount sums to 1,470, leavers to 237.
- Highest rate: **Sales, level 1: 42.1%** (32 of 76). Next: Human Resources level 3 at 33.3%, but that's only 6 people.
- R&D level 1 has the most leavers in absolute terms: **101** of 434.

That last point is the first of many places where you should **watch the group size**. A 33% rate across 6 people is two people.

<details>
<summary>Reference query</summary>

```sql
SELECT department,
       job_level                          AS "Job level",
       COUNT(*)                           AS "Headcount",
       COUNT(*) FILTER (WHERE attrition)  AS "Leavers",
       ROUND(100.0 * COUNT(*) FILTER (WHERE attrition) / COUNT(*), 1) AS "Attrition %"
FROM employees
WHERE {{department}}
GROUP BY department, job_level
ORDER BY department, job_level;
```

</details>
