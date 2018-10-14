USE sakila;

-- 1a. Display the first and last names of all actors from the table `actor`.
Select first_name, last_name from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
Select concat(first_name," ",last_name) as Actor_Name from actor ;
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name from actor
	where first_name = "Joe";
-- 2b. Find all actors whose last name contain the letters `GEN`:
Select first_name, last_name from actor
	where last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
select last_name, first_name from actor
	where last_name like '%LI%';
-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country from country
	Where country in ('Afghanistan','Bangladesh','China');
    
-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
ALTER TABLE actor
ADD column description BLOB (200); 

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
ALTER TABLE actor
drop column description;
--  4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(*)
 from actor
	group by last_name;
    
   
--  4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(*)
 from actor
	group by last_name
    having count(*) > 1;
-- 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
select * FROM ACTOR
WHERE FIRST_NAME = 'GROUCHO' and Last_name = 'Williams';

UPDATE ACTOR
SET FIRST_NAME ='HARPO' 
WHERE FIRST_NAME = 'GROUCHO' and Last_name = 'Williams';


-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE ACTOR
SET FIRST_NAME ='GROUCHO' 
WHERE FIRST_NAME = 'HARPO' and Last_name = 'Williams';
-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
DESCRIBE ADDRESS;
--  Hint: [https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html](https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html)

--  6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
Select first_name, last_name, address.address from staff
Inner Join address on 
staff.address_id = address.address_id;

-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
Select payment.staff_id, sum(amount) as Total_amount from payment
Inner Join staff on
payment.staff_id = staff.staff_id
WHERE payment_date BETWEEN 
     CAST('2005-08-01' AS DATE) AND CAST('2005-08-31' AS DATE)
	 Group by(payment.staff_id);

-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
select film.title, count(film_actor.actor_id) as Actorcount from film
Inner Join film_actor on
film_actor.film_id =  film.film_id
group by film.title;
--  6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
select film.film_id
  from film 
  where film.title= 'Hunchback Impossible';
  
select * from inventory where film_id = 439;

select film.title, count(inventory.inventory_id) as CopiesinInventory from inventory
Inner Join film on
inventory.film_id = film.film_id
where film.title = 'Hunchback Impossible';
--  6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
select customer.last_name,customer.first_name, sum(payment.amount) as Total_Amount_Paid from payment
Inner Join customer on
payment.customer_id = customer. customer_id
group by customer.last_name;
--   ![Total amount paid](Images/total_payment.png)

--  7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.

Select film.title,Language.name from film
Inner Join Language on
language.language_id = film.language_id
where language.name = 'ENGLISH'
And	film.film_id in 
(Select film.film_id from film
where film.title like 'K%' or film.title like 'Q%');

--  7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
select actor.first_name, actor.last_name from actor
Inner Join film_actor ON
film_actor.actor_id = actor.actor_id
and film_actor.film_id in
(select film.film_id from film
where film.title = 'Alone Trip');

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
Select customer.first_name, customer.last_name, customer.email from customer
Join address ON
address.address_id = customer.address_id
Join City on
city.city_id = address.city_id
Join country on
country.country_id = city. country_id
where country.country = 'Canada';

--  7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.
select * from film;
select * from category;
select * from film_category;

Select film.title from film
Join film_Category ON
film.film_id =film_category.film_id
Join Category ON
film_Category.category_id = category.category_id
Where category.name = 'family';
--  7e. Display the most frequently rented movies in descending order.
select * from rental;
select * from inventory;
select * from film;
Select film.title, count(rental.rental_id) as RentedMoviesCount from film
Join inventory on
film.film_id = inventory.film_id
join rental on
rental.inventory_id = inventory.inventory_id
	group by film.title order by RentedMoviesCount DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
select * from store;
select * from inventory;
select * from Rental;
select * from payment;

select store.store_id, sum(payment.amount) as Businessin$ from store
Join Inventory on
store.store_id= inventory.store_id
Join Rental on
Rental.inventory_id =  inventory.inventory_id
Join Payment on
Payment.rental_id = rental.rental_id
group by store.store_id;


--  7g. Write a query to display for each store its store ID, city, and country.
select store.store_id, city.city, country.country from store
Join address ON
store.address_id = address.address_id
Join city on
city.city_id = address.city_id
join country on
country.country_id = city.country_id;


--  7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select category.name,sum(payment.amount) as Gross_Revenue from category
Join Film_category ON
category.category_id = film_category.category_id
Join Inventory ON
film_category.film_id = Inventory.film_id
Join Rental ON
rental.inventory_id = Inventory.inventory_id
Join payment ON
Payment.rental_id = Rental.Rental_id
group by category.name Order by Gross_Revenue DESC LIMIT 5;

--  8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
create view TOP5Genres as
select category.name,sum(payment.amount) as Gross_Revenue from category
Join Film_category ON
category.category_id = film_category.category_id
Join Inventory ON
film_category.film_id = Inventory.film_id
Join Rental ON
rental.inventory_id = Inventory.inventory_id
Join payment ON
Payment.rental_id = Rental.Rental_id
group by category.name Order by Gross_Revenue DESC LIMIT 5;

--  8b. How would you display the view that you created in 8a?
select * from TOP5Genres;
--  8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
drop view TOP5Genres;