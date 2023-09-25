use sakila;

-- Create a View
-- First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
create view rental_summary as
select c.customer_id, concat (c.first_name, ' ', c.last_name) as name, 
c.email, count(r.rental_id) as rental_count
from customer as c
LEFT join  rental as r 
on c.customer_id = r.customer_id
group by c.customer_id, name , c.email;

-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.
create temporary table customer_payment_table as 
select rs.customer_id, rs.name, rs.rental_count,rs.email,
sum(p.amount) as total_paid
from rental_summary as rs
left join payment as p on rs.customer_id= p.customer_id
group by rs.customer_id;


select * from customer_payment_table;

-- Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid.

with customer_summary_report as(
	select 
		cp.name as customer_name,
        cp.email as 'email address',
        rs.rental_count as 'rental count',
        cp.total_paid as 'total amount paid',
        round(cp.total_paid/rs.rental_count,2) as 'average_payment_per_rental'
        from rental_summary as rs
        join customer_payment_table as cp
		on rs.customer_id = cp.customer_id
)
select * from customer_summary_report;


