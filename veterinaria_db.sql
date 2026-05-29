CREATE SCHEMA veterinaria;
USE veterinaria;

DROP TABLE IF EXISTS producto;
DROP TABLE IF EXISTS mascota;
DROP TABLE IF EXISTS cliente;
DROP TABLE IF EXISTS factura;
DROP TABLE IF EXISTS empleado;
DROP TABLE IF EXISTS fact_productos;
DROP TABLE IF EXISTS servicio;

-- TABLA DE PRODUCTOS
-- Se le quita el data type
CREATE TABLE producto
(
	pro_id INT AUTO_INCREMENT PRIMARY KEY,
	pro_tipo ENUM('Alimento','Aseo','Accesorio') NOT NULL,
	pro_nombre VARCHAR(40) NOT NULL,
	pro_costo DOUBLE(8,2) NOT NULL,
	pro_unid INT NOT NULL,
	pro_pv  DOUBLE(8,2) NOT NULL
);

-- INSERCIÓN EN LA TABLA DE PRODUCTOS
-- se le quita los valores adicionales, se optimiza el insert
INSERT INTO producto(pro_tipo,pro_nombre,pro_costo,pro_unid,pro_pv) VALUES
('Alimento'		,'Donkan carne y cereal 22kg'			,58200	,10	,66931),
('Alimento'		,'Dogourmet carneparrilla adulto 22kg'	,93733	,10	,107794),
('Alimento'		,'Dogourmet carneparrilla adulto 400g'	,2186	,10	,2515),
('Alimento'		,'Italcan carne y verduras 25kg'		,60607	,10	,69699),
('Alimento'		,'Chunky cordero 12kg'					,87632	,10	,100777),
('Alimento'		,'Ohmaigat caseros 500g'				,5330	,10	,6130),
('Alimento'		,'Dog Chow Adultos 22,7kg'				,145292	,10	,167086),
('Alimento'		,'Ocelatus 720gr'						,1630	,10	,1875),
('Aseo'			,'Arena fofijazmin 5kg'					,14000	,10	,16100),
('Alimento'		,'Cabanos 1kg'							,8000	,10	,9200),
('Alimento'		,'Monello cat 15kg'						,128108	,10	,147324),
('Alimento'		,'Incros14,2g'							,2021	,10	,2425),
('Accesorio'	,'Palas gato'							,2160	,10	,2592);

-- TABLA DE EMPLEADOS
CREATE TABLE empleado
(
	emp_id INT AUTO_INCREMENT PRIMARY KEY,
	emp_nombre VARCHAR(30) NOT NULL,
	emp_telefono BIGINT NOT NULL,
	emp_correo VARCHAR(20) NULL,
    emp_estado ENUM('activo','inactivo') DEFAULT 'activo'
);

-- INSERCIÓN DE EMPLEADOS
INSERT INTO empleado(emp_nombre,emp_telefono) VALUES
('Angie Baños','3188645236'),
('Nevardo Efrain Baños','3146782904'),
('Catalina Anzola PAvon','3118970221'),
('Valentina Rodriguez','3141592653');


-- TABLA DE CLIENTES
CREATE TABLE cliente
(
	cli_id INT AUTO_INCREMENT PRIMARY KEY,
	cli_nombre VARCHAR(30) NOT NULL,
	cli_celular BIGINT,
	cli_celular2 BIGINT
);

-- INSERCION DE CLIENTES
INSERT INTO cliente(cli_nombre, cli_celular, cli_celular2) VALUES
('Dumar Cendales',3133240933,3118634645),
('Johanna Méndez',3123210933,3045489120),
('Wilson Contreras',3102718281,3156879043),
('Alejandra Pulido',3016751264,3164654954),
('Hernán Sánchez',3135624231,3208082839),
('Olga Pardo',3144378409,3109471214),
('Maleja González',3227916509,3006213625),
('Katherine Bastidas',3112496603,3212032553),
('Camila Patiño',3138343323,3142102214);

-- TABLA DE FACTURA DE PRODUCTOS
-- DROP TABLE IF EXISTS fac_productos;
CREATE TABLE fac_productos(
	id_fact INT AUTO_INCREMENT PRIMARY KEY,
	id_producto INT NOT NULL,
	cantidad INT NOT NULL,
	precio INT NOT NULL,
    fecha DATE,
    hora TIME,
	Id_empleado INT NOT NULL,
	foreign key(id_producto) references producto(pro_id),
	foreign key(Id_empleado) references empleado(emp_id)
);

ALTER TABLE fac_productos AUTO_INCREMENT=2020;
-- Creo que debe ir aca
-- ALTER TABLE fac_productos AUTO_INCREMENT=100; 

-- TABLA DE MASCOTAS
CREATE TABLE mascota
(
	mas_id INT AUTO_INCREMENT PRIMARY KEY,
	mas_nombre VARCHAR(10) NOT NULL,
	mas_tipo ENUM('Perro','Gato','Hamster','Conejo','Loro','Pez') NOT NULL,
	mas_raza VARCHAR(20) NOT NULL,
	mas_peso DOUBLE(5,2) NOT NULL,
	mas_sexo ENUM('m','h') NOT NULL, 
	mas_tamano DOUBLE(5,2) NOT NULL,
	mas_des_social VARCHAR(50) NULL,
	mas_edad DOUBLE(5,2) NULL,
	mas_dueno INT NOT NULL,
	FOREIGN KEY (mas_dueno) REFERENCES cliente(cli_id)
);

ALTER TABLE mascota AUTO_INCREMENT=101

-- INSERCIÓN DE MASCOTAS
-- CHECK
-- Se le cambia el nombre de la tabla
INSERT INTO mascota(mas_nombre,mas_tipo,mas_raza,mas_peso,mas_sexo,mas_tamano,mas_des_social,mas_edad,mas_dueno) VALUES
('Max'		,'Perro'	,'Labrador'			,52.8	,'m'	,52	,'Juguetón excepto con los perros de su misma raza'	,5		,1),
('Lula'		,'Perro'	,'French poodle'	,13		,'h'	,30	,NULL												,3		,2),
('Rufo'		,'Perro'	,'Pitbull'			,22.3	,'m'	,49	,NULL												,2		,3),
('Rodolfo'	,'Perro'	,'Beagle'			,11.4	,'m'	,37	,'Territorial, es cazador. Ha atacado palomas'		,1.25	,4),
('Tony'		,'Perro'	,'Criollo'			,38		,'m'	,42	,'Miedoso, fue recogido de la calle'				,NULL	,7),
('Toby'		,'Perro'	,'Criollo'			,32		,'m'	,37	,'Miedoso, fue recogido de la calle'				,NULL	,7),
('Princesa'	,'Perro'	,'Baset hound'		,28		,'h'	,32	,'Perezoso'											,3.25	,7),
('Pelusa'	,'Gato'		,'Ragdoll'			,7		,'h'	,36	,'Esquivo, tranquilo'								,4		,5),
('Manchas'	,'Gato'		,'Criollo'			,5.3	,'h'	,23	,NULL												,NULL	,5),
('Tomas'	,'Gato'		,'Criollo'			,6.2	,'m'	,27	,NULL												,NULL	,5),
('Terry'	,'Perro'	,'Pitbull'			,6		,'m'	,13	,'Juguetón'											,4/12	,4),
('Niña'		,'Perro'	,'Criollo'			,17		,'h'	,32	,'Juguetón'											,3		,6),
('Lemus'	,'Hamster'	,'Ruso'				,30/1000,'m'	,7.4,NULL												,7/12	,8);

-- TABLA DE SERVICIOS
CREATE TABLE servicio
(
	ser_id CHAR(1) NOT NULL PRIMARY KEY,
	ser_nombre VARCHAR(20) NOT NULL
);

-- Inserción de servicios
-- Se corrije nombre de columna
INSERT INTO servicio(ser_id, ser_nombre) VALUES
('P','Peluqueria'),
('G','Guarderia'),
('C','Consulta'),
('V','Venta');

-- TABAL DE FACTURA DE PRODUCTOS
-- Se corrije data type de ser_id
CREATE TABLE factura
(
	fact_id INT AUTO_INCREMENT PRIMARY KEY,
	fact_fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    mas_id INT NOT NULL,
	emp_id INT NULL,
    ser_id CHAR(1) NOT NULL,
	fact_costo INT NOT NULL,
	FOREIGN KEY (emp_id) REFERENCES empleado(emp_id),
	FOREIGN KEY (mas_id) REFERENCES mascota(mas_id),
	FOREIGN KEY (ser_id) REFERENCES servicio(ser_id)
);

INSERT INTO factura(mas_id,emp_id,ser_id, fact_costo) VALUES
(101, 4, 'P', 50000),
(108, 3, 'G', 100000),
(109, 3, 'G', 100000),
(113, 4, 'C', 20000),
(111, 1, 'P', 50000),
(102, 2, 'V', 35000),
(103, 4, 'P', 50000),
(105, 4, 'P', 50000),
(110, 2, 'V', 35000);

CREATE TABLE factura_venta
(
	fact_vta_id INT PRIMARY KEY,
	fact_vta_producto INT NOT NULL,
	FOREIGN KEY (fact_vta_id) REFERENCES factura(fact_id),
    FOREIGN KEY (fact_vta_producto) REFERENCES producto(pro_id)
);

INSERT INTO factura_venta VALUES
(6, 3),
(9, 9);