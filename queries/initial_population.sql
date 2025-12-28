--- POPULATE TABLES ---

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


