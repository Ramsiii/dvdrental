-- COMMENT OUT EACH STEP UNTIL READY --

-- List all existing Triggers:

-- SELECT * FROM pg_trigger WHERE tgname LIKE 'trg_%';

-- Disable Trigger

-- ALTER TABLE detailed_rentals DISABLE TRIGGER trg_update_summary;

-- List all existing Triggers:

-- SELECT * FROM pg_trigger WHERE tgname LIKE 'trg_%';

-- Re-Enable Trigger after re-populating table
-- ALTER TABLE detailed_rentals ENABLE TRIGGER trg_update_summary;

-- List all existing Triggers:

-- SELECT * FROM pg_trigger WHERE tgname LIKE 'trg_%';



-- Test PROCEDURE with DELETE statements --

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
