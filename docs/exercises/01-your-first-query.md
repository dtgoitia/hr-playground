# 01 · Your first query

**You will learn:** what SQL is, how to open Metabase's SQL editor, and how to look at a table.

## What is SQL?

A database stores data in **tables**. A table works like a spreadsheet tab: each **row** is one record (here, one employee) and each **column** is one piece of information (age, department, salary…).

**SQL** (often said "sequel") is the language you use to ask a database questions. You write a question, called a **query**, and the database answers with a table of results. Running a query never changes the data, so you can't break anything by experimenting.

Our database has a table called **`employees`**, which lists 1,470 fictional employees of a company.

## Open the SQL editor in Metabase

1. In Metabase, click **+ New** (top right) → **SQL query**.
2. If Metabase asks which database to use, pick your HR database.
3. Type your query in the big text box.
4. Run it with the blue **▶ (Run)** button, or press **Ctrl + Enter** (**Cmd + Enter** on a Mac).

The results appear below the editor.

## Example

```sql
SELECT *
FROM employees
LIMIT 10;
```

Read it like a sentence: "**select** all columns (`*` means everything) **from** the employees table, but **limit** the answer to 10 rows".

- `SELECT` says *what* you want to see.
- `FROM` says *where* to get it from.
- `LIMIT` caps how many rows come back. This is handy when you just want a peek.
- The `;` at the end marks the end of the query. Metabase doesn't require it, but it's a good habit.

SQL doesn't care about upper or lower case in its keywords (`select` works too) or about line breaks. By convention, people write keywords in CAPITALS and put each part on its own line so queries are easy to read.

## Your turn

1. Run the example query above. Scroll right to see all the columns.
2. Change it to show only **3** rows.
3. Remove the `LIMIT 10` line entirely and run it again. How many rows are in the table? Metabase shows the count just below the results.
4. There is a second table, `employee_attrition`, which holds the same data in its raw form. Look at 5 rows of it and compare. What's different about columns like `job_satisfaction`?

## Check your answers

- Task 3: **1,470** rows.
- Task 4: in `employee_attrition`, the satisfaction columns are numbers (1–4). In `employees` they are labels (`Low`, `Medium`, `High`, `Very High`). We'll use `employees` from now on.

<details>
<summary>Solutions</summary>

```sql
-- Task 2
SELECT *
FROM employees
LIMIT 3;

-- Task 3
SELECT *
FROM employees;

-- Task 4
SELECT *
FROM employee_attrition
LIMIT 5;
```

Lines that start with `--` are **comments**. The database ignores them, so you can use them for notes to yourself.

</details>
