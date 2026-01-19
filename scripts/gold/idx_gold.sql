/* =============================================================================
	Gold Layer - Fact Table Indexing

	Table:
		- gold.fact_olympic_resutls

	Purpose:
		This script creates indexes on all FOREIGN KEY columns in the fact table.
		These indexes significantly improve query performance for:
			- Star Schema joins (Fact -> Dimension)
			- Aggregations grouped by dimension attributes

	In a STAR SCHEMA:
		- The fact table is large and frequently scanned
		- Dimension tables are smaller and joined repeatedly
		- Indexing foreign keys on the fact table is a best practice

	Notes:
		- Primary keys in dimension tables are already indexed implicitly
		- These indexes support OLAP-style workloads, not transactional updates
		- IF NOT EXISTS ensures idempotent execution

	Execution Layer:
		- Gold Layer (PostgreSQL)
============================================================================= */



-- ============================================================================
-- FACT TABLE FOREIGN KEY INDEXES
-- ============================================================================

-- Index on athlete_key
-- Supports:
--	- Joins to dim_athletes
--	- Queries analyzing athlete participation, medals, and career longevity
CREATE INDEX IF NOT EXISTS		idx_fact_olympic_results_athlete_key
						ON		gold.fact_olympic_results(athlete_key);



-- Index on game_key
-- Supports:
--	- Joins to dim_games
--	- Time-series analysis by Olympic year and season
CREATE INDEX IF NOT EXISTS		idx_fact_olympic_results_game_key
						ON		gold.fact_olympic_results(game_key);



-- Index on sport_event_key
-- Supports:
--	- Joins to dim_sport_events
--	- Analysis of athlete participation by sport and discipline
-- Note:
--	- Column is nullable by design.
CREATE INDEX IF NOT EXISTS		idx_fact_olympic_results_sport_event_key
						ON		gold.fact_olympic_results(sport_event_key);



-- Index on noc_key
-- Supports:
--	- Joins to dim_nocs
--	- Country / region-level aggregations and medal analysis
--	Note:
--	- Column is nullable by design.
CREATE INDEX IF NOT EXISTS		idx_fact_olympic_results_noc_key
						ON		gold.fact_olympic_results(noc_key);





