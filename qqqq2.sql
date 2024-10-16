--1 Первые 3 клиента, купившие товаров на максимальную сумму в диапазоне дат
SELECT c.customer_name, SUM(pi.product_count * pi.product_price) AS total_spent
FROM purchases p
JOIN purchase_items pi ON p.purchase_id = pi.purchase_id
JOIN customers c ON p.customer_id = c.customer_id
WHERE p.purchase_date BETWEEN '1601217801' AND '1621217801'  -- Заданный диапазон дат
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 3;

--2 Первые 3 клиента, купившие максимальное количество товаров в диапазоне дат
SELECT c.customer_name, SUM(pi.product_count) AS total_products
FROM purchases p
JOIN purchase_items pi ON p.purchase_id = pi.purchase_id
JOIN customers c ON p.customer_id = c.customer_id
WHERE p.purchase_date BETWEEN '1601217801' AND '1621217801'  -- Заданный диапазон дат
GROUP BY c.customer_name
ORDER BY total_products DESC
LIMIT 3;

--3 Товар, который покупали чаще всего в диапазоне дат
SELECT p.product_name, SUM(pi.product_count) AS total_sold
FROM purchases pur
JOIN purchase_items pi ON pur.purchase_id = pi.purchase_id
JOIN products p ON pi.product_id = p.product_id
WHERE pur.purchase_date BETWEEN '1601217801' AND '1621217801'  -- Заданный диапазон дат
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 1;

--4 Товар, который покупали чаще всего в диапазоне дат по филиалам
SELECT s.store_name, p.product_name, SUM(pi.product_count) AS total_sold
FROM purchases pur
JOIN purchase_items pi ON pur.purchase_id = pi.purchase_id
JOIN products p ON pi.product_id = p.product_id
JOIN stores s ON pur.store_id = s.store_id
WHERE pur.purchase_date BETWEEN '1601217801' AND '1621217801'  -- Заданный диапазон дат
GROUP BY s.store_name, p.product_name
ORDER BY total_sold DESC
LIMIT 1;

--5 Средний чек в диапазоне дат
SELECT AVG(total_spent) AS avg_check
FROM (
    SELECT SUM(pi.product_count * pi.product_price) AS total_spent
    FROM purchases p
    JOIN purchase_items pi ON p.purchase_id = pi.purchase_id
    WHERE p.purchase_date BETWEEN '1601217801' AND '1621217801'  -- Заданный диапазон дат
    GROUP BY p.purchase_id
) AS subquery;

--6 Средний чек в диапазоне дат по филиалам
SELECT s.store_name, AVG(total_spent) AS avg_check
FROM (
    SELECT p.store_id, SUM(pi.product_count * pi.product_price) AS total_spent
    FROM purchases p
    JOIN purchase_items pi ON p.purchase_id = pi.purchase_id
    WHERE p.purchase_date BETWEEN '1601217801' AND '1621217801'  -- Заданный диапазон дат
    GROUP BY p.purchase_id
) AS subquery
JOIN stores s ON subquery.store_id = s.store_id
GROUP BY s.store_name;


--7 Суммарная стоимость проданных товаров каждого филиала в диапазоне дат
SELECT s.store_name, SUM(pi.product_count * pi.product_price) AS total_sales
FROM purchases p
JOIN purchase_items pi ON p.purchase_id = pi.purchase_id
JOIN stores s ON p.store_id = s.store_id
WHERE p.purchase_date BETWEEN '1601217801' AND '1621217801'  -- Заданный диапазон дат
GROUP BY s.store_name;

--8 Суммарная стоимость проданных товаров в диапазоне дат
SELECT SUM(pi.product_count * pi.product_price) AS total_sales
FROM purchases p
JOIN purchase_items pi ON p.purchase_id = pi.purchase_id
WHERE p.purchase_date BETWEEN '1601217801' AND '1621217801';  -- Заданный диапазон дат

--9 Список филиалов по убыванию объема продаж до заданной даты
SELECT s.store_name, SUM(pi.product_count * pi.product_price) AS total_sales
FROM purchases p
JOIN purchase_items pi ON p.purchase_id = pi.purchase_id
JOIN stores s ON p.store_id = s.store_id
WHERE p.purchase_date < '1621217801'  -- Заданная дата
GROUP BY s.store_name
ORDER BY total_sales DESC;

--10 Список филиалов по убыванию количества проданного товара до заданной даты
SELECT s.store_name, SUM(pi.product_count) AS total_products
FROM purchases p
JOIN purchase_items pi ON p.purchase_id = pi.purchase_id
JOIN stores s ON p.store_id = s.store_id
WHERE p.purchase_date < '1621217801'  -- Заданная дата
GROUP BY s.store_name
ORDER BY total_products DESC;

--11 Список товаров с указанием проданного количества в каждом магазине до заданной даты
SELECT s.store_name, p.product_name, SUM(pi.product_count) AS total_sold
FROM purchases pur
JOIN purchase_items pi ON pur.purchase_id = pi.purchase_id
JOIN products p ON pi.product_id = p.product_id
JOIN stores s ON pur.store_id = s.store_id
WHERE pur.purchase_date < '1621217801'  -- Заданная дата
GROUP BY s.store_name, p.product_name
ORDER BY s.store_name, p.product_name;

--12 Список товаров, проданных в заданном филиале до заданной даты
SELECT p.product_name, SUM(pi.product_count) AS total_sold
FROM purchases pur
JOIN purchase_items pi ON pur.purchase_id = pi.purchase_id
JOIN products p ON pi.product_id = p.product_id
WHERE pur.store_id = 1  -- ID заданного филиала
  AND pur.purchase_date < '1621217801'  -- Заданная дата
GROUP BY p.product_name
ORDER BY total_sold DESC;

--13 Список клиентов, покупавших в заданном магазине до заданной даты
SELECT DISTINCT c.customer_name
FROM purchases p
JOIN customers c ON p.customer_id = c.customer_id
WHERE p.store_id = 1  -- ID заданного магазина
  AND p.purchase_date < '1621217801';  -- Заданная дата

--14 Список клиентов, покупавших в двух магазинах
SELECT c.customer_name
FROM purchases p
JOIN customers c ON p.customer_id = c.customer_id
GROUP BY c.customer_name
HAVING COUNT(DISTINCT p.store_id) >= 2;  -- Покупки как минимум в 2 магазинах

--15 Список клиентов, покупавших в каждом магазине
SELECT c.customer_name
FROM purchases p
JOIN customers c ON p.customer_id = c.customer_id
GROUP BY c.customer_name
HAVING COUNT(DISTINCT p.store_id) = (SELECT COUNT(*) FROM stores); -- Покупки во всех магазинах
--таких кстати нету

--16 Количество товара каждой категории, проданных в филиале до заданной даты
SELECT cat.category_name, SUM(pi.product_count) AS total_sold
FROM purchases pur
JOIN purchase_items pi ON pur.purchase_id = pi.purchase_id
JOIN products p ON pi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
WHERE pur.store_id = 1  -- ID заданного филиала
  AND pur.purchase_date < '1621217801'  -- Заданная дата
GROUP BY cat.category_name;

--17 Количество товара каждой категории, проданных во всех филиалах до заданной даты
SELECT cat.category_name, SUM(pi.product_count) AS total_sold
FROM purchases pur
JOIN purchase_items pi ON pur.purchase_id = pi.purchase_id
JOIN products p ON pi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
WHERE pur.purchase_date < '1621217801'  -- Заданная дата
GROUP BY cat.category_name;

--18 Суммарная стоимость товаров по филиалам на заданную дату
SELECT s.store_name, SUM(d.product_count * pc.new_price) AS total_value
FROM deliveries d
JOIN stores s ON d.store_id = s.store_id
JOIN price_change pc ON d.product_id = pc.product_id
WHERE d.delivery_date <= '1621217801'  -- Заданная дата
GROUP BY s.store_name;

--19 Суммарная стоимость товаров во всех филиалах на заданную дату
SELECT SUM(d.product_count * pc.new_price) AS total_value
FROM deliveries d
JOIN price_change pc ON d.product_id = pc.product_id
WHERE d.delivery_date <= '1621217801';  -- Заданная дата

-- 20 Количество товаров в каждом филиале на заданную дату
SELECT s.store_name, SUM(d.product_count) AS total_products
FROM deliveries d
JOIN stores s ON d.store_id = s.store_id
WHERE d.delivery_date <= '1621217801'  -- Заданная дата
GROUP BY s.store_name;

--21 Товар, которого меньше всего осталось в каждом филиале на заданную дату
SELECT s.store_name, p.product_name, MIN(d.product_count) AS min_count
FROM deliveries d
JOIN products p ON d.product_id = p.product_id
JOIN stores s ON d.store_id = s.store_id
WHERE d.delivery_date <= '1621217801'  -- Заданная дата
GROUP BY s.store_name, p.product_name
ORDER BY min_count ASC;


-- 22 Товар, которого больше всего осталось в каждом филиале на заданную дату
SELECT s.store_name, p.product_name, d.product_count
FROM deliveries d
JOIN products p ON d.product_id = p.product_id
JOIN stores s ON d.store_id = s.store_id
WHERE d.delivery_date <= '1621217801'  -- Заданная дата
  AND d.product_count = (
      SELECT MAX(d2.product_count)
      FROM deliveries d2
      WHERE d2.store_id = d.store_id
        AND d2.delivery_date <= '1621217801'
    )
ORDER BY s.store_name;

--23 Количество товаров каждого наименования во всех филиалах на заданную дату
SELECT p.product_name, SUM(d.product_count) AS total_count
FROM deliveries d
JOIN products p ON d.product_id = p.product_id
WHERE d.delivery_date <= '1621217801'  -- Заданная дата
GROUP BY p.product_name;

--24 Остатки товаров каждого наименования в филиале на заданную дату
SELECT p.product_name, SUM(d.product_count) AS total_count
FROM deliveries d
JOIN products p ON d.product_id = p.product_id
WHERE d.store_id = 1  -- ID филиала
  AND d.delivery_date <= '1621217801'  -- Заданная дата
GROUP BY p.product_name;

-- 25 Пять самых дешевых товаров в филиале на заданную дату
SELECT p.product_name, pc.new_price
FROM price_change pc
JOIN products p ON pc.product_id = p.product_id
JOIN deliveries d ON d.product_id = p.product_id
WHERE pc.date_price_change <= '2024-10-02'  -- Заданная дата
  AND d.store_id = 1   -- ID филиала
ORDER BY pc.new_price ASC
LIMIT 5;

-- 26 Пять самых дорогих товаров в филиале на заданную дату
SELECT p.product_name, pc.new_price
FROM price_change pc
JOIN products p ON pc.product_id = p.product_id
JOIN deliveries d ON d.product_id = p.product_id
WHERE pc.date_price_change <= '2024-10-02'  -- Заданная дата
  AND d.store_id = 1   -- ID филиала
ORDER BY pc.new_price DESC
LIMIT 5;

--27 Дата, в которую поступило товара на максимальную сумму в заданный филиал
SELECT d.delivery_date, SUM(d.product_count * pc.new_price) AS total_value
FROM deliveries d
JOIN price_change pc ON d.product_id = pc.product_id
WHERE d.store_id = 1  -- ID филиала
GROUP BY d.delivery_date
ORDER BY total_value DESC
LIMIT 1;

--28 Суммарная стоимость поступивших товаров на каждую дату поступления в заданный филиал
SELECT d.delivery_date, SUM(d.product_count * pc.new_price) AS total_value
FROM deliveries d
JOIN price_change pc ON d.product_id = pc.product_id
WHERE d.store_id = 1  -- ID филиала
GROUP BY d.delivery_date
ORDER BY d.delivery_date;

-- 29 Суммарная стоимость товаров каждого производителя в филиале на дату
SELECT m.manufacturer_name, SUM(d.product_count * pc.new_price) AS total_value
FROM deliveries d
JOIN products p ON d.product_id = p.product_id
JOIN manufacturers m ON p.manufacturer_id = m.manufacturer_id
JOIN price_change pc ON p.product_id = pc.product_id
WHERE d.store_id = 1  -- ID филиала
  AND d.delivery_date <= '1621217801'  -- Заданная дата (если Unix timestamp)
GROUP BY m.manufacturer_name;

-- 30 Суммарное количество товаров каждого производителя в филиале на дату
SELECT m.manufacturer_name, SUM(d.product_count) AS total_quantity
FROM deliveries d
JOIN products p ON d.product_id = p.product_id
JOIN manufacturers m ON p.manufacturer_id = m.manufacturer_id
JOIN price_change pc ON p.product_id = pc.product_id
WHERE d.store_id = 1  -- ID филиала
  AND d.delivery_date <= '1621217801'  -- Заданная дата (если Unix timestamp)
GROUP BY m.manufacturer_name;

--31 Суммарное количество проданных товаров каждого производителя в филиале до заданной даты
SELECT m.manufacturer_name, SUM(pi.product_count) AS total_sold
FROM purchases pr
JOIN purchase_items pi ON pr.purchase_id = pi.purchase_id
JOIN products p ON pi.product_id = p.product_id
JOIN manufacturers m ON p.manufacturer_id = m.manufacturer_id
WHERE pr.store_id = 1  -- ID филиала
  AND pr.purchase_date <= '1621217801'  -- Заданная дата
GROUP BY m.manufacturer_name;

--32 Суммарная стоимость проданных товаров каждого производителя в филиале до заданной даты
SELECT m.manufacturer_name, SUM(pi.product_count * pi.product_price) AS total_sales
FROM purchases pr
JOIN purchase_items pi ON pr.purchase_id = pi.purchase_id
JOIN products p ON pi.product_id = p.product_id
JOIN manufacturers m ON p.manufacturer_id = m.manufacturer_id
WHERE pr.store_id = 1  -- ID филиала
  AND pr.purchase_date <= '1621217801'  -- Заданная дата
GROUP BY m.manufacturer_name;

--33 Суммарная стоимость проданных товаров каждого производителя во всех филиалах до заданной даты
SELECT m.manufacturer_name, SUM(pi.product_count * pi.product_price) AS total_sales
FROM purchases pr
JOIN purchase_items pi ON pr.purchase_id = pi.purchase_id
JOIN products p ON pi.product_id = p.product_id
JOIN manufacturers m ON p.manufacturer_id = m.manufacturer_id
WHERE pr.purchase_date <= '1621217801'  -- Заданная дата
GROUP BY m.manufacturer_name;

--34 Суммарное количество проданных товаров каждого производителя во всех филиалах до заданной даты
SELECT m.manufacturer_name, SUM(pi.product_count) AS total_sold
FROM purchases pr
JOIN purchase_items pi ON pr.purchase_id = pi.purchase_id
JOIN products p ON pi.product_id = p.product_id
JOIN manufacturers m ON p.manufacturer_id = m.manufacturer_id
WHERE pr.purchase_date <= '1621217801'  -- Заданная дата
GROUP BY m.manufacturer_name;

--35 Суммарное количество поступивших товаров каждого производителя во всех филиалах до заданной даты
SELECT m.manufacturer_name, SUM(d.product_count) AS total_delivered
FROM deliveries d
JOIN products p ON d.product_id = p.product_id
JOIN manufacturers m ON p.manufacturer_id = m.manufacturer_id
WHERE d.delivery_date <= '1621217801'  -- Заданная дата
GROUP BY m.manufacturer_name;

--36 Суммарное количество поступивших товаров каждого производителя в филиал до заданной даты
SELECT m.manufacturer_name, SUM(d.product_count) AS total_delivered
FROM deliveries d
JOIN products p ON d.product_id = p.product_id
JOIN manufacturers m ON p.manufacturer_id = m.manufacturer_id
WHERE d.store_id = 1  -- ID филиала
  AND d.delivery_date <= '1621217801'  -- Заданная дата
GROUP BY m.manufacturer_name;

-- 37 Суммарная стоимость поступивших товаров каждого производителя в филиал до заданной даты
SELECT m.manufacturer_name, SUM(d.product_count * pc.new_price) AS total_value
FROM deliveries d
JOIN products p ON d.product_id = p.product_id
JOIN manufacturers m ON p.manufacturer_id = m.manufacturer_id
JOIN price_change pc ON p.product_id = pc.product_id
WHERE d.store_id = 1  -- ID филиала
  AND d.delivery_date <= '1621217801'  -- Заданная дата
GROUP BY m.manufacturer_name;

-- 38 Изменение суммарной стоимости товаров заданного производителя в филиале в диапазоне дат
SELECT to_timestamp(d.delivery_date) AS delivery_date, SUM(d.product_count * pc.new_price) AS total_value
FROM deliveries d
JOIN products p ON d.product_id = p.product_id
JOIN price_change pc ON d.product_id = pc.product_id
WHERE d.store_id = 1  -- ID филиала
  AND p.manufacturer_id = 1  -- ID производителя
  -- Преобразуем UNIX-время в TIMESTAMP для сравнения
  AND to_timestamp(d.delivery_date) BETWEEN '2020-09-27' AND '2021-05-17'  -- Диапазон дат в формате 'YYYY-MM-DD'
  -- Сравниваем дату изменения цены с доставкой, преобразовав UNIX-время в TIMESTAMP
  AND pc.date_price_change <= to_timestamp(d.delivery_date)  -- Учитываем актуальную цену на момент поставки
GROUP BY d.delivery_date
ORDER BY d.delivery_date;






