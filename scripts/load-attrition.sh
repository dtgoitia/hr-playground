#!/bin/sh
# Load the IBM HR Attrition CSV into the running Postgres container.
# Safe to re-run: the table is dropped and recreated each time.
set -eu
cd "$(dirname "$0")/.."

CSV=data/WA_Fn-UseC_-HR-Employee-Attrition.csv
[ -f .env ] && . ./.env
DB_USER=${POSTGRES_USER:-hr}
DB_NAME=${POSTGRES_DB:-hr}

if [ ! -f "$CSV" ]; then
    echo "Missing $CSV. Download the dataset from Kaggle and unzip it into data/." >&2
    exit 1
fi

psql() { docker compose exec -T postgres psql -v ON_ERROR_STOP=1 -q -U "$DB_USER" -d "$DB_NAME" "$@"; }

psql < sql/attrition.sql
psql -c "\copy employee_attrition FROM STDIN WITH (FORMAT csv, HEADER true)" < "$CSV"
psql -At -c "SELECT count(*) || ' rows loaded into employee_attrition' FROM employee_attrition"
