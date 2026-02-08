# Feature Specification: Add Business Vault Dimension Joining Activity KPI and Customer

**Feature Branch**: `001-add-bv-dim-activity-kpi-customer`  
**Created**: 2026-02-08  
**Status**: Draft  
**Input**: User description: "Add a new Dimension to the Business vault joining Activity KPI and Customer"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Query Customer Activity KPI Status with Customer Attributes (Priority: P1)

As a data analyst, I want a dimension table that combines customer identity and activity KPI classification so that I can query customer activity status (NAC, RAC, AC, REACT, CHURN) alongside customer attributes (name, registration date, brand, market) without manually joining multiple tables.

**Why this priority**: This is the core purpose of the new dimension -- providing a denormalized, query-friendly view that joins the Activity KPI fact grain with customer descriptive attributes. It eliminates the need for analysts to repeatedly join DIM_CUSTOMER_CURRENT, bridge tables, and the fact table.

**Independent Test**: Can be fully tested by querying the new dimension table and verifying that each row contains both the customer's identifying attributes and their activity KPI classification for a given period. Delivers value by enabling simpler, faster analytical queries.

**Acceptance Scenarios**:

1. **Given** the dimension table is populated for a specific period, **When** I query by a customer ID, **Then** I see the customer's brand, market, and their activity status (NAC/RAC/AC/REACT/CHURN) for that period.
2. **Given** a customer has activity KPI records across multiple periods, **When** I query the dimension, **Then** I see one row per customer per period per level, each with the correct activity classification.
3. **Given** a customer is classified as CHURN in the current period, **When** I query the dimension, **Then** the CHURN flag is set to 1 and the AC flag is set to 0 for that customer-period-level combination.

---

### User Story 2 - Support Downstream Mart and Reporting Joins (Priority: P2)

As a BI developer, I want the new dimension to serve as a reusable join target for downstream mart tables and dashboards so that Activity KPI reports can include customer attributes without complex multi-table joins.

**Why this priority**: Reduces join complexity in mart-layer queries and dashboard definitions. Supports the existing reporting pipeline (QlikSense integration via `BUSMRT_ACTIVITY_KPI`).

**Independent Test**: Can be tested by verifying that a mart-layer query can join to the new dimension using a single foreign key and retrieve customer attributes alongside KPI measures.

**Acceptance Scenarios**:

1. **Given** the new dimension exists and is populated, **When** a mart query joins FACT_CUSTOMER_ACTIVITY_KPI to the new dimension on FK_CUSTOMER, **Then** customer attributes (customer ID, brand, market) are available without additional joins.
2. **Given** the dimension contains current customer snapshot data, **When** a reporting dashboard references it, **Then** the dashboard displays up-to-date customer attributes alongside their activity KPI status.

---

### User Story 3 - Automated Dimension Refresh via Airflow (Priority: P2)

As a data engineer, I want the new dimension to be populated and refreshed automatically as part of the Activity KPI Airflow DAG so that the dimension data stays current without manual intervention.

**Why this priority**: Ensures operational reliability. Without automated refresh, the dimension data would become stale and unreliable for downstream consumers.

**Independent Test**: Can be tested by triggering the Airflow DAG and verifying that the dimension table is populated with current data after the DAG completes.

**Acceptance Scenarios**:

1. **Given** the Airflow DAG runs on its monthly schedule, **When** the dimension processing task executes, **Then** the dimension table is populated with the latest customer attributes joined to the current period's activity KPI classifications.
2. **Given** new customers are added to the Activity KPI fact table, **When** the dimension refresh runs, **Then** the new customers appear in the dimension with their correct attributes and KPI status.

---

### Edge Cases

- What happens when a customer exists in DIM_CUSTOMER_CURRENT but has no Activity KPI records? (The customer should NOT appear in this dimension -- it only contains customers with Activity KPI entries.)
- What happens when a customer is migrated between platforms? (The dimension should reflect the migrated customer's current identity, consistent with how FACT_CUSTOMER_ACTIVITY_KPI handles migrations.)
- What happens when DIM_CUSTOMER_CURRENT is updated between Activity KPI runs? (The dimension reflects the customer snapshot at the time of the dimension refresh, not at the time of the original KPI calculation.)
- What happens for test customers (IS_TEST_CUSTOMER = 1)? (Test customers should be excluded from the dimension, consistent with the fact table's exclusion logic.)

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST provide a new dimension table `DIM_ACTIVITY_KPI_CUSTOMER` in the `BUSINESS_VAULT` schema that joins customer attributes with Activity KPI classifications.
- **FR-002**: The dimension MUST contain one row per unique combination of customer, brand, market, and period at the **Brand aggregation level only**. Product category and product area level Activity KPI data is excluded from this dimension.
- **FR-003**: The dimension MUST include customer identifying attributes sourced from `DIM_CUSTOMER_CURRENT` (customer ID, registration-related attributes, and relevant descriptive fields).
- **FR-004**: The dimension MUST include brand and market identifiers sourced from the existing bridge tables and dimension tables.
- **FR-005**: The dimension MUST include the Activity KPI classification flags (NAC, RAC, AC, REACT, CHURN) from `FACT_CUSTOMER_ACTIVITY_KPI`.
- **FR-006**: The dimension MUST include period information (period type, period date from, period date to).
- **FR-007**: The dimension MUST exclude test customers (where `IS_TEST_CUSTOMER = 1` in `DIM_CUSTOMER_CURRENT`).
- **FR-008**: The dimension MUST follow the existing Business Vault naming conventions: surrogate key (`SK_ACTIVITY_KPI_CUSTOMER`), foreign keys (`FK_` prefix), and metadata columns (`CREATED_AT`, `UPDATED_AT`).
- **FR-009**: The dimension MUST be populated via a stored procedure that can be called from the Activity KPI Airflow DAG.
- **FR-010**: The dimension refresh MUST be idempotent -- re-running for the same period should not create duplicate rows.

### Key Entities

- **DIM_ACTIVITY_KPI_CUSTOMER**: A denormalized dimension joining customer master data with Activity KPI status at the Brand aggregation level. Contains customer identifying attributes (customer ID, brand, market), period information, and KPI classification flags (NAC/RAC/AC/REACT/CHURN). One row per customer-brand-market-period combination.
- **FACT_CUSTOMER_ACTIVITY_KPI** (existing): The source fact table containing Activity KPI calculations. The new dimension references the same customer-period-level grain.
- **DIM_CUSTOMER_CURRENT** (existing): The current customer snapshot providing customer attributes for denormalization into the new dimension.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The dimension table is queryable and returns customer attributes alongside Activity KPI flags for any given period, without requiring additional table joins.
- **SC-002**: Every Brand-level row in `FACT_CUSTOMER_ACTIVITY_KPI` (excluding test customers) has a corresponding row in `DIM_ACTIVITY_KPI_CUSTOMER` after a dimension refresh for that period.
- **SC-003**: The dimension refresh completes within the Airflow DAG's existing execution window (does not add more than 15 minutes to the overall DAG runtime).
- **SC-004**: Re-running the dimension refresh for an already-processed period does not produce duplicate rows.
- **SC-005**: The dimension table follows all existing Business Vault naming conventions and patterns, requiring no special documentation for existing team members to use it.

## Assumptions

- The dimension will be placed in the `activity_kpi` domain within the Business Vault (alongside the existing `DIM_ACTIVITY_KPI_LEVEL` and `DIM_ACTIVITY_KPI_PERIOD`).
- The dimension will source customer attributes from `DIM_CUSTOMER_CURRENT` (the current snapshot), not the historical `DIM_CUSTOMER_HISTORY`.
- The stored procedure for populating the dimension will follow the same JavaScript stored procedure pattern used by `BUSBUS_FACT_CUSTOMER_ACTIVITY_KPI`.
- The Airflow DAG will be updated to include a dimension processing task group that runs before the fact processing task group.
- Surrogate key generation will use the same MD5 hashing pattern as existing tables.
