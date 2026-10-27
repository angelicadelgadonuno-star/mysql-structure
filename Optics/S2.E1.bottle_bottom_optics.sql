DROP DATABASE IF EXISTS bottle_bottom_optics;
CREATE DATABASE bottle_bottom_optics;
USE bottle_bottom_optics;

CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(60) NOT NULL,
    street VARCHAR(100),
    number VARCHAR(10),
    floor VARCHAR(10),
    door VARCHAR(10),
    city VARCHAR(50),
    postal_code VARCHAR(10),
    country VARCHAR(50),
    phone VARCHAR(20),
    fax VARCHAR(20),
    nif VARCHAR(15) NOT NULL UNIQUE
);

CREATE TABLE brands (
    brand_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    name VARCHAR(50) NOT NULL,
    supplier_id INT NOT NULL,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

CREATE TABLE glasses (
    glasses_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_id INT NOT NULL,
    graduation_right DECIMAL(4,2) NOT NULL,
    graduation_left DECIMAL(4,2) NOT NULL,
    mount_type ENUM('floating', 'plastic', 'metal') NOT NULL,
    mount_color VARCHAR(15),
    glass_color_right VARCHAR(15),
    glass_color_left VARCHAR(15),
    price DECIMAL(8,2) NOT NULL,
    FOREIGN KEY(brand_id) REFERENCES brands(brand_id)
);

CREATE TABLE clients (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    postal_address VARCHAR(200),
    phone VARCHAR(20),
    email VARCHAR(50) UNIQUE,
    registry_date DATE NOT NULL,
    referred_by INT,
    FOREIGN KEY (referred_by) REFERENCES clients(client_id)
);

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    surname VARCHAR (50) NOT NULL,
    nif VARCHAR (15) UNIQUE
);

CREATE TABLE sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    employee_id INT NOT NULL,
    glasses_id INT NOT NULL UNIQUE,
    sale_date DATE NOT NULL,
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (glasses_id) REFERENCES glasses(glasses_id)
);

USE bottle_bottom_optics;


INSERT INTO suppliers (name, street, city, postal_code, country, phone, nif) 
VALUES 
('Luxottica', 'Via Roma 1', 'Milano', '20121', 'Italia', '003902123456', 'IT123456789'),
('Safilo', 'Via Industria 5', 'Padova', '35129', 'Italia', '003904987654', 'IT987654321');

INSERT INTO brands (name, supplier_id) 
VALUES 
('Ray-Ban', 1), 
('Oakley', 1),
('Carrera', 2),
('Police', 2);

INSERT INTO glasses (brand_id, graduation_right, graduation_left, mount_type, mount_color, glass_color_right, glass_color_left, price) 
VALUES 
(1, -1.50, -1.25, 'metal', 'black', 'transparent', 'transparent', 150.00),
(2, 0.00, 0.00, 'plastic', 'blue', 'transparent', 'transparent', 95.50),
(1, -2.00, -2.00, 'plastic', 'black', 'grey', 'grey', 120.00),
(3, -1.00, -1.00, 'metal', 'silver', 'green', 'green', 130.00);

INSERT INTO clients (name, postal_address, phone, email, registry_date) 
VALUES 
('Joan Garcia', 'Carrer Major 10, Barcelona', '600111222', 'joan@email.com', '2023-10-01'),
('Maria Lopez', 'Avinguda Diagonal 5, Barcelona', '600333444', 'maria@email.com', '2023-10-02');

INSERT INTO employees (name, surname, nif) 
VALUES 
('Pere', 'Vidal', '12345678A'),
('Anna', 'Ruiz', '23456789B');

INSERT INTO sales (client_id, employee_id, glasses_id, sale_date) 
VALUES 
(1, 1, 1, '2023-10-05'),
(2, 2, 2, '2023-10-10'),
(1, 1, 3, '2024-02-20');


SELECT SUM(g.price) AS total_invoiced
FROM sales s
JOIN glasses g ON s.glasses_id = g.glasses_id
WHERE s.client_id = 1 
  AND s.sale_date BETWEEN '2023-01-01' AND '2023-12-31';


SELECT DISTINCT g.glasses_id, b.name AS brand, g.mount_type, g.price
FROM sales s
JOIN glasses g ON s.glasses_id = g.glasses_id
JOIN brands b ON g.brand_id = b.brand_id
WHERE s.employee_id = 1 
  AND YEAR(s.sale_date) = 2023;

SELECT DISTINCT sup.supplier_id, sup.name
FROM suppliers sup
JOIN brands b ON sup.supplier_id = b.supplier_id
JOIN glasses g ON b.brand_id = g.brand_id
JOIN sales s ON g.glasses_id = s.glasses_id;