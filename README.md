# 🏅 Olympic Data Warehouse & Analytics Project

Welcome to the **Olympic Data Warehouse & Analytics Project**
This repository demonstrates an end-to-end **modern data warehousing solution**, from raw data ingestion to analytics-ready datasets designed for Business Intelligence (BI) tools.

The project focuses on **data engineering best practices**, including medallion architecture, star schema modeling, data quality validation, and a semantic BI layer built for interactive analytics.

While inspired by modern data warehouse design patterns shared by industry practitioners, this project is a **fully original implementation**, tailored specifically to Olympic Games analytics.

---

## 📌 Project Contributors & Credits

This project builds upon publicly available resources and community knowledge:

- **Reymart Felisilda** - Data Warehouse Design, ETL Development, Data Modeling, BI Semantic Layer
- **Keith Galli** - Original Olympic datasets (scraped from official Olympic sources)
- **Baraa Khatib Salkini** - Architectural inspiration and modern data warehouse concepts
- **Andy Kriebel** - BI and Tableau dashboard design inspiration

> ⚠️ ALL SQL scripts, transformations, modeling decisions, tests, and BI views in this repository are original implementations created for this project.

---

## Project Overview

This project demonstrates:

1. **Modern Data Architecture**
   - Medallion Architecture (Bronze, Silver, Gold)
   - Clear separation of ingestion, transformation, and analytics layers

2. **ETL & Data Engineering**
   - SQL-based pipelines using PostgreSQL
   - Idempotent DDL and load procedures
   - Explicit data quality and integrity checks

3. **Dimensional Data Modeling**
   - Star schema desing
   - Fact and dimension tables optimized for analytics
  
4. **BI & Analytics Enablement**
   - Business-facing semantic views
   - Interactive, filterable analytics
   - Reproducible exports for BI tools (e.g., Tableau)

---

## 🏗️ Data Architecture

The data warehouse follows the **Medallion Architecture**, a layered approach that improves data quality, scalability, and maintainability.

### 🥉 Bronze Layer - Raw Ingestion
- Stores data **exactly as received**
- No transformations applied
- Acts as the immutable source of truth
- Data ingested from CSV files into PostgreSQL

### 🥈 Silver Layer - Cleansed & Standardized
- Data cleansing (null handling, trimming, deduplication)
- Standardization (case normalization, type casting)
- Data enrichment (derived attributes, parsed dates, locations)
- Structural transformations (e.g., reshaping)

### 🥇 Gold Layer - Analytics - Ready
- Business-ready datasets
- Star schema design (fact and dimensions)
- Optimized for analytical workloads

### 📊 Gold BI Layer - Semantic Layer
- Business-facing views
- Explicit grain per view
- Designed for BI interactivity
- No row-level mutations; aggregations only.

---

## 🧱 Data Model

The Gold layer is modeled using a **Star Schema**.

### Fact Table
- **`fact_olympic_results`**
- Grain: *One row per athlete per Olympic Games participation*

### Dimension Tables
- `dim_athletes`
- `dim_games`
- `dim_sport_events`
- `dim_nocs`

All relationship follow **1-to-many** cardinality from dimensions to fact, ensuring predictable joins and performant analytics.

---

## 📊 Analytics & Business Questions

The BI semantic layer supports analysis such as:

- Athlete participation trends over time
- Medal distribution by country (NOC)
- Most decorated Olympic athletes
- Sports with the highest athlete participation
- Medal efficiency by country

Aggregations are intentionally handled at the **semantic layer**, allowing BI tools to provide filtering, drill-downs, and interactive dashboards.

---

## 
