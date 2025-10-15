-- Top 10 customers by number of rentals from the rental table

SELECT customer_id, COUNT(*) as rental_count
FROM rental 
GROUP BY customer_id 
ORDER BY rental_count DESC 
LIMIT 10;

-- Top 10 customers from the customer table

SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id
ORDER BY rental_count DESC
LIMIT 10;