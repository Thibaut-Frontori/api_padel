BEGIN;

-- Drop tables if they exist
DROP TABLE IF EXISTS payment, reservation, court, club, location, weather, review, "user" CASCADE;

-- Users table
CREATE TABLE "user" (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) CHECK (role IN ('player', 'admin', 'manager')) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- Weather table
CREATE TABLE weather (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    condition VARCHAR(255) NOT NULL,
    wind VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- Location table
CREATE TABLE location (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    postal_code VARCHAR(255) CHECK (postal_code ~ '^[0-9]{4}0$') NOT NULL,
    latitude FLOAT NOT NULL,
    longitude FLOAT NOT NULL
);

-- Club table
CREATE TABLE club (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(255),
    email VARCHAR(255),
    website VARCHAR(255),
    location_id BIGINT NOT NULL REFERENCES location(id) ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- Courts table
CREATE TABLE court (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    indoor BOOLEAN NOT NULL,
    num_courts INTEGER NOT NULL,
    lights BOOLEAN NOT NULL,
    base_price DECIMAL(10,2) NOT NULL,
    weather_price DECIMAL(10,2) NOT NULL,
    weather_id BIGINT NOT NULL REFERENCES weather(id) ON DELETE CASCADE,
    club_id BIGINT NOT NULL REFERENCES club(id) ON DELETE CASCADE,
    user_id BIGINT NOT NULL REFERENCES "user"(id) ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- Reservations table
CREATE TABLE reservation (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    date_time TIMESTAMP NOT NULL,
    status VARCHAR(50) CHECK (status IN ('confirmed', 'cancelled', 'completed')) NOT NULL,
    user_id BIGINT NOT NULL REFERENCES "user"(id) ON DELETE CASCADE,
    court_id BIGINT NOT NULL REFERENCES court(id) ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- Payments table
CREATE TABLE payment (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    reservation_id BIGINT UNIQUE NOT NULL REFERENCES reservation(id) ON DELETE CASCADE,
    user_id BIGINT NOT NULL REFERENCES "user"(id) ON DELETE CASCADE,
    amount DECIMAL(10,2) NOT NULL,
    method VARCHAR(50) CHECK (method IN ('CB', 'PayPal', 'crypto')) NOT NULL,
    status VARCHAR(50) CHECK (status IN ('validated', 'pending', 'failed')) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- Reviews table
CREATE TABLE review (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    rating INTEGER CHECK (rating >= 0 AND rating <= 5) NOT NULL,
    comment VARCHAR(255) NOT NULL,
    user_id BIGINT NOT NULL REFERENCES "user"(id) ON DELETE CASCADE,
    club_id BIGINT NOT NULL REFERENCES club(id) ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

INSERT INTO "user" (name, email, password, role, created_at)
VALUES 
  ('User1', 'user1@example.com', 'hashed_pwd_1', 'player', CURRENT_TIMESTAMP),
  ('User2', 'user2@example.com', 'hashed_pwd_2', 'manager', CURRENT_TIMESTAMP),
  ('User3', 'user3@example.com', 'hashed_pwd_3', 'admin', CURRENT_TIMESTAMP),
  ('User4', 'user4@example.com', 'hashed_pwd_4', 'player', CURRENT_TIMESTAMP),
  ('User5', 'user5@example.com', 'hashed_pwd_5', 'player', CURRENT_TIMESTAMP);


INSERT INTO location (name, address, city, postal_code, latitude, longitude)
VALUES
  ('Loc A', '1 Rue A', 'Paris', '75010', 48.86, 2.35),
  ('Loc B', '2 Rue B', 'Lyon', '69000', 45.75, 4.85),
  ('Loc C', '3 Rue C', 'Nice', '06000', 43.70, 7.26),
  ('Loc D', '4 Rue D', 'Bordeaux', '33000', 44.84, -0.57),
  ('Loc E', '5 Rue E', 'Lille', '59000', 50.63, 3.06);

INSERT INTO weather (condition, wind, created_at)
VALUES
  ('Sunny', 'Low', CURRENT_TIMESTAMP),
  ('Rainy', 'High', CURRENT_TIMESTAMP),
  ('Windy', 'Medium', CURRENT_TIMESTAMP),
  ('Cloudy', 'Low', CURRENT_TIMESTAMP),
  ('Stormy', 'High', CURRENT_TIMESTAMP);

INSERT INTO club (name, phone, email, website, location_id, created_at)
VALUES
  ('Club A', '0101010101', 'a@club.com', 'www.clubA.com', 1, CURRENT_TIMESTAMP),
  ('Club B', '0202020202', 'b@club.com', 'www.clubB.com', 2, CURRENT_TIMESTAMP),
  ('Club C', '0303030303', 'c@club.com', 'www.clubC.com', 3, CURRENT_TIMESTAMP),
  ('Club D', '0404040404', 'd@club.com', 'www.clubD.com', 4, CURRENT_TIMESTAMP),
  ('Club E', '0505050505', 'e@club.com', 'www.clubE.com', 5, CURRENT_TIMESTAMP);

INSERT INTO court (name, indoor, num_courts, lights, base_price, weather_price, weather_id, club_id, user_id, created_at)
VALUES
  ('Court A', TRUE, 2, TRUE, 25.00, 20.00, 1, 1, 1, CURRENT_TIMESTAMP),
  ('Court B', FALSE, 3, FALSE, 22.00, 18.00, 2, 2, 2, CURRENT_TIMESTAMP),
  ('Court C', TRUE, 1, TRUE, 30.00, 24.00, 3, 3, 3, CURRENT_TIMESTAMP),
  ('Court D', FALSE, 2, TRUE, 28.00, 23.00, 4, 4, 4, CURRENT_TIMESTAMP),
  ('Court E', TRUE, 4, FALSE, 26.00, 21.00, 5, 5, 5, CURRENT_TIMESTAMP);

INSERT INTO reservation (date_time, status, user_id, court_id, created_at)
VALUES
  (CURRENT_TIMESTAMP, 'confirmed', 1, 1, CURRENT_TIMESTAMP),
  (CURRENT_TIMESTAMP, 'cancelled', 2, 2, CURRENT_TIMESTAMP),
  (CURRENT_TIMESTAMP, 'completed', 3, 3, CURRENT_TIMESTAMP),
  (CURRENT_TIMESTAMP, 'confirmed', 4, 4, CURRENT_TIMESTAMP),
  (CURRENT_TIMESTAMP, 'confirmed', 5, 5, CURRENT_TIMESTAMP);

INSERT INTO payment (reservation_id, user_id, amount, method, status, created_at)
VALUES
  (1, 1, 25.00, 'CB', 'validated', CURRENT_TIMESTAMP),
  (2, 2, 22.00, 'PayPal', 'validated', CURRENT_TIMESTAMP),
  (3, 3, 30.00, 'crypto', 'pending', CURRENT_TIMESTAMP),
  (4, 4, 28.00, 'CB', 'validated', CURRENT_TIMESTAMP),
  (5, 5, 26.00, 'PayPal', 'failed', CURRENT_TIMESTAMP);

INSERT INTO review (rating, comment, user_id, club_id, created_at)
VALUES
  (5, 'Excellent club!', 1, 1, CURRENT_TIMESTAMP),
  (4, 'Très bon terrain', 2, 2, CURRENT_TIMESTAMP),
  (3, 'Correct', 3, 3, CURRENT_TIMESTAMP),
  (5, 'Super ambiance !', 4, 4, CURRENT_TIMESTAMP),
  (2, 'Peut mieux faire', 5, 5, CURRENT_TIMESTAMP);

COMMIT;
