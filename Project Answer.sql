create database Final_Project

use Final_Project


---Exploring the data
SELECT * FROM [production].[brands]
SELECT * FROM [production].[categories]
SELECT * FROM [production].[products]
SELECT * FROM [production].[stocks]
SELECT * FROM [sales].[stores] 
SELECT * FROM [sales].[customers]
SELECT * FROM [sales].[order_items] 
SELECT * FROM [sales].[orders]
SELECT * FROM [sales].[staffs] 





---1) Which bike is most expensive? What could be the motive behind pricing this bike at the high price?
SELECT top(1) product_name, brand_name, list_price
FROM production.products p
join production.brands b
on p.brand_id=b.brand_id
order by list_price desc
--(=1)this is the bike and it could be a high price for the brand trek and his modle 2018




---2) How many total customers does BikeStore have? 
SELECT count(distinct customer_id)
FROM sales.orders
	
----Would you consider people with order status 3 as customers substantiate your answer?
SELECT* FROM sales.orders
WHERE order_status=3 

---I think yes because theres an order date and customer id




---3) How many stores does BikeStore have?
SELECT '#Stores',count(store_id)
FROM sales.stores


	
---4) What is the total price spent per order?
SELECT order_id,SUM([list_price] *[quantity]*(1-[discount])) '#Total price'
FROM sales.order_items
GROUP BY cube( order_id)
order by order_id

	
---5) What’s the sales/revenue per store?
SELECT store_name,SUM([list_price] *[quantity]*(1-[discount])) '#Total price'
FROM sales.stores as s
inner join sales.orders o
on s.store_id=o.store_id
inner join sales.order_items i
on i.order_id=o.order_id
GROUP BY (store_name)


	
---6) Which category is most sold?
SELECT TOP 1 category_name,count(i.[product_id] *[quantity]) '# of times sold'
FROM sales.order_items i
INNER JOIN production.products p
on p.product_id=i.product_id
INNER JOIN production.categories c
ON c.category_id=p.category_id
GROUP BY category_name
order by [# of times sold] desc


	
---7) Which category rejected more orders?
SELECT top 1 category_name,count(c.category_id) '# of rejected'
FROM sales.order_items i
INNER JOIN production.products p
on p.product_id=i.product_id
INNER JOIN production.categories c
ON c.category_id=p.category_id
INNER JOIN sales.orders o
on o.order_id=i.order_id
where shipped_date is null
GROUP BY category_name
order by [# of rejected] desc


	
---8) Which bike is the least sold?
SELECT p.product_name,count(i.[product_id] *[quantity]) '# of times sold'
FROM production.products as p
, sales.order_items i
WHERE p.product_id=i.product_id 
group by p.product_name
having count(i.[product_id] *[quantity]) <2
order by [# of times sold]



	
---9) What’s the full name of a customer with ID 259?
SELECT customer_id,concat(first_name,' ',last_name)
FROM sales.customers
WHERE customer_id=259


	
---10) What did the customer on question 9 buy and when? What’s the status of this order?
SELECT customer_id,product_name,order_date,order_status
FROM sales.orders o
INNER JOIN sales.order_items i
on o.order_id=i.order_id
INNER JOIN production.products p
on i.product_id=p.product_id
WHERE customer_id=259


	
---11) Which staff processed the order of customer 259? And from which store?
SELECT customer_id,concat(s.first_name,' ',s.last_name) staff_name,r.store_name store_name
FROM sales.orders o
JOIN sales.staffs s
on o.staff_id=s.staff_id
join sales.stores r
on r.store_id=o.store_id
WHERE customer_id=259


	
---12) How many staff does BikeStore have? 
SELECT count(staff_id)
FROM sales.staffs
--Who seems to be the lead Staff at BikeStore?
SELECT *
FROM sales.staffs
WHERE manager_id is null


	

---13) Which brand is the most liked?
SELECT top 1 brand_name,COUNT(quantity)'#quantity'
FROM production.brands b
INNER JOIN production.products p
on p.brand_id=b.brand_id
INNER JOIN production.stocks s
on p.product_id=s.product_id
group by brand_name
order by #quantity desc



	
---14)How many categories does BikeStore have, and which one is the least liked?
SELECT COUNT(category_id) '#category'
FROM production.categories
---and which one is the least liked?
SELECT  category_name,COUNT(quantity)'#quantity'
FROM production.categories b
INNER JOIN production.products p
on p.category_id=b.category_id
INNER JOIN production.stocks s
on p.product_id=s.product_id
group by category_name
order by #quantity desc

	

---15) Which store still have more products of the most liked brand?   (X)
select store_name, count(s.product_id)'#p'
from sales.stores r
INNER JOIN production.stocks s on r.store_id=s.store_id
INNER JOIN production.products p on p.product_id=s.product_id
join production.brands b on p.brand_id=b.brand_id
Where brand_name='Trek'
group by store_name
order by #p desc

	
----16) Which state is doing better in terms of sales?
SELECT top 1 state,SUM([list_price] *[quantity]*(1-[discount])) '#Total price'
FROM sales.stores as s
inner join sales.orders o
on s.store_id=o.store_id
inner join sales.order_items i
on i.order_id=o.order_id
GROUP BY (state)
order by [#Total price]


---17) What’s the discounted price of product id 259?
SELECT customer_id,sum(discount)'T_discount'
FROM sales.orders o
JOIN sales.order_items i on i.order_id=o.order_id 
where customer_id=259
group by customer_id


---18) What’s the product name, quantity, price, category, model year and brand name of product number 44?
SELECT product_name,sum(quantity)'T_Quantity',p.list_price,category_name,model_year,brand_name
FROM production.products p
join production.stocks i on i.product_id=p.product_id
join production.categories c on c.category_id=p.category_id
join production.brands b on b.brand_id=p.brand_id
WHERE p.product_id=44
group by product_name,p.list_price,category_name,model_year,brand_name




---19) What’s the zip code of CA?
SELECT state,zip_code
FROM sales.stores
where state='CA'


---20) How many states does BikeStore operate in?
SELECT COUNT(state) '# states'
FROM sales.stores



------21) How many bikes under the children category were sold in the last 8 months?
SELECT COUNT(i.[product_id]*[quantity])'# of sold bike'
FROM production.categories c
join production.products p on c.category_id=p.category_id
join sales.order_items i on i.product_id=p.product_id
join sales.orders o on o.order_id=i.order_id
where category_name='Children Bicycles' 
	  AND o.order_date >= DATEADD(MONTH, -8,2018-12-28)
      AND o.order_status = 4;


----22) What’s the shipped date for the order from customer 523
SELECT customer_id,shipped_date
FROM sales.orders
WhERE customer_id=523 


---23) How many orders are still pending?
SELECT count(order_id)'# orders are still pending'
FROM sales.orders
WhERE order_status!=4



---24) What’s the names of category and brand does "Electra white water 3i -2018" fall under?
SELECT product_name,category_name, brand_name
FROM production.products p
join production.categories c on c.category_id=p.category_id
join production.brands b on b.brand_id=p.brand_id
where product_name like '%Electra white%'


