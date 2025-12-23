-- In order to start from scratch, DROP tables and restart

-- DROP TABLE IF EXISTS summary_popular_films CASCADE;
-- DROP TABLE IF EXISTS detailed_rentals CASCADE;

-- get_time_period Function to replace timestamp with Quarter time period

CREATE OR REPLACE FUNCTION get_time_period(rental_timestamp TIMESTAMP)
RETURNS VARCHAR AS $$
BEGIN
    RETURN TO_CHAR(rental_timestamp, 'YYYY-"Q"Q');
    -- Returns format: '2005-Q1', '2005-Q2', etc.
END;
$$ LANGUAGE plpgsql;

-- Create detailed table of rentals:

CREATE TABLE IF NOT EXISTS detailed_rentals (
    rental_id INTEGER PRIMARY KEY,
    film_id INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    rental_date TIMESTAMP NOT NULL,
    time_period VARCHAR(10) NOT NULL
);

-- Create Summary table of popular films 

CREATE TABLE IF NOT EXISTS summary_popular_films (
    film_id INTEGER PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    total_rentals INTEGER NOT NULL,
    rank INTEGER NOT NULL
);

-- TODO: add ranking to Summary table?
-- rank (INT, optional) - ranking within time period

--populate detailed_rentals Table

INSERT INTO detailed_rentals
SELECT 
    r.rental_id,
    f.film_id,
    f.title,
    r.rental_date,
    get_time_period(r.rental_date) as time_period
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
ON CONFLICT (rental_id) DO NOTHING;

-- populate Summary table

INSERT INTO summary_popular_films
SELECT 
    film_id,
    title,
    SUM(rental_count) as total_rentals,
    ROW_NUMBER() OVER (ORDER BY SUM(rental_count) DESC, film_id) as rank
FROM (
    SELECT film_id, title, time_period, COUNT(*) as rental_count
    FROM detailed_rentals
    GROUP BY film_id, title, time_period
) quarterly
GROUP BY film_id, title
ORDER BY rank
LIMIT 100
ON CONFLICT (film_id) DO NOTHING;

-- Trigger to recalculate summary table:
-- see notes in Drive Doc

-- TODO: Create Trigger

-- Detailed query to display data which populates detailed_rentals

SELECT r.rental_id, f.film_id, f.title, r.rental_date, get_time_period(r.rental_date) as time_period 
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
LIMIT 500;

-- DISPLAY summary_popular_films ordered by rank

SELECT * FROM summary_popular_films ORDER BY rank;