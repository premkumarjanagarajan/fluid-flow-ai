# Quickstart: DIM_ACTIVITY_KPI_CUSTOMER

**Branch**: `001-add-bv-dim-activity-kpi-customer`
**Date**: 2026-02-08

## Prerequisites

- Access to the `data-snowflake-dwh-dev` repository
- Access to the `data-airflow-dags-dev` repository
- Snowflake BUSINESS_VAULT schema write permissions
- Existing tables populated: FACT_CUSTOMER_ACTIVITY_KPI, DIM_CUSTOMER_CURRENT, DIM_BRAND, DIM_CUSTOMER_MARKET, DIM_ACTIVITY_KPI_PERIOD, BRIDGE_CUSTOMER_CUSTOMER_MARKET

## Implementation Order

### 1. Create the dimension table DDL

**Repository**: `data-snowflake-dwh-dev`
**Path**: `business_vault/activity_kpi/tables/DIM_ACTIVITY_KPI_CUSTOMER/`

Create two files:
- `V{TIMESTAMP}_1__TBL_DIM_ACTIVITY_KPI_CUSTOMER.sql` - CREATE TABLE statement
- `U{TIMESTAMP}_1__TBL_DIM_ACTIVITY_KPI_CUSTOMER.sql` - DROP TABLE (undo)

### 2. Create the stored procedure

**Repository**: `data-snowflake-dwh-dev`
**Path**: `business_vault/activity_kpi/procs/BUSBUS_DIM_ACTIVITY_KPI_CUSTOMER/`

Create two files:
- `V{TIMESTAMP}_3__PROC__BUSBUS_DIM_ACTIVITY_KPI_CUSTOMER.sql` - CREATE PROCEDURE
- `U{TIMESTAMP}_3__PROC__BUSBUS_DIM_ACTIVITY_KPI_CUSTOMER.sql` - DROP PROCEDURE (undo)

### 3. Update Airflow DAG

**Repository**: `data-airflow-dags-dev`
**Path**: `activity_kpi/`

- Create `taskgroup_02_bus_dims.py` - New dimension task group (numbered `02` to run AFTER facts `01`)
- Modify `activity_kpi_dag.py` - Wire dimension task group after facts task group

### 4. Validate

Run these validation queries after deployment:

```sql
-- Check row count matches Brand-level fact rows (excluding test customers)
SELECT 
    'FACT' AS source, COUNT(*) AS row_count
FROM BUSINESS_VAULT.FACT_CUSTOMER_ACTIVITY_KPI F
INNER JOIN BUSINESS_VAULT.DIM_CUSTOMER_CURRENT CC ON CC.SK_CUSTOMER = F.FK_CUSTOMER
WHERE F.FK_ACTIVITY_KPI_LEVEL = MD5(UPPER('Brand'))::BINARY
    AND CC.IS_TEST_CUSTOMER = 0
UNION ALL
SELECT 
    'DIM' AS source, COUNT(*) AS row_count
FROM BUSINESS_VAULT.DIM_ACTIVITY_KPI_CUSTOMER;

-- Check no test customers leaked in
SELECT COUNT(*) AS test_customer_count
FROM BUSINESS_VAULT.DIM_ACTIVITY_KPI_CUSTOMER D
INNER JOIN BUSINESS_VAULT.DIM_CUSTOMER_CURRENT CC ON CC.SK_CUSTOMER = D.FK_CUSTOMER
WHERE CC.IS_TEST_CUSTOMER = 1;

-- Check no duplicate surrogate keys
SELECT SK_ACTIVITY_KPI_CUSTOMER, COUNT(*) AS cnt
FROM BUSINESS_VAULT.DIM_ACTIVITY_KPI_CUSTOMER
GROUP BY SK_ACTIVITY_KPI_CUSTOMER
HAVING COUNT(*) > 1;

-- Sample data check
SELECT * FROM BUSINESS_VAULT.DIM_ACTIVITY_KPI_CUSTOMER
ORDER BY CREATED_AT DESC
LIMIT 10;
```

## Rollback

1. Drop the dimension table: `DROP TABLE IF EXISTS BUSINESS_VAULT.DIM_ACTIVITY_KPI_CUSTOMER;`
2. Drop the procedure: `DROP PROCEDURE IF EXISTS BUSINESS_VAULT.BUSBUS_DIM_ACTIVITY_KPI_CUSTOMER(STRING);`
3. Revert Airflow DAG changes (remove taskgroup_02_bus_dims.py, revert activity_kpi_dag.py)
