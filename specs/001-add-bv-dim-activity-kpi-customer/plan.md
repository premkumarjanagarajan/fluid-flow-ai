# Implementation Plan: DIM_ACTIVITY_KPI_CUSTOMER

**Branch**: `001-add-bv-dim-activity-kpi-customer` | **Date**: 2026-02-08 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `specs/001-add-bv-dim-activity-kpi-customer/spec.md`

## Summary

Add a new denormalized dimension table `DIM_ACTIVITY_KPI_CUSTOMER` to the `BUSINESS_VAULT` schema that joins customer master data from `DIM_CUSTOMER_CURRENT` with Activity KPI classification flags (NAC/RAC/AC/REACT/CHURN) from `FACT_CUSTOMER_ACTIVITY_KPI` at the Brand aggregation level. The dimension will be populated via a new JavaScript stored procedure and integrated into the existing Activity KPI Airflow DAG.

## Technical Context

**Language/Version**: SQL (Snowflake dialect), JavaScript (Snowflake stored procedures), Python 3.x (Airflow DAGs)
**Primary Dependencies**: Snowflake BUSINESS_VAULT schema, Apache Airflow, DoubleTemplatedBashOperator
**Storage**: Snowflake - BUSINESS_VAULT schema (existing)
**Testing**: Manual SQL validation queries (consistent with existing patterns - no automated test framework in place)
**Target Platform**: Snowflake cloud data warehouse
**Project Type**: Multi-repository data warehouse (SQL DDL/DML + Airflow DAGs)
**Performance Goals**: Dimension refresh completes within 15 minutes (per SC-003)
**Constraints**: Must follow existing Data Vault 2.0 patterns, MD5 surrogate keys, V/U migration file convention
**Scale/Scope**: Brand-level grain only; estimated row count = number of unique customer-brand-market-period combinations in FACT_CUSTOMER_ACTIVITY_KPI where FK_ACTIVITY_KPI_LEVEL = MD5(UPPER('Brand'))::BINARY

## Constitution Check

*GATE: Constitution is a template (not project-specific). No constitution gates apply.*

No violations identified. This feature:
- Follows existing architectural patterns (Data Vault 2.0 Business Vault)
- Introduces no new technologies
- Uses established naming conventions and key generation patterns
- Does not modify existing tables or procedures

## Project Structure

### Documentation (this feature)

```text
specs/001-add-bv-dim-activity-kpi-customer/
├── spec.md              # Feature specification (complete)
├── plan.md              # This file
├── research.md          # Phase 0 output - technical research
├── data-model.md        # Phase 1 output - data model design
├── quickstart.md        # Phase 1 output - implementation quickstart
├── checklists/
│   └── requirements.md  # Specification quality checklist (complete)
├── state.md             # Feature state tracking
├── audit.md             # Audit trail
└── workspace-detection.md # Workspace detection results
```

### Source Code (across repositories)

```text
# data-snowflake-dwh-dev repository
business_vault/activity_kpi/
├── tables/
│   ├── DIM_ACTIVITY_KPI_CUSTOMER/          # NEW: Dimension table DDL
│   │   ├── V{TIMESTAMP}_1__TBL_DIM_ACTIVITY_KPI_CUSTOMER.sql   # CREATE TABLE
│   │   └── U{TIMESTAMP}_1__TBL_DIM_ACTIVITY_KPI_CUSTOMER.sql   # Undo (DROP TABLE)
│   ├── DIM_ACTIVITY_KPI_LEVEL/             # Existing
│   ├── DIM_ACTIVITY_KPI_PERIOD/            # Existing
│   └── FACT_CUSTOMER_ACTIVITY_KPI/         # Existing (unchanged)
└── procs/
    ├── BUSBUS_DIM_ACTIVITY_KPI_CUSTOMER/   # NEW: Stored procedure
    │   ├── V{TIMESTAMP}_3__PROC__BUSBUS_DIM_ACTIVITY_KPI_CUSTOMER.sql   # CREATE PROCEDURE
    │   └── U{TIMESTAMP}_3__PROC__BUSBUS_DIM_ACTIVITY_KPI_CUSTOMER.sql   # Undo (DROP PROCEDURE)
    └── BUSBUS_FACT_CUSTOMER_ACTIVITY_KPI/  # Existing (unchanged)

# data-airflow-dags-dev repository
activity_kpi/
├── activity_kpi_dag.py                     # MODIFIED: Add dimension task group dependency
├── taskgroup_00_bus_dims.py                # NEW: Dimension processing task group
└── taskgroup_01_bus_facts.py               # Existing (unchanged)
```

**Structure Decision**: Follows existing domain-based directory structure. New SQL files placed in `business_vault/activity_kpi/tables/DIM_ACTIVITY_KPI_CUSTOMER/` and `business_vault/activity_kpi/procs/BUSBUS_DIM_ACTIVITY_KPI_CUSTOMER/`. Airflow DAG updated to add a dimension task group before the existing facts task group.

## Implementation Approach

### Step 1: DDL - Create DIM_ACTIVITY_KPI_CUSTOMER Table

Create the dimension table following existing patterns:
- Surrogate key: `SK_ACTIVITY_KPI_CUSTOMER` using `MD5(UPPER(ARRAY_TO_STRING(ARRAY_CONSTRUCT(CUSTOMER_ID, BRAND_ID, MARKET_ID, PERIOD_NAME, PERIOD_DATE_FROM_CET, PERIOD_DATE_TO_CET),'^')))::BINARY`
- Foreign keys to existing dimensions (logical, no constraints)
- Customer attributes denormalized from `DIM_CUSTOMER_CURRENT`
- Activity KPI flags from `FACT_CUSTOMER_ACTIVITY_KPI` (Brand level only)
- Standard metadata columns (`CREATED_AT`, `UPDATED_AT`)

### Step 2: Stored Procedure - BUSBUS_DIM_ACTIVITY_KPI_CUSTOMER

Create a JavaScript stored procedure following the same pattern as `BUSBUS_FACT_CUSTOMER_ACTIVITY_KPI`:
- Input parameter: `PERIOD_LEVEL` (STRING) - 'MONTHLY' or '3_MONTHS_ROLLING'
- Idempotent: Check if period already processed before inserting
- Source data: JOIN `FACT_CUSTOMER_ACTIVITY_KPI` (Brand level) with `DIM_CUSTOMER_CURRENT`
- Exclude test customers (`IS_TEST_CUSTOMER = 0`)
- Use MERGE or DELETE+INSERT pattern for updates

### Step 3: Airflow DAG - Add Dimension Task Group

Create `taskgroup_00_bus_dims.py` following the pattern from other domains (e.g., payments):
- Task: Call `BUSBUS_DIM_ACTIVITY_KPI_CUSTOMER` for MONTHLY
- Task: Call `BUSBUS_DIM_ACTIVITY_KPI_CUSTOMER` for 3_MONTHS_ROLLING
- Update `activity_kpi_dag.py` to wire: `dims_done >> facts_start`

### Step 4: Undo Scripts

Create U (undo) migration files for rollback:
- Table: `DROP TABLE IF EXISTS BUSINESS_VAULT.DIM_ACTIVITY_KPI_CUSTOMER;`
- Procedure: `DROP PROCEDURE IF EXISTS BUSINESS_VAULT.BUSBUS_DIM_ACTIVITY_KPI_CUSTOMER(STRING);`

## Complexity Tracking

No constitution violations. No complexity justifications needed.
