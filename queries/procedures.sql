
-- Refresh procedure

CREATE OR REPLACE PROCEDURE refresh_rental_analysis()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Disable Trigger before re-populating table (Triggers execute updates after each insert)
    ALTER TABLE detailed_rentals DISABLE TRIGGER trg_update_summary;

    -- Clear existing data
    TRUNCATE TABLE detailed_rentals;
    TRUNCATE TABLE summary_popular_films;
    
    -- Repopulate detailed_rentals (your Part D extraction)
    INSERT INTO detailed_rentals (rental_id, film_id, title, rental_date, time_period)
    SELECT 
        r.rental_id,
		f.film_id,
		f.title,
        r.rental_date,
        get_time_period(r.rental_date)
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id;
    
    INSERT INTO summary_popular_films (film_id, title, total_rentals, popularity_rank)
    SELECT 
        film_id,
        title,
        COUNT(*) as total_rentals,
        DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) as popularity_rank
    FROM detailed_rentals
    GROUP BY film_id, title
    ORDER BY total_rentals DESC
    LIMIT 100;

    -- Re-Enable Trigger after re-populating table
    ALTER TABLE detailed_rentals ENABLE TRIGGER trg_update_summary;
END;
$$;
