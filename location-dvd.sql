-- Missions:

-- Nous voulons connaitre les différentes notes (colonne rating) des Etats-Unis (PG, PG-13, R, etc...) présentes dans la table films

SELECT DISTINCT rating
FROM film;

-- Nous Souhaitons aussi connaitre les différents taux de location (colonne rental_rate) présentes dans la table films

SELECT DISTINCT rental_rate
FROM film;

-- Compter le nombre de films des différentes rating et rental_rate.

SELECT rating, COUNT (rating)
FROM film
GROUP BY rating;

SELECT rental_rate, COUNT (rental_rate)
FROM film
GROUP BY rental_rate;

-- Je viens d'ajouter à la liste de films présents dans le magasin un nouveau film qui pourrait plaire à 'Gloria Cook', pouvez-vous me donner son mail afin que je lui envoie un message?

SELECT email
FROM customer
WHERE first_name = 'Gloria' AND last_name = 'Cook'
;

-- On m'a parlé d'un film qui se nomme 'Texas Watch' et j'aimerai savoir si ça peut me plaire. Pouvez-vous me fournir une description de ce film?

SELECT title, description
FROM film
WHERE title == 'Texas Watch'
;

-- Un client est en retard pour rendre son film loué la semaine dernière, nous avons noté son adresse qui est '270 Toulon Boulevard'. Pouvez-vous trouver son numéro de téléphone qu'on le prévienne?

SELECT phone
FROM address
WHERE address = '270 Toulon Boulevard'
;

-- Compter le nombre d'acteur dont le nom de famille commence par P

SELECT COUNT(last_name)
FROM actor
WHERE last_name LIKE 'P%'
;

-- Compter le nombre de films qui contiennent Truman dans leur titre

SELECT COUNT(title)
FROM film
WHERE title LIKE '%Truman%'
;

-- Quel est le client qui a le plus grand customer ID et dont le prénom commence par 'E' et a un adress id inférieur à 500?

SELECT first_name, last_name
FROM customer
WHERE first_name LIKE 'E%' AND address_id < 500
ORDER BY customer_id DESC
LIMIT 1
;

-- Nous avons 2 équipes différentes qu'on appelle staff_id 1 et staff_id 2. Nous souhaitons donner un bonus à l'équipe qui a obtenu le plus de paiements
-- Combien de paiements a réalisé chaque équipe et pour quel montant?

SELECT first_name, last_name, COUNT(payment.amount) AS number_payment, SUM(payment.amount) AS sum_payment
FROM staff, payment
WHERE staff.staff_id = payment.staff_id
GROUP BY staff.staff_id
ORDER BY number_payment DESC
;

-- Un cabinet d'audit est en train d'auditer notre magasin et souhaiterait connaitre le cout moyen de remplacement des films par lettre de notation (ex: R, PG, ...)

SELECT rating, AVG(replacement_cost)
FROM film
GROUP BY rating
;

-- Nous voulons distribuer des coupons à nos 5 clients qui ont dépensé le plus d'argent dans notre magasin
-- Obtenez les IDs de ces 5 personnes

SELECT customer_id, SUM(amount) AS somme
FROM payment
GROUP BY customer_id
ORDER BY somme DESC
LIMIT 5
;


-- Nous souhaitons distribuer une carte de paiements avantageuse pour nos meilleurs clients, Sont éligibles à cette carte les clients qui totalisent au moins 30 transactions de paiements
-- Quels clients sont donc éligibles? (vous fournirez leur IDs)

SELECT customer_id, COUNT(rental_id)
FROM payment
GROUP BY customer_id
HAVING COUNT(rental_id) >= 30
;

-- Obtenir les notations (R, PG, ...) dont la durée de location moyenne est supérieure à 5 jours

SELECT rating , AVG(rental_duration) AS diff
FROM film
GROUP BY rating
HAVING diff > 5
;

--Obtenir les IDs des clients qui ont payé plus de 110$ à l'équipe staff 2

SELECT customer_id, SUM(amount)
FROM payment
WHERE staff_id = 2
GROUP BY customer_id
HAVING SUM(amount) > 110
;


-- Afficher la liste de tous les films accompagnés de la catégorie de films auwquelles ils appartiennent ainsi que la langue du film


SELECT title, c.name, l.name
FROM film AS f
INNER JOIN film_category AS fc ON fc.film_id = f.film_id
INNER JOIN category AS c ON c.category_id = fc.category_id
INNER JOIN language AS l ON l.language_id = f.language_id
ORDER BY title
;

-- Challenge Marketing 1: Trouver les films qui rapportent le plusieurs


SELECT title, rental_rate, COUNT(r.rental_id) AS number_location, rental_rate*COUNT(r.rental_id) AS revenu_film
FROM film AS f
INNER JOIN inventory AS i ON i.film_id = f.film_id
INNER JOIN rental AS r ON r.inventory_id = i.inventory_id
GROUP BY title, rental_rate
ORDER BY revenu_film DESC;

-- Challenge Marketing 2: Quel est le magasin qui a vendu le plus (Store 1 ou Store 2?)


SELECT s.store_id, COUNT(amount) AS number_sell, SUM(amount) AS total
FROM store AS s
INNER JOIN staff AS st ON st.store_id = s.store_id
INNER JOIN payment AS p ON p.staff_id = st.staff_id
GROUP BY s.store_id
ORDER BY total DESC
;

-- Challenge Marketing 3: Nombre de locations de films d'actions, comedies et animation


SELECT c.name, COUNT(rental_id) AS number_rental
FROM category AS c
INNER JOIN film_category AS fc ON fc.category_id = c.category_id
INNER JOIN film AS f ON f.film_id = fc.film_id
INNER JOIN inventory AS i ON i.film_id = f.film_id
INNER JOIN rental AS r ON r.inventory_id = i.inventory_id
WHERE c.name IN ('Action','Comedy','Animation')
GROUP BY c.name
ORDER BY number_rental DESC;

-- Challenge Marketing 4: Envoyer une offre promotionnelle à tous les clients qui ont loué au moins 40 films

SELECT c.customer_id, email, COUNT(DISTINCT i.film_id)
FROM customer AS c
INNER JOIN rental AS r ON r.customer_id = c.customer_id
INNER JOIN inventory AS i ON i.inventory_id = r.inventory_id
GROUP BY c.customer_id
HAVING COUNT(DISTINCT i.film_id) > 40;

SELECT c.customer_id, email, COUNT(DISTINCT inventory_id)
FROM customer AS c
INNER JOIN rental AS r ON r.customer_id = c.customer_id
GROUP BY c.customer_id
HAVING COUNT(DISTINCT inventory_id) > 40;
