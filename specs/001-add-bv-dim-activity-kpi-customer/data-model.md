# Data Model: DIM_ACTIVITY_KPI_CUSTOMER

**Branch**: `001-add-bv-dim-activity-kpi-customer`
**Date**: 2026-02-08

## Entity Relationship Diagram

```mermaid
erDiagram
    DIM_ACTIVITY_KPI_CUSTOMER {
        BINARY SK_ACTIVITY_KPI_CUSTOMER PK "MD5 composite key"
        BINARY FK_CUSTOMER FK "FK to DIM_CUSTOMER_CURRENT"
        VARCHAR CUSTOMER_ID "Business key"
        BINARY FK_BRAND FK "FK to DIM_BRAND"
        VARCHAR BRAND_ID "Brand business key"
        BINARY FK_MARKET FK "FK to DIM_CUSTOMER_MARKET"
        VARCHAR MARKET_ID "Market business key"
        BINARY FK_ACTIVITY_KPI_PERIOD FK "FK to DIM_ACTIVITY_KPI_PERIOD"
        DATE PERIOD_DATE_FROM_CET "Period start date CET"
        DATE PERIOD_DATE_TO_CET "Period end date CET"
        NUMBER NAC "New Active Customer 0 or 1"
        NUMBER RAC "Returning Active Customer 0 or 1"
        NUMBER AC "Active Customer 0 or 1"
        NUMBER REACT "Reactivated Customer 0 or 1"
        NUMBER CHURN "Churned Customer 0 or 1"
        BOOLEAN IS_MIGRATED_ROW "Migrated customer flag"
        TIMESTAMP_LTZ CREATED_AT "Record creation timestamp"
        TIMESTAMP_LTZ UPDATED_AT "Last update timestamp"
    }

    DIM_CUSTOMER_CURRENT {
        BINARY SK_CUSTOMER PK
        VARCHAR CUSTOMER_ID
        BOOLEAN IS_TEST_CUSTOMER
    }

    DIM_BRAND {
        BINARY SK_BRAND PK
        VARCHAR BRAND_ID
    }

    DIM_CUSTOMER_MARKET {
        BINARY SK_CUSTOMER_MARKET PK
        VARCHAR MARKET_ID
    }

    DIM_ACTIVITY_KPI_PERIOD {
        BINARY SK_ACTIVITY_KPI_PERIOD PK
        VARCHAR PERIOD_NAME
    }

    FACT_CUSTOMER_ACTIVITY_KPI {
        BINARY SK_CUSTOMER_ACTIVITY_KPI PK
        BINARY FK_CUSTOMER FK
        BINARY FK_BRAND FK
        BINARY FK_MARKET FK
        BINARY FK_ACTIVITY_KPI_PERIOD FK
        BINARY FK_ACTIVITY_KPI_LEVEL FK
        NUMBER NAC
        NUMBER RAC
        NUMBER AC
        NUMBER REACT
        NUMBER CHURN
        BOOLEAN IS_MIGRATED_ROW
    }

    DIM_ACTIVITY_KPI_CUSTOMER ||--o{ DIM_CUSTOMER_CURRENT : "FK_CUSTOMER"
    DIM_ACTIVITY_KPI_CUSTOMER ||--o{ DIM_BRAND : "FK_BRAND"
    DIM_ACTIVITY_KPI_CUSTOMER ||--o{ DIM_CUSTOMER_MARKET : "FK_MARKET"
    DIM_ACTIVITY_KPI_CUSTOMER ||--o{ DIM_ACTIVITY_KPI_PERIOD : "FK_ACTIVITY_KPI_PERIOD"
    DIM_ACTIVITY_KPI_CUSTOMER }o--|| FACT_CUSTOMER_ACTIVITY_KPI : "populated from Brand-level rows"
```

## Table Definition: DIM_ACTIVITY_KPI_CUSTOMER

### Columns

| # | Column | Type | Nullable | Description | Source |
|---|--------|------|----------|-------------|--------|
| 1 | SK_ACTIVITY_KPI_CUSTOMER | BINARY | NOT NULL | Surrogate key (composite MD5) | Generated |
| 2 | FK_CUSTOMER | BINARY | NOT NULL | FK to DIM_CUSTOMER_CURRENT.SK_CUSTOMER | FACT_CUSTOMER_ACTIVITY_KPI.FK_CUSTOMER |
| 3 | CUSTOMER_ID | VARCHAR | NOT NULL | Customer business key | DIM_CUSTOMER_CURRENT.CUSTOMER_ID |
| 4 | FK_BRAND | BINARY | NOT NULL | FK to DIM_BRAND.SK_BRAND | FACT_CUSTOMER_ACTIVITY_KPI.FK_BRAND |
| 5 | BRAND_ID | VARCHAR | NOT NULL | Brand business key | DIM_BRAND.BRAND_ID |
| 6 | FK_MARKET | BINARY | NOT NULL | FK to DIM_CUSTOMER_MARKET | FACT_CUSTOMER_ACTIVITY_KPI.FK_MARKET |
| 7 | MARKET_ID | VARCHAR | NOT NULL | Market business key | DIM_CUSTOMER_MARKET.MARKET_ID |
| 8 | FK_ACTIVITY_KPI_PERIOD | BINARY | NOT NULL | FK to DIM_ACTIVITY_KPI_PERIOD | FACT_CUSTOMER_ACTIVITY_KPI.FK_ACTIVITY_KPI_PERIOD |
| 9 | PERIOD_DATE_FROM_CET | DATE | NOT NULL | Period start date (CET) | FACT_CUSTOMER_ACTIVITY_KPI.PERIOD_DATE_FROM_CET |
| 10 | PERIOD_DATE_TO_CET | DATE | NOT NULL | Period end date (CET) | FACT_CUSTOMER_ACTIVITY_KPI.PERIOD_DATE_TO_CET |
| 11 | NAC | NUMBER(38,0) | NOT NULL | New Active Customer flag (0/1) | FACT_CUSTOMER_ACTIVITY_KPI.NAC |
| 12 | RAC | NUMBER(38,0) | NOT NULL | Returning Active Customer flag (0/1) | FACT_CUSTOMER_ACTIVITY_KPI.RAC |
| 13 | AC | NUMBER(38,0) | NOT NULL | Active Customer flag (0/1) | FACT_CUSTOMER_ACTIVITY_KPI.AC |
| 14 | REACT | NUMBER(38,0) | NOT NULL | Reactivated Customer flag (0/1) | FACT_CUSTOMER_ACTIVITY_KPI.REACT |
| 15 | CHURN | NUMBER(38,0) | NOT NULL | Churned Customer flag (0/1) | FACT_CUSTOMER_ACTIVITY_KPI.CHURN |
| 16 | IS_MIGRATED_ROW | BOOLEAN | | Migrated customer flag | FACT_CUSTOMER_ACTIVITY_KPI.IS_MIGRATED_ROW |
| 17 | CREATED_AT | TIMESTAMP_LTZ(9) | NOT NULL | Record creation timestamp | SYSDATE() |
| 18 | UPDATED_AT | TIMESTAMP_LTZ(9) | | Last update timestamp | NULL on insert |

### Surrogate Key Generation

```sql
MD5(UPPER(ARRAY_TO_STRING(ARRAY_CONSTRUCT(
    TRIM(UPPER(CUSTOMER_ID)),
    TRIM(UPPER(BRAND_ID)),
    TRIM(UPPER(MARKET_ID)),
    TRIM(UPPER(PERIOD_NAME)),
    PERIOD_DATE_FROM_CET,
    PERIOD_DATE_TO_CET
),'^')))::BINARY AS SK_ACTIVITY_KPI_CUSTOMER
```

### Row Filter (Brand Level Only)

```sql
WHERE FK_ACTIVITY_KPI_LEVEL = MD5(UPPER('Brand'))::BINARY
  AND CC.IS_TEST_CUSTOMER = 0
```

### Source Query Pattern

```sql
SELECT
    -- Surrogate key (composite MD5)
    MD5(UPPER(ARRAY_TO_STRING(ARRAY_CONSTRUCT(
        TRIM(UPPER(CC.CUSTOMER_ID)),
        TRIM(UPPER(B.BRAND_ID)),
        TRIM(UPPER(CM.MARKET_ID)),
        TRIM(UPPER(P.PERIOD_NAME)),
        F.PERIOD_DATE_FROM_CET,
        F.PERIOD_DATE_TO_CET
    ),'^')))::BINARY AS SK_ACTIVITY_KPI_CUSTOMER,
    -- Customer attributes
    F.FK_CUSTOMER,
    CC.CUSTOMER_ID,
    -- Brand attributes
    F.FK_BRAND,
    B.BRAND_ID,
    -- Market attributes
    F.FK_MARKET,
    CM.MARKET_ID,
    -- Period attributes
    F.FK_ACTIVITY_KPI_PERIOD,
    F.PERIOD_DATE_FROM_CET,
    F.PERIOD_DATE_TO_CET,
    -- KPI flags
    F.NAC,
    F.RAC,
    F.AC,
    F.REACT,
    F.CHURN,
    F.IS_MIGRATED_ROW,
    -- Metadata
    SYSDATE() AS CREATED_AT,
    NULL AS UPDATED_AT
FROM BUSINESS_VAULT.FACT_CUSTOMER_ACTIVITY_KPI F
INNER JOIN BUSINESS_VAULT.DIM_CUSTOMER_CURRENT CC 
    ON CC.SK_CUSTOMER = F.FK_CUSTOMER
INNER JOIN BUSINESS_VAULT.DIM_BRAND B 
    ON B.SK_BRAND = F.FK_BRAND
INNER JOIN BUSINESS_VAULT.BRIDGE_CUSTOMER_CUSTOMER_MARKET BCCM 
    ON BCCM.FK_CUSTOMER = F.FK_CUSTOMER 
    AND BCCM.IS_CURRENT
INNER JOIN BUSINESS_VAULT.DIM_CUSTOMER_MARKET CM 
    ON CM.SK_CUSTOMER_MARKET = BCCM.FK_CUSTOMER_MARKET
INNER JOIN BUSINESS_VAULT.DIM_ACTIVITY_KPI_PERIOD P 
    ON P.SK_ACTIVITY_KPI_PERIOD = F.FK_ACTIVITY_KPI_PERIOD
WHERE F.FK_ACTIVITY_KPI_LEVEL = MD5(UPPER('Brand'))::BINARY
    AND CC.IS_TEST_CUSTOMER = 0
    AND F.PERIOD_DATE_FROM_CET = $CURR_PERIOD_DATE_FROM
    AND F.PERIOD_DATE_TO_CET = $CURR_PERIOD_DATE_TO
    AND F.FK_ACTIVITY_KPI_PERIOD = MD5(UPPER($PERIOD_LEVEL_STRING))::BINARY
```

## Data Flow Diagram

```mermaid
flowchart TD
    subgraph Sources["Source Tables (Read)"]
        FACT["FACT_CUSTOMER_ACTIVITY_KPI<br/>(Brand level rows only)"]
        DCC["DIM_CUSTOMER_CURRENT<br/>(Customer attributes)"]
        DB["DIM_BRAND<br/>(Brand ID)"]
        BCCM["BRIDGE_CUSTOMER_CUSTOMER_MARKET<br/>(Customer-Market link)"]
        DCM["DIM_CUSTOMER_MARKET<br/>(Market ID)"]
        DAP["DIM_ACTIVITY_KPI_PERIOD<br/>(Period name)"]
    end

    PROC["BUSBUS_DIM_ACTIVITY_KPI_CUSTOMER<br/>(Stored Procedure)"]

    DIM["DIM_ACTIVITY_KPI_CUSTOMER<br/>(Target Dimension)"]

    FACT --> PROC
    DCC --> PROC
    DB --> PROC
    BCCM --> PROC
    DCM --> PROC
    DAP --> PROC
    PROC --> DIM

    style Sources fill:#E3F2FD,stroke:#1565C0,color:#000
    style PROC fill:#FFF3E0,stroke:#E65100,color:#000
    style DIM fill:#E8F5E9,stroke:#2E7D32,color:#000
```

## Validation Rules

1. **Uniqueness**: `SK_ACTIVITY_KPI_CUSTOMER` must be unique (guaranteed by composite MD5 of natural key)
2. **Completeness**: Every Brand-level row in FACT_CUSTOMER_ACTIVITY_KPI (excluding test customers) must have a corresponding row in DIM_ACTIVITY_KPI_CUSTOMER after refresh
3. **Exclusivity**: KPI flags are mutually exclusive groupings per the fact table logic (NAC+AC, RAC+AC, REACT+AC, or CHURN alone)
4. **Test customer exclusion**: No rows where DIM_CUSTOMER_CURRENT.IS_TEST_CUSTOMER = 1
