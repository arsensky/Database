--- Basic COPY syntax:
-- Export data to file
COPY table_name TO '/path/to/file.csv' WITH CSV HEADER;
-- Import data from file
COPY table_name FROM '/path/to/file.csv' WITH CSV HEADER;

--- Advanced COPY options:
-- Export with custom delimiter and null representation
COPY employees TO '/tmp/employees.txt'
WITH DELIMITER '|' NULL 'N/A' CSV HEADER;
-- Import specific columns only
COPY employees(first_name, last_name, email)
FROM '/tmp/new_employees.csv' WITH CSV HEADER;
-- Export query results
COPY (SELECT * FROM employees WHERE department = 'IT')
TO '/tmp/it_employees.csv' WITH CSV HEADER;

--- CSV Export Examples:
-- Basic CSV export with headers
COPY products TO '/tmp/products.csv' WITH CSV HEADER;
-- CSV export with custom quote character and delimiter
COPY customers TO '/tmp/customers.csv'
WITH CSV HEADER DELIMITER ';' QUOTE '"';
-- Export with custom date format
COPY orders TO '/tmp/orders.csv'
WITH CSV HEADER FORCE_QUOTE (order_date);

--- CSV Import Examples:
-- Basic CSV import (assuming table already exists)
COPY products FROM '/tmp/products.csv' WITH CSV HEADER;
-- Import with error handling - skip bad rows
COPY products FROM '/tmp/products_with_errors.csv'
WITH CSV HEADER ON_ERROR IGNORE;
-- Import with specific encoding
COPY products FROM '/tmp/products_utf8.csv'
WITH CSV HEADER ENCODING 'UTF8';

--- Handling special cases:
-- Deal with embedded commas and quotes
COPY customer_feedback TO '/tmp/feedback.csv'
WITH CSV HEADER DELIMITER ',' QUOTE '"' ESCAPE '"';
-- Custom NULL representation
COPY sales_data FROM '/tmp/sales.csv'
WITH CSV HEADER NULL 'NULL';

--- pg_dump - Creating backups:
-- Basic database backup to SQL file
pg_dump -h localhost -U username -d database_name > backup.sql
-- Compressed custom format backup (recommended)
pg_dump -h localhost -U username -d database_name -Fc > backup.dump
-- Backup specific tables only
pg_dump -h localhost -U username -d database_name -t employees -t departments > tables_backup.sql
-- Backup with verbose output
pg_dump -h localhost -U username -d database_name -Fc -v > backup.dump

--- pg_restore - Restoring backups:
-- Restore from custom format
pg_restore -h localhost -U username -d target_database backup.dump
-- Restore to a new database (create database first)
createdb new_database
pg_restore -h localhost -U username -d new_database backup.dump
-- Restore specific tables only
pg_restore -h localhost -U username -d database_name -t employees backup.dump
-- Restore with parallel jobs for faster performance
pg_restore -h localhost -U username -d database_name -j 4 backup.dump
*/

--- Advanced pg_dump options:
-- Schema-only backup
pg_dump -h localhost -U username -d database_name -s > schema_only.sql
-- Data-only backup
pg_dump -h localhost -U username -d database_name -a > data_only.sql
-- Exclude specific tables
pg_dump -h localhost -U username -d database_name -T log_table -T temp_data > backup_without_logs.sql

--- Creating full backups:
-- Full backup with all databases on the server
pg_dumpall -h localhost -U postgres > full_cluster_backup.sql
-- Full backup of single database with all objects
pg_dump -h localhost -U username -d production_db -Fc --verbose > full_production_backup.dump
-- Full backup with ownership information preserved
pg_dump -h localhost -U username -d database_name -Fc -O > backup_with_ownership.dump

--- Automated backup script example:
#!/bin/bash
-- Daily backup script
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backups/postgresql"
DB_NAME="production_db"

pg_dump -h localhost -U backup_user -d $DB_NAME -Fc > "$BACKUP_DIR/${DB_NAME}_${DATE}.dump"

-- Keep only last 7 days of backups
find $BACKUP_DIR -name "${DB_NAME}_*.dump" -mtime +7 -delete

--- Backup validation:
-- Test backup integrity
pg_restore --list backup.dump

-- Verify backup can be restored (to test database)
createdb test_restore
pg_restore -d test_restore backup.dump

---- Incremental Backups
--- Setting up continuous archiving:
-- Enable WAL archiving in postgresql.conf
archive_mode = on
archive_command = 'cp %p /backup/wal/%f'
wal_level = replica

-- Creating base backup:
-- Create base backup using pg_basebackup
pg_basebackup -h localhost -U replication_user -D /backup/base -Ft -z -P
-- Create base backup with WAL files included
pg_basebackup -h localhost -U replication_user -D /backup/base -x -P

-- WAL archive management:
-- Manual WAL file archiving
pg_switch_wal();  -- Force WAL segment switch

-- Archive cleanup (remove old WAL files)
pg_archivecleanup /backup/wal 000000010000000000000010

--- PITR setup requirements:
-- Required configuration in postgresql.conf
wal_level = replica
archive_mode = on
archive_command = 'cp %p /backup/wal/%f'
restore_command = 'cp /backup/wal/%f %p'

-- Performing PITR:
-- 1. Stop PostgreSQL server
sudo systemctl stop postgresql

-- 2. Remove current data directory
rm -rf /var/lib/postgresql/data/ *

-- 3. Restore base backup
tar -xf /backup/base/base.tar -C /var/lib/postgresql/data/

-- 4. Create recovery configuration
cat > /var/lib/postgresql/data/recovery.signal << EOF
restore_command = 'cp /backup/wal/%f %p'
recovery_target_time = '2024-01-15 14:30:00'
EOF

-- 5. Start PostgreSQL (recovery will begin automatically)
sudo systemctl start postgresql

-- Recovery targeting options:
-- Recovery to specific time
recovery_target_time = '2024-01-15 14:30:00'

-- Recovery to specific transaction
recovery_target_xid = '12345'

-- Recovery to named restore point
recovery_target_name = 'before_data_migration'

-- Create named restore point
SELECT pg_create_restore_point('before_data_migration');

---- Data Migration Strategies
--- Strategy 1: Dump and Restore (Simple Migration)
-- Source database dump
pg_dump -h source_host -U username -d source_db -Fc > migration.dump

-- Target database restore
pg_restore -h target_host -U username -d target_db migration.dump

--- Strategy 2: Logical Replication (Minimal Downtime)
-- On source database: Create publication
CREATE PUBLICATION migration_pub FOR ALL TABLES;

-- On target database: Create subscription
CREATE SUBSCRIPTION migration_sub
CONNECTION 'host=source_host dbname=source_db user=replication_user'
PUBLICATION migration_pub;

--- Strategy 3: Physical Replication (Zero Downtime)
-- Set up streaming replication
-- In postgresql.conf on primary
wal_level = replica
max_wal_senders = 3

-- Create standby using pg_basebackup
pg_basebackup -h primary_host -D /var/lib/postgresql/standby -U replication_user -R -P

--- Strategy 4: ETL Pipeline Migration
-- Create staging tables
CREATE TABLE staging_customers AS SELECT * FROM customers WHERE 1=0;

-- Extract data in batches
COPY (SELECT * FROM customers LIMIT 10000 OFFSET 0)
TO '/tmp/customers_batch_1.csv' WITH CSV HEADER;

-- Transform and load
COPY staging_customers FROM '/tmp/customers_batch_1.csv' WITH CSV HEADER;

-- Validate and merge
INSERT INTO target_customers
SELECT * FROM staging_customers
ON CONFLICT (customer_id) DO UPDATE SET ...;

---- Migration best practices:
--- Pre-migration checklist
-- 1. Verify source data integrity
SELECT COUNT(*) FROM source_table;

-- 2. Test migration on smaller dataset
pg_dump -h source -U user -d db -t small_table | psql -h target -U user -d db

-- 3. Monitor migration progress
SELECT pid, usename, application_name, client_addr, state
FROM pg_stat_activity
WHERE application_name = 'pg_dump';

-- 4. Post-migration validation
SELECT COUNT(*) FROM target_table;

---- Handling large table migrations:
-- Partition large tables for easier migration
CREATE TABLE large_table_2023 PARTITION OF large_table
FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

-- Migrate partitions individually
pg_dump -h source -U user -d db -t large_table_2023 | psql -h target -U user -d db