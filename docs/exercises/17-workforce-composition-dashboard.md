# 17 · Workforce composition: a population pyramid and your first dashboard

**You will learn:** to tell the assistant **which chart you want**, so it shapes the data for that chart. You'll also start the *People analytics* dashboard you'll keep building until exercise 25.

## The HR question

> "Show the leadership team what our workforce looks like: age and gender profile, gender balance per department, and education mix."

## Why this is harder

Each chart needs data in a particular shape. A population pyramid, for example, is a horizontal bar chart where men go **left** and women go **right**. The usual trick is to make one side **negative**. The assistant knows tricks like this, but only if you say which chart you're building.

## Step 1: Ask the assistant

Start a new chat with the context block from exercise 16, then ask for three queries:

```text
I'm building three charts in Metabase.

1. A population pyramid: 5-year age bands (18-24, 25-29, 30-34 … 55-60) on the vertical
   axis, male headcount extending to the left and female to the right. Give me one row per
   band, with the male count as a NEGATIVE number so the chart diverges.
2. Gender balance per department, for a 100% stacked bar: one row per department with
   female and male headcount as two columns.
3. Headcount by education level, ordered from 'Below College' to 'Doctor'.
```

## Step 2: Check the answers

- **Pyramid**: 8 rows. Men + women across all bands must equal **1,470**. Remember that the male numbers are negative, so add their absolute values.
- Spot-check a band by hand, e.g. `SELECT gender, COUNT(*) FROM employees WHERE age BETWEEN 30 AND 34 GROUP BY gender;`
- **Education**: is the order logical, or alphabetical (Bachelor, Below College, College…)? If it's alphabetical, tell the assistant: *"order by education level, not alphabetically"*.

## Step 3: Build the charts

**Pyramid**
1. Visualization → **Row** (horizontal bars).
2. ⚙️ **Data**: Y-axis = age band; series = the male and female columns.
3. ⚙️ **Display** → **Stack**. The negative male bars grow left and the female bars grow right.
4. Give the series clear names and colours (e.g. "Men", "Women").

**Gender balance**: Visualization → **Bar** → ⚙️ Display → **Stack – 100%**. Each department becomes one bar split by percentage.

**Education mix**: Visualization → **Pie** (Metabase draws it as a donut, with the total in the middle).

## Step 4: Start the dashboard

1. Save each question. When Metabase offers, **add it to a new dashboard** called **People analytics**.
2. In the dashboard, rename the first tab **Composition** (click the tab name in edit mode). Later exercises add more tabs.
3. Add a **Heading** card ("Workforce composition") and arrange the cards: pyramid large on the left, the two smaller charts on the right.
4. Add a **dashboard filter** → **Text or Category** → *Department*, and connect it to the three cards. Because each query has `{{department}}`, the cards offer it as a target. **Save**.

## Check your answers

| Age band | Men | Women |
|----------|-----|-------|
| 18-24    | 60  | 37    |
| 25-29    | 146 | 83    |
| 30-34    | 191 | 134   |
| 35-39    | 180 | 117   |
| 40-44    | 129 | 79    |
| 45-49    | 76  | 65    |
| 50-54    | 56  | 48    |
| 55-60    | 44  | 25    |

- Share of women: Sales **42.4%**, R&D **39.4%**, Human Resources **31.7%**.
- Education: Bachelor 572, Master 398, College 282, Below College 170, Doctor 48.

<details>
<summary>Reference queries</summary>

```sql
-- 1. Population pyramid
SELECT CASE
           WHEN age < 25 THEN '18-24' WHEN age < 30 THEN '25-29'
           WHEN age < 35 THEN '30-34' WHEN age < 40 THEN '35-39'
           WHEN age < 45 THEN '40-44' WHEN age < 50 THEN '45-49'
           WHEN age < 55 THEN '50-54' ELSE '55-60'
       END                                           AS "Age band",
       -COUNT(*) FILTER (WHERE gender = 'Male')      AS "Men",
       COUNT(*) FILTER (WHERE gender = 'Female')     AS "Women"
FROM employees
WHERE {{department}}
GROUP BY 1
ORDER BY MIN(age) DESC;   -- oldest at the top, like a classic pyramid

-- 2. Gender balance per department
SELECT department,
       COUNT(*) FILTER (WHERE gender = 'Female') AS "Women",
       COUNT(*) FILTER (WHERE gender = 'Male')   AS "Men"
FROM employees
WHERE {{department}}
GROUP BY department
ORDER BY department;

-- 3. Education mix
SELECT education          AS "Education",
       COUNT(*)           AS "Headcount"
FROM employees
WHERE {{department}}
GROUP BY education
ORDER BY CASE education
             WHEN 'Below College' THEN 1 WHEN 'College' THEN 2
             WHEN 'Bachelor' THEN 3 WHEN 'Master' THEN 4 ELSE 5
         END;
```

`ORDER BY CASE …` is a handy pattern: it sorts text values in any custom order you define.

</details>
