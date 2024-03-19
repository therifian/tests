import pyodbc
import sqlite3

# Connect to SQL Server database
sql_server_connection = pyodbc.connect('DRIVER={SQL Server};SERVER=your_server;DATABASE=your_database;UID=your_username;PWD=your_password')
sql_server_cursor = sql_server_connection.cursor()

# Extract SQL Server database schema
sql_server_cursor.execute("SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'dbo'")
schema_info = sql_server_cursor.fetchall()

# Convert schema information to SQLite-compatible SQL statements
sqlite_schema_sql = ""
for table_name, column_name, data_type in schema_info:
    sqlite_schema_sql += f"CREATE TABLE {table_name} ({column_name} {data_type}, PRIMARY KEY({column_name}));\n"

# Connect to SQLite database
sqlite_connection = sqlite3.connect('your_sqlite_database.db')
sqlite_cursor = sqlite_connection.cursor()

# Execute SQLite schema creation statements
sqlite_cursor.executescript(sqlite_schema_sql)

# Commit changes and close connections
sqlite_connection.commit()
sqlite_connection.close()
sql_server_connection.close()

print("Schema migration from SQL Server to SQLite completed successfully.")
