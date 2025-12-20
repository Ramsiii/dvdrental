CREATE OR REPLACE FUNCTION get_time_period(rental_timestamp TIMESTAMP)
RETURNS VARCHAR AS $$
BEGIN
    RETURN TO_CHAR(rental_timestamp, 'YYYY-"Q"Q');
    -- Returns format: '2005-Q1', '2005-Q2', etc.
END;
$$ LANGUAGE plpgsql;

-- Trigger to recalculate summary table:



-- Part D: Raw Data:
SELECT r.rental_id, f.film_id, f.title, r.rental_date, get_time_period(r.rental_date) as time_period 
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
 
 -- test the first again
 -- tested
 -- add function and trigger to update most rented