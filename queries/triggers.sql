/*

 --- TRIGGERS --- 
New rental transaction → INSERT into rental table (dvdrental database)
trg_sync_detailed_rentals fires → INSERT into detailed_rentals
trg_update_summary fires → UPDATE summary_popular_films

*/

-- Trigger function to update detailed_rentals AFTER INSERT in rentals

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

-- Trigger Function to recalculate summary table:

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
        INSERT INTO summary_popular_films (film_id, title, total_rentals, popularity_rank)
        VALUES (NEW.film_id, NEW.title, 1, 0);
    END IF;
    
    -- Recalculate all ranks after insert
    UPDATE summary_popular_films
    SET popularity_rank = subquery.new_rank
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





-- List all existing Triggers:

SELECT * FROM pg_trigger WHERE tgname LIKE 'trg_%';