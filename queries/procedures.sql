
-- Refresh procedure

-- CREATE OR REPLACE PROCEDURE refresh_rental_analysis()
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN
--     -- Clear existing data
--     TRUNCATE TABLE detailed_rentals;
--     TRUNCATE TABLE summary_popular_films;
    
--     -- Repopulate detailed_rentals (your Part D extraction)
--     INSERT INTO detailed_rentals (rental_id, film_id, title, rental_date, time_period)
--     SELECT 
--         r.rental_id,
-- 		f.film_id,
-- 		f.title,
--         r.rental_date,
--         get_time_period(r.rental_date)
--     FROM rental r
--     JOIN inventory i ON r.inventory_id = i.inventory_id
--     JOIN film f ON i.film_id = f.film_id;
    
--     -- Summary table auto-populates via trigger
-- END;
-- $$;
