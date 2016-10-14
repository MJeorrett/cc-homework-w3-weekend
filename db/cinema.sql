DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS films;

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

CREATE TABLE tickets (
  id SERIAL4 primary key,
  customer_id INT4 REFERENCES customers(id),
  film_id INT4 REFERENCES films(id)
);
