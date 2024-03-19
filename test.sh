#!/bin/bash

# SQL Server connection details
sql_server_user="your_username"
sql_server_password="your_password"
sql_server_host="your_server"
sql_server_database="your_database"

# SQLite database file path
sqlite_db_file="your_sqlite_database.db"

# Extract SQL Server database schema and convert it to SQLite-compatible SQL
sqlite_schema_sql=""
while IFS= read -r line; do
    table_name=$(echo "$line" | cut -d '|' -f 1)
    column_name=$(echo "$line" | cut -d '|' -f 2)
    data_type=$(echo "$line" | cut -d '|' -f 3)
    sqlite_schema_sql+="CREATE TABLE $table_name ($column_name $data_type, PRIMARY KEY($column_name));\n"
done < <(echo "SELECT TABLE_NAME || '|' || COLUMN_NAME || '|' || DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'dbo';" | sqlcmd -S "$sql_server_host" -U "$sql_server_user" -P "$sql_server_password" -d "$sql_server_database" -h-1 -s'|')

# Create SQLite database and execute schema SQL
sqlite3 "$sqlite_db_file" <<EOF
$sqlite_schema_sql
EOF

echo "Schema migration from SQL Server to SQLite completed successfully."
