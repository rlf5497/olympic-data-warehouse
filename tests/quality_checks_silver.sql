/*
====================================================================================================
File	: quality_checks_silver.sql
Purpose	:
    Validate data quality, standardization, and transformation rules
    applied during the Bronze → Silver load of the Olympic Data Warehouse.

Scope:
    - Verifies Silver-layer outputs against Bronze source data
    - Confirms correctness of parsing, enrichment, and standardization logic
    - Highlights invalid patterns, unexpected values, and data anomalies

Checks Include:
    - Trimming and casing consistency
    - Date parsing (exact, partial, and circa-based dates)
    - Location extraction (city, region, country code)
    - Measurement normalization (cm / kg)
    - Position & tie logic derivation
    - Key integrity and low-cardinality fields

Notes:
    - This script is READ-ONLY (validation only)
    - No data is modified or corrected here
    - Results are used to confirm Silver logic correctness before downstream use
====================================================================================================
*/



/*
====================================================================================================
QUALITY CHECKS: bronze.olympics_bios
====================================================================================================
*/


--------------------
-- sex
--------------------

-- Unwanted leading/trailing spaces
SELECT
	sex
FROM silver.olympics_bios
WHERE
	sex <> TRIM(sex);

-- Standardization check (expected low cardinality)
SELECT DISTINCT
	sex
FROM silver.olympics_bios;


--------------------
-- used_name
--------------------

-- Unwanted spaces
SELECT
	used_name
FROM silver.olympics_bios
WHERE
	used_name <> TRIM(used_name);

-- Special character check (• should be replaced with space)
SELECT
	COUNT(*) AS names_without_bulltet
FROM silver.olympics_bios
WHERE
	used_name ILIKE '%•%';


--------------------
-- born 
--------------------

-- Unwanted spaces
SELECT
	born_country_code
FROM silver.olympics_bios
WHERE
	born_country_code <> TRIM(born_country_code);

-- Date pattern coverage (records not containing location info)
SELECT
	born
FROM bronze.olympics_bios
WHERE
	born NOT ILIKE '%in%';


--------------------
-- born date parsing (Silver logic validation)
--------------------

-- Valid date extraction patterns
SELECT DISTINCT
	born,
	CASE
		WHEN	born~*		'^\d{1,2}\s+[A-Za-z]+\s+\d{4}'
		THEN	SUBSTRING	(born FROM '^\d{1,2}\s+[A-Za-z]+\s+\d{4}')
		WHEN	born~*		'^[A-Za-z]+\s+\d{4}'
		THEN	SUBSTRING	(born FROM '^[A-Za-z]+\s+\d{4}')
		WHEN	born~*		'\((?:circa|c\.)\s+\d{4}\)'
		THEN	SUBSTRING	(born FROM '\((?:circa|c\.)\s+(\d{4})\)')
		WHEN	born~*		'^\d{4}'
		THEN	SUBSTRING	(born FROM '^\d{4}')
		ELSE 	NULL
	END AS extracted_date
FROM bronze.olympics_bios;

SELECT DISTINCT
	born_date,
	born_city,
	born_region,
	born_country_code
FROM silver.olympics_bios
WHERE
	born_city ILIKE '%?%';


--------------------
-- born location parsing
--------------------

-- Expected patterns:
-- city				: 'in <city>,'
-- region			: ', <region> (XXXX)'
-- country_code		: '(XXXX)'
SELECT DISTINCT
	born,
	born_city,
	born_region,
	born_country_code
FROM(
	SELECT 
		born,
		NULLIF(TRIM(SUBSTRING(born FROM 'in\s+([^,]+),')), '?')					AS born_city,
		NULLIF(TRIM(SUBSTRING(born FROM ',\s+([^,]+)\s+\(\w{3}\)')), '?')		AS born_region,
		TRIM(SUBSTRING(born FROM '\((\w{3})\)'))								AS born_country_code
	FROM bronze.olympics_bios
) AS sq
WHERE
	born ILIKE '%circa%';


--------------------
-- died 
--------------------

-- Unwanted spaces
SELECT
	died
FROM bronze.olympics_bios
WHERE
	died <> TRIM(died);

-- Pattern consistency
SELECT
	died
FROM bronze.olympics_bios
WHERE
	died NOT ILIKE '%in%';

SELECT DISTINCT
	died_date,
	died_city,
	died_region,
	died_country_code
FROM silver.olympics_bios;


--------------------
-- noc
--------------------

-- Unwanted spaces
SELECT
	noc
FROM silver.olympics_bios
WHERE
	noc <> TRIM(noc);

-- Expected Capitalization
SELECT DISTINCT
	INITCAP(noc)
FROM silver.olympics_bios;


--------------------
-- athlete_id (primary key integrity)
--------------------

SELECT
	athlete_id,
	COUNT(*) AS duplicates
FROM silver.olympics_bios
GROUP BY
	athlete_id
HAVING
	COUNT(*) > 1
OR 	athlete_id IS NULL;


--------------------
-- measurement
--------------------

-- Unwanted spaces
SELECT
	measurements
FROM bronze.olympics_bios
WHERE
	measurements <> TRIM(measurements);

-- Measurement enrichment validation
SELECT DISTINCT
	measurements,
	CASE
		WHEN	measurements~*		'(\d{2,3})\s*cm'
		THEN	SUBSTRING			(measurements FROM '(\d{2,3})\s*cm')::NUMERIC
		ELSE	NULL
	END AS height_cm,
	CASE
		WHEN	measurements~*		'(\d{2,3})\s*kg'
		THEN	SUBSTRING			(measurements FROM '(\d{2,3})\s*kg')::NUMERIC
		ELSE	NULL
	END AS weight_kg
FROM bronze.olympics_bios
WHERE
	measurements NOT ILIKE '%/%';



/*
====================================================================================================
QUALITY CHECKS: bronze.olympics_bios_locs
====================================================================================================
*/


--------------------
-- athlete_id
--------------------

SELECT
	athlete_id,
	COUNT(*) AS duplicates
FROM silver.olympics_bios_locs
GROUP BY
	athlete_id
HAVING
	COUNT(*) > 1;


--------------------
-- name
--------------------

-- Unwanted spaces
SELECT
	name
FROM silver.olympics_bios_locs
WHERE
	name <> TRIM(name);


--------------------
-- born_date / died_date
--------------------

-- Unwated spaces
SELECT
	born_date
FROM bronze.olympics_bios_locs
WHERE
	born_date <> TRIM(born_date);

SELECT
	born_city
FROM silver.olympics_bios_locs
WHERE
	born_city <> TRIM(born_city);

SELECT
	died_date
FROM bronze.olympics_bios_locs
WHERE
	died_date <> TRIM(died_date);


--------------------
-- noc
--------------------

SELECT
	noc
FROM bronze.olympics_bios_locs
WHERE
	noc <> TRIM(noc);



/*
====================================================================================================
QUALITY CHECKS: bronze.olympics_noc_regions
====================================================================================================
*/


--------------------
-- noc
--------------------

SELECT
	noc
FROM silver.olympics_noc_regions
WHERE
	noc <> TRIM(noc)
OR	noc <> UPPER(noc);


--------------------
-- region
--------------------

SELECT
	region
FROM silver.olympics_noc_regions
WHERE
	region <> TRIM(region);



/*
====================================================================================================
QUALITY CHECKS: bronze.olympics_results
====================================================================================================
*/


--------------------
-- games (year + type derivation)
--------------------

-- Unwanted spaces
SELECT
	games
FROM bronze.olympics_results
WHERE
	games <> TRIM(games);

SELECT
	game_type
FROM silver.olympics_results
WHERE
	game_type <> TRIM(game_type);

-- Olympic year & game type derivation
SELECT DISTINCT
	games,
	CASE
		WHEN	games~*			'^\d{4}'
		THEN	SUBSTRING		(games FROM '^\d{4}')::INT
		ELSE	NULL
	END AS olympic_year,
	CASE
		WHEN 	games~*			'^\d{4}(?:-\d{2})?\s+(.*?)\s+(Olympic Games|Olympics|Olympic|Games)$'
		THEN	SUBSTRING		(games FROM '^\d{4}(?:-\d{2})?\s+(.*?)\s+(Olympic Games|Olympics|Olympic|Games)$')
		ELSE	NULL
	END AS game_type
FROM bronze.olympics_results;

SELECT DISTINCT
	olympic_year,
	game_type
FROM silver.olympics_results
WHERE
	game_type <> TRIM(game_type);


--------------------
-- sport_event / team
--------------------

-- Unwanted spaces
SELECT
	sport_event
FROM silver.olympics_results
WHERE
	sport_event <> TRIM(sport_event);

SELECT
	team
FROM silver.olympics_results
WHERE
	team <> TRIM(team);


--------------------
-- pos (position & tie logic)
--------------------

-- Check distinct raw values
SELECT DISTINCT
	pos
FROM bronze.olympics_results;

-- Position extraction & tie logic
-- Examples / Rules:
-- 98.0			-> pos = 98, is_tied = FALSE
-- =10			-> pos = 10, is_tied = TRUE
-- 8 h9 r1/4	-> pos = NULL, is_tied = NULL
SELECT
	pos,
	SUBSTRING(pos FROM '^\s*=?(\d+)(?:\.0)?\s*$')::INT AS pos_num,
	CASE
		WHEN	pos~	'^\s*=\d+(\.0)?\s*$'
		THEN	TRUE
		WHEN	pos~	'^\s*\d+(\.0)?\s*$'
		THEN	FALSE
		ELSE 	NULL
	END AS is_tied
FROM bronze.olympics_results;


--------------------
-- medal
--------------------

-- Unwanted spaces
SELECT
	medal
FROM silver.olympics_results
WHERE
	medal <> TRIM(medal);

SELECT DISTINCT
	medal
FROM bronze.olympics_results;


--------------------
-- noc
--------------------

-- Unwanted spaces
SELECT
	noc
FROM silver.olympics_results
WHERE
	noc <> TRIM(noc)
OR	LENGTH(noc) <> 3;


--------------------
-- discipline
--------------------

-- Unwanted spaces
SELECT
	discipline
FROM silver.olympics_results
WHERE
	discipline <> TRIM (discipline);
