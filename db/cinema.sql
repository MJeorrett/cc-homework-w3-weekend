-- Run file from command line:
-- psql -d cinema -f db/cinema.sql

-- DROP VIEWS
DROP VIEW IF EXISTS customers_snacks_vw;
DROP VIEW IF EXISTS tickets_vw;
DROP VIEW IF EXISTS customers_vw;
DROP VIEW IF EXISTS films_vw;
DROP VIEW IF EXISTS snacks_vw;

-- DROP TABLES
DROP TABLE IF EXISTS customers_snacks;
DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS films;
DROP TABLE IF EXISTS snacks;

-- CREATE TABLES
CREATE TABLE customers (
  id SERIAL4 primary key,
  first_name VARCHAR(255),
  last_name VARCHAR(255),
  funds DECIMAL(11, 2)
);

CREATE TABLE films (
  id SERIAL4 primary key,
  title VARCHAR(255),
  price DECIMAL(5, 2)
);

CREATE TABLE snacks (
  id SERIAL4 primary key,
  name VARCHAR(255),
  price DECIMAL(4, 2)
);

CREATE TABLE tickets (
  id SERIAL4 primary key,
  customer_id INT4 REFERENCES customers(id),
  film_id INT4 REFERENCES films(id),
  used BOOLEAN
);

CREATE TABLE customers_snacks (
  id SERIAL4 primary key,
  customer_id INT4 REFERENCES customers(id),
  snack_id INT4 REFERENCES snacks(id)
);

-- CREATE VIEWS
CREATE VIEW customers_vw AS SELECT
  id,
  concat(first_name, ' ', last_name) full_name,
  first_name,
  last_name,
  funds,
  (SELECT COUNT(*) FROM tickets t WHERE c.id = t.customer_id) number_of_tickets,
  (SELECT COUNT(*) FROM customers_snacks cs WHERE c.id = cs.customer_id) number_of_snacks
FROM customers c
ORDER BY full_name ASC;

CREATE VIEW films_vw AS SELECT
  f.id,
  f.title,
  f.price,
  (SELECT COUNT(*) FROM tickets t WHERE f.id = t.film_id) number_of_tickets
FROM films f
ORDER BY title ASC;

CREATE VIEW tickets_vw AS SELECT
  t.id,
  c_vw.full_name customer,
  f.title film,
  t.used
FROM tickets t
  INNER JOIN customers_vw c_vw ON c_vw.id = t.customer_id
  INNER JOIN films f ON f.id = t.film_id
ORDER BY customer ASC;

CREATE VIEW snacks_vw AS SELECT
  s.id,
  s.name,
  (SELECT COUNT(*) FROM customers_snacks cs WHERE s.id = cs.snack_id) number_of_sales
FROM snacks s
ORDER BY name ASC;

CREATE VIEW customers_snacks_vw AS SELECT
  cs.id,
  c_vw.full_name customer,
  s.name snack
FROM customers_snacks cs
  INNER JOIN customers_vw c_vw ON c_vw.id = cs.customer_id
  INNER JOIN snacks s ON s.id = cs.snack_id
ORDER BY customer ASC;
