-- Create detailed table of rentals:

CREATE TABLE IF NOT EXISTS detailed_rentals (
    rental_id INTEGER PRIMARY KEY,
    film_id INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    rental_date TIMESTAMP NOT NULL,
    time_period VARCHAR(10) NOT NULL,
    customer_id INTEGER NOT NULL
);

--populate detailed_rentals Table

INSERT INTO detailed_rentals
SELECT 
    r.rental_id,
    f.film_id,
    f.title,
    r.rental_date,
    get_time_period(r.rental_date) as time_period,
    r.customer_id
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
ON CONFLICT (rental_id) DO NOTHING;

-- Create Summary table of popular films

CREATE TABLE  IF NOT EXISTS summary_popular_films (
    film_id INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    time_period VARCHAR(10) NOT NULL,
    rental_count INTEGER DEFAULT 0,
    PRIMARY KEY (film_id, time_period)
);

-- populate Summary table

INSERT INTO summary_popular_films (film_id, title, time_period, rental_count)
SELECT 
    film_id,
    title,
    time_period,
    COUNT(*) as rental_count
FROM detailed_rentals
GROUP BY film_id, title, time_period
ON CONFLICT (film_id, time_period) DO NOTHING;

-- get_time_period Function to replace timestamp with Quarter time period

CREATE OR REPLACE FUNCTION get_time_period(rental_timestamp TIMESTAMP)
RETURNS VARCHAR AS $$
BEGIN
    RETURN TO_CHAR(rental_timestamp, 'YYYY-"Q"Q');
    -- Returns format: '2005-Q1', '2005-Q2', etc.
END;
$$ LANGUAGE plpgsql;

-- Trigger to recalculate summary table:


-- Detailed query to display data which populates detailed_rentals

SELECT r.rental_id, f.film_id, f.title, r.rental_date, get_time_period(r.rental_date) as time_period 
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id;
