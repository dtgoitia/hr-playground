# hr-playground

PostgreSQL with Metabase on top, run with Docker Compose.

## Setup

1. Copy the example settings and set a password:

   ```sh
   cp .env.example .env
   ```

   Edit `.env` and replace `change-me`. `.env` is git-ignored.

2. Start everything:

   ```sh
   docker compose up -d
   ```

3. Wait about a minute for Metabase to start (`docker compose ps` shows it as
   `healthy`), then open http://localhost:3000 and follow the setup wizard.

## Connecting Metabase to the data

When the wizard asks to add your data, choose **PostgreSQL** and enter:

| Setting  | Value                         |
|----------|-------------------------------|
| Host     | `postgres`                    |
| Port     | `5432`                        |
| Database | value of `POSTGRES_DB` (`hr`) |
| User     | value of `POSTGRES_USER`      |
| Password | value of `POSTGRES_PASSWORD`  |

Use `postgres` as the host, not `localhost`: Metabase reaches the database over
the Compose network.

## Sample data: IBM HR Attrition

The [IBM HR Analytics Employee Attrition](https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset)
dataset (1,470 fictional employees, 35 columns) is in `data/`. Load it with:

```sh
./scripts/load-attrition.sh
```

The script needs the containers running. It recreates the data each time, so it
is safe to re-run. It creates:

- **`employee_attrition`**: the raw CSV, columns renamed to `snake_case`, and
  `Yes`/`No` columns stored as booleans.
- **`employees`**: a view over that table with the 1–4 / 1–5 survey codes
  turned into labels (e.g. job satisfaction `Low` … `Very High`) and the
  constant columns left out. Use this one in Metabase.

The table and view are defined in `sql/attrition.sql`. To fetch the CSV again:

```sh
curl -L -o /tmp/attrition.zip https://www.kaggle.com/api/v1/datasets/download/pavansubhasht/ibm-hr-analytics-attrition-dataset
unzip -o -d data /tmp/attrition.zip
```

After loading, have Metabase pick up the new tables:
**Admin → Databases → (your database) → Sync database schema now**.

## Connecting from your machine

Use `localhost:5432` with the same credentials, for example:

```sh
psql -h localhost -U hr -d hr
```

Or open a shell inside the container:

```sh
docker compose exec postgres psql -U hr -d hr
```

## Everyday commands

```sh
docker compose ps                  # status
docker compose logs -f metabase    # follow Metabase logs
docker compose stop                # stop, keep containers and data
docker compose down                # remove containers, keep data
```

Data lives in the `pgdata` Docker volume, so it survives `down`.
`docker compose down -v` also deletes the volume and **all data**, including
Metabase's dashboards.

## Configuration

All settings are in `.env`:

| Variable            | Default | Notes                              |
|---------------------|---------|------------------------------------|
| `POSTGRES_USER`     | `hr`    |                                    |
| `POSTGRES_PASSWORD` | —       | Required                           |
| `POSTGRES_DB`       | `hr`    | The data database                  |
| `POSTGRES_PORT`     | `5432`  | Host port; change if 5432 is taken |
| `METABASE_PORT`     | `3000`  | Host port; change if 3000 is taken |

The init script and the user/password/database settings only take effect on
the first start with an empty volume. Changing them later does not alter an
existing database.
