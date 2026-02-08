# Workspace Detection Results

**Feature**: 001-add-bv-dim-activity-kpi-customer
**Date**: 2026-02-08T07:24:30Z

## Workspace State
- **Existing Code**: Yes
- **Programming Languages**: SQL (Snowflake), Python (Airflow DAGs)
- **Build System**: Timestamp-based SQL migration files, Apache Airflow
- **Project Structure**: Multi-repository Data Vault 2.0 data warehouse
- **Workspace Root**: /Users/clde01/Library/CloudStorage/OneDrive-BetssonGroup/documents/projects/development/
- **Project Type**: Brownfield

## Multi-Workspace Layout
- `fluid-flow/` - Workflow/documentation repository (this repo)
- `data-snowflake-dwh-dev/` - Snowflake SQL DDL/DML (Data Vault layers)
- `data-airflow-dags-dev/` - Apache Airflow DAGs (ETL orchestration)

## Data Warehouse Architecture
- **Database**: Snowflake
- **Modeling**: Data Vault 2.0 with Business Vault layer
- **Layers**: raw_staging → staging → operational_vault → business_vault → marts → realtime
- **Business Vault**: ~5,605 SQL files across domains (customer, payments, gaming, sportsbook, wallet, activity_kpi, etc.)

## Relevant Existing Structures

### Activity KPI Domain (`business_vault/activity_kpi/`)
- `DIM_ACTIVITY_KPI_LEVEL` - Activity KPI level dimension
- `DIM_ACTIVITY_KPI_PERIOD` - Activity KPI period dimension
- `FACT_CUSTOMER_ACTIVITY_KPI` - Customer activity KPI fact table
- `BUSBUS_FACT_CUSTOMER_ACTIVITY_KPI` - Stored procedure for fact processing

### Customer Domain (`business_vault/customer/`)
- `DIM_CUSTOMER` - Main customer dimension (SK_CUSTOMER, CUSTOMER_ID, descriptive attributes)
- `DIM_CUSTOMER_ACTIVITY` - Customer activity dimension
- Multiple other customer dimensions (history, segmentation, etc.)

### No existing `DIM_ACTIVITY_KPI_CUSTOMER` found

## Naming Conventions
- Dimensions: `DIM_[ENTITY]`
- Facts: `FACT_[ENTITY]`
- Surrogate keys: `SK_` prefix (BINARY type)
- Foreign keys: `FK_` prefix
- Migration files: `U[timestamp]_[version]__[type]_[name].sql` / `V[timestamp]_[version]__[type]_[name].sql`
- Metadata columns: `CREATED_AT`, `UPDATED_AT` (TIMESTAMP_LTZ(9))

## Code Location Rules
- **Application Code**: Workspace root (NEVER in specs/)
- **Feature Documentation**: specs/001-add-bv-dim-activity-kpi-customer/ only
- **Project-Level Artifacts**: specs/_project/ only
