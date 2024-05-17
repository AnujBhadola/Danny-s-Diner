-- Q1 What is the total amount each customer spent at the restaurant?
SELECT sales.customer_id ,sum(menu.price) as "total amount" FROM sales
inner join menu
on sales.product_id = menu.product_id
group by sales.customer_id ;

-- Q2 How many days has each customer visited the restaurant?
SELECT customer_id, COUNT(DISTINCT order_date) 
FROM sales 
GROUP BY customer_id;

-- Q3 What was the first item from the menu purchased by each customer?
SELECT sales.customer_id , menu.product_name FROM sales 
inner join menu
on sales.product_id = menu.product_id 
group by sales.customer_id;

-- Q4 What is the most purchased item on the menu and how many times was it purchased by all customers?


SELECT menu.product_name FROM sales 
inner join menu
on sales.product_id = menu.product_id
group by menu.product_name
order by count(*) desc limit 1;

-- Q5 Which item was the most popular for each customer?
SELECT 
    T1.customer_id, 
    M.product_name
FROM 
    (
        SELECT 
            customer_id, 
            product_id,
            ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY COUNT(*) DESC) AS rank1
        FROM 
            sales
        GROUP BY 
            customer_id, 
            product_id
    ) AS T1
JOIN 
    menu AS M ON T1.product_id = M.product_id
WHERE 
    rank1 = 1
ORDER BY 
    customer_id;


-- Q6 Which item was purchased first by the customer after they became a member?
SELECT T1.customer_id , menu.product_name FROM
(select sales.customer_id,sales.product_id,min(datediff(sales.order_date,members.join_date)) as date_diff  from sales
inner join members
on sales.customer_id = members.customer_id
where datediff(sales.order_date,members.join_date) >=0
group by sales.customer_id) as T1
INNER JOIN menu
on T1.product_id = menu.product_id
order by T1.customer_id;

-- Q7 Which item was purchased just before the customer became a member? 
SELECT T1.customer_id , menu.product_name FROM
(select sales.customer_id,sales.product_id,max(datediff(sales.order_date,members.join_date)) as date_diff  from sales
inner join members
on sales.customer_id = members.customer_id
where datediff(sales.order_date,members.join_date) < 0
group by sales.customer_id) as T1
INNER JOIN menu
on T1.product_id = menu.product_id
order by T1.customer_id;

-- Q8 What is the total items and amount spent for each member before they became a member?
select sales.customer_id,
count(*) as total_item , sum(menu.price) as total_amount from sales
inner join members
on sales.customer_id = members.customer_id
inner join menu
on sales.product_id = menu.product_id
where datediff(sales.order_date,members.join_date) < 0
group by sales.customer_id;

-- Q9 If each $1 spent equates to 10 points and sushi has a 2x points multiplier -
--  how many points would each customer have?
SELECT 
    sales.customer_id, 
    SUM(CASE 
        WHEN menu.product_name = 'sushi' THEN menu.price * 20
        ELSE menu.price * 10
    END) AS total_points
FROM 
    sales
INNER JOIN 
    menu 
ON 
    sales.product_id = menu.product_id
GROUP BY 
    sales.customer_id;


-- Q 10 In the first week after a customer joins the program (including their join date)
--  they earn 2x points on all items, not just sushi - 
-- how many points do customer A and B have at the end of January? 
with cte1 as(SELECT 
        S.customer_id, 
        S.order_date, 
        S.product_id, 
        M.join_date, 
        M.join_date + INTERVAL 6 DAY AS first_week_end
        
    FROM 
        sales AS S
    INNER JOIN 
        members AS M
    ON 
        S.customer_id = M.customer_id
    WHERE 
        MONTH(S.order_date) = 1),
point_calculation as (Select cte1.customer_id , cte1.order_date, 
 case
     when order_date between join_date AND first_week_end then M.price * 20 else M.price * 10 end as point
     from cte1 
     inner join menu as M
     on cte1.product_id = M.product_id )
	
Select customer_id , sum(point) as total_point from point_calculation
group by customer_id
having customer_id in ("A","B")





 





























       










SELECT 
    T1.customer_id, 
    M.product_name
FROM 
    (
        SELECT 
            customer_id, 
            product_id,
            ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY COUNT(*) DESC) AS rank1
        FROM 
            sales
        GROUP BY 
            customer_id, 
            product_id
    ) AS T1
JOIN 
    menu AS M ON T1.product_id = M.product_id
WHERE 
    rank1 = 1
ORDER BY 
    customer_id;












 