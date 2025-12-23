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


/*

 --- TRIGGERS --- 
New rental transaction → INSERT into rental table (dvdrental database)
trg_sync_detailed_rentals fires → INSERT into detailed_rentals
trg_update_summary fires → UPDATE summary_popular_films

*/

-- Trigger to recalculate summary table:

CREATE OR REPLACE FUNCTION update_summary_table()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM summary_popular_films 
        WHERE film_id = NEW.film_id
    ) THEN
        -- Increment total_rentals for existing film
        UPDATE summary_popular_films
        SET total_rentals = total_rentals + 1
        WHERE film_id = NEW.film_id;
    ELSE
        -- Insert new film (rank calculated separately)
        INSERT INTO summary_popular_films (film_id, title, total_rentals, rank)
        VALUES (NEW.film_id, NEW.title, 1, 0);
    END IF;
    
    -- Recalculate all ranks after insert
    UPDATE summary_popular_films
    SET rank = subquery.new_rank
    FROM (
        SELECT 
            film_id,
            ROW_NUMBER() OVER (ORDER BY total_rentals DESC, film_id) as new_rank
        FROM summary_popular_films
    ) subquery
    WHERE summary_popular_films.film_id = subquery.film_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--TRIGGER to update summary_popular_films

CREATE OR REPLACE TRIGGER trg_update_summary
AFTER INSERT ON detailed_rentals
FOR EACH ROW
EXECUTE FUNCTION update_summary_table();

-- Second Trigger function to update detailed_rentals AFTER INSERT in rentals

CREATE OR REPLACE FUNCTION sync_detailed_rentals()
RETURNS TRIGGER AS $$
DECLARE
    v_film_id INTEGER;
    v_title VARCHAR(255);
BEGIN
    -- Lookup film info from inventory and film tables
    SELECT f.film_id, f.title
    INTO v_film_id, v_title
    FROM inventory i
    JOIN film f ON i.film_id = f.film_id
    WHERE i.inventory_id = NEW.inventory_id;
    
    -- Insert new rental into detailed_rentals
    INSERT INTO detailed_rentals (rental_id, film_id, title, rental_date, time_period)
    VALUES (
        NEW.rental_id,
        v_film_id,
        v_title,
        NEW.rental_date,
        get_time_period(NEW.rental_date)
    );
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- TRIGGER to update detailed_rentals

CREATE OR REPLACE TRIGGER trg_sync_detailed_rentals
AFTER INSERT ON rental
FOR EACH ROW
EXECUTE FUNCTION sync_detailed_rentals();



-- Detailed query to display data which populates detailed_rentals

-- SELECT r.rental_id, f.film_id, f.title, r.rental_date, get_time_period(r.rental_date) as time_period 
-- FROM rental r
-- JOIN inventory i ON r.inventory_id = i.inventory_id
-- JOIN film f ON i.film_id = f.film_id
-- LIMIT 500;

-- DISPLAY summary_popular_films ordered by rank

SELECT * FROM summary_popular_films ORDER BY rank;