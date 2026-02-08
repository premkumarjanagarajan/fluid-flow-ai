# Requirements Document: UC20 - Bonus Abuser Detection ML Model

**Branch**: 003-uc20-bonus-abuser-detection
**Date**: 2026-02-08
**Depth**: Comprehensive
**Status**: Draft - Pending Verification

---

## Intent Analysis

| Attribute | Value |
|-----------|-------|
| **Request Type** | New Project (Greenfield ML System) |
| **Request Clarity** | Detailed - Comprehensive requirements provided from Confluence, JIRA analysis, and meeting transcription |
| **Scope Estimate** | Cross-system - ML pipeline, API service, batch/real-time scoring, integrations with 3+ external systems |
| **Complexity Estimate** | Complex - Multiple stakeholders, regulatory constraints, infrastructure provisioning, ML lifecycle management |
| **Domain** | Risk & Fraud - Bonus Abuse Detection in Online Gaming |
| **Jurisdiction** | Multi-jurisdictional (Peru primary pilot, Argentina, global expansion) |
| **Domain Criticality** | High - Revenue protection, regulatory compliance, customer experience impact |
| **Regulatory Surface** | Fund confiscation laws vary by jurisdiction; data protection for customer financial/behavioral data |

---

## 1. Business Context

### 1.1 Problem Statement

Fraudulent players systematically abuse promotional bonuses by exploiting system blind spots and breaking terms and conditions. They employ sophisticated tactics including multi-accounting, device fingerprint manipulation, chip-dumping, arbitrage betting, and coordinated gameplay patterns to claim bonuses and successfully withdraw funds.

**Current State:**
- Risk and Fraud team manually reviews suspicious withdrawals across multiple platforms and tabs
- ~200 bonus abusers detected per month through manual review
- Detection is primarily reactive rather than proactive
- 85% of withdrawals process automatically, allowing abusers to extract funds before manual review
- 12,000+ historical bonus-related customer records flagged since 2016
- Peru and Argentina identified as core markets with high abuse volumes

### 1.2 Business Objectives

| # | Objective | Baseline | Target | Measurement |
|---|-----------|----------|--------|-------------|
| OBJ-001 | Increase bonus abuser detection rate | ~200/month | +20% minimum within 3 months of deployment | Monthly detection count |
| OBJ-002 | Increase confiscated funds from confirmed abusers | Current baseline TBD | Measurable increase, reported monthly | Total confiscated value |
| OBJ-003 | Reduce manual review time | Current manual process | Automated pattern detection reduces review burden | Time per case, cases per analyst |
| OBJ-004 | Enable proactive detection | Reactive only | Flag high-risk customers before withdrawal | Time-to-flag metric |

### 1.3 Key Stakeholders

| Role | Names | Responsibility |
|------|-------|---------------|
| Risk Team | Mark Camilleri, Annabel Pisani, Valera Pelekhov | Manual fraud investigation, domain expertise, pattern identification |
| AI & ML Team | Anastasios Kachrimanis, Kyra Fenech | Model development, training, evaluation, deployment |
| Product/Business | Marvin Zammit, Monique Mifsud, Jamie Frendo, Daniel Soler | Success criteria, roadmap, stakeholder alignment |
| Architects | Terence Zarb | Technical architecture decisions |
| Payment Operations | Vadym Biliuga | Payment product integration |

### 1.4 Timeline & Phased Approach

| Phase | Timeline | Scope |
|-------|----------|-------|
| Q1 2026 | Jan-Mar 2026 | Discovery phase: data understanding, data preparation (CRISP-DM steps 1-3) |
| Q2 2026 | Apr-May 2026 | Model training, evaluation, infrastructure setup |
| MVP Launch | Before June 11, 2026 (World Cup) | Batch predictions for one market (Peru), infrastructure ready end of May |
| Future Phases | Post-MVP | Real-time scoring, multi-market expansion, A/B testing |

---

## 2. Functional Requirements

### 2.1 Core ML Model Requirements

| Req # | Requirement | Priority | Status | Source |
|-------|-------------|----------|--------|--------|
| FR-001 | The ML model must output a probability score (0-1) indicating the likelihood of bonus abuse for each customer/withdrawal | High | Agreed | REQ-002 |
| FR-002 | The model must provide explainability (top 5 contributing factors with importance scores) for each prediction | High | Agreed | REQ-003 |
| FR-003 | The system must flag customers with abuse probability > 0.8 as high-risk for immediate review | High | Agreed | REQ-004 |
| FR-004 | The model must detect multi-accounting by correlating device fingerprints, IP addresses, and user agent strings | High | Agreed | REQ-006 |
| FR-005 | The model must detect sportsbook-to-casino bouncing patterns indicating bonus hunting behavior | Medium | Agreed | REQ-008 |
| FR-006 | The model must detect consistent bet sizing patterns as potential abuse indicators | Medium | Agreed | REQ-017 |
| FR-007 | The model must identify chip-dumping patterns in poker games through transaction analysis | Medium | Clarification Needed | REQ-007 |
| FR-008 | The model must handle cold-start scenarios for new customers with limited behavioral history | Medium | Clarification Needed | REQ-019 |
| FR-009 | The model must identify which specific abuse pattern triggered the alert (multi-accounting, opposite betting, chip-dumping) with confidence scores | High | Agreed | UC-015 |

### 2.2 Batch Processing Requirements

| Req # | Requirement | Priority | Status | Source |
|-------|-------------|----------|--------|--------|
| FR-010 | The system must support batch predictions for daily withdrawal reviews | High | Agreed | REQ-009 |
| FR-011 | The model must be able to process and score at least 1,000 withdrawals per day in batch mode | High | Agreed | REQ-020 |
| FR-012 | The batch prediction pipeline must execute on a configurable schedule (daily minimum) | High | Agreed | REQ-009 |

### 2.3 API Requirements

| Req # | Requirement | Priority | Status | Source |
|-------|-------------|----------|--------|--------|
| FR-013 | The system must provide an API endpoint for retrieving model predictions and explainability | High | Agreed | REQ-021 |
| FR-014 | The API must support querying predictions by customer ID, withdrawal ID, or device fingerprint | Medium | Agreed | REQ-018, UC-011 |
| FR-015 | Device fingerprint search must return all customers using that fingerprint with timestamps and activity summary within 5 seconds | Medium | Agreed | UC-011 |

### 2.4 Data & Training Requirements

| Req # | Requirement | Priority | Status | Source |
|-------|-------------|----------|--------|--------|
| FR-016 | The model must be trained on high-resolution transaction data from Snowflake | High | Agreed | REQ-013 |
| FR-017 | The model must leverage historical data from 12,000+ labeled bonus-related customer records since 2016 | High | Agreed | REQ-024 |
| FR-018 | The model training pipeline must complete within 24 hours including data preparation and validation | Medium | Agreed | REQ-022 |
| FR-019 | The system must retrain the model periodically to adapt to evolving fraud patterns | High | Agreed | REQ-012 |
| FR-020 | The system must store historical predictions and outcomes for model evaluation and audit purposes | High | Agreed | REQ-016 |

### 2.5 Integration Requirements

| Req # | Requirement | Priority | Status | Source |
|-------|-------------|----------|--------|--------|
| FR-021 | The system must integrate with existing withdrawal review tools (WCPS, BAQ) | High | Clarification Needed | REQ-015 |
| FR-022 | The system must integrate with Group-IB for device fingerprint data | High | Agreed | REQ-006 |
| FR-023 | The system must support real-time scoring for proactive detection (future phase) | Low | Pending | REQ-010 |

### 2.6 Jurisdictional & Business Rules

| Req # | Requirement | Priority | Status | Source |
|-------|-------------|----------|--------|--------|
| FR-024 | The system must respect jurisdictional constraints and only recommend confiscation in permitted regions | High | Agreed | REQ-014 |
| FR-025 | The MVP must focus on Peru as the pilot market | High | Agreed | REQ-027 |
| FR-026 | The model must recognize that different markets have different bonus abuse patterns | Medium | Agreed | REQ-028 |
| FR-027 | After successful deployment in one market, the model should be expandable to other markets | Low | Agreed | REQ-029 |

### 2.7 Short-Term Rules-Based Solution (Parallel Track)

| Req # | Requirement | Priority | Status | Source |
|-------|-------------|----------|--------|--------|
| FR-028 | A short-term rules-based solution should be launched in Q1 for immediate value | Medium | Agreed | REQ-034 |
| FR-029 | Short-term solution should integrate with bonus tool to exclude high-risk customers during registration | Medium | Agreed | REQ-035 |
| FR-030 | Short-term solution can check completed bonuses and apply simple rules | Medium | Agreed | REQ-036 |

---

## 3. Non-Functional Requirements

### 3.1 Performance

| Req # | Requirement | Priority | Status | Source |
|-------|-------------|----------|--------|--------|
| NFR-001 | Model accuracy must achieve minimum 80% on validation dataset | High | Agreed | REQ-001 |
| NFR-002 | False positive rate must be below 20% | High | Agreed | REQ-005 |
| NFR-003 | Multi-accounting detection accuracy >85% | High | Agreed | UC-003 |
| NFR-004 | Chip-dumping detection accuracy >75% (if in scope) | Medium | Clarification Needed | UC-008 |
| NFR-005 | Batch scoring pipeline must process 1,000+ withdrawals daily | High | Agreed | REQ-020 |
| NFR-006 | Device fingerprint search must return results within 5 seconds | Medium | Agreed | UC-011 |
| NFR-007 | High-risk customers must be flagged within 1 hour of bonus completion (proactive mode) | Medium | Pending | UC-007 |

### 3.2 Security & Compliance

| Req # | Requirement | Priority | Status | Source |
|-------|-------------|----------|--------|--------|
| NFR-008 | All customer data must be handled according to data protection regulations | High | Agreed | Compliance |
| NFR-009 | Model predictions must be auditable with full decision trail | High | Agreed | REQ-016 |
| NFR-010 | Jurisdictional rules must be configurable without code changes | High | Agreed | REQ-014 |
| NFR-011 | API endpoints must be authenticated and authorized | High | Agreed | Security best practice |

### 3.3 Reliability & Monitoring

| Req # | Requirement | Priority | Status | Source |
|-------|-------------|----------|--------|--------|
| NFR-012 | The system must track model performance metrics (accuracy, precision, recall, F1) and alert on degradation | High | Agreed | REQ-011 |
| NFR-013 | The system must track key business metrics: detection rate increase, confiscated funds increase | High | Agreed | REQ-023 |
| NFR-014 | The system must support A/B testing to compare model versions before full deployment | Medium | Pending | REQ-025 |

### 3.4 Scalability & Maintainability

| Req # | Requirement | Priority | Status | Source |
|-------|-------------|----------|--------|--------|
| NFR-015 | Model retraining must be automated with configurable triggers | High | Agreed | REQ-012 |
| NFR-016 | The system must support model versioning with rollback capability | High | Agreed | Best practice |
| NFR-017 | The system must be expandable to additional markets without major rearchitecture | Medium | Agreed | REQ-029 |

---

## 4. Use Cases Summary

### 4.1 MVP Use Cases (Peru Pilot)

| UC # | Title | Priority | Status |
|------|-------|----------|--------|
| UC-001 | Batch withdrawal risk scoring and prioritization | High | Agreed |
| UC-002 | Prediction explainability for manual reviewers | High | Agreed |
| UC-003 | Multi-accounting detection via device fingerprint correlation | High | Agreed |
| UC-004 | ML pipeline training on high-resolution Snowflake data | High | Agreed |
| UC-006 | Detection rate KPI tracking | High | Agreed |
| UC-009 | Sportsbook-to-casino bouncing detection | Medium | Agreed |
| UC-012 | Historical labeled data access for training | High | Agreed |

### 4.2 Post-MVP Use Cases

| UC # | Title | Priority | Status |
|------|-------|----------|--------|
| UC-005 | Periodic model retraining | High | Agreed |
| UC-007 | Proactive pre-withdrawal flagging | Medium | Pending |
| UC-008 | Chip-dumping detection in poker | Medium | Clarification Needed |
| UC-010 | Jurisdictional constraint enforcement | High | Clarification Needed |
| UC-011 | Device fingerprint search | Medium | Agreed |
| UC-013 | Bonus campaign exclusion for suspected abusers | Medium | Agreed |
| UC-014 | Manual withdrawal review queue prioritization | Medium | Agreed |
| UC-015 | Pattern-specific alert classification | Medium | Agreed |

---

## 5. Personas

### 5.1 Risk Analyst (Primary User)
- **Role**: Manual fraud investigator reviewing suspicious withdrawals
- **Key Needs**: Prioritized review queue, explainability, device fingerprint search, linked account detection
- **Pain Points**: Volume overwhelm, multi-tab manual correlation, reactive-only detection

### 5.2 ML Data Scientist (System Developer)
- **Role**: Model development, training, evaluation, deployment
- **Key Needs**: Data access, compute budget, feature engineering tools, model monitoring
- **Pain Points**: Data volume (billions of rows), compute costs, balancing accuracy vs explainability

### 5.3 Product Manager / Business Stakeholder (Decision Maker)
- **Role**: Define success criteria, oversee delivery
- **Key Needs**: ROI metrics, jurisdictional compliance, scalability
- **Pain Points**: Cost justification, false positive balance, global rollout complexity

---

## 6. Known Fraud Patterns (Training Targets)

| Pattern | Description | Detection Signals | MVP Scope |
|---------|-------------|-------------------|-----------|
| **Multi-accounting with opposite betting** | Multiple accounts in same market, opposite bets (red/black), one accumulates winnings | Device fingerprint matching, IP correlation, simultaneous registration, opposite betting patterns | Yes |
| **Sportsbook-to-casino bouncing** | Switching between products around bonus trigger thresholds | Cross-product activity patterns, consistent bet sizing (e.g., 50 SEK on Epic Jokers) | Yes |
| **Chip-dumping (poker)** | Coordinated collusion where one player deliberately loses to another | Poker betting/folding patterns, player co-occurrence | Clarification Needed |
| **Bonus hunting** | Exploiting bonus T&Cs systematically | Rapid bonus completion, minimal post-bonus activity, wagering pattern anomalies | Yes |

---

## 7. Data Sources

| Source | Type | Content | Access |
|--------|------|---------|--------|
| Snowflake Transaction Tables | Primary | Customer transactions, bets, deposits, withdrawals (billions of rows) | Snowflake access required |
| Historical Labeled Data | Training | 12,000+ bonus-related customer records since 2016 | Available |
| Group-IB | External | Device fingerprints (Canvas, WebGL signatures) | Integration required |
| WCPS | Existing Tool | Withdrawal review system | Integration TBD |
| BAQ | Existing Tool | Bonus abuse queue | Integration TBD |
| KYC Data | Internal | Customer identity verification data | Access required |

---

## 8. Assumptions

1. Historical labeled data (12,000+ records since 2016) is sufficiently accurate and representative
2. Snowflake transaction data contains necessary behavioral signals to detect abuse patterns
3. Risk team will continue to provide labeled data for retraining and validation
4. Group-IB device fingerprinting data can be integrated with the ML model
5. Current manual review processes remain during initial deployment (hybrid approach)
6. Business stakeholders will approve compute budget for Snowflake processing
7. Real-time scoring is future enhancement; batch predictions acceptable for MVP
8. Peru market data is accessible and sufficiently large for training
9. ML team has existing CRISP-DM process and templates
10. Discovery phase can be completed within Q1 2026

---

## 9. Risks

| # | Risk | Impact | Mitigation |
|---|------|--------|------------|
| R-001 | High Snowflake compute costs exceed approved budget | High | Estimate costs early; scope reduction or data sampling as fallback |
| R-002 | Model doesn't generalize to new fraud patterns | Medium | Regular retraining; feature engineering for emerging patterns |
| R-003 | False positives negatively impact customer experience | High | Tunable threshold; human-in-the-loop for borderline cases |
| R-004 | Data leakage creates feedback loop | High | Strict train/test split; monitor for label contamination |
| R-005 | Integration with WCPS/BAQ/Group-IB more complex than expected | Medium | Early API discovery; integration spike in Q1 |
| R-006 | Jurisdictional constraints limit global rollout | Medium | Configurable jurisdiction rules engine |
| R-007 | Fraudsters adapt tactics once ML detection deployed | Medium | Continuous retraining; adversarial robustness testing |
| R-008 | Cold-start problem for new customers | Medium | Default risk scoring based on registration signals |
| R-009 | ML team capacity constraints (CRM integration competing) | High | Realistic capacity planning; phased delivery |
| R-010 | Discovery phase reveals "no-go" scenarios (missing data/targets) | High | Define go/no-go criteria upfront; early data validation |
| R-011 | Aggressive MVP timeline (before World Cup) may not be achievable | High | Phased scope; MVP with batch-only, single market |

---

## 10. Open Clarification Items

Items requiring resolution before or during implementation. See `requirement-verification-questions.md` for structured questions.

| # | Item | Who Should Clarify | Impact on Implementation |
|---|------|--------------------|--------------------------|
| OC-001 | Specific false positive rate threshold (currently "below 20%") | Product + Risk | Model tuning targets |
| OC-002 | Chip-dumping detection feasibility and poker data availability | Risk + Data | MVP scope decision |
| OC-003 | Real-time scoring timeline and infrastructure needs | ML + Real-Time Analytics | Architecture design |
| OC-004 | Snowflake compute cost budget approval | Product + Finance | Data pipeline design |
| OC-005 | WCPS/BAQ/Group-IB integration specifications (APIs, data formats) | Engineering + Risk | Integration layer design |
| OC-006 | Jurisdictional constraints - specific countries and rules | Compliance + Product | Rules engine design |
| OC-007 | Cold-start strategy for new customers | ML + Risk | Feature engineering |
| OC-008 | Model retraining frequency and trigger criteria | ML + Product | Pipeline design |
| OC-009 | Specific Snowflake tables, schemas, and fields needed | ML + Data | Data pipeline design |
| OC-010 | Short-term rules-based solution scope and integration | Operations + Engineering | Parallel workstream |

---

## 11. MVP Scope Definition (Proposed)

Based on the requirements analysis and timeline constraints (before World Cup, June 11 2026):

### In MVP Scope
- Single market: Peru
- Batch prediction pipeline (daily scoring)
- ML model trained on historical labeled data
- Probability scoring (0-1) with explainability
- Multi-accounting detection via device fingerprints/IP
- Sportsbook-to-casino bouncing detection
- Consistent bet sizing pattern detection
- API for prediction retrieval and explainability
- Model performance monitoring (accuracy, precision, recall, F1)
- Business metric tracking (detection rate, confiscated funds)
- Prediction audit trail storage

### Deferred to Post-MVP
- Real-time scoring
- Multi-market expansion
- Chip-dumping detection (pending data availability)
- A/B testing framework
- Proactive pre-withdrawal flagging
- Bonus campaign exclusion integration
- Full WCPS/BAQ integration (MVP uses API-only approach)

---

**Document Generated**: 2026-02-08
**Source Documents**: req1.md (Confluence/JIRA analysis, 829 lines), req2.vtt (Meeting transcription, ~72 minutes)
**Total Functional Requirements**: 30
**Total Non-Functional Requirements**: 17
**Total Use Cases**: 15
**Total Risks**: 11
**Total Open Clarification Items**: 10
