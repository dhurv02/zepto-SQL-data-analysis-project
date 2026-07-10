drop table if exists zepto;

create table zepto(
sku_id SERIAL primary key,
category varchar(120),
name varchar(150) not null,
mrp numeric(8,2),
discountPercent numeric(5,2),
availabeQuantity integer,
discountedSellingPrice numeric(8,2),
weightInGms integer,
outOfStock boolean,
quantity integer
);

select count(*) from zepto;

select * from zepto
limit 10;

alter table zepto
rename column availabeQuantity to availableQuantity;

select * from zepto
limit 10;

--Checking Null Values
select *
from zepto
WHERE category IS NULL
   OR name IS NULL
   OR mrp IS NULL
   OR discountPercent IS NULL
   OR availableQuantity IS NULL
   OR discountedSellingPrice IS NULL
   OR weightInGms IS NULL
   OR outOfStock IS NULL
   OR quantity IS NULL;

-- different product categories
select distinct category from zepto
order by category desc;

-- checking products instock or out of stock
select outOfStock, count(sku_id) from zepto
group by outOfStock;

-- checking product names that present multiple times
select name, count(sku_id) as "Number of SKUs" from zepto
group by name
having count(sku_id) > 1
order by count(sku_id) desc;

-- Data cleaning

--product price with 0
select * from zepto
where mrp = 0 or discountedSellingPrice = 0;

delete from zepto
where mrp = 0;

-- convert paise into rupess
update zepto
set mrp=mrp/100.0,
discountedSellingPrice= discountedSellingPrice/100.0;

select mrp, discountedSellingPrice from zepto;

--Business Insight Questions

--Q1. Find the top 10 best value products based on the discount percentage.

select distinct name, mrp, discountPercent from zepto
order by discountPercent desc
limit 10;

--Q2. What are the products with high MRP(above 200) but out of stock??

select distinct name, mrp from zepto
where outOfStock = true and mrp > 200
order by mrp desc;

--Q3. Calculate estimated revenue for each category.

select category, sum(discountedSellingPrice * availableQuantity) as Total_Revenue
from zepto
group by category
order by Total_Revenue;

--Q4. Find all products where MRP is greater than rs.500 and discount is less than 10%.

select distinct name, mrp, discountPercent from zepto
where mrp > 500 and discountPercent < 10
order by mrp desc, discountPercent desc;

--Q5. Identify the top 5 categories offering the highest average discount percent.

select category, round(avg(discountPercent),2) as average_discount
from zepto
group by category
order by average_discount desc
limit 5;

--Q6. Find the price per gram for products above 100g and sort by the best value.

select distinct name, weightInGms, discountedSellingPrice,
round(discountedSellingPrice/weightInGms,2) as price_per_gram
from zepto
where weightInGms >= 100
order by price_per_gram;

--Q7. Group the products into categories like low, medium and bulk based on their weights in grams.

select distinct name, weightInGms,
case when weightInGms < 1000 then 'Low'
	 when weightInGms < 5000 then 'Medium'
	 else 'Bulk'
	 end as weight_category
from zepto;

--Q8. What is the total inventory weight per category??

select category, sum(WeightInGms * availableQuantity) as total_inventory_weight
from zepto
group by category
order by total_inventory_weight;