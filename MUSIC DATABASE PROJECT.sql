
--Question Set 1 - Easy

--Q1: Who is senior most employee based on Job title?

SELECT employee_id, CONCAT(first_name, ' ', last_name) AS full_name,
title, levels  FROM employee   
order by levels desc
limit 1


--Q2: Which countries have the most Invoices?

SELECT COUNT(*) AS c, billing_country 
FROM invoice
GROUP BY billing_country
ORDER BY c DESC


--Q3: What are top 3 values of total invoice?

SELECT total AS top_values FROM invoice
ORDER BY total DESC
LIMIT 3


--Q4: Which city has the best customers? We would like to throw a promotional
--Music Festival in the city we made the most money. 
--Write a query that returns one city that has the highest sum of invoice totals. 
--Return both the city name & sum of all invoice totals

SELECT i.billing_city,
SUM(i.total) AS total_invoice
FROM invoice i GROUP BY i.billing_city HAVING SUM(i.total) = (
SELECT MAX(total_invoice) FROM (SELECT SUM(i.total) AS total_invoice 
FROM invoice i GROUP BY i.billing_city) t)


--Q5: Who is the best customer? The customer who has spent the most money
--    will be declared the best customer. 
--Write a query that returns the person who has spent the most money.

SELECT i.customer_id, concat(c.first_name,' ',c.last_name) AS full_name,
SUM(i.total) AS total_invoice
FROM invoice i JOIN customer c ON 
c.customer_id = i.customer_id group by i.customer_id, full_name
ORDER BY total_invoice DESC
LIMIT 1


--Question Set 2 - Moderate

--Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
--    Return your list ordered alphabetically by email starting with A.

SELECT DISTINCT c.email, c.first_name, c.last_name
FROM track t JOIN invoice_line il ON t.track_id = il.track_id
JOIN invoice i ON i.invoice_id = il.invoice_id
JOIN customer c ON c.customer_id = i.customer_id
WHERE t.genre_id = '1'
ORDER BY c.email ASC


--Q2: Let's invite the artists who have written the most rock music in our dataset. 
--    Write a query that returns the Artist name and total track count of the top 10 rock bands.

SELECT ar.name, COUNT(t.track_id) AS count_track FROM 
track t JOIN album a ON t.album_id = a.album_id
JOIN artist ar ON ar.artist_id = a.artist_id
WHERE t.genre_id = '1'
GROUP BY ar.name
ORDER BY count_track DESC
LIMIT 10


--Q3: Return all the track names that have a song length
--   longer than the average song length. 
--   Return the Name and Milliseconds for each track. 
--   Order by the song length with the longest songs listed first.

SELECT t.name, t.milliseconds AS song_length
FROM track t
GROUP BY t.track_id HAVING t.milliseconds > (
SELECT ROUND(AVG(t.milliseconds),2)
AS avg_song_length FROM track t
) ORDER BY song_length DESC


--Question Set 3 - Advance 

--Q1: Find how much amount spent by each customer on artists? 
--Write a query to return customer name, artist name and total spent 

/* Steps to Solve: First, find which artist has earned the most according to the 
InvoiceLines. Now use this artist to find which customer spent the most on this 
artist. For this query, you will need to use the Invoice, InvoiceLine, Track, 
Customer, Album, and Artist tables. Note, this one is tricky because the Total 
spent in the Invoice table might not be on a single product, so you need to use
the InvoiceLine table to find out how many of each product was purchased, and 
then multiply this by the price for each artist. */


WITH best_selling_artist AS (

select ar.artist_id, ar.name as artist_name, 
sum(il.unit_price * il.quantity) as total_revenue
from invoice_line il join invoice i 
on il.invoice_id = i.invoice_id
join track t on il.track_id = t.track_id
join album a on t.album_id = a.album_id
join artist ar on a.artist_id = ar.artist_id
group by ar.artist_id
order by total_revenue desc 
limit 1
)

select concat(c.first_name,' ',c.last_name) 
as customer_name, bsa.artist_name as artist_name, 
round(cast(sum(il.unit_price * il.quantity) as numeric),2) as total_revenue
from invoice_line il join invoice i 
on il.invoice_id = i.invoice_id
join customer c on i.customer_id = c.customer_id
join track t on il.track_id = t.track_id
join album a on t.album_id = a.album_id
join artist ar on a.artist_id = ar.artist_id
join best_selling_artist bsa on bsa.artist_id = a.artist_id
group by c.customer_id, customer_name, ar.artist_id, artist_name 
order by total_revenue desc


/* Q2: We want to find out the most popular music Genre for each country. We determine 
the most popular genre as the genre with the highest amount of purchases. Write a query 
that returns each country along with the top Genre. For countries where the maximum 
number of purchases is shared return all Genres. */

WITH best_selling_genre as (

select i.billing_country, g.name,
count(il.invoice_line_id) as total_purchases,
DENSE_RANK() OVER (PARTITION BY i.billing_country
ORDER BY count(il.invoice_line_id) DESC) AS D_RANKED
from invoice i join invoice_line il on i.invoice_id = il.invoice_id
join track t on t.track_id = il.track_id
join genre g on t.genre_id = g.genre_id
group by i.billing_country, g.name
order by total_purchases desc, i.billing_country asc
)
 select * from best_selling_genre where D_RANKED <= 1



/* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

/* Steps to Solve:  Similar to the above question. There are two parts in question- 
-first find the most spent on music for each country 
-second filter the data for respective customers. */


WITH most_spent AS (
SELECT i.billing_country, concat(c.first_name,' ',c.last_name) AS customer_name,
ROUND(CAST(SUM(il.quantity * il.unit_price) AS NUMERIC),2) AS total_spent,
DENSE_RANK() OVER(
PARTITION BY i.billing_country
ORDER BY SUM(il.quantity * il.unit_price) DESC) AS D_RANK 
FROM invoice i JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN customer c ON i.customer_id = c.customer_id
GROUP BY i.billing_country, c.customer_id, customer_name
ORDER BY total_spent DESC
)
SELECT * FROM most_spent WHERE D_RANK <= 1

