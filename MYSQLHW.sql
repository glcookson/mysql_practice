USE sakila;

#1a
SELECT first_name, last_name FROM actor;

#1b
ALTER TABLE actor ADD COLUMN combined VARCHAR(50);
UPDATE actor  SET combined = CONCAT(first_name, ', ', last_name);

#2a
SELECT actor_id, first_name, last_name FROM actor WHERE first_name="Joe";

#2b
SELECT first_name, last_name FROM actor WHERE last_name LIKE "%GEN%";

#2c
SELECT first_name, last_name FROM actor WHERE last_name LIKE "%LI%" ORDER BY last_name, first_name;

#2d
SELECT country_id, country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

#3a
ALTER table actor Add column middle_name varchar(255) AFTER first_name;

#3b
ALTER TABLE actor MODIFY middle_name BLOB;

#3c
ALTER TABLE actor DROP COLUMN middle_name;

#4a
SELECT last_name, COUNT( last_name) FROM actor GROUP BY last_name;

#4b
SELECT last_name, COUNT( last_name) AS cnt
FROM actor
GROUP BY last_name
HAVING cnt > 1;

#4c
UPDATE actor SET first_name='HARPO' WHERE first_name='GROUCHO' AND last_name = 'WILLIAMS';

#4d
UPDATE actor SET first_name = 
CASE
	WHEN first_name = 'HARPO' THEN 'GROUCHO'
    ELSE 'MUCHO GROUCHO'
END
WHERE last_name = 'WILLIAMS';

#5a
CREATE TABLE IF NOT EXISTS address (
  address_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  address VARCHAR(50) NOT NULL,
  address2 VARCHAR(50) DEFAULT NULL,
  district VARCHAR(20) NOT NULL,
  city_id SMALLINT UNSIGNED NOT NULL,
  postal_code VARCHAR(10) DEFAULT NULL,
  phone VARCHAR(20) NOT NULL,
  /*!50705 location GEOMETRY NOT NULL,*/
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (address_id),
  KEY idx_fk_city_id (city_id),
  /*!50705 SPATIAL KEY `idx_location` (location),*/
  CONSTRAINT `fk_address_city` FOREIGN KEY (city_id) REFERENCES city (city_id) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

#6a
SELECT staff.first_name, staff.last_name, address.address
FROM staff
JOIN address ON
staff.address_id = address.address_id;

#6b
SELECT 
    s.first_name,
    s.last_name,
    p.staff_id,
    SUM(amount) AS total_amount
FROM
    staff s
        JOIN
    payment p USING (staff_id)
WHERE
    YEAR(p.payment_date) = 2005
    AND MONTH(p.payment_date) = 08
GROUP BY p.staff_id;


#6c
SELECT title, Count(actor_id) AS total_actors
FROM film
INNER JOIN film_actor ON
film.film_id = film_actor.film_id
GROUP BY title;

#6d
SELECT COUNT(film_id) FROM film WHERE title = 'Hunchback Impossible';

#6e
SELECT customer_id, first_name, last_name, SUM(amount) AS total_payment
FROM customer
JOIN payment USING (customer_id)
GROUP BY customer_id
ORDER BY last_name;

#7a
# language_id = 'ENLISH' 
SELECT title FROM film WHERE title LIKE 'Q%' OR  title LIKE 'K%';

#7b
SELECT first_name, last_name FROM actor 
WHERE actor_id IN
(
	SELECT actor_id FROM film_actor
	WHERE film_id IN
    (
		SELECT film_id FROM film WHERE title = 'Alone Trip'
	)
);


#7c
SELECT first_name, last_name, email
FROM customer
JOIN address USING (address_id)
JOIN city USING (city_id)
JOIN country USING (country_id)
WHERE country = 'canada'
GROUP BY customer_id;

#7d
SELECT title
FROM film
JOIN film_category USING (film_id)
JOIN category USING (category_id)
WHERE name = 'family';

#7e
SELECT title, COUNT(*) AS cnt
FROM film
JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
GROUP BY title
ORDER BY cnt DESC;

#7f
SELECT store_id, SUM(amount) AS total_profit
FROM store
JOIN customer USING (store_id)
JOIN payment USING (customer_id)
GROUP BY store_id;

#7g
SELECT store_id, city, country
FROM store
JOIN address USING (address_id)
JOIN city USING (city_id)
JOIN country USING (country_id)
GROUP BY store_id;

#7h
SELECT name, COUNT(name) AS genre
FROM category
JOIN film_category USING (category_id)
JOIN film USING (film_id)
JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
JOIN payment USING (rental_id)
GROUP BY name
ORDER BY COUNT(name) DESC
LIMIT 5;


#8a
CREATE VIEW Top_Five_Genre AS
SELECT name, COUNT(name) AS genre
FROM category
JOIN film_category USING (category_id)
JOIN film USING (film_id)
JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
JOIN payment USING (rental_id)
GROUP BY name
ORDER BY COUNT(name) DESC
LIMIT 5;

#8b
SELECT * FROM Top_Five_Genre;


#8c
DROP VIEW Top_Five_Genre;
