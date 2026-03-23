---
step: build-and-test
subagent: false
---

# Build and Test

**Build verification and test execution**

## Inputs

- Code Generation must be complete for all units
- All code artifacts must be generated
- Project is ready for build and testing

## Guidance

### Purpose

Build all units and execute comprehensive testing strategy.

### Step 1: Analyze Testing Requirements

Analyze the project to determine appropriate testing strategy:
- **Unit tests**: Already generated per unit during code generation
- **Integration tests**: Test interactions between units/services
- **Performance tests**: Load, stress, and scalability testing
- **End-to-end tests**: Complete user workflows
- **Contract tests**: API contract validation between services
- **Security tests**: Vulnerability scanning, penetration testing

### Step 2: Generate Build Instructions

Create `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/build-and-test/build-instructions.md`:

```markdown
# Build Instructions

## Prerequisites
- **Build Tool**: [Tool name and version]
- **Dependencies**: [List all required dependencies]
- **Environment Variables**: [List required env vars]
- **System Requirements**: [OS, memory, disk space]

## Build Steps

### 1. Install Dependencies
\`\`\`bash
[Command to install dependencies]
# Example: npm install, mvn dependency:resolve, pip install -r requirements.txt
\`\`\`

### 2. Configure Environment
\`\`\`bash
[Commands to set up environment]
# Example: export variables, configure credentials
\`\`\`

### 3. Build All Units
\`\`\`bash
[Command to build all units]
# Example: mvn clean install, npm run build, brazil-build
\`\`\`

### 4. Verify Build Success
- **Expected Output**: [Describe successful build output]
- **Build Artifacts**: [List generated artifacts and locations]
- **Common Warnings**: [Note any acceptable warnings]

## Troubleshooting

### Build Fails with Dependency Errors
- **Cause**: [Common causes]
- **Solution**: [Step-by-step fix]

### Build Fails with Compilation Errors
- **Cause**: [Common causes]
- **Solution**: [Step-by-step fix]
```

### Step 3: Generate Unit Test Execution Instructions

Create `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/build-and-test/unit-test-instructions.md`:

```markdown
# Unit Test Execution

## Run Unit Tests

### 1. Execute All Unit Tests
\`\`\`bash
[Command to run all unit tests]
# Example: mvn test, npm test, pytest tests/unit
\`\`\`

### 2. Review Test Results
- **Expected**: [X] tests pass, 0 failures
- **Test Coverage**: [Expected coverage percentage]
- **Test Report Location**: [Path to test reports]

### 3. Fix Failing Tests
If tests fail:
1. Review test output in [location]
2. Identify failing test cases
3. Fix code issues
4. Rerun tests until all pass
```

### Step 4: Generate Integration Test Instructions

Create `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/build-and-test/integration-test-instructions.md`:

```markdown
# Integration Test Instructions

## Purpose
Test interactions between units/services to ensure they work together correctly.

## Test Scenarios

### Scenario 1: [Unit A] → [Unit B] Integration
- **Description**: [What is being tested]
- **Setup**: [Required test environment setup]
- **Test Steps**: [Step-by-step test execution]
- **Expected Results**: [What should happen]
- **Cleanup**: [How to clean up after test]

### Scenario 2: [Unit B] → [Unit C] Integration
[Similar structure]

## Setup Integration Test Environment

### 1. Start Required Services
\`\`\`bash
[Commands to start services]
# Example: docker-compose up, start test database
\`\`\`

### 2. Configure Service Endpoints
\`\`\`bash
[Commands to configure endpoints]
# Example: export API_URL=http://localhost:8080
\`\`\`

## Run Integration Tests

### 1. Execute Integration Test Suite
\`\`\`bash
[Command to run integration tests]
# Example: mvn integration-test, npm run test:integration
\`\`\`

### 2. Verify Service Interactions
- **Test Scenarios**: [List key integration test scenarios]
- **Expected Results**: [Describe expected outcomes]
- **Logs Location**: [Where to check logs]

### 3. Cleanup
\`\`\`bash
[Commands to clean up test environment]
# Example: docker-compose down, stop test services
\`\`\`
```

### Step 5: Generate Performance Test Instructions (If Applicable)

Create `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/build-and-test/performance-test-instructions.md`:

```markdown
# Performance Test Instructions

## Purpose
Validate system performance under load to ensure it meets requirements.

## Performance Requirements
- **Response Time**: < [X]ms for [Y]% of requests
- **Throughput**: [X] requests/second
- **Concurrent Users**: Support [X] concurrent users
- **Error Rate**: < [X]%

## Setup Performance Test Environment

### 1. Prepare Test Environment
\`\`\`bash
[Commands to set up performance testing]
# Example: scale services, configure load balancers
\`\`\`

### 2. Configure Test Parameters
- **Test Duration**: [X] minutes
- **Ramp-up Time**: [X] seconds
- **Virtual Users**: [X] users

## Run Performance Tests

### 1. Execute Load Tests
### 2. Execute Stress Tests
### 3. Analyze Performance Results
```

### Step 6: Generate Additional Test Instructions (As Needed)

**BDD Tests** (If BDD Specification was executed): Create `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/build-and-test/bdd-test-instructions.md`:

```markdown
# BDD Test Execution Instructions

## Purpose
Execute the Gherkin feature files against their step definitions to validate that the system
behaves exactly as specified in the living documentation.

## Prerequisites
- BDD framework installed and configured (see `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/bdd/bdd-strategy.md`)
- Step definitions generated for all units (see Code Generation outputs)
- Test environment running with required services available

## Feature Files Location
`{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/bdd/features/`

## Run BDD Tests

### 1. Execute Full BDD Suite
\`\`\`bash
[Command to run all feature files]
# SpecFlow (.NET): dotnet test --filter Category=BDD
# Cucumber (Java): mvn test -Dcucumber.features=path/to/features
# pytest-bdd (Python): pytest --bdd tests/
# Behave (Python): behave features/
\`\`\`

### 2. Run by Tag
\`\`\`bash
[Command to run scenarios by tag]
# Example (Cucumber): mvn test -Dcucumber.filter.tags="@smoke"
# Example (Behave): behave --tags=@regression
\`\`\`

### 3. Review Scenario Results
- **Expected**: All scenarios pass; 0 failing; 0 undefined steps
- **Report Location**: [Path to BDD HTML/JSON report]
- **Interpret Results**:
  - **Passed**: Scenario behaviour confirmed
  - **Failed**: Behaviour diverges from specification — fix code, not the scenario
  - **Pending/Undefined**: Step definition missing — generate and implement before marking complete

### 4. Fix Undefined or Failing Steps
If steps are undefined or failing:
1. Check `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/inception/bdd/step-catalogue.md` for correct step wording
2. Verify step definition binding matches the Gherkin text exactly
3. Review `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/{unit-name}/functional-design/bdd-step-mapping.md` for the intended implementation
4. Re-run after fix to confirm green

## Scenario Traceability
Each scenario includes a story ID comment — use these to trace failures back to the originating user story and acceptance criteria.
```

**Contract Tests** (For Microservices): Create `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/build-and-test/contract-test-instructions.md`:
- API contract validation between services
- Consumer-driven contract testing
- Schema validation

**Security Tests**: Create `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/build-and-test/security-test-instructions.md`:
- Vulnerability scanning
- Dependency security checks
- Authentication/authorization testing
- Input validation testing

**End-to-End Tests**: Create `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/build-and-test/e2e-test-instructions.md`:
- Complete user workflow testing
- Cross-service scenarios
- UI testing (if applicable)

### Step 7: Generate Test Summary

Create `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/build-and-test/build-and-test-summary.md`:

```markdown
# Build and Test Summary

## Build Status
- **Build Tool**: [Tool name]
- **Build Status**: [Success/Failed]
- **Build Artifacts**: [List artifacts]
- **Build Time**: [Duration]

## Test Execution Summary

### Unit Tests
- **Total Tests**: [X]
- **Passed**: [X]
- **Failed**: [X]
- **Coverage**: [X]%
- **Status**: [Pass/Fail]

### Integration Tests
- **Test Scenarios**: [X]
- **Passed**: [X]
- **Failed**: [X]
- **Status**: [Pass/Fail]

### Performance Tests
- **Response Time**: [Actual] (Target: [Expected])
- **Throughput**: [Actual] (Target: [Expected])
- **Error Rate**: [Actual] (Target: [Expected])
- **Status**: [Pass/Fail]

### BDD Tests
- **Feature Files**: [X]
- **Total Scenarios**: [X]
- **Passed**: [X]
- **Failed**: [X]
- **Pending / Undefined**: [X]
- **Status**: [Pass/Fail/N/A]

### Additional Tests
- **Contract Tests**: [Pass/Fail/N/A]
- **Security Tests**: [Pass/Fail/N/A]
- **E2E Tests**: [Pass/Fail/N/A]

## Overall Status
- **Build**: [Success/Failed]
- **All Tests**: [Pass/Fail]
- **Ready for Operations**: [Yes/No]

## Next Steps
[If all pass]: Ready to proceed to Operations phase for deployment planning
[If failures]: Address failing tests and rebuild
```

### Step 8: Test Coverage Delta & Improvement Plan (CONDITIONAL - Post-Implementation)

**Execute IF**: Reverse engineering artifacts exist at `{LOCAL_REPO_PATH}/initiatives/_project/reverse-engineering/test-coverage-analysis.md`

**Skip IF**: No test coverage baseline exists (greenfield project or test-coverage-analysis.md not generated)

**Purpose**: Compare current coverage against the Phase 1 baseline and generate a feature-level improvement plan.

**Execution**:
1. Load Phase 2 instructions from shared test-coverage-analysis stage
2. Load the Phase 1 baseline from reverse-engineering
3. Re-run coverage commands to get current metrics (post-implementation)
4. Execute Phase 2: Coverage Delta Report, Improvement Plan, Test Templates, Quality Gate Recommendations, Continuous Coverage Improvement Loop
5. Generate output at `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/coverage-improvement-plan.md`
6. Present coverage delta summary to user

### Step 9: Reverse Engineering Update (CONDITIONAL - Post-Implementation)

**Execute IF**: Reverse engineering artifacts exist at `{LOCAL_REPO_PATH}/initiatives/_project/reverse-engineering/`

**Skip IF**: No reverse engineering artifacts (greenfield project)

**Purpose**: Keep all reverse engineering artifacts — including the C4 architecture model — up to date after every implementation cycle. This is the **final step** of the Construction phase and must not be skipped when artifacts exist.

**Execution**:
1. Execute incremental update of ALL `{LOCAL_REPO_PATH}/initiatives/_project/reverse-engineering/` artifacts based on changes made during this feature's implementation, including:
   - `business-overview.md`, `architecture.md`, `c4-architecture.md`, `code-structure.md`, `api-documentation.md`, `component-inventory.md`, `technology-stack.md`, `dependencies.md`, `code-quality-assessment.md`, `test-coverage-analysis.md`
2. Update `reverse-engineering-timestamp.md` with feature reference and change summary

### Step 10: Present Results to User

Present comprehensive message with build status, test results (unit, integration, performance, additional), generated files list, and summary location. Ask user if ready to proceed to Operations stage for deployment planning.

## Outputs

- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/build-and-test/build-instructions.md`
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/build-and-test/unit-test-instructions.md`
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/build-and-test/integration-test-instructions.md`
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/build-and-test/performance-test-instructions.md` (if applicable)
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/build-and-test/bdd-test-instructions.md` (if BDD executed)
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/build-and-test/contract-test-instructions.md` (for microservices)
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/build-and-test/security-test-instructions.md`
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/build-and-test/e2e-test-instructions.md`
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/build-and-test/build-and-test-summary.md`
- `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/coverage-improvement-plan.md` (conditional)
- Updated reverse-engineering artifacts (conditional)

## Gate

1. Present completion message:

```markdown
🔨 Build and Test Complete!

**Build Status**: [Success/Failed]

**Test Results**:
✅ Unit Tests: [X] passed
✅ Integration Tests: [X] scenarios passed
✅ Performance Tests: [Status]
✅ Additional Tests: [Status]

**Generated Files**:
1. ✅ build-instructions.md
2. ✅ unit-test-instructions.md
3. ✅ integration-test-instructions.md
4. ✅ performance-test-instructions.md (if applicable)
5. ✅ bdd-test-instructions.md (if BDD Specification was executed)
6. ✅ [additional test files as needed]
7. ✅ build-and-test-summary.md

Review the summary in `{LOCAL_REPO_PATH}/initiatives/{INITIATIVE_NAME}/artefacts/construction/build-and-test/build-and-test-summary.md`

**Ready to proceed to Operations stage for deployment planning?**
```

2. Wait for user confirmation before proceeding to Operations.
