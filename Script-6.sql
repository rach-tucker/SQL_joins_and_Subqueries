--1. List all customers who live in Texas (use JOINs)
select *
from customer;

select *
from customer c 
join address a 
on c.customer_id = a.address_id;

select c.first_name, c.last_name, a.district
from customer c
join address a
on c.customer_id = a.address_id
where district like 'Texas';


--2. List all payments of more than $7.00 with the customer’s first and last name
select customer_id 
from payment
where amount > 7.00
group by customer_id;

select c.first_name, c.last_name, p.amount
from customer c 
join payment p
on c.customer_id = p.payment_id 
where amount > 7.00;

select c.first_name, c.last_name, r.customer_id, p.amount
from customer c
join rental r 
on c.customer_id = r.rental_id
join payment p 
on r.rental_id = p.payment_id;


--3. Show all customer names who have made over $175 in payments (use
--subqueries)

select customer_id
from payment
group by customer_id
having sum(amount) > 175

select *
from customer 
where customer_id in (
	144,
	526,
	178,
	459,
	137,
	148
);

---now combine:

select *
from customer 
where customer_id in(
	select customer_id
	from payment
	group by customer_id
	having sum(amount) > 175
);


--4. List all customers that live in Argentina (use the city table)
select city_id
from city
where country_id = '6';

select * 
from country

select *
from address
where city_id in (
	20,
	43,
	45,
	128,
	161,
	165,
	289,
	334,
	424,
	454,
	457,
	524,
	56
);

--combine: (this wasn't necessary?)
select *
from address
where city_id in(
	select city_id
	from city
	where country_id = '6'
);


--using customer_id associated with city_id that is associated with country_id of 6, therefore living in Argentina
select *
from customer 
where address_id in (
	28,
	65,
	93,
	111,
	247,
	327,
	336,
	364,
	410,
	450,
	536,
	566,
	591
);

--below gives first and last name of customers who live in Argentina.. 

select c.first_name, c.last_name
from customer c
where address_id in (
	select city_id
	from city
	where country_id = '6'
);

--return a data table containing first_name, last_name, district, city and country


select c.first_name, c.last_name, a.district, ci.city, co.country
from customer c
join address a
on c.customer_id = a.address_id
join city ci
on ci.city_id = a.address_id
join country co
on co.country_id = a.address_id
where co.country_id = '6'; -- or 'Argentina'

--above is only showing Jennifer Davis ? 


--5. Show all the film categories with their count in descending order


select category_id, COUNT(*) as num_movies_in_cat
from film_category
group by category_id
order by num_movies_in_cat desc;


--6. What film had the most actors in it (show film info)?


select film_id, COUNT(*) as num_actors
from film_actor
group by film_id;

select MAX(num_actors)
from (
	select film_id, COUNT(*) as num_actors
	from film_actor
	group by film_id
) as most_actors;

select *
from film
where film_id in (
	select film_id 
	from film_actor 
	group by film_id
	having count(*) = (
		select MAX(num_actors)
		from (
			select film_id, COUNT(*) as num_actors
			from film_actor
			group by film_id
		) as most_actors
	)
);

--7. Which actor has been in the least movies?

select actor_id, COUNT(*) as num_in_movies
from film_actor
group by actor_id;

select MIN(num_in_movies)
from (
	select actor_id, COUNT(*) as num_in_movies
	from film_actor
	group by actor_id
) as lease_num_in_movies;

select * 
from actor
where actor_id in (
	select actor_id
	from film_actor
	group by actor_id
	having count(*) = (
		select MIN(num_in_movies)
		from (
			select actor_id, COUNT(*) as num_in_movies
			from film_actor
			group by actor_id
		) as lease_num_in_movies
	)
);


--8. Which country has the most cities?

select * 
from city

select country_id, COUNT(*) as num_cities
from city 
group by country_id;

select max(num_cities)
from (
	select country_id, COUNT(*) as num_cities
	from city 
	group by country_id
) as most_cities;

select *
from country 
where country_id in (
	select country_id 
	from city
	group by country_id 
	having count(*) = (
		select max(num_cities)
		from (
			select country_id, COUNT(*) as num_cities
			from city 
			group by country_id
		) as most_cities
	)
);
	
	



--9. List the actors who have been in between 20 and 25 films.

select actor_id, COUNT(*) as num_in_movies
from film_actor
group by actor_id
having count(*) between 20 and 25;

select *
from actor
where actor_id in(
	select actor_id 
	from film_actor
	group by actor_id 
	having count(*) = (
		select count(num_in_movies)
		from(
			select actor_id, COUNT(*) as num_in_movies
			from film_actor
			group by actor_id
			having count(*) between 20 and 25
		) as between_nums
	)
);


-- Below is not correct.

select *
from actor
where actor_id in(
	select actor_id 
	from film_actor
	group by actor_id 
	having count(*) = (
		select actor_id, COUNT(*)
		from film_actor
		group by actor_id
		having count(*) between 20 and 25
	) as between_nums
);	


