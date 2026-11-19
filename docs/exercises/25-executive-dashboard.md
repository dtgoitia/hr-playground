# 25 · Capstone: an executive-ready People analytics dashboard

**You will learn:** to turn a collection of charts into a dashboard leaders actually use: KPI header, linked filters, click-through between charts, a written narrative drafted with the assistant, and a final design review.

## The HR question

> "Next week the leadership team gets the People analytics dashboard. It has to answer the big questions in 30 seconds, and let anyone dig into their own department."

## What you have so far

From exercises 17–24, **People analytics** should have these tabs: **Composition**, **Attrition drivers**, **Pay**, **Engagement**, **Retention**, **Flight risk**. This exercise adds an **Overview** tab as the first tab and makes the whole dashboard work as one.

## Step 1: KPI header

Ask the assistant for **one query per KPI**, each returning a single number and each with the department field filter:

```text
Give me five separate single-value queries for KPI cards:
headcount, leavers, attrition rate %, median monthly income, and the engagement index
(defined as in our earlier conversation: the average of the 5 survey scores rescaled to 0-100).
```

> If you're in a new chat, the assistant doesn't remember "our earlier conversation". Paste the context block **and** your glossary entry from exercise 22. Keeping definitions in one place pays off.

Save each as a **Number** card. On the **Overview** tab, place the five cards in a row across the top. ⚙️ on each card: add a suffix `%` where it applies, and set a sensible number of decimals.

## Step 2: Overview charts

Below the KPIs, re-use saved questions. In edit mode, **Add a chart** → pick them from your collection:

- Attrition rate by department, a bar chart (ask the assistant for it if you don't have it yet).
- The attrition-drivers ranking (exercise 19).
- The retention curve (exercise 23).

## Step 3: Filters that work across the whole dashboard

1. You already have a **Department** filter. In edit mode, open it and make sure it's connected to **every card on every tab**. Cards without the `{{department}}` variable show as "No valid fields", so fix those queries.
2. Add a second filter, **Job role**. For the cards where it makes sense, ask the assistant to add a `{{job_role}}` field filter, then connect it.
3. **Linked filters:** open the Job role filter → **Linked filters** → limit it by **Department**. Picking *Sales* now only offers Sales roles in the Job role dropdown.

## Step 4: Click-through

Make the overview chart drive the filter:

1. Edit the dashboard → hover over the *Attrition rate by department* card → **Click behavior**.
2. Choose **Update a dashboard filter** → *Department* ← the department column.
3. Save. Clicking the *Sales* bar now filters the **whole dashboard**, KPIs included, to Sales.

## Step 5: Narrative with the assistant

Numbers need a story. Export the **aggregated** results of your overview cards (the ⬇ download on each card, or copy the table). Remember: aggregates only, never row-level data. Then ask:

```text
Here are the aggregated results from our HR dashboard: <paste>.
Write a 5-bullet executive summary for a leadership audience: the 3 most important findings,
1 caveat about the data, and 1 recommended next step. Use only numbers that appear in what I pasted.
After the summary, list every number you used and which table it came from.
```

**Check every number** against the dashboard. The "list every number you used" instruction makes this quick. Assistants sometimes round differently or invent a plausible-looking figure. Put the final text in a **Text** card at the top of the Overview tab.

## Step 6: Design review

Take a screenshot of the Overview tab, or describe the layout, and ask the assistant to review it:

```text
Act as a data-visualization reviewer. Here is my HR dashboard layout: <screenshot or description>.
Who is the audience, does the order of the cards follow the story, are any charts the wrong type,
and what would you remove? Be direct.
```

Apply the suggestions you agree with. Common improvements: fewer colours, consistent titles that state the finding ("Overtime triples attrition" rather than "Attrition by overtime"), and the most important chart top-left.

## Check your answers

With **no filter**:

| KPI                   | Value  |
|-----------------------|--------|
| Headcount             | 1,470  |
| Leavers               | 237    |
| Attrition rate        | 16.1%  |
| Median monthly income | 4,919  |
| Engagement index      | 57.7   |

With **Department = Sales** (via the filter or by clicking the bar): headcount **446**, leavers **92**, attrition **20.6%**.

Final test: pick *Research & Development* and open every tab. Every card should change, and none should show an error.

<details>
<summary>Reference queries for the KPI cards</summary>

```sql
SELECT COUNT(*) AS "Headcount"
FROM employees WHERE {{department}};

SELECT COUNT(*) FILTER (WHERE attrition) AS "Leavers"
FROM employees WHERE {{department}};

SELECT ROUND(100.0 * AVG(attrition::int), 1) AS "Attrition %"
FROM employees WHERE {{department}};

SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY monthly_income) AS "Median monthly income"
FROM employees WHERE {{department}};

SELECT ROUND(AVG((environment_satisfaction + job_satisfaction + relationship_satisfaction
                  + job_involvement + work_life_balance - 5) / 15.0 * 100), 1) AS "Engagement index"
FROM employee_attrition WHERE {{department}};

-- Attrition rate by department (for click-through)
SELECT department                               AS "Department",
       ROUND(100.0 * AVG(attrition::int), 1)    AS "Attrition %"
FROM employees
WHERE {{department}}
GROUP BY department
ORDER BY "Attrition %" DESC;
```

To add a job-role filter to any of these, add `AND {{job_role}}` and map the new variable to **Employees → Job Role**.

</details>

## Where to go from here

You can now take an HR question, turn it into a precise request, check the SQL you get back, and present the answer as a dashboard people can explore. With your own organisation's data, the main new thing will be **dates**: hires, exits and changes over time. Everything else you've practised here applies directly.
