/*
-- =============================================
-- Author: Ivan Hincapie
-- Create date: 12/18/2025
-- Description: Creación de tablas principales para el registro operativo y análisis de clientes/ventas.
-- Comments:
-- Se cumple la 1FN porque en las tres tablas se deben hacer registros únicos. Es decir, sin grupos.alter
-- Se cumple la 2FN porque en el caso proporcionado no se va a tomar que la venta tenga varios productos. Si hubiera sido así, se deberia crear otra tabla donde se tenga los detalles y que esa se pueda relacionar entre la venta y los productos
-- Se cumple la 3FN porque ningún campo importante depende de otro igual o más importante
-- Se le agrega el "IF NOT EXISTS" por buena practica.
-- Se le define si el campo debe recibir información para evitar la perdida de la misma.
-- Stack: MySQL
-- =============================================
*/
/*
========
Base de datos creada
========
*/
CREATE TABLE IF NOT EXISTS products (
      product_id CHAR(25) NOT NULL PRIMARY KEY
    , name CHAR(25) NOT NULL -- Al no ser el nombre tan largo, se otimiza el campo con un tipo de dato más adecuado
    , price DECIMAL(10, 2) NOT NULL -- Uso de decimal para precisión
);  


CREATE TABLE IF NOT EXISTS clients (
      client_id SMALLINT PRIMARY KEY -- Al ser un ejemplo de 10 registros, se le deja el campo más bajo
    , first_name CHAR(25) NOT NULL
    , surname CHAR(25) NOT NULL
    , email CHAR(150) UNIQUE -- El email es único para evitar duplicados en el marketing.
    , phone MEDIUMINT -- Es un negocio nacional, así que no derberia tener en mente el prefijo
    , observations TEXT -- Por ejemplo: "Alérgico al aguacate"
);


CREATE TABLE IF NOT EXISTS sales (
      order_id CHAR(25) PRIMARY KEY
    , sale_date DATETIME NOT NULL
    , client_id SMALLINT NOT NULL
    , product_id CHAR(25) NOT NULL
   
-- Definición de Llaves Foráneas
    ,CONSTRAINT fk_client FOREIGN KEY (client_id)
        REFERENCES clients(client_id)
        ON DELETE CASCADE, -- Si se borra un cliente, se gestiona su historial según política.
       
    CONSTRAINT fk_order FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);
/*
========
Tablas con registros
========
*/
INSERT INTO products (product_id, name, price) VALUES
('PROD-001', 'Café Espresso', 2.50),
('PROD-002', 'Capuchino', 3.20),
('PROD-003', 'Té Verde', 1.80),
('PROD-004', 'Muffin de Arándanos', 2.10),
('PROD-005', 'Sándwich de Jamón', 4.50),
('PROD-006', 'Pastel de Chocolate', 3.75),
('PROD-007', 'Agua Mineral', 1.20),
('PROD-008', 'Jugo de Naranja', 2.80),
('PROD-009', 'Croissant', 1.90),
('PROD-010', 'Galleta de Avena', 1.50);


INSERT INTO clients (client_id, first_name, surname, email, phone, observations) VALUES
(1, 'Ivan', 'Hincapie', 'ivan.h@email.com', 300123,NULL),
(2, 'Maria', 'Garcia', 'm.garcia@email.com', 311456, 'Sin Azucar'),
(3, 'Juan', 'Perez', 'jperez@email.com', 320789, 'Alérgico a las nueces'),
(4, 'Ana', 'Lopez', 'alopez@email.com', 315234, NULL),
(5, 'Carlos', 'Ruiz', 'cruiz@email.com', 318567, NULL),
(6, 'Laura', 'Torres', 'ltorres@email.com', 310890, 'Alérgica al aguacate'),
(7, 'Pedro', 'Gomez', 'pgomez@email.com', 305111, NULL),
(8, 'Elena', 'Mora', 'emora@email.com', 302222, NULL),
(9, 'Diego', 'Diaz', 'ddiaz@email.com', 301333, NULL),
(10, 'Sofia', 'Vega', 'svega@email.com', 304444, 'Sin leche de almendras');


INSERT INTO sales (order_id, sale_date, client_id, product_id) VALUES
('ORD-2025-001', '2025-12-18 08:30:00', 1, 'PROD-001'),
('ORD-2025-002', '2025-12-18 09:15:00', 2, 'PROD-002'),
('ORD-2025-003', '2025-12-18 10:00:00', 3, 'PROD-004'),
('ORD-2025-004', '2025-12-19 11:20:00', 1, 'PROD-005'),
('ORD-2025-005', '2025-12-19 14:45:00', 5, 'PROD-003'),
('ORD-2025-006', '2025-12-20 16:10:00', 6, 'PROD-008'),
('ORD-2025-007', '2025-12-20 17:00:00', 7, 'PROD-009'),
('ORD-2025-008', '2025-12-21 08:05:00', 1, 'PROD-010'),
('ORD-2025-009', '2025-12-21 09:50:00', 4, 'PROD-001'),
('ORD-2025-0010', '2025-12-21 16:50:00', 4, 'PROD-002'),
('ORD-2025-0011', '2025-12-22 08:13:00', 8, 'PROD-003'),
('ORD-2025-0012', '2025-12-22 14:12:00', 9, 'PROD-004'),
('ORD-2025-0013', '2025-12-23 13:15:00', 8, 'PROD-005'),
('ORD-2025-0014', '2025-12-24 12:35:00', 9, 'PROD-006'),
('ORD-2025-0015', '2025-12-24 16:54:00', 10, 'PROD-007'),
('ORD-2025-0016', '2025-12-25 14:44:00', 9, 'PROD-008'),
('ORD-2025-0017', '2025-12-25 12:30:00', 10, 'PROD-009');


/*
=============================================================
DOCUMENTACIÓN ADICIONAL PARA EL MANTENIMIENTO DE DATOS Y ESTRUCTURAS (DDL & DML)
=============================================================


-- ELIMINACIÓN DE TABLAS COMPLETAS (DDL)
-- DROP TABLE: Se utiliza para eliminar la tabla por completo.
-- DROP TABLE IF EXISTS pyme.sales;


-- ALTER TABLE: Modifica una tala ya creada. También puede añadir o borrar columnas.
-- ALTER TABLE pyme.sales ADD 'quantity' INT


-- MODIFICACIÓN Y ELIMINACIÓN DE REGISTROS (DML)
-- UPDATE: Se utiliza para editar valores existentes y en su mayoria de veces se debe acompañar de un WHERE.
-- UPDATE pyme.clients SET observations = 'Es celíaco' WHERE client_id = 1;


-- DELETE: Solo elimina filas de la tabla.
-- DELETE FROM pyme.products WHERE product_id = 'PROD-010';
*/


/*
========
Queries
========
*/
-- Consulta básica, donde se trae todos los registros, se omiten los primeros 5 registros y tiene un limite de 10.
SELECT *
FROM pyme.sales AS s
LIMIT 10
OFFSET 5;


-- Consulta con Subqueries para saber el prodcutos con mayor y menor valor
SELECT
    product_id
    ,name
    ,price
FROM products
WHERE price = (SELECT MAX(price) FROM products)
   OR price = (SELECT MIN(price) FROM products)
ORDER BY price DESC;


-- Consulta para saber el precio de los productos y la cantidad de veces que se vendio, ordenado por mayor cantidad (Ambos)
SELECT
    p.product_id
    ,p.name
    ,p.price
    ,COUNT(s.order_id) AS sales
FROM products AS p
JOIN sales AS s
    ON p.product_id = s.product_id
GROUP BY p.product_id
ORDER BY sales desc, price desc;


-- Consulta para filtrat las ventas realizadas en una semana en especifico
SELECT
    s.order_id
    ,s.sale_date
    ,s.client_id
    ,s.product_id
FROM pyme.sales AS s
WHERE s.sale_date BETWEEN '2025-12-14 00:00:00' AND '2025-12-20 23:59:59'
ORDER BY s.sale_date ASC;


-- Consulta de las ventas que se hicieron por un valor mayor o igual a 3 USD
SELECT
    s.order_id
    ,s.sale_date
    ,s.client_id
    ,s.product_id
    ,p.price
FROM pyme.sales AS s
JOIN pyme.products AS p
    ON s.product_id = p.product_id
WHERE s.client_id BETWEEN 1 AND 5
HAVING p.price >= 3.00
ORDER BY s.sale_date ASC;


-- Consulta para saber los clientes cuánto han comprado (Top 5 más han invertido en la empresa)
SELECT
    s.client_id
    ,CONCAT(c.first_name," ",c.surname) AS client_name
    ,SUM(p.price) AS 'Total'
FROM pyme.sales AS s
JOIN pyme.products AS p
    ON s.product_id = p.product_id
JOIN pyme.clients AS c
    ON s.client_id = c.client_id
GROUP BY s.client_id
ORDER BY 'Total' DESC
LIMIT 5;


-- Consulta para saber la cantidad de veces que los clientes han comprado (Top 5)
SELECT
    CONCAT(c.first_name," ",c.surname) AS client_name
    ,COUNT(s.order_id) AS 'Compras'
FROM pyme.sales AS s
JOIN pyme.clients AS c
    ON c.client_id = s.client_id
GROUP BY s.client_id
HAVING COUNT(s.order_id) > 1
ORDER BY Compras DESC;


-- Consulta para saber cuanto cuesta cada prodcuto, la cantidad de veces vendido y cuando representa en las ventas. Del menos al menor con uso de CTE.
WITH expent AS (
    SELECT
        p.product_id
        ,p.name
        ,p.price
        ,COUNT(S.order_id) AS 'Sales'
    FROM pyme.products AS p
    JOIN pyme.sales AS s
        ON p.product_id = s.product_id
    GROUP BY product_id
)
SELECT
    name
    ,price
    ,Sales
    ,(Sales*price) AS GMV
FROM expent
ORDER BY GMV DESC;


-- Consulta para ver saber la cantidad de ventas y dinero acumulado por días del mes
WITH ventas_por_dia AS (
    SELECT
        DATE_FORMAT(s.sale_date,'%D') AS dia
        ,COUNT(s.order_id) AS ventas_dia
        ,SUM(p.price) AS GMV
    FROM pyme.sales AS s
    JOIN pyme.products AS p
        ON s.product_id = p.product_id
    GROUP BY dia
)
SELECT
    Dia
    ,SUM(ventas_dia) OVER (
        ORDER BY dia
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS `S. Acum.`
    ,SUM(GMV) OVER (
        ORDER BY dia
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS `GMV. Acum.`
FROM ventas_por_dia
ORDER BY dia;