-- COMMENT OUT EACH STEP UNTIL READY --

-- 1a. Show current state of detailed table
-- SELECT COUNT(*) FROM detailed_rentals;  -- e.g., 16,044 rows

-- 1b. Show current state of summary table
-- SELECT COUNT(*) FROM summary_popular_films;  -- e.g., 100 rows

-- 2. Manually corrupt/delete data
-- DELETE FROM detailed_rentals WHERE rental_id < 100;

-- DELETE FROM summary_popular_films WHERE film_id < 100;

-- 3. Show damaged state
-- SELECT COUNT(*) FROM detailed_rentals;  -- e.g., 15,945 rows

-- SELECT COUNT(*) FROM summary_popular_films;  -- e.g., 95 rows

-- 4. Run the procedure

-- CALL refresh_rental_analysis();

-- 5. Show restored state
-- SELECT COUNT(*) FROM detailed_rentals;  -- Back to 16,044

-- SELECT COUNT(*) FROM summary_popular_films;  -- Back to 100 rows

-- CHANGE RENTAL INVENTORY --

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
