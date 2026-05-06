CREATE SCHEMA IF NOT EXISTS source_data;
CREATE SCHEMA IF NOT EXISTS dest_db;

CREATE TABLE source_data.customers (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone_number VARCHAR(50),
    registration_date VARCHAR(50),
    status VARCHAR(20)
);

INSERT INTO source_data.customers (full_name, email, phone_number, registration_date, status) VALUES
('ahmet Yılmaz', 'ahmet.y@example.com', '555-1234567', '2023/10/01', 'ACTIVE'),
(' MEHMET  Kaya ', 'mehmet.k@ EXAmple.com', '+90 555 987 65 43', '01-11-2023', 'active'),
('Ayşe Demir', NULL, '05551112233', '2023-12-05', 'INACTIVE'),
('ahmet Yılmaz', 'ahmet.y@example.com', '555-1234567', '2023/10/01', 'ACTIVE'), 
('Fatma Sahin', 'fatmasahin@test.com', 'Bilinmiyor', '2024.01.15', 'pending'),
('Ali Can', 'ali.can@example', '555 444 33 22', '15/02/2024', 'ACT');
