--- POPULATE TABLES ---

-- Disable Trigger before populating table

ALTER TABLE detailed_rentals DISABLE TRIGGER trg_update_summary;

--populate detailed_rentals Table


INSERT INTO detailed_rentals (rental_id, film_id, title, rental_date, time_period)
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

INSERT INTO summary_popular_films (film_id, title, total_rentals, popularity_rank)
SELECT 
    film_id,
    title,
    COUNT(*) as total_rentals,
    DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) as popularity_rank
FROM detailed_rentals
GROUP BY film_id, title
ORDER BY total_rentals DESC
LIMIT 100
ON CONFLICT (film_id) DO NOTHING;

-- Re-Enable Trigger after populating table
ALTER TABLE detailed_rentals ENABLE TRIGGER trg_update_summary;