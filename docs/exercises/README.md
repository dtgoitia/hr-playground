# SQL for HR: exercises

Twenty-five exercises in two parts, ordered from easiest to hardest. Each one builds on the one before.

- **Part 1 (01–15): SQL from scratch.** You write every query yourself, from your first `SELECT` to a simple dashboard.
- **Part 2 (16–25): HR analytics with an AI assistant.** You describe the analysis to a web-based assistant (Claude, ChatGPT…), check the SQL it writes, and build a multi-tab *People analytics* dashboard in Metabase.

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

## Part 2: HR analytics with an AI assistant

| #  | Exercise | Working with the assistant | Metabase |
|----|----------|----------------------------|----------|
| 16 | [Working with an AI assistant](16-working-with-an-llm.md) | context block, privacy, checking output | field filters, mini bars, conditional formatting |
| 17 | [Workforce composition](17-workforce-composition-dashboard.md) | asking for chart-shaped data | population pyramid, 100% stacked bar, dashboard tabs |
| 18 | [Attrition heatmap](18-attrition-heatmap.md) | cross-tabs, line-by-line explanations | heatmap table, grouped bars |
| 19 | [Ranking attrition drivers](19-attrition-drivers-ranking.md) | plan before SQL, `UNION ALL`, lift | row chart with goal line |
| 20 | [Gender pay gap](20-gender-pay-gap.md) | challenging conclusions, medians, Simpson's paradox | combo chart, two axes |
| 21 | [Compa-ratio](21-compa-ratio-and-pay-positioning.md) | fixing errors by pasting them back | histogram, scatter plot |
| 22 | [Engagement index](22-engagement-index.md) | agreeing metric definitions first | gauge, glossary text card |
| 23 | [Retention curve](23-retention-curve.md) | verifying complex logic step by step, window functions | line/combo, progress card |
| 24 | [Flight-risk score](24-flight-risk-score.md) | ethics and fairness review, `RANK() OVER` | action list, 100% stacked bar |
| 25 | [Executive dashboard](25-executive-dashboard.md) | narratives from aggregates, design review | KPIs, linked filters, click behavior |
