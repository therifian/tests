import sqlite3
import pyodbc

# Function to extract SQL Server database schema
def extract_schema(server, database, username, password):
    conn_str = 'DRIVER={SQL Server};SERVER=' + server + ';DATABASE=' + database + ';UID=' + username + ';PWD=' + password
    conn = pyodbc.connect(conn_str)
    cursor = conn.cursor()

    # Extract tables and their schema
    schema = {}
    cursor.execute("SELECT table_name FROM information_schema.tables WHERE table_type='BASE TABLE'")
    tables = cursor.fetchall()
    for table in tables:
        table_name = table[0]
        cursor.execute(f"SELECT column_name, data_type FROM information_schema.columns WHERE table_name='{table_name}'")
        columns = cursor.fetchall()
        schema[table_name] = columns

    conn.close()
    return schema

# Function to migrate data from SQL Server to SQLite
def migrate_data(server, database, username, password, sqlite_db_path):
    # Extract schema
    schema = extract_schema(server, database, username, password)

    # Connect to SQLite database
    sqlite_conn = sqlite3.connect(sqlite_db_path)
    sqlite_cursor = sqlite_conn.cursor()

    # Create tables in SQLite database
    for table_name, columns in schema.items():
        create_table_query = f"CREATE TABLE {table_name} ("
        for column in columns:
            column_name, data_type = column
            create_table_query += f"{column_name} {data_type}, "
        create_table_query = create_table_query[:-2] + ")"
        sqlite_cursor.execute(create_table_query)

    # Connect to SQL Server database
    conn_str = 'DRIVER={SQL Server};SERVER=' + server + ';DATABASE=' + database + ';UID=' + username + ';PWD=' + password
    conn = pyodbc.connect(conn_str)
    cursor = conn.cursor()

    # Migrate data
    for table_name in schema.keys():
        cursor.execute(f"SELECT * FROM {table_name}")
        rows = cursor.fetchall()
        for row in rows:
            placeholders = ','.join(['?'] * len(row))
            sqlite_cursor.execute(f"INSERT INTO {table_name} VALUES ({placeholders})", row)

    # Commit changes and close connections
    sqlite_conn.commit()
    sqlite_conn.close()
    conn.close()

# Example usage
if __name__ == "__main__":
    server = 'your_sql_server_host'
    database = 'your_sql_server_database'
    username = 'your_sql_server_username'
    password = 'your_sql_server_password'
    sqlite_db_path = 'path_to_your_sqlite_database.db'

    migrate_data(server, database, username, password, sqlite_db_path)
