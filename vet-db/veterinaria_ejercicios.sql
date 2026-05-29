-- List all registered products.
SELECT *
FROM veterinaria.producto p;

-- Show product name and sale price for products with price greater than 50,000, ordered from highest to lowest.
SELECT
	p.pro_nombre 
	,p.pro_pv
FROM veterinaria.producto p
WHERE p.pro_pv > 50000
ORDER BY p.pro_pv DESC; 

-- List all pets showing id, name, type, and breed.
SELECT
	m.mas_id 
	,m.mas_nombre
	,m.mas_tipo 
	,m.mas_raza 
FROM veterinaria.mascota m; 

-- Show name, breed, and weight for pets of type 'Perro'.
SELECT
	m.mas_nombre
	,m.mas_raza
	,m.mas_peso 
FROM veterinaria.mascota m
WHERE m.mas_tipo = 'Perro';

-- Show all services with their corresponding cost.
SELECT * 
FROM veterinaria.producto;

-- Show pet name and the owner's client name.
SELECT
	m.mas_nombre
	,c.cli_nombre
FROM veterinaria.mascota AS m 
LEFT JOIN veterinaria.cliente AS c
	ON m.mas_dueno = c.cli_id;

-- Show invoice number, date, and service name performed.
SELECT
	f.fact_id
	,f.fact_fecha 
	,s.ser_nombre 
FROM veterinaria.factura AS f
LEFT JOIN veterinaria.servicio AS s
	ON f.ser_id = s.ser_id;

-- Show invoice number, date, pet name, and owner name.
SELECT
	f.fact_id
	,f.fact_fecha 
	,m.mas_nombre 
	,c.cli_nombre 
FROM veterinaria.factura AS f
LEFT JOIN veterinaria.mascota AS m
	ON f.mas_id  = m.mas_id
LEFT JOIN veterinaria.cliente AS c
	ON m.mas_dueno = c.cli_id;
	
-- Show employee name and total billed amount for each one.
SELECT
	e.emp_nombre
	,SUM(f.fact_costo) AS total_facturado
FROM veterinaria.empleado AS e
LEFT JOIN veterinaria.factura AS f
	ON e.emp_id  = f.emp_id
GROUP BY e.emp_nombre;

-- Show client name and the number of pets they have registered.
SELECT
	c.cli_nombre
	,COUNT(m.mas_id) AS cantidad_mascotas
FROM veterinaria.cliente AS c
LEFT JOIN veterinaria.mascota AS m
	ON c.cli_id = m.mas_dueno
GROUP BY c.cli_nombre;

-- Show the 3 clients who have spent the most at the veterinary clinic.
SELECT
	c.cli_nombre
	,SUM(f.fact_costo) AS gasto
FROM veterinaria.cliente AS c
LEFT JOIN veterinaria.mascota AS m
	ON c.cli_id = m.mas_dueno
LEFT JOIN veterinaria.factura AS f
	ON m.mas_id  = f.mas_id
GROUP BY c.cli_nombre
ORDER BY gasto DESC
LIMIT 3;

-- Identify products that have never been sold.
SELECT
	p.pro_nombre
	,COUNT(f.fact_id) AS ventas
FROM veterinaria.producto AS p 
LEFT JOIN veterinaria.factura_venta AS fv
	ON fv.fact_vta_producto = p.pro_id
LEFT JOIN veterinaria.factura AS f
	ON f.fact_id - fv.fact_vta_id
GROUP BY p.pro_nombre
HAVING COUNT(f.fact_id) = 0;

-- Show the employee who has generated the highest total billing.
SELECT
	e.emp_nombre
	,SUM(f.fact_costo) AS total_facturado
FROM veterinaria.empleado AS e
LEFT JOIN veterinaria.factura AS f
	ON e.emp_id  = f.emp_id
GROUP BY e.emp_nombre
ORDER BY total_facturado DESC
LIMIT 1;

-- Show invoices with value greater than the overall average billing amount.
SELECT 
    f.fact_id
    ,f.fact_costo 
FROM veterinaria.factura AS f
WHERE f.fact_costo > (SELECT AVG(fact_costo) FROM veterinaria.factura);

-- Show clients who have more than one registered pet.
SELECT
	c.cli_nombre
	,COUNT(m.mas_id) AS mascotas
FROM veterinaria.cliente AS c
LEFT JOIN veterinaria.mascota AS m
	ON c.cli_id = m.mas_dueno
GROUP BY c.cli_nombre
HAVING COUNT(m.mas_id) > 1;