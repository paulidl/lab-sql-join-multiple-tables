-- Lab | SQL Joins on multiple tables: In this lab, you will be using the Sakila database of movie rentals.

USE sakila;
-- Instructions

-- 1. Write a query to display for each store its store ID, city, and country.

SELECT * FROM sakila.store;		-- store_id, address_id
SELECT * FROM sakila.address;	-- address_id, city_id
SELECT * FROM sakila.city;		-- city_id, city, country_id
SELECT * FROM sakila.country;	-- country_id, country

SELECT s.store_id, ci.city, co.country
FROM sakila.store s
JOIN sakila.address a ON s.address_id = a.address_id
JOIN sakila.city ci ON a.city_id = ci.city_id
JOIN sakila.country co ON ci.country_id = co.country_id
GROUP BY s.store_id;

# OR

SELECT s.store_id, ci.city, co.country
FROM sakila.store s
JOIN sakila.address a USING(address_id)
JOIN sakila.city ci USING(city_id)
JOIN sakila.country co USING(country_id)
GROUP BY s.store_id;

-- 2. Write a query to display how much business, in dollars, each store brought in.

SELECT * FROM sakila.store;		-- store_id
SELECT * FROM sakila.staff;		-- store_id, staff_id
SELECT * FROM sakila.payment;	-- staff_id, amount

SELECT s.store_id, round(sum(p.amount)) AS business_in_dollars
FROM sakila.store s
JOIN sakila.staff f USING(store_id)
JOIN sakila.payment p USING(staff_id)
GROUP BY s.store_id;

-- 3. What is the average running time of films by category?

SELECT * FROM sakila.category;			-- category_id, name
SELECT * FROM sakila.film_category;		-- film_id, category_id
SELECT * FROM sakila.film;				-- film_id, length

SELECT c.name AS category, round(AVG(f.length) , 2) AS average_running_time
FROM sakila.category c
JOIN sakila.film_category fc USING(category_id)
JOIN sakila.film f USING(film_id)
GROUP BY c.name
ORDER BY c.name ASC;

-- 4. Which film categories are longest?

SELECT c.name AS category, round(AVG(f.length) , 2) AS average_running_time
FROM sakila.category c
JOIN sakila.film_category fc USING(category_id)
JOIN sakila.film f USING(film_id)
GROUP BY c.name
ORDER BY average_running_time DESC;				-- Sports=128.20, Games=127.84, Foreign=121.70

-- 5. Display the most frequently rented movies in descending order.

SELECT * FROM sakila.film;		-- title, film_id
SELECT * FROM sakila.inventory;	-- film_id, inventory_id
SELECT * FROM sakila.rental; 	-- inventory_ id, rental_id, 

SELECT f.title AS film_title, COUNT(rental_id) AS frequently_rented
FROM sakila.film f
JOIN sakila.inventory i USING(film_id)
JOIN sakila.rental r USING(inventory_id)
GROUP BY f.title
ORDER BY COUNT(rental_id) DESC;			-- BUCKET BROTHERHOOD=34, ROCKETEER MOTHER=33, FORWARD TEMPLE=32 

-- 6. List the top five genres in gross revenue in descending order.

SELECT * FROM sakila.category;			-- name, category_id
SELECT * FROM sakila.film_category;		-- category_id, film_id
SELECT * FROM sakila.inventory;			-- film_id, inventory_id
SELECT * FROM sakila.rental;			-- inventory_id, customer_id
SELECT * FROM sakila.payment;			-- customer_id, amount

SELECT c.name AS category, round(SUM(amount)) AS gross_revenue
FROM sakila.category c 
JOIN sakila.film_category fc USING(category_id)
JOIN sakila.inventory i USING(film_id)
JOIN sakila.rental r USING(inventory_id)
JOIN sakila.payment p USING(customer_id)
GROUP BY c.name
ORDER BY round(SUM(amount)) DESC
LIMIT 5; 								-- Sports=138260, Animation=137088, Action=130659, Family=129028, Sci-Fi=127759

-- 7. Is "Academy Dinosaur" available for rent from Store 1?

SELECT * FROM sakila.film;			-- title, film_id
SELECT * FROM sakila.inventory;		-- film_id, inventory_id

SELECT f.title, sum(i.store_id)
FROM sakila.film f
JOIN sakila.inventory i USING(film_id)
WHERE f.title = "Academy Dinosaur" AND i.store_id = 1			-- THe film "Academy Dinosaur" stilla have 4 coies in the Store 1.
