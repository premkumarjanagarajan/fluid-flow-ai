# Requirements Verification Questions

**Branch**: 003-uc20-bonus-abuser-detection
**Phase**: INCEPTION - Requirements Analysis
**Date**: 2026-02-08

Please answer each question by filling in the letter choice after the `[Answer]:` tag.
If none of the options match your needs, choose the last option (Other) and describe your preference.

---

## Question 1
What is the primary programming language and ML framework for the model development?

A) Python with scikit-learn (traditional ML - Random Forest, XGBoost, LightGBM)
B) Python with PyTorch (deep learning)
C) Python with TensorFlow/Keras (deep learning)
D) Python with scikit-learn for MVP, with option to upgrade to deep learning later
E) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 2
What is the target deployment platform and infrastructure?

A) AWS (SageMaker for model serving, S3 for storage, Lambda/ECS for API)
B) Azure (Azure ML for model serving, Blob Storage, Azure Functions/AKS for API)
C) GCP (Vertex AI for model serving, GCS for storage, Cloud Run/GKE for API)
D) On-premises or company-managed Kubernetes cluster
E) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 3
What orchestration tool should be used for the batch prediction and training pipelines?

A) Apache Airflow (managed or self-hosted)
B) AWS Step Functions
C) Azure Data Factory
D) Prefect or Dagster
E) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 4
How should the prediction API be built and served?

A) FastAPI (Python REST API) deployed as a containerized service
B) Flask/Django REST API deployed as a containerized service
C) Serverless functions (AWS Lambda / Azure Functions) with API Gateway
D) ML model serving platform native API (SageMaker Endpoints / Azure ML Endpoints)
E) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 5
What is the authentication/authorization approach for the API?

A) API key-based authentication
B) OAuth 2.0 / JWT token-based authentication
C) Internal network only (no external authentication, firewall-restricted)
D) Integration with existing company SSO/identity provider
E) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 6
Should chip-dumping detection (poker) be included in the MVP scope, or deferred?

A) Include in MVP - poker data is available and feasible
B) Defer to post-MVP - poker data availability is uncertain
C) Exclude entirely - not a priority for this project
D) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 7
What is the preferred approach for model explainability?

A) SHAP (SHapley Additive exPlanations) values for feature importance
B) LIME (Local Interpretable Model-agnostic Explanations)
C) Built-in feature importance from tree-based models (e.g., XGBoost feature importance)
D) Combination of SHAP values + built-in feature importance
E) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 8
How should the model connect to Snowflake for data access?

A) Direct Snowflake connector (snowflake-connector-python) with SQL queries
B) Snowpark for Python (native Snowflake Python integration)
C) Export data to cloud storage (S3/Blob/GCS) first, then process from storage
D) dbt for data transformation in Snowflake + connector for model training
E) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 9
What is the approach for the short-term rules-based solution (parallel track)?

A) Build as a separate module within the same codebase (shared data layer)
B) Build as a completely separate service/project
C) Defer the rules-based solution - focus entirely on the ML model
D) Implement rules as a first iteration of the ML system (rules become features)
E) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 10
What CI/CD and version control approach should be used?

A) GitHub with GitHub Actions for CI/CD
B) GitLab with GitLab CI/CD
C) Azure DevOps with Azure Pipelines
D) Bitbucket with Jenkins/Bamboo
E) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 11
What is the preferred model versioning and experiment tracking approach?

A) MLflow for experiment tracking and model registry
B) Weights & Biases (W&B) for experiment tracking
C) Cloud-native (SageMaker Model Registry / Azure ML Registry / Vertex AI Registry)
D) DVC (Data Version Control) + Git
E) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 12
For the MVP, what should happen when the model flags a customer as high-risk (>0.8 probability)?

A) Add to a manual review queue only (no automated actions)
B) Block the withdrawal automatically and add to review queue
C) Add to review queue with recommended action (block/allow) but require manual confirmation
D) Send alert notification to Risk team + add to review queue
E) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 13
What database should store predictions, audit trails, and model metadata?

A) Snowflake (same platform as source data)
B) PostgreSQL (relational, separate from Snowflake)
C) Cloud-native database (DynamoDB / CosmosDB / Cloud Spanner)
D) Both Snowflake (for analytics) and PostgreSQL (for operational API)
E) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 14
What is the monitoring and alerting approach?

A) Prometheus + Grafana for metrics, PagerDuty/Opsgenie for alerts
B) Cloud-native monitoring (CloudWatch / Azure Monitor / Cloud Monitoring)
C) Datadog for unified monitoring and alerting
D) ELK Stack (Elasticsearch, Logstash, Kibana) for logging + custom alerting
E) Other (please describe after [Answer]: tag below)

[Answer]: 

---

## Question 15
Regarding the jurisdictional constraints, how should the system handle markets where fund confiscation is prohibited?

A) Flag for monitoring only (no confiscation recommendation in system output)
B) Flag with "monitoring only" label and route to separate compliance review queue
C) Apply same scoring but suppress confiscation-related actions in the UI/API response
D) Use a configurable rules engine that maps jurisdictions to allowed actions
E) Other (please describe after [Answer]: tag below)

[Answer]: 

---

**Instructions**: Please answer all 15 questions by adding your letter choice (or description for "Other") after each `[Answer]:` tag. Let me know when you're done.
