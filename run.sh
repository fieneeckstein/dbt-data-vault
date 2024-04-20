#!/bin/sh

# PostgreSQL Verbindungsparameter
DB_HOST="localhost"
DB_PORT="5432"
DB_NAME="bikerental"
DB_USER="*****"
DB_PASSWORD="******"

# Pfad zum SQL-Skript
SQL_SCRIPT_1=".\data_scripts\init-dump.sql"

# Verbindung zur Datenbank herstellen und SQL-Skript ausführen
PGPASSWORD="$DB_PASSWORD" psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -w -f $SQL_SCRIPT_1

# Aktiviere virtuelle Umgebung dbt-vault-env
source ./dbt-vault/dbt-vault-venv/Scripts/activate
# Navigate to project directory
cd ./dbt-vault/dbt_vault_tutorial

# (Connection Debugging)
dbt debug

dbt deps

# Drop all existing tables and recreate them RUN_1
echo "Starting scenario 1"
dbt run --full-refresh --vars "{star_date: 2023-12-12, load_date: 2024-01-01}"

dbt test --select "run_1.*"

read -p "Press enter to continue with the next scenario"

echo "Starting scenario 2"
# Drop all existing tables and recreate them RUN_2
dbt run --full-refresh --vars "{star_date: 2024-01-31, load_date: 2024-01-01}"

dbt test --select "run_2.*"
read -p "Press enter to continue with the next scenario"

echo "Starting scenario 3"
SQL_SCRIPT_3="..\..\data_scripts\run3.sql"
PGPASSWORD="$DB_PASSWORD" psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -w -f $SQL_SCRIPT_3
dbt run --vars "{star_date: 2024-01-03, load_date: 2024-01-02}"
dbt test --select "run_3.*"
read -p "Press enter to continue with the next scenario"

echo "Starting scenario 4"
SQL_SCRIPT_4="..\..\data_scripts\run4.sql"
PGPASSWORD="$DB_PASSWORD" psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -w -f $SQL_SCRIPT_4
dbt run --vars "{star_date: 2024-01-07, load_date: 2024-01-06}"
dbt test --select "run_4.*"
read -p "You have completed all scenarios. Press enter to exit"


