-- IBM HR Analytics Employee Attrition (Kaggle: pavansubhasht/ibm-hr-analytics-attrition-dataset)
-- Recreates the table; scripts/load-attrition.sh fills it from the CSV.

SET client_min_messages = warning;

DROP VIEW IF EXISTS employees;
DROP TABLE IF EXISTS employee_attrition;

CREATE TABLE employee_attrition (
    age                          integer NOT NULL,
    attrition                    boolean NOT NULL,  -- Yes/No: did the employee leave
    business_travel              text    NOT NULL,
    daily_rate                   integer NOT NULL,
    department                   text    NOT NULL,
    distance_from_home           integer NOT NULL,
    education                    integer NOT NULL,  -- 1-5, see employees view
    education_field              text    NOT NULL,
    employee_count               integer NOT NULL,  -- always 1
    employee_number              integer PRIMARY KEY,
    environment_satisfaction     integer NOT NULL,  -- 1-4
    gender                       text    NOT NULL,
    hourly_rate                  integer NOT NULL,
    job_involvement              integer NOT NULL,  -- 1-4
    job_level                    integer NOT NULL,
    job_role                     text    NOT NULL,
    job_satisfaction             integer NOT NULL,  -- 1-4
    marital_status               text    NOT NULL,
    monthly_income               integer NOT NULL,
    monthly_rate                 integer NOT NULL,
    num_companies_worked         integer NOT NULL,
    over_18                      boolean NOT NULL,  -- always Y
    over_time                    boolean NOT NULL,
    percent_salary_hike          integer NOT NULL,
    performance_rating           integer NOT NULL,  -- 1-4
    relationship_satisfaction    integer NOT NULL,  -- 1-4
    standard_hours               integer NOT NULL,  -- always 80
    stock_option_level           integer NOT NULL,
    total_working_years          integer NOT NULL,
    training_times_last_year     integer NOT NULL,
    work_life_balance            integer NOT NULL,  -- 1-4
    years_at_company             integer NOT NULL,
    years_in_current_role        integer NOT NULL,
    years_since_last_promotion   integer NOT NULL,
    years_with_curr_manager      integer NOT NULL
);

-- Same data with the numeric survey codes turned into the labels from the
-- dataset description, and the constant columns left out. Easier to chart
-- and to ask Metabase's AI about.
CREATE VIEW employees AS
SELECT
    employee_number,
    age,
    gender,
    marital_status,
    department,
    job_role,
    job_level,
    business_travel,
    distance_from_home,
    CASE education WHEN 1 THEN 'Below College' WHEN 2 THEN 'College'
        WHEN 3 THEN 'Bachelor' WHEN 4 THEN 'Master' WHEN 5 THEN 'Doctor' END AS education,
    education_field,
    monthly_income,
    percent_salary_hike,
    stock_option_level,
    over_time,
    CASE environment_satisfaction WHEN 1 THEN 'Low' WHEN 2 THEN 'Medium'
        WHEN 3 THEN 'High' WHEN 4 THEN 'Very High' END AS environment_satisfaction,
    CASE job_involvement WHEN 1 THEN 'Low' WHEN 2 THEN 'Medium'
        WHEN 3 THEN 'High' WHEN 4 THEN 'Very High' END AS job_involvement,
    CASE job_satisfaction WHEN 1 THEN 'Low' WHEN 2 THEN 'Medium'
        WHEN 3 THEN 'High' WHEN 4 THEN 'Very High' END AS job_satisfaction,
    CASE relationship_satisfaction WHEN 1 THEN 'Low' WHEN 2 THEN 'Medium'
        WHEN 3 THEN 'High' WHEN 4 THEN 'Very High' END AS relationship_satisfaction,
    CASE work_life_balance WHEN 1 THEN 'Bad' WHEN 2 THEN 'Good'
        WHEN 3 THEN 'Better' WHEN 4 THEN 'Best' END AS work_life_balance,
    CASE performance_rating WHEN 1 THEN 'Low' WHEN 2 THEN 'Good'
        WHEN 3 THEN 'Excellent' WHEN 4 THEN 'Outstanding' END AS performance_rating,
    num_companies_worked,
    total_working_years,
    training_times_last_year,
    years_at_company,
    years_in_current_role,
    years_since_last_promotion,
    years_with_curr_manager,
    attrition
FROM employee_attrition;
