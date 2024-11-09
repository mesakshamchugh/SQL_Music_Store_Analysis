USE music_database

#1 Who is the senior most employee based on job title ?
SELECT title, first_name, last_name
FROM employee
ORDER BY levels DESC
Limit 1;

#2 which country have the most invoices ?
SELECT COUNT(*) AS Invoices, billing_country
FROM invoice
GROUP BY billing_country
ORDER BY Invoices DESC
Limit 1;

#3 what are the values of top 3 invoice ?
SELECT invoice_id, total AS invoice_value
FROM invoice
ORDER BY invoice_value DESC
Limit 3;

#4 Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
#Write a query that returns one city that has the highest sum of invoice totals. 
#Return both the city name & sum of all invoice totals 
SELECT billing_city AS city, SUM(total) AS invoice_total
from invoice
GROUP BY billing_city
ORDER BY invoice_total DESC
Limit 1;

#5 Who is the best customer? The customer who has spent the most money will be declared the best customer. 
#Write a query that returns the person who has spent the most money.
SELECT customer.customer_id,customer.first_name,customer.last_name,SUM(invoice.total) AS money_spend
FROM customer
JOIN invoice ON invoice.customer_id = customer.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name
ORDER BY money_spend DESC
Limit 1;

#6 Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
#Return your list ordered alphabetically by email starting with A.
SELECT DISTINCT email, first_name, last_name
FROM customer
JOIN invoice ON customer.customer_id=invoice.customer_id
JOIN invoice_line ON invoice.invoice_id=invoice_line.invoice_id
JOIN track ON invoice_line.track_id=track.track_id
JOIN genre ON track.genre_id=genre.genre_id
WHERE genre.name LIKE 'Rock'
ORDER BY customer.email ASC;

#7 Let's invite the artists who have written the most rock music in our dataset. 
#Write a query that returns the Artist name and total track count of the top 10 rock bands.
SELECT artist.artist_id, artist.name, COUNT(artist.artist_id) AS no_of_songs
FROM track
JOIN album1 ON album1.album_id = track.album_id
JOIN artist ON artist.artist_id = album1.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id, artist.name
ORDER BY no_of_songs DESC
LIMIT 10; 

#8 Return all the track names that have a song length longer than the average song length.
#Return the name and millisecond for each track. Order by the song length with the longest songs listed first.
SELECT track.name AS Track_name, milliseconds
FROM track
WHERE milliseconds >(SELECT AVG(milliseconds) AS AVG_length
FROM track)
ORDER BY milliseconds DESC;

#9 Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent
WITH best_selling_artist AS (
SELECT artist.artist_id AS artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS Total_sales
FROM invoice_line
JOIN track ON track.track_id=invoice_line.track_id
JOIN album1 ON album1.album_id=track.album_id
JOIN artist ON artist.artist_id=album1.artist_id
GROUP BY artist_id, artist.name
ORDER BY Total_sales DESC
Limit 1
)
SELECT * FROM best_selling_artist

#10 We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre
#with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
#the maximum number of purchases is shared return all Genres.
WITH popular_genre AS 
(
SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
FROM invoice_line 
JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
JOIN customer ON customer.customer_id = invoice.customer_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN genre ON genre.genre_id = track.genre_id
GROUP BY 2,3,4
ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1
 
#11 Write a query that determines the customer that has spent the most on music for each country. 
#Write a query that returns the country along with the top customer and how much they spent. 
#For countries where the top amount spent is shared, provide all customers who spent this amount.
WITH Customer_with_country AS (
       SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
       ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS Rowno
       FROM invoice
       JOIN customer ON customer.customer_id = invoice.customer_id
       GROUP BY 1,2,3,4
	   ORDER BY 4 ASC,5 DESC )
SELECT * FROM Customer_with_country WHERE Rowno <= 1














 