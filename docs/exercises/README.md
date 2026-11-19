# SQL for HR: exercises

Fifteen exercises that take you from never having written SQL to building an attrition dashboard. They're ordered from easiest to hardest, and each one builds on the one before.

All exercises run in **Metabase** (**+ New → SQL query**) against the `employees` table, which holds the [IBM HR Attrition](https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset) sample data: 1,470 fictional employees. If the table isn't there yet, see "Sample data" in the main README.

Every exercise lists the expected answers, so you can check your work. The full solutions are hidden at the bottom, so try first and peek later.

| #  | Exercise | SQL you'll learn |
|----|----------|------------------|
| 01 | [Your first query](01-your-first-query.md) | `SELECT *`, `FROM`, `LIMIT` |
| 02 | [Choosing columns](02-choosing-columns.md) | column lists, `AS`, arithmetic |
| 03 | [Sorting results](03-sorting-results.md) | `ORDER BY`, `DESC`, top-N lists |
| 04 | [Filtering rows](04-filtering-rows.md) | `WHERE`, `=` `>` `<`…, text and true/false |
| 05 | [Combining conditions](05-combining-conditions.md) | `AND`, `OR`, `IN`, `BETWEEN`, `NOT`, parentheses |
| 06 | [Exploring values and text](06-exploring-values-and-text.md) | `DISTINCT`, `LIKE`, `ILIKE`, `<>` |
| 07 | [Counting: headcount](07-counting.md) | `COUNT(*)`, `COUNT(DISTINCT …)` |
| 08 | [Sums and averages](08-sums-and-averages.md) | `SUM`, `AVG`, `MIN`, `MAX`, `ROUND` |
| 09 | [GROUP BY and charts](09-group-by-and-charts.md) | `GROUP BY`, Metabase charts |
| 10 | [Multiple groups and HAVING](10-multiple-groups-and-having.md) | grouping by 2 columns, `HAVING` |
| 11 | [Attrition rate](11-attrition-rate.md) | percentages, `FILTER`, the whole-number trap |
| 12 | [Bands with CASE](12-bands-with-case.md) | `CASE WHEN`, age, tenure and income bands |
| 13 | [Subqueries](13-subqueries.md) | comparing against averages, `IN (SELECT …)` |
| 14 | [WITH and JOIN](14-with-and-join.md) | `WITH`, `JOIN`, pay vs. role average |
| 15 | [Reusable report and dashboard](15-reusable-report-and-dashboard.md) | Metabase variables `{{ }}`, `[[ ]]`, dashboards |
