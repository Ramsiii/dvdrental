-- In order to start from scratch, DROP tables and restart

DROP TABLE IF EXISTS summary_popular_films CASCADE;
DROP TABLE IF EXISTS detailed_rentals CASCADE;

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
    popularity_rank INTEGER NOT NULL
);