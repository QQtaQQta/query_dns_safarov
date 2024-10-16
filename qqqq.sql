--1 Все записи таблицы customers
SELECT * FROM customers;

--2 Все записи таблицы categories
SELECT * FROM categories;

--3 Все записи таблицы manufacturers
SELECT * FROM manufacturers;

--4 Все записи таблицы stores
SELECT * FROM stores;

--5 Все записи таблицы products
SELECT * FROM products;

--6 Все записи таблицы deliveries
SELECT * FROM deliveries;

--7 Все записи таблицы price_change
SELECT * FROM price_change;

--8 Все записи таблицы purchase_items
SELECT * FROM purchase_items;

--9 Фамилии и имена покупателей, отсортированные по имени, вывод только фамилии и имени
SELECT SPLIT_PART(customer_name, ' ', 1) AS фамилия, 
       SPLIT_PART(customer_name, ' ', 2) AS имя
FROM customers
ORDER BY имя, фамилия;

--10 Фамилии и имена покупателей, отсортированные по фамилии, вывод только фамилии и имени
SELECT SPLIT_PART(customer_name, ' ', 1) AS фамилия, 
       SPLIT_PART(customer_name, ' ', 2) AS имя
FROM customers
ORDER BY фамилия, имя;

----11 Количество покупателей в базе
SELECT COUNT(*) FROM customers;

--12 Количество товаров в базе
SELECT COUNT(*) FROM products;

--13 Количество имен производителей в базе
SELECT COUNT(*) FROM manufacturers;

--14 Список производителей, отсортированный по алфавиту
SELECT manufacturer_name FROM manufacturers ORDER BY manufacturer_name;

--15 Количество товаров, поступивших до заданной даты
SELECT COUNT(*) FROM deliveries WHERE delivery_date < 1615880592;

--16 Количество товаров заданной категории
SELECT COUNT(*) FROM products WHERE category_id = 1;

--17 Количество товаров в каждой категории
SELECT c.category_name, COUNT(p.product_id) 
FROM categories c 
LEFT JOIN products p ON c.category_id = p.category_id 
GROUP BY c.category_name;

--18 Количество товаров заданного производителя
SELECT COUNT(*) FROM products WHERE manufacturer_id = 105;

--19 Количество товаров по каждому производителю
SELECT m.manufacturer_name, COUNT(p.product_id) 
FROM manufacturers m 
LEFT JOIN products p ON m.manufacturer_id = p.manufacturer_id 
GROUP BY m.manufacturer_name;

--20 Наименование товара, категория
SELECT p.product_name, c.category_name 
FROM products p 
JOIN categories c ON p.category_id = c.category_id;


--21 Наименование товара, производитель
SELECT p.product_name, m.manufacturer_name 
FROM products p 
JOIN manufacturers m ON p.manufacturer_id = m.manufacturer_id;

--22 Дата покупки, фамилия покупателя
SELECT pu.purchase_date, SPLIT_PART(cu.customer_name, ' ', 1)
FROM purchases pu 
JOIN customers cu ON pu.customer_id = cu.customer_id;

--23 Фамилия покупателя, общее количество покупок (не товаров)
SELECT SPLIT_PART(cu.customer_name, ' ', 1) as lname, COUNT(pu.purchase_id) AS purchase_count 
FROM customers cu 
JOIN purchases pu ON cu.customer_id = pu.customer_id 
GROUP BY lname;

--24 Дата покупки, фамилия покупателя, филиал
SELECT pu.purchase_date, SPLIT_PART(cu.customer_name, ' ', 1), s.store_name 
FROM purchases pu 
JOIN customers cu ON pu.customer_id = cu.customer_id 
JOIN stores s ON pu.store_id = s.store_id;

--25 Список товаров, отсортированных по наименованию (по алфавиту)
SELECT product_name FROM products ORDER BY product_name;

--26 Список всех покупок (purchases), отсортированных по дате
SELECT * FROM purchases ORDER BY purchase_date;

--27 Даты последних 5 покупок (purchases)
SELECT purchase_date FROM purchases ORDER BY purchase_date DESC LIMIT 5;

--28 Даты первых 5 покупок (purchases)
SELECT purchase_date FROM purchases ORDER BY purchase_date ASC LIMIT 5;

--29 Фамилии последних 5 покупателей
SELECT SPLIT_PART(cu.customer_name, ' ', 1) FROM customers cu 
JOIN purchases pu ON cu.customer_id = pu.customer_id 
ORDER BY pu.purchase_date DESC LIMIT 5;

--30 Фамилии первых 5 покупателей
SELECT SPLIT_PART(cu.customer_name, ' ', 1) FROM customers cu 
JOIN purchases pu ON cu.customer_id = pu.customer_id 
ORDER BY pu.purchase_date ASC LIMIT 5;
