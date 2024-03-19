const sql = require('mssql');
const sqlite3 = require('sqlite3').verbose();

// SQL Server connection config
const sqlServerConfig = {
  user: 'your_username',
  password: 'your_password',
  server: 'your_server',
  database: 'your_database',
  options: {
    trustedConnection: true // For Windows authentication
  }
};

// SQLite database file path
const sqliteDBPath = 'your_sqlite_database.db';

async function migrateSchema() {
  try {
    // Connect to SQL Server
    await sql.connect(sqlServerConfig);

    // Extract SQL Server database schema
    const result = await sql.query("SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'dbo'");
    const schemaInfo = result.recordset;

    // Connect to SQLite database
    const sqliteDB = new sqlite3.Database(sqliteDBPath);

    // Convert schema information to SQLite-compatible SQL statements
    let sqliteSchemaSql = '';
    schemaInfo.forEach(({ TABLE_NAME, COLUMN_NAME, DATA_TYPE }) => {
      sqliteSchemaSql += `CREATE TABLE ${TABLE_NAME} (${COLUMN_NAME} ${DATA_TYPE}, PRIMARY KEY(${COLUMN_NAME}));\n`;
    });

    // Execute SQLite schema creation statements
    sqliteDB.exec(sqliteSchemaSql, (err) => {
      if (err) {
        console.error('Error executing SQLite schema:', err);
      } else {
        console.log('Schema migration from SQL Server to SQLite completed successfully.');
      }
      // Close SQLite database connection
      sqliteDB.close();
    });

  } catch (err) {
    console.error('Error migrating schema:', err);
  } finally {
    // Close SQL Server connection
    sql.close();
  }
}

// Execute migration
migrateSchema();
