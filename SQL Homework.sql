USE sakila;

#1a
SELECT first_name, last_name
FROM actor;

#1b
SELECT CONCAT(first_name,' ',last_name) AS 'Actor Name'
FROM actor;

#2a
SELECT actor_id, first_name, last_name 
FROM actor 
WHERE first_name = "Joe";

#2b
SELECT first_name, last_name 
FROM actor 
WHERE last_name LIKE '%gen%';

#2c
SELECT first_name, last_name 
FROM actor 
WHERE last_name LIKE '%li%' 
ORDER BY last_name,first_name;

#2d
SELECT country_id, country 
FROM country 
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

#3a
ALTER TABLE actor
	ADD description BLOB;

#3b
ALTER TABLE actor
	DROP description;
    SELECT * FROM actor;
	
#4a
SELECT last_name, COUNT(*)
FROM actor
GROUP BY last_name;

#4b
SELECT last_name, COUNT(*)
FROM actor
GROUP BY last_name
ORDER BY COUNT(*) DESC;

#4c
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";

#4d
UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO";

#5a
#CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8);

#6a
SELECT staff.first_name, staff.last_name, address.address
FROM staff
JOIN address ON
staff.address_id = address.address_id;

#6b
SELECT staff.first_name, staff.last_name, SUM(payment.amount) AS "total amount"
FROM staff
JOIN payment ON 
staff.staff_id = payment.staff_id
WHERE MONTH(payment.payment_date) = 08 AND YEAR(payment.payment_date)=2005
GROUP BY staff.first_name, staff.last_name;

#6c
SELECT film.title AS 'Film', COUNT(film_actor.actor_id) AS 'Number of Actors'
FROM film
INNER JOIN film_actor ON
film.film_id = film_actor.film_id
GROUP BY Film;

#6d
SELECT film.title, COUNT(inventory.inventory_id)
FROM film
INNER JOIN inventory ON
film.film_id = inventory.film_id
WHERE film.title = "Hunchback Impossible"
GROUP BY film.title;

#there are 6 copies in the inventory system

#6e
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS 'Total Amount Paid'
FROM customer
JOIN payment ON
customer.customer_id = payment.customer_id
GROUP BY customer.first_name, customer.last_name
ORDER BY customer.last_name;

#7a
SELECT film.title, language.name 
FROM film
JOIN language ON
film.language_id = language.language_id
WHERE language.name = 'English'
AND (film.title LIKE 'K%' or film.title LIKE 'Q%');

#7b
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
	SELECT actor_id
    FROM film_actor
    WHERE film_id IN
    (
		SELECT film_id
        FROM film
        WHERE title = 'Alone Trip'
	)
);

#7c
SELECT customer.email, country.country
FROM customer
JOIN address ON
customer.address_id = address.address_id
JOIN city ON 
address.city_id = city.city_id
JOIN country ON
city.country_id = country.country_id
WHERE country.country = 'Canada';

#7d
SELECT film.title, category.name
FROM film
JOIN film_category ON
film.film_id = film_category.film_id
JOIN category ON
category.category_id = film_category.category_id
WHERE name = 'family';

#7e
SELECT film.title AS 'Film' , COUNT(rental.rental_date) AS 'Times Rented'
FROM film
JOIN inventory 
ON film.film_id =inventory.film_id
JOIN rental
ON inventory.inventory_id = rental.inventory_id
GROUP BY Film
ORDER BY COUNT(rental.rental_date) DESC;

#7f
SELECT SUM(payment.amount) AS 'Total Dollars', address.district
FROM payment
JOIN staff
ON staff.staff_id = payment.staff_id
JOIN store 
ON staff.store_id = store.store_id
JOIN address
ON store.address_id = address.address_id
GROUP BY address.district;

#7g
SELECT store.store_id, city.city, country.country
FROM store
JOIN address
ON store.address_id = address.address_id
JOIN city 
ON address.city_id = city.city_id
JOIN country
ON city.country_id = country.country_id;

#7h
SELECT category.name, SUM(payment.amount) AS "Gross Revenue"
FROM category
JOIN film_category
ON category.category_id = film_category.category_id
JOIN inventory
ON film_category.film_id = inventory.film_id
JOIN rental
ON inventory.inventory_id = rental.inventory_id
JOIN payment
ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount)
LIMIT 5;

#8a
CREATE VIEW top_five_genres AS
SELECT category.name, SUM(payment.amount) AS "Gross Revenue"
FROM category
JOIN film_category
ON category.category_id = film_category.category_id
JOIN inventory
ON film_category.film_id = inventory.film_id
JOIN rental
ON inventory.inventory_id = rental.inventory_id
JOIN payment
ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount)
LIMIT 5;

    
#8b
SELECT * FROM top_five_genres;

#8c
DROP VIEW top_five_genres;