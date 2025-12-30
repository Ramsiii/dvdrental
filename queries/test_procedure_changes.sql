-- COMMENT OUT EACH STEP UNTIL READY --

-- CHANGE RENTAL INVENTORY --

-- Check summary table
-- SELECT * FROM summary_popular_films ORDER BY popularity_rank LIMIT 5;

-- Find available inventory for "Rocketeer Mother"
-- SELECT inventory_id FROM inventory WHERE film_id = 738 LIMIT 2; -- inventory_d for film_id 738 = 3360 & 3361
-- SELECT MAX(rental_id) FROM rental; -- max rental_id = 16049

-- INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id, return_date)
-- VALUES (NOW(), 3360, 1, 1, NOW() + INTERVAL '3 days');

-- INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id, return_date)
-- VALUES (NOW(), 3361, 1, 1, NOW() + INTERVAL '3 days');

-- Check summary table
-- SELECT * FROM summary_popular_films ORDER BY popularity_rank LIMIT 5;

-- Should show:
-- 738 "Rocketeer Mother" 35 1
-- 103 "Bucket Brotherhood" 34 2

-- DELETE FROM rental WHERE rental_id > 16049;

-- CALL refresh_rental_analysis();

-- SELECT * FROM summary_popular_films ORDER BY popularity_rank LIMIT 5;

-- Should show original rank again:
-- 103 "Bucket Brotherhood" 34 1
-- 738 "Rocketeer Mother" 33 2
