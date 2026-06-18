-- ======================================
-- ENTREGA WEEK 2 — TECHSTORE INVENTARIO
-- Nombre: [Bernardo Castro]  |  Fecha: [17-Jun-26]
-- ======================================

-- Parte 1: DDL
-- Borra base de datos techstore_inventario cuando ya existe
DROP DATABASE IF EXISTS techstore_inventario;
CREATE DATABASE techstore_inventario;
USE techstore_inventario;
SELECT DATABASE();
-- Crea tablas productos y ventas
CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo_producto VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    categoria VARCHAR(50) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    costo DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    stock_minimo INT DEFAULT 5,
    proveedor VARCHAR(100),
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE ventas (
id INT AUTO_INCREMENT PRIMARY KEY,
producto_id INT NOT NULL,
cantidad INT NOT NULL,
precio_venta DECIMAL(10,2) NOT NULL,
total DECIMAL(10,2) NOT NULL,
fecha_venta TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
SHOW TABLES;
DESCRIBE productos;
DESCRIBE ventas;

-- Parte 2: DML inicial cargar catalogo y primeras ventas
INSERT INTO productos
    (codigo_producto, nombre, descripcion, categoria, precio, costo, stock, stock_minimo, proveedor, activo)
VALUES
    -- Laptops
    ('LAP001', 'Laptop HP Pavilion 15', 'Laptop Intel i5, 8GB RAM, 256GB SSD', 'Laptops', 799.99, 650.00, 12, 5, 'HP Inc', TRUE),
    ('LAP002', 'MacBook Air M2', 'Apple MacBook Air con chip M2, 8GB, 256GB', 'Laptops', 1299.99, 1050.00, 8, 3, 'Apple', TRUE),
    ('LAP003', 'Dell XPS 13', 'Ultrabook Dell XPS 13, i7, 16GB, 512GB SSD', 'Laptops', 1499.99, 1200.00, 5, 3, 'Dell', TRUE),
    ('LAP004', 'Lenovo ThinkPad', NULL, 'Laptops', 899.99, 720.00, 0, 5, 'Lenovo', FALSE),

    -- Periféricos
    ('PER001', 'MoUSE Logitech MX Master 3', 'MoUSE ergonómico inalámbrico', 'Perifericos', 99.99, 65.00, 35, 10, 'Logitech', TRUE),
    ('PER002', 'Teclado Mecánico KEYchron K2', 'Teclado mecánico RGB, switches Gateron Brown', 'Perifericos', 89.99, 55.00, 20, 8, 'Keychron', TRUE),
    ('PER003', 'Webcam Logitech C920', 'Webcam Full HD 1080p', 'Perifericos', 79.99, 50.00, 15, 10, 'Logitech', TRUE),
    ('PER004', 'Hub USB-C 7 puertos', NULL, 'Perifericos', 45.99, 25.00, 50, 15, 'Anker', TRUE),
    ('PER005', 'MoUSE Pad XL', 'MoUSE pad gaming 90x40cm', 'Perifericos', 24.99, 10.00, 80, 20, 'SteelSeries', TRUE),
    ('PER006', 'Soporte Laptop Ajustable', 'Soporte ergonómico aluminio', 'Perifericos', 39.99, 20.00, 25, 10, 'Rain Design', TRUE),

    -- Audio
    ('AUD001', 'Audífonos Sony WH-1000XM5', 'Audífonos con cancelación de ruido', 'Audio', 399.99, 280.00, 10, 5, 'Sony', TRUE),
    ('AUD002', 'Audífonos Gaming HyperX', NULL, 'Audio', 79.99, 45.00, 30, 10, 'HyperX', TRUE),
    ('AUD003', 'Micrófono Blue Yeti', 'Micrófono USB profesional', 'Audio', 129.99, 85.00, 12, 6, 'Logitech', TRUE),
    ('AUD004', 'Parlantes Logitech Z623', 'Sistema 2.1, 200W', 'Audio', 149.99, 95.00, 8, 5, 'Logitech', TRUE),
    ('AUD005', 'Audífonos Bluetooth JBL', 'Audífonos inalámbricos portátiles', 'Audio', 49.99, 25.00, 2, 10, 'JBL', TRUE),

    -- Componentes
    ('COM001', 'SSD Samsung 1TB', 'SSD NVMe M.2 1TB', 'Componentes', 89.99, 60.00, 40, 15, 'Samsung', TRUE),
    ('COM002', 'RAM Corsair 16GB DDR4', '16GB (2x8GB) DDR4 3200MHz', 'Componentes', 79.99, 50.00, 25, 10, 'Corsair', TRUE),
    ('COM003', 'Monitor LG 27" 4K', 'Monitor IPS 27 pulgadas 4K', 'Componentes', 449.99, 320.00, 7, 5, 'LG', TRUE),
    ('COM004', 'Cable HDMI 2.1 - 2m', NULL, 'Componentes', 19.99, 8.00, 100, 30, 'Cable Matters', TRUE),
    ('COM005', 'Adaptador USB-C a HDMI', 'Adaptador 4K 60Hz', 'Componentes', 29.99, 15.00, 60, 20, 'Anker', TRUE);
    
INSERT INTO ventas (producto_id, cantidad, precio_venta, total) VALUES
    (1,  2,  799.99, 1599.98),
    (5,  5,   99.99,  499.95),
    (6,  3,   89.99,  269.97),
    (11, 1,  399.99,  399.99),
    (16, 4,   89.99,  359.96);
    
-- verificación
SELECT count(*) FROM productos;
SELECT count(*) FROM ventas;
SELECT categoria, count(*) FROM productos GROUP BY categoria;

-- Parte 3: UPDATE 
SELECT nombre, precio, round(precio *1.10, 2) AS nuevo_precio, categoria
FROM productos WHERE categoria = 'Audio';

SET SQL_SAFE_UPDATEs = 0; -- Hard updates
UPDATE productos SET precio = precio * 1.10 WHERE categoria = 'Audio';
SET SQL_SAFE_UPDATEs = 1; -- Safe updates

-- verificación
SELECT nombre, precio, categoria
FROM productos WHERE categoria = 'Audio';

-- Reducir stock
START TRANSACTION;

UPDATE productos SET stock = stock - 2 WHERE id = 1;   -- venta 1: 2 unidades
UPDATE productos SET stock = stock - 5 WHERE id = 5;   -- venta 2: 5 unidades
UPDATE productos SET stock = stock - 3 WHERE id = 6;   -- venta 3: 3 unidades
UPDATE productos SET stock = stock - 1 WHERE id = 11;  -- venta 4: 1 unidad
UPDATE productos SET stock = stock - 4 WHERE id = 16;  -- venta 5: 4 unidades
-- verificación
SELECT nombre, stock FROM productos WHERE id in (1, 5, 6, 11, 16);
COMMIT;

-- marcar como inactivos los productos con stock bajo
SELECT nombre, stock, stock_minimo
FROM productos
WHERE stock < stock_minimo;

SET SQL_SAFE_UPDATEs = 0;
UPDATE productos
SET activo = false
WHERE stock < stock_minimo;
SET SQL_SAFE_UPDATEs = 1;

-- verificación
SELECT nombre, stock, stock_minimo, activo
FROM productos WHERE activo = FALSE;

SELECT nombre, fecha_creacion, fecha_actualizacion FROM productos WHERE id IN (1, 5);
-- fecha_actualizacion debe ser HOY, fecha_creacion debe ser HOY también pero más temprano.

-- Parte 4 DELETE: soft + hard DELETE
-- Agregar columna deleted_at
ALTER TABLE productos ADD COLUMN deleted_at TIMESTAMP NULL;

UPDATE productos 
SET deleted_at = current_timestamp
WHERE codigo_producto = 'LAP004';
SELECT id, nombre, deleted_at FROM productos WHERE deleted_at IS NOT NULL;
-- ventas viejas > 2 años
SELECT * FROM ventas WHERE fecha_venta < '2024-01-01';
SET SQL_SAFE_UPDATEs = 0;
DELETE FROM ventas WHERE fecha_venta < '2024-01-01';
SET SQL_SAFE_UPDATEs = 1;
SELECT COUNT(*) FROM ventas;

-- Parte 5 Transaccion de venta completa
-- verificar stock de mouse pad XL (id=9)
START TRANSACTION;
SELECT id, nombre, stock, precio
FROM productos
WHERE id = 9 AND stock >= 3 AND deleted_at IS NULL;
-- reducir stock (-3 unidades)
UPDATE productos
SET stock = stock - 3
WHERE id = 9;
-- capturar precio actual como variable
SELECT @precio_actual := precio FROM productos WHERE id = 9;
-- registrar la venta usando variable de precio
INSERT INTO ventas (producto_id, cantidad, precio_venta, total)
VALUES (9, 3, @precio_actual, @precio_actual * 3);
-- verificación
SELECT id, nombre, stock FROM productos WHERE id = 9;
SELECT * FROM ventas WHERE id = LAST_INSERT_ID();
COMMIT;

-- Parte 6 (bonus): Reportes

-- Productos en alerta de stock bajo (con prioridad)
SELECT codigo_producto, nombre, categoria, stock, stock_minimo, stock_minimo - stock AS unidades_faltantes
FROM productos
WHERE stock < stock_minimo AND deleted_at IS NULL
ORDER BY unidades_faltantes DESC;

-- Margen de ganacia Top 10
SELECT nombre, categoria, precio, costo, precio - costo AS margen_abs, ROUND(((precio - costo) / precio) * 100, 2) 
       AS margen_pct
FROM productos
WHERE DELETEd_at IS NULL
ORDER BY margen_abs DESC
LIMIT 10;

-- Revenue por categoria
SELECT p.categoria, COUNT(v.id) AS num_ventas, SUM(v.cantidad) AS unidades, SUM(v.total) AS revenue_total
FROM ventas v
JOIN productos p ON v.producto_id = p.id
GROUP BY p.categoria
ORDER BY revenue_total DESC;