-- Detailed query to display data which populates detailed_rentals

SELECT r.rental_id, f.film_id, f.title, r.rental_date, get_time_period(r.rental_date) as time_period 
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
ORDER BY r.rental_id;

-- SELECT * FROM detailed_rentals ORDER BY rental_id;

-- DISPLAY summary_popular_films ordered by rank

-- SELECT * FROM summary_popular_films ORDER BY popularity_rank;




