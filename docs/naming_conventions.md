# Naming Conventions
**Olympic Data Warehouse Project**

This project follows a standardized naming convention inspired by **Baraa Salkini's Data Warehouse architecture**, adapted specifically for the **Olympic Data Warehouse** built using **Keith Galli's web-scraped Olympics datasets**

Since all data originates from Olympics-related sources (primarily Olympedia), the `<source_system>` is simplified and standardized as:

> **olympics**

The goal of these conventions is to ensure:
- Consistency across all warehouse layers
- Clear separation of responsibilities (raw vs. curated vs. analytics)
- Readability for both engineers and analysts
- Scalability for future extensions

---

## General Principles

- **Naming Style:** `snake_case` (lowercase letters with underscores)
- **Language:** English only
- **Clarity Over Brevity:** Prefer descriptive names
- **No Reserved Words:** Avoid SQL reserved keywords
- **Layer-Aware Naming:** Names should clearly indicate the warehouse layer and object purpose

---

## Schema Naming Conventions

Each warehouse layer is isolated into its own schema:

| Layer | Schema Name | Description |
|----|----|----|
| Bronze | `bronze` | Raw ingestion layer |
| Silver | `silver` | Cleansed & standardized layer |
| Gold | `gold` | Business-ready star schema |
| Gold BI | `gold_bi` | Analytics-friendly views |

---

## Table Naming Conventions

---

### 🥉 Bronze Layer (Raw Ingestion)

**Purpose:**
Stores raw, untransformed data exactly as ingested from source CSV files.

**Rules:**
- Retain original entity names from the source
- Prefix tables with the standardized source system name
- No business logic, transformations, or renaming applied
- Tables are fully replaced on each load

**Pattern:**
`<bronze>.<source_system>_<entity>`

**Examples:**
- `bronze.olympics_bios`
- `bronze.olympics_bios_locs`
- `bronze.olympics_noc_regions`
- `bronze.olympics_populations`
- `bronze.olympics_results`

---

### 🥈 Silver Layer (Cleansed & Standardized)

**Purpose:**
Contains cleaned, standardized, and enriched versions of Bronze tables.

**Transformations include:**
- Trimming and null handling
- Case normalization
- Type casting
- Date parsing
- Structural reshaping (wide → long)
- Derivation of standardized attributes

**Rules:**
- Retain source-aligned entity names
- Prefix tables with the source system name
- No business aggregation or dimensional modeling

**Pattern:**
`<silver>.<source_system>_<entity>`

**Examples:**
- `silver.olympics_bios`
- `silver.olympics_bios_locs`
- `silver.olympics_noc_regions`
- `silver.olympics_populations`
- `silver.olympics_results`

---

### 🥇 Gold Layer (Business-Ready / Star Schema)

**Purpose:**
Provides analytics-ready dimensional and fact tables optimized for BI and reporting tools.

---

#### Gold Table Categories

| Type | Prefix | Description |
|----|----|----|
| Dimension | `dim_` | Descriptive entities |
| Fact | `fact_` | Measurable business events |

---

### Gold Table Naming Rules

- Do **not** use source system prefixes
- Use business-oriented entity names
- Surrogate keys are generated in Gold only
- Fact tables do **not** have surrogate primary keys

**Patterns:**
- `gold.dim_<entity>`
- `gold.fact_<business_pricess>`

**Examples:**
- `gold.dim_athletes`
- `gold.dim_nocs`
- `gold.dim_games`
- `gold.dim_sport_events`
- `gold.fact_olympic_results`

---

## Column Naming Conventions

---

### Surrogate keys (Gold only)

**Rules:**
- Generated using `GENERATED ALWAYS AS IDENTITY`
- Suffix `_key`
- Exist only in Gold Layer

**Examples:**
- `athlete_key`
- `noc_key`
- `game_key`
- `sport_event_key`

---

### Foreign Keys (Fact Tables)

**Rules**
- Match the referenced dimension surrogate key name
- Always suffixed with `_key`

**Examples**
- `athlete_key`
- `game_key`
- `noc_key`
- `sport_event_key`

---

### Business Attributes

**Rules**
- Descriptive, human-readable
- Avoid abbreviations unless industry standard

**Examples**
- `name`
- `discipline`
- `region`
- `season`
- `olympic_year`
- `medal`

---

### 🔧 Technical Columns (`<dwh>`)

**Purpose**
Technical metadata columns used for lineage, auditing, and data quality.

**Rules**
- Prefixed with `dwh_`
- Present in Bronze and Silver layers
- Optional in Gold (by design)

**Examples**
- `dwh_create_date`

---

## Function Naming Conventions (Silver Layer)

**Purpose**
Encapsulate deterministic parsing and standardization logic.

**Rules**
- Functions exist only in Silver
- Must be deterministic (`IMMUTABLE`)
- Prefixed with `fn_`

**Pattern**
`silver.fn_<action>_<entity>`

**Examples**
- `silver.fn_parse_location`
- `silver.fn_parse_date`

---

## View Naming Conventions (Gold BI Layer)

**Purpose**
Business-facing semantic views for analytics and BI tools.

**Rules**
- No transformation logic beyond aggregation
- Grain must be documented
- One business question per view

**Pattern**
`gold_bi.vw_<business_concept>`

**Examples**
- `gold_bi.vw_olympic_analysis`
- `gold_bi.vw_athletes_by_noc`
- `gold_bi.vw_medals_by_games`
- `gold_bi.vw_vw_kpi_overview`

--

## Procedure Naming Conventions

**Purpose**
Operational logic such as exports and orchestration

**Rules**
- Action-oriented verbs
- Schema-aligned with responsibility

**Pattern**
`<schema>.<action>_<object>`

**Examples**
- `gold_bi.export_gold_bi_views`

---

## Test & Quality Check Naming

**Purpose**
Validate assumptions and data quality across layers.

**Rules**
- Explicitly state what is being validated
- Stored under `/tests`

**Examples**
- `tests/quality_checks_silver.sql`
- `test/quality_checks_gold.sql`

---

## File Naming Conventions (Repository)

- SQL scripts use descriptive, action-based names
- One responsibility per file

**Examples**
- `init_database.sql`
- `ddl_bronze.sql`

---

## Final Notes

These conventions are designed to:
- Support analytical correctness
- Enable BI self-service
- Scale to additional source systems
- Communicate intent clearly to reviewers and recruiters

Consistency is enforced by **design**, not tooling alone.
