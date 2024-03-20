const sqlite3 = require('sqlite3').verbose();
const sql = require('mssql');

// Configuration for SQL Server
const sqlServerConfig = {
    user: 'your_sql_server_username',
    password: 'your_sql_server_password',
    server: 'your_sql_server_host',
    database: 'your_sql_server_database',
    options: {
        encrypt: true, // If you are connecting to Microsoft Azure SQL Database, you need this
        enableArithAbort: true // If you are using SQL Server 2019 or newer, you need this
    }
};

// SQLite database path
const sqliteDbPath = 'path_to_your_sqlite_database.db';

// Function to migrate data from SQL Server to SQLite
async function migrateData() {
    try {
        // Connect to SQL Server
        await sql.connect(sqlServerConfig);

        // Extract tables and their schema
        const result = await sql.query(`SELECT table_name FROM information_schema.tables WHERE table_type='BASE TABLE'`);
        const tables = result.recordset;

        // Connect to SQLite database
        const sqliteDb = new sqlite3.Database(sqliteDbPath);

        // Migrate data for each table
        for (const table of tables) {
            const tableName = table.table_name;
            const { recordset } = await sql.query(`SELECT * FROM ${tableName}`);
            const columns = Object.keys(recordset[0]).join(', ');
            const placeholders = recordset.map(row => '(' + Object.values(row).map(val => '?' ).join(', ') + ')').join(', ');

            // Create table in SQLite
            sqliteDb.run(`CREATE TABLE ${tableName} (${columns})`);

            // Insert data into SQLite
            const stmt = sqliteDb.prepare(`INSERT INTO ${tableName} VALUES (${placeholders})`);
            for (const row of recordset) {
                stmt.run(Object.values(row));
            }
            stmt.finalize();
        }

        // Close connections
        sqliteDb.close();
        await sql.close();
        console.log('Data migration completed successfully.');
    } catch (err) {
        console.error('Error migrating data:', err);
    }
}

// Call the function to start migration
migrateData();
