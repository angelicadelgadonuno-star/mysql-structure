DROP DATABASE IF EXISTS pizza_restaurant;
CREATE DATABASE pizza_restaurant;
USE pizza_restaurant;

CREATE TABLE provinces(
    province_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR (50) NOT NULL
);

CREATE TABLE localities(
    locality_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR (50) NOT NULL,
    province_id INT,
    FOREIGN KEY (province_id) REFERENCES provinces(province_id) 
    );


CREATE TABLE stores(
    store_id INT AUTO_INCREMENT PRIMARY KEY,
    address VARCHAR(30),
    postal_code VARCHAR (10),
    locality_id INT,
    FOREIGN KEY (locality_id) REFERENCES localities (locality_id)
);

CREATE TABLE clients(
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR (60) NOT NULL,
    surname VARCHAR (60),
    address VARCHAR (100) NOT NULL,
    postal_code INT (10) NOT NULL,
    phone VARCHAR (20) NOT NULL,
    locality_id INT,
    FOREIGN KEY (locality_id) REFERENCES localities (locality_id)
);

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR (60) NOT NULL,
    surname VARCHAR(20),
    nif VARCHAR (20) NOT NULL,
    phone VARCHAR(20),
    role ENUM('kitchen', 'delivery') NOT NULL,
    store_id INT,
    FOREIGN KEY(store_id) REFERENCES stores(store_id)
);

CREATE TABLE categories(
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR (50) NOT NULL
);

CREATE TABLE products(
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    image VARCHAR(255),
    price DECIMAL(8,2) NOT NULL,
    type ENUM('pizza','hamburger','beverage') NOT NULL,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    CHECK ( (type = 'pizza' AND category_id IS NOT NULL)
         OR (type <> 'pizza' AND category_id IS NULL) )
);

CREATE TABLE orders(
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    sale_date_hour DATETIME,
    order_type ENUM('delivery','takeaway') NOT NULL,
    total_sale DECIMAL (8,2) NOT NULL,
    client_id INT,
    store_id INT,
    FOREIGN KEY (client_id) REFERENCES clients (client_id),
    FOREIGN KEY (store_id) REFERENCES stores (store_id)
);

CREATE TABLE order_line(
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL DEFAULT 1,
    unitary_price DECIMAL (8,2),
    FOREIGN KEY(order_id) REFERENCES orders(order_id),
    CHECK (quantity > 0)
);

CREATE TABLE deliveries(
    delivery_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    order_id INT,
    employee_id INT,
    delivery_date_hour DATETIME,
    FOREIGN KEY(order_id) REFERENCES orders(order_id),
    FOREIGN KEY(employee_id) REFERENCES employees(employee_id)
);

USE pizza_restaurant;

-- ============================================
-- 1. PROVINCES
-- ============================================
INSERT INTO provinces (name) VALUES
('Madrid'),
('Barcelona'),
('Valencia'),
('Sevilla');

-- ============================================
-- 2. LOCALITIES
-- ============================================
INSERT INTO localities (name, province_id) VALUES
('Madrid', 1),
('Alcalá de Henares', 1),
('Getafe', 1),
('Barcelona', 2),
('Badalona', 2),
('Valencia', 3),
('Sevilla', 4);

-- ============================================
-- 3. STORES
-- ============================================
INSERT INTO stores (address, postal_code, locality_id) VALUES
('Calle Mayor 10', '28013', 1),
('Avenida de la Constitución 5', '28801', 2),
('Calle Colón 22', '08001', 4),
('Plaza del Ayuntamiento 3', '46002', 6);

-- ============================================
-- 4. CLIENTS
-- ============================================
INSERT INTO clients (name, surname, address, postal_code, phone, locality_id) VALUES
('Ana', 'García López', 'Calle Sol 12', '28004', '600111222', 1),
('Luis', 'Martínez Ruiz', 'Avenida Luna 8', '28802', '600333444', 2),
('Marta', 'Sánchez Pérez', 'Calle Mar 45', '08002', '600555666', 4),
('Pedro', 'Gómez Díaz', 'Calle Río 3', '46001', '600777888', 6),
('Lucía', 'Fernández Torres', 'Calle Monte 19', '41001', '600999000', 7);

-- ============================================
-- 5. EMPLOYEES
-- ============================================
INSERT INTO employees (name, surname, nif, phone, role, store_id) VALUES
('Carlos', 'Ruiz', '12345678A', '611111111', 'kitchen', 1),
('Elena', 'Moreno', '23456789B', '622222222', 'delivery', 1),
('Javier', 'Navarro', '34567890C', '633333333', 'kitchen', 2),
('Sara', 'Iglesias', '45678901D', '644444444', 'delivery', 2),
('David', 'Ortega', '56789012E', '655555555', 'kitchen', 3),
('Paula', 'Romero', '67890123F', '666666666', 'delivery', 3),
('Hugo', 'Vidal', '78901234G', '677777777', 'kitchen', 4),
('Nerea', 'Castro', '89012345H', '688888888', 'delivery', 4);

-- ============================================
-- 6. CATEGORIES (solo pizzas)
-- ============================================
INSERT INTO categories (name) VALUES
('Clásicas'),
('Especiales'),
('Vegetarianas'),
('Barbacoa');

-- ============================================
-- 7. PRODUCTS
-- ============================================
-- Pizzas (type = 'pizza', category_id obligatorio)
INSERT INTO products (name, description, image, price, type, category_id) VALUES
('Margarita', 'Tomate, mozzarella y albahaca', 'margarita.jpg', 8.50, 'pizza', 1),
('Pepperoni', 'Tomate, mozzarella y pepperoni', 'pepperoni.jpg', 9.50, 'pizza', 1),
('Cuatro Quesos', 'Mozzarella, gorgonzola, parmesano y emmental', 'cuatroquesos.jpg', 10.50, 'pizza', 2),
('Barbacoa', 'Salsa barbacoa, carne, cebolla y mozzarella', 'barbacoa.jpg', 11.00, 'pizza', 4),
('Vegetal', 'Tomate, mozzarella, pimiento, cebolla y champiñones', 'vegetal.jpg', 9.00, 'pizza', 3),
('Hawaiana', 'Tomate, mozzarella, jamón y piña', 'hawaiana.jpg', 9.75, 'pizza', 2);

-- Hamburguesas (type = 'hamburger', category_id NULL)
INSERT INTO products (name, description, image, price, type, category_id) VALUES
('Clásica', 'Carne de ternera, lechuga, tomate y queso', 'clasica.jpg', 7.50, 'hamburger', NULL),
('Doble Queso', 'Doble carne, doble queso cheddar', 'doblequeso.jpg', 9.00, 'hamburger', NULL),
('Pollo Crispy', 'Pollo crujiente, lechuga y mayonesa', 'pollocrispy.jpg', 8.00, 'hamburger', NULL),
('Veggie', 'Hamburguesa de garbanzos y verduras', 'veggie.jpg', 7.75, 'hamburger', NULL);

-- Bebidas (type = 'beverage', category_id NULL)
INSERT INTO products (name, description, image, price, type, category_id) VALUES
('Coca-Cola', 'Refresco de cola 33cl', 'cocacola.jpg', 2.00, 'beverage', NULL),
('Agua Mineral', 'Botella de agua 50cl', 'agua.jpg', 1.50, 'beverage', NULL),
('Cerveza', 'Cerveza rubia 33cl', 'cerveza.jpg', 2.50, 'beverage', NULL),
('Zumo de Naranja', 'Zumo natural 33cl', 'zumo.jpg', 2.25, 'beverage', NULL);

-- ============================================
-- 8. ORDERS
-- ============================================
INSERT INTO orders (sale_date_hour, order_type, total_sale, client_id, store_id) VALUES
('2026-10-20 13:30:00', 'delivery', 28.50, 1, 1),
('2026-10-20 14:00:00', 'takeaway', 19.00, 2, 2),
('2026-10-21 20:15:00', 'delivery', 35.75, 3, 3),
('2026-10-22 12:45:00', 'takeaway', 15.50, 4, 4),
('2026-10-23 21:00:00', 'delivery', 42.00, 5, 1);

-- ============================================
-- 9. ORDER_LINE
-- ============================================
-- Pedido 1 (Ana, tienda 1): 2 Margaritas + 1 Coca-Cola + 1 Agua
INSERT INTO order_line (order_id, product_id, quantity, unitary_price) VALUES
(1, 1, 2, 8.50),   -- Margarita
(1, 11, 1, 2.00),  -- Coca-Cola
(1, 12, 1, 1.50);  -- Agua

-- Pedido 2 (Luis, tienda 2): 1 Pepperoni + 1 Clásica + 1 Cerveza
INSERT INTO order_line (order_id, product_id, quantity, unitary_price) VALUES
(2, 2, 1, 9.50),   -- Pepperoni
(2, 7, 1, 7.50),   -- Hamburguesa Clásica
(2, 13, 1, 2.50);  -- Cerveza

-- Pedido 3 (Marta, tienda 3): 2 Cuatro Quesos + 1 Veggie + 2 Zumos
INSERT INTO order_line (order_id, product_id, quantity, unitary_price) VALUES
(3, 3, 2, 10.50),  -- Cuatro Quesos
(3, 10, 1, 7.75),  -- Veggie
(3, 14, 2, 2.25);  -- Zumo

-- Pedido 4 (Pedro, tienda 4): 1 Vegetal + 1 Doble Queso
INSERT INTO order_line (order_id, product_id, quantity, unitary_price) VALUES
(4, 5, 1, 9.00),   -- Vegetal
(4, 8, 1, 9.00);   -- Doble Queso

-- Pedido 5 (Lucía, tienda 1): 2 Barbacoa + 2 Pollo Crispy + 2 Cervezas
INSERT INTO order_line (order_id, product_id, quantity, unitary_price) VALUES
(5, 4, 2, 11.00),  -- Barbacoa
(5, 9, 2, 8.00),   -- Pollo Crispy
(5, 13, 2, 2.50);  -- Cerveza

-- ============================================
-- 10. DELIVERIES (solo pedidos a domicilio)
-- ============================================
-- Pedido 1: repartidor Elena (employee 2, tienda 1)
INSERT INTO deliveries (order_id, employee_id, delivery_date_hour) VALUES
(1, 2, '2026-10-20 13:55:00');

-- Pedido 3: repartidor Paula (employee 6, tienda 3)
INSERT INTO deliveries (order_id, employee_id, delivery_date_hour) VALUES
(3, 6, '2026-10-21 20:40:00');

-- Pedido 5: repartidor Elena (employee 2, tienda 1)
INSERT INTO deliveries (order_id, employee_id, delivery_date_hour) VALUES
(5, 2, '2026-10-23 21:25:00');

SELECT SUM(ol.quantity) AS total_beverages_sold
FROM order_line ol
JOIN products p   ON ol.product_id = p.product_id
JOIN orders o     ON ol.order_id = o.order_id
JOIN clients c    ON o.client_id = c.client_id
JOIN localities l ON c.locality_id = l.locality_id
WHERE p.type = 'beverage'
  AND l.name = 'Alcalá de Henares';
 
