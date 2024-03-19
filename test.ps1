# SQL Server connection details
$sqlServerUser = "your_username"
$sqlServerPassword = "your_password"
$sqlServerHost = "your_server"
$sqlServerDatabase = "your_database"

# SQLite database file path
$sqliteDatabaseFile = "your_sqlite_database.db"

# Extract SQL Server database schema and convert it to SQLite-compatible SQL
$sqliteSchemaSql = ""
$query = "SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'dbo'"
$connectionString = "Server=$sqlServerHost;Database=$sqlServerDatabase;User Id=$sqlServerUser;Password=$sqlServerPassword;"
$connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
$command = New-Object System.Data.SqlClient.SqlCommand($query, $connection)
$connection.Open()
$reader = $command.ExecuteReader()

while ($reader.Read()) {
    $tableName = $reader["TABLE_NAME"]
    $columnName = $reader["COLUMN_NAME"]
    $dataType = $reader["DATA_TYPE"]
    $sqliteSchemaSql += "CREATE TABLE $tableName ($columnName $dataType, PRIMARY KEY($columnName));`n"
}

$reader.Close()
$connection.Close()

# Create SQLite database and execute schema SQL
$sqlite = New-Object -TypeName System.Data.SQLite.SQLiteConnection -ArgumentList "Data Source=$sqliteDatabaseFile"
$sqlite.Open()
$sqliteCommand = $sqlite.CreateCommand()
$sqliteCommand.CommandText = $sqliteSchemaSql
$sqliteCommand.ExecuteNonQuery()
$sqlite.Close()

Write-Output "Schema migration from SQL Server to SQLite completed successfully."




# Load environment variables from .env file
$envFile = Get-Content -Path ".env" -Raw
$envVariables = ConvertFrom-StringData -StringData $envFile

# Extract SQL Server connection details from environment variables
$sqlServerUser = $envVariables["SQL_SERVER_USER"]
$sqlServerPassword = $envVariables["SQL_SERVER_PASSWORD"]
$sqlServerHost = $envVariables["SQL_SERVER_HOST"]
$sqlServerDatabase = $envVariables["SQL_SERVER_DATABASE"]

# SQLite database file path
$sqliteDatabaseFile = $envVariables["SQLITE_DATABASE_FILE"]

# Extract SQL Server database schema and convert it to SQLite-compatible SQL
# The rest of the script remains unchanged from the previous version

# Create SQLite database and execute schema SQL
$sqlite = New-Object -TypeName System.Data.SQLite.SQLiteConnection -ArgumentList "Data Source=$sqliteDatabaseFile"
$sqlite.Open()
$sqliteCommand = $sqlite.CreateCommand()
$sqliteCommand.CommandText = $sqliteSchemaSql
$sqliteCommand.ExecuteNonQuery()
$sqlite.Close()

Write-Output "Schema migration from SQL Server to SQLite completed successfully."
