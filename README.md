# Relational Database Design Project

This repository contains the design, implementation, and SQL queries for three different relational database models based on different business areas: an optician's shop, a pizzeria, and a video platform (like YouTube).

## 📋 Project Content

The project is divided into three independent databases. For each one, the project includes:
1. **Creation Script (DDL):** Tables, primary keys, foreign keys, and constraints (CHECK, UNIQUE).
2. **Test Data (DML):** Sample data to test the database.
3. **Queries (DQL):** Solutions to the queries requested in the exercises.
4. **Entity-Relationship Diagrams (E-R):** Visual models generated with DBML.

---

## 🗄️ 1. Optician's Shop "Cul d'Ampolla" (`bottle_bottom_optics`)
**Goal:** Manage clients, suppliers, brands, glasses, and sales for an optician's shop.

**Main features of the model:**
- **Suppliers and Brands:** 1:N relationship (one supplier can have many brands, but one brand belongs to only one supplier).
- **Glasses:** Stores the physical details of each pair of glasses (graduation, mount type, colors, price).
- **Clients:** Includes a self-referencing relationship (`referred_by`) to save which client recommended the shop to a new client.
- **Employees and Sales:** Records which employee sold each pair of glasses and the date.

**Solved Queries:**
- Total amount invoiced to a client in a specific period.
- Glasses sold by an employee during a specific year.
- Suppliers who provided glasses that were successfully sold.

---

## 🍕 2. Pizzeria (`pizza_restaurant`)
**Goal:** Design the database model for a food delivery website.

**Main features of the model:**
- **Geography:** Normalized tables for `provinces` and `localities`.
- **Products:** Uses a `type` field (pizzas, hamburgers, beverages). Pizzas are related to `categories`.
- **Orders:** Order header (`orders`) and order details (`order_lines`) to save quantities and prices.
- **Delivery:** `deliveries` table (1:1 relationship with delivery orders) to record the delivery driver and the delivery time.

---

## 📺 3. Video Platform - YouTube (`youtube_db`)
**Goal:** Model a reduced version of a video hosting platform.

**Main features of the model:**
- **Users and Channels:** A user can create channels and subscribe to other channels.
- **Videos:** Attributes like title, duration (`TIME`), views, likes, dislikes, and status (public, hidden, private).
- **Interactions:**
  - `likes_dislikes` table with a composite primary key (`user_id`, `video_id`) to make sure a user only votes once per video.
  - Comment system and rating for comments.
  - Public or private playlists.

---

## 🛠️ Technologies Used

- **Database Engine:** MySQL 8.0+
- **SQL Client:** MySQL Workbench
- **Visual Modeling:** DBML (Database Markup Language) / dbdiagram.io
- **Version Control:** Git / GitHub

## 🚀 How to run the scripts

1. Open **MySQL Workbench** (or your favorite SQL client).
2. Create a new connection to your local server.
3. Open the `.sql` file for the project you want to test (for example, `bottle_bottom_optics.sql`).
4. Run the full script. *(Note: The scripts include `DROP DATABASE IF EXISTS` at the beginning, so they will reset the database from scratch).*
5. Run the queries at the end of the script to see the results.

## 👤 Author

- **[Your Name and Surname]**
- [Your email or GitHub profile]
- Project for the subject [Subject Name] - [Course/Year]

---
*This project was developed following database normalization best practices and entity-relationship modeling.*
