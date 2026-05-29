-- Create a view named vw_factura_detalle that includes invoice number, date, service name, pet name, owner name, and employee name.
USE veterinaria;
CREATE VIEW vw_factura_detalle AS
SELECT
	f.fact_id		AS numero_factura
	,f.fact_fecha	AS fecha
	,s.ser_nombre	AS nombre_servicio
	,m.mas_nombre	AS nombre_mascota
	,c.cli_nombre	AS nombre_cliente
	,e.emp_nombre	AS nombre_empleado
FROM veterinaria.factura AS f
LEFT JOIN veterinaria.servicio AS s
	ON f.ser_id = s.ser_id
LEFT JOIN veterinaria.mascota AS m
	ON f.mas_id = m.mas_id
LEFT JOIN veterinaria.cliente AS c
	ON m.mas_dueno = c.cli_id
LEFT JOIN veterinaria.empleado AS e
	ON f.emp_id = e.emp_id;

-- Query the created view showing only invoices for the 'Peluqueria' service.
SELECT *
FROM vw_factura_detalle AS vw
WHERE vw.nombre_servicio = 'Peluqueria';

-- Create a view named vw_ventas_productos that includes invoice number, date, product name, product type, and sale price.
CREATE VIEW vw_ventas_productos AS
SELECT
	f.fact_id		AS numero_factura
	,f.fact_fecha	AS fecha
	,p.pro_nombre	AS nombre_producto
	,p.pro_tipo		AS tipo_producto
	,p.pro_pv		AS precio_venta
FROM veterinaria.factura AS f
LEFT JOIN veterinaria.factura_venta AS fv
	ON f.fact_id - fv.fact_vta_id
LEFT JOIN veterinaria.producto AS p
	ON fv.fact_vta_producto = p.pro_id;

-- Query the view vw_ventas_productos showing only products of type 'Alimento'.
SELECT *
FROM vw_ventas_productos  AS vw
WHERE vw.tipo_producto = 'Alimento';

-- Create a customer classification view based on total spending.
CREATE VIEW vw_clasificacion_clientes AS
SELECT
    c.cli_id
    ,c.cli_nombre
    ,CASE 
        WHEN SUM(f.fact_costo) > 500000 THEN 'VIP' 
        WHEN SUM(f.fact_costo) BETWEEN 200000 AND 500000 THEN 'Frecuente' 
        WHEN SUM(f.fact_costo) < 200000 THEN 'Ocasional'
        ELSE 'Sin Compras'
    END AS gasto
FROM veterinaria.cliente AS c
LEFT JOIN veterinaria.mascota AS m
    ON c.cli_id = m.mas_dueno
LEFT JOIN veterinaria.factura AS f
    ON m.mas_id  = f.mas_id
GROUP BY c.cli_id, c.cli_nombre;