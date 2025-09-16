SELECT customer_id, COUNT(*) as rental_count
FROM rental 
GROUP BY customer_id 
ORDER BY rental_count DESC 
LIMIT 10;