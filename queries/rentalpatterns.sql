-- Top 10 customers by number of rentals from the rental table

-- SELECT customer_id, COUNT(*) as rental_count
-- FROM rental 
-- GROUP BY customer_id 
-- ORDER BY rental_count DESC 
-- LIMIT 10;

-- Top 10 customers from the customer table

-- SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS rental_count
-- FROM customer c
-- JOIN rental r ON c.customer_id = r.customer_id
-- GROUP BY c.customer_id
-- ORDER BY rental_count DESC
-- LIMIT 10;

CREATE OR REPLACE FUNCTION get_time_period(rental_timestamp TIMESTAMP)
RETURNS VARCHAR AS $$
BEGIN
    RETURN TO_CHAR(rental_timestamp, 'YYYY-"Q"Q');
    -- Returns format: '2005-Q1', '2005-Q2', etc.
END;
$$ LANGUAGE plpgsql;

SELECT r.rental_id, f.film_id, f.title, r.rental_date, get_time_period(r.rental_date) as time_period 
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
 
 -- test the first again
 -- tested