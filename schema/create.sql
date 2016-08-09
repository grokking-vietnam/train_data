CREATE EXTENSION IF NOT EXISTS "uuid-ossp"; -- enable UUID types

---------------------------------------------------------------------------------------------------
-- exchange to USD
-- rate_micros:
--    1 currency unit is 1000000 in micros
--    to exchange 1 USD to currency X:    multiply by rate_micros
--    to exchange to USD from currency X: divide by rate_micros
DROP TABLE IF EXISTS exchange_rates CASCADE;
CREATE TABLE exchange_rates (
  currency TEXT NOT NULL,
  day DATE,
  rate_micros INTEGER NOT NULL,
  PRIMARY KEY (currency, day)
);

---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS users CASCADE;
CREATE TABLE users (
  id UUID NOT NULL DEFAULT uuid_generate_v5(uuid_ns_dns(), 'grokking.org.users'),
  name TEXT NOT NULL,
  birthday DATE NOT NULL,
  email TEXT NOT NULL,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS cards CASCADE;
CREATE TABLE cards (
  id UUID NOT NULL DEFAULT uuid_generate_v5(uuid_ns_dns(), 'grokking.org.cards'),
  last_4_digits CHAR(4) NOT NULL,
  expiry_date DATE NOT NULL,
  user_id UUID NOT NULL REFERENCES users(id), -- owner PRIMARY KEY (id)
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS addresses CASCADE;
CREATE TABLE addresses (
  id UUID NOT NULL DEFAULT uuid_generate_v5(uuid_ns_dns(), 'grokking.org.addresses'),
  address TEXT NOT NULL,
  city TEXT NOT NULL,
  state TEXT NOT NULL,
  contact_number TEXT NOT NULL,
  user_id UUID NOT NULL REFERENCES users(id), -- owner
  PRIMARY KEY (id)
);

---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS sellers CASCADE;
CREATE TABLE sellers (
  id UUID NOT NULL DEFAULT uuid_generate_v5(uuid_ns_dns(), 'grokking.org.sellers'),
  display_name TEXT NOT NULL,
  info TEXT NOT NULL,
  contact_number TEXT NOT NULL,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS categories CASCADE;
CREATE TABLE categories (
  id UUID NOT NULL DEFAULT uuid_generate_v5(uuid_ns_dns(), 'grokking.org.categories'),
  display_name TEXT NOT NULL,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS categories_taxonomies CASCADE;
CREATE TABLE categories_taxonomies (
  parent_id UUID NOT NULL REFERENCES categories(id),
  child_id UUID NOT NULL REFERENCES categories(id)
);

DROP TABLE IF EXISTS products CASCADE;
CREATE TABLE products (
  id UUID NOT NULL DEFAULT uuid_generate_v5(uuid_ns_dns(), 'grokking.org.products'),
  seller_id UUID NOT NULL REFERENCES sellers(id),
  display_name TEXT NOT NULL,
  category_id UUID NOT NULL REFERENCES categories(id),
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS product_prices CASCADE;
CREATE TABLE product_prices (
  product_id UUID  NOT NULL REFERENCES products(id),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  discount_percentage SMALLINT NOT NULL CHECK(discount_percentage > 0),
  price_micros INTEGER NOT NULL CHECK(price_micros > 0),
  currency TEXT NOT NULL,
  PRIMARY KEY (product_id, created_at)
);

---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS couriers CASCADE;
CREATE TABLE couriers (
  id UUID NOT NULL DEFAULT uuid_generate_v5(uuid_ns_dns(), 'grokking.org.couriers'),
  name TEXT NOT NULL,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS courier_packages CASCADE;
CREATE TABLE courier_packages (
  courier_id UUID NOT NULL REFERENCES couriers(id),
  package_id TEXT NOT NULL,
  delivered_at TIMESTAMP WITH TIME ZONE,
  cost_micros INTEGER NOT NULL CHECK (cost_micros > 0),
  PRIMARY KEY (courier_id, package_id)
);

---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS orders CASCADE;
CREATE TABLE orders (
  id UUID NOT NULL DEFAULT uuid_generate_v5(uuid_ns_dns(), 'grokking.org.orders'),
  delivery_address UUID NOT NULL REFERENCES addresses(id),
  status TEXT NOT NULL CHECK (status IN ('placed', 'paid', 'shipped', 'delivered')),
  user_id UUID NOT NULL REFERENCES users(id),
  card_id UUID NOT NULL REFERENCES cards(id),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  courier_id UUID NOT NULL REFERENCES couriers(id),
  package_id TEXT NOT NULL,
  total_micros INTEGER NOT NULL, -- aggregated
  total_currency TEXT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (courier_id, package_id) REFERENCES courier_packages(courier_id, package_id),
  UNIQUE (courier_id, package_id)
);

DROP TABLE IF EXISTS order_items CASCADE;
CREATE TABLE order_items (
  product_id UUID NOT NULL,
  purchased_at TIMESTAMP WITH TIME ZONE NOT NULL,
  order_id UUID NOT NULL REFERENCES orders(id),
  PRIMARY KEY (product_id, order_id),
  FOREIGN KEY (product_id, purchased_at) REFERENCES product_prices(product_id, created_at)
);
