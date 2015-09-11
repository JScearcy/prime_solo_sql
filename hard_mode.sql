CREATE DATABASE customer_information;

COMMENT ON DATABASE booktown
       IS 'The customer information database.';
\connect booktown postgres
CREATE TABLE shipping_addresses (
  address_id integer PRIMARY KEY,
  street text,
  city text,
  state text,
  zip integer
);

CREATE TABLE customers (
  cust_id integer PRIMARY KEY,
  name text NOT NULL,
  address_id integer REFERENCES shipping_addresses(address_id)
);
INSERT INTO customers(cust_id, name, address_id)
  VALUES (1, 'Jake Scearcy', 100),
          (2, 'Random Tester', 101),
          (3, 'Totalia Fakes', 102),
          (4, 'Alfonzo Grote', 103),
          (5, 'Jane Doe', 104);

INSERT INTO shipping_addresses (address_id, street, city, state, zip)
  VALUES (100, '1576 Margaret St', 'St Paul', 'Minnesota', 55106),
          (101, '1234 MadeUp Ave', 'Wayzata', 'Minnesota', 55391),
          (102, '4321 McMasters St', 'Eden Prairie', 'Minnesota', 55347),
          (103, '5000 Europe Rd', 'Richfield', 'Minnesota', 55423),
          (104, '111 Kellogg Blvd', 'St Paul', 'Minnesota', 55101);

CREATE TABLE products(
  product_id integer PRIMARY KEY,
  product_name text,
  product_price numeric
);

INSERT INTO products (product_id, product_name, product_amount)
  VALUES (201, 'Pork Ribs', 5.00),
          (202, 'Hickory Wood Chips', 2.00),
          (203, 'Tongs', 10.00),
          (204, 'Spatula', 12.00),
          (205, 'Charcoal', 1.00);

CREATE TABLE orders (
  order_id integer,
  product_id integer REFERENCES products(product_id),
  product_amount integer
);

INSERT INTO orders (order_id, product_id, product_amount)
  VALUES (301, 201, 5), (301, 202, 10),
          (302, 203, 1), (302, 205, 5), (302, 201, 2),
          (303, 202, 1), (303, 203, 1), (303, 204, 1),
          (304, 201, 4), (304, 202, 2), (304, 204, 2),
          (305, 203, 2), (305, 204, 1),
          (306, 201, 10),
          (307, 204, 1),
          (308, 205, 20),
          (309, 202, 25),
          (310, 201, 2), (310, 202, 3), (310, 205, 3);

CREATE TABLE orderid_custid (
  order_id integer,
  customer_id integer REFERENCES customers(cust_id),
);

INSERT INTO orderid_custid (order_id, customer_id)
  VALUES (301, 1), (302, 1),
          (303, 2), (304, 2),
          (305, 3), (306, 3),
          (307, 4), (308, 4),
          (309, 5), (310, 5);
