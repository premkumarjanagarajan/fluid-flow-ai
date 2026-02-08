# Research: DIM_ACTIVITY_KPI_CUSTOMER

**Branch**: `001-add-bv-dim-activity-kpi-customer`
**Date**: 2026-02-08

## Research Summary

No major unknowns or NEEDS CLARIFICATION items remained after the specification phase. The following research was conducted to inform implementation decisions.

---

## R1: Dimension Grain and Surrogate Key Composition

**Decision**: Brand-level grain with composite surrogate key derived from CUSTOMER_ID + BRAND_ID + MARKET_ID + PERIOD_NAME + PERIOD_DATE_FROM + PERIOD_DATE_TO

**Rationale**: The user specified Brand level only (Option A). The SK components mirror the natural key of the fact table at Brand level, ensuring 1:1 correspondence between Brand-level fact rows and dimension rows. Using the same hashing pattern (`MD5(UPPER(ARRAY_TO_STRING(ARRAY_CONSTRUCT(...),'^')))::BINARY`) maintains consistency with the existing codebase.

**Alternatives considered**:
- Single SK based on FK_CUSTOMER + FK_ACTIVITY_KPI_PERIOD + period dates: Rejected because it would not uniquely identify the Brand-Market combination
- Using IDENTITY/SEQUENCE for SK: Rejected because all existing tables use MD5-based surrogate keys

---

## R2: Customer Attributes to Include

**Decision**: Include a focused set of customer identifying and classification attributes from DIM_CUSTOMER_CURRENT, not the full 91-column set.

**Rationale**: Including all 91 columns would create an unnecessarily wide table that duplicates DIM_CUSTOMER_CURRENT. The dimension should include attributes most useful for Activity KPI analysis: customer identification (CUSTOMER_ID), key classification attributes, and the KPI flags. Analysts needing the full customer profile can join back to DIM_CUSTOMER_CURRENT using FK_CUSTOMER.

**Attributes selected**:
- `CUSTOMER_ID` - Business key for human-readable identification
- `FK_CUSTOMER` - Surrogate key for joins to DIM_CUSTOMER_CURRENT
- `FK_BRAND` / `BRAND_ID` - Brand identification
- `FK_MARKET` / `MARKET_ID` - Market identification
- Period information (FK_ACTIVITY_KPI_PERIOD, PERIOD_DATE_FROM_CET, PERIOD_DATE_TO_CET)
- KPI flags (NAC, RAC, AC, REACT, CHURN)
- `IS_MIGRATED_ROW` - Migration tracking

**Alternatives considered**:
- Full DIM_CUSTOMER_CURRENT denormalization (91 columns): Rejected - too wide, creates maintenance burden
- Minimal (FK_CUSTOMER + KPI flags only): Rejected - loses the primary value of the dimension (avoiding joins for common attributes)

---

## R3: Population Strategy (INSERT vs MERGE)

**Decision**: Use DELETE + INSERT pattern for dimension refresh, scoped to the specific period being processed.

**Rationale**: The dimension is a snapshot that should reflect the current state of both the fact table and DIM_CUSTOMER_CURRENT. A MERGE would preserve stale customer attributes from previous runs. DELETE + INSERT for the specific period ensures the dimension always has the latest customer attributes. The idempotency check (whether the period has already been processed) can optionally skip re-processing, or the DELETE + INSERT approach makes re-processing safe by default.

**Alternatives considered**:
- MERGE (upsert): Rejected - stale customer attributes would persist if a customer's details change in DIM_CUSTOMER_CURRENT
- Full table rebuild: Rejected - too slow for large datasets, and unnecessary when only the current period needs updating
- INSERT only (with pre-check): Considered viable, similar to fact table pattern. The pre-check ensures idempotency.

**Final approach**: Check if period already processed (like the fact proc). If not processed, INSERT new rows. If re-processing is needed, provide a parameter or manual DELETE before re-running.

---

## R4: Airflow DAG Integration Pattern

**Decision**: Create `taskgroup_00_bus_dims.py` with naming convention `00` to ensure it sorts before `01` (facts), and wire it as a dependency in `activity_kpi_dag.py`.

**Rationale**: Other domains (e.g., payments) use a `taskgroup_NN_bus_dims.py` pattern where dimensions are processed before facts. Using `00` ensures correct ordering. The dimension must be populated AFTER the fact table (since it reads from FACT_CUSTOMER_ACTIVITY_KPI), so the actual Airflow dependency should be: `facts_done >> dims_start`, not the other way around.

**IMPORTANT CORRECTION**: Unlike typical dimension-before-fact patterns, this dimension reads FROM the fact table. Therefore the dependency order is: **facts first, then dimension**.

**Alternatives considered**:
- Running dimension in parallel with facts: Rejected - dimension depends on fact data
- Adding tasks directly to taskgroup_01_bus_facts.py: Rejected - violates separation of concerns
- Creating a post-processing task group: Considered, but the `taskgroup_00` naming with adjusted dependency is cleaner
