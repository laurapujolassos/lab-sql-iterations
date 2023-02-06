# Lab | SQL Iterations
# 1. Write a query to find what is the total business done by each store.
select s.store_id, count(p.amount) from sakila.payment p 
join sakila.staff s
on s.staff_id=p.staff_id
group by store_id;

# 2. Convert the previous query into a stored procedure.
DELIMITER $$
CREATE PROCEDURE GetStorePaymentCounts()
BEGIN
    SELECT s.store_id, count(p.amount)
    FROM sakila.payment p
    JOIN sakila.staff s ON s.staff_id = p.staff_id
    GROUP BY store_id;
END $$
DELIMITER ;
CALL GetStorePaymentCounts();

# 3. Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.
DELIMITER $$
CREATE PROCEDURE GetStoreSales(IN store_id INT)
BEGIN
    SELECT SUM(p.amount) AS TotalSales
    FROM sakila.payment p
    JOIN sakila.staff s ON s.staff_id = p.staff_id
    WHERE s.store_id = store_id;
END $$
DELIMITER ;
CALL GetStoreSales(1);

# 4. Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). Call the stored procedure and print the results
DELIMITER $$
CREATE PROCEDURE GetStoreSales2(IN store_id INT, OUT total_sales_value FLOAT)
BEGIN
    SELECT SUM(p.amount) INTO total_sales_value
    FROM sakila.payment p
    JOIN sakila.staff s ON s.staff_id = p.staff_id
    WHERE s.store_id = store_id;
END $$
DELIMITER ;

# 5. In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value
DELIMITER $$
CREATE PROCEDURE GetStoreSalesWithFlag(IN store_id INT, OUT total_sales_value FLOAT, OUT flag VARCHAR(10))
BEGIN
    SELECT SUM(p.amount) INTO total_sales_value
    FROM sakila.payment p
    JOIN sakila.staff s ON s.staff_id = p.staff_id
    WHERE s.store_id = store_id;

    IF total_sales_value > 30000 THEN
        SET flag = 'green_flag';
    ELSE
        SET flag = 'red_flag';
    END IF;
END $$
DELIMITER ;

SET @store_id_input = 1;
SET @total_sales_value = 0;
SET @flag = '';

CALL GetStoreSalesWithFlag(@store_id_input, @total_sales_value, @flag);

SELECT @total_sales_value AS TotalSales, @flag AS Flag;





