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



