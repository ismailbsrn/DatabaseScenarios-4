CREATE TABLE dest_db.customers (
    customer_key SERIAL PRIMARY KEY,
    source_id INT,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone_number VARCHAR(20),
    registration_date DATE,
    status VARCHAR(20),
    etl_load_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO dest_db.customers (source_id, full_name, email, phone_number, registration_date, status)
WITH DedupedCustomers AS (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY full_name, email ORDER BY id) as rn
    FROM source_data.customers
),
CleanedText AS (
    SELECT 
        id,
        INITCAP(TRIM(REGEXP_REPLACE(full_name, '\s+', ' ', 'g'))) as clean_name,
        COALESCE(LOWER(TRIM(REPLACE(email, ' ', ''))), 'unknown@domain.com') as clean_email,
        REGEXP_REPLACE(phone_number, '\D', '', 'g') as raw_phone,
        TRIM(registration_date) as raw_date,
        CASE 
            WHEN LOWER(status) IN ('active', 'act') THEN 'ACTIVE'
            WHEN LOWER(status) = 'inactive' THEN 'INACTIVE'
            ELSE 'PENDING'
        END as clean_status
    FROM DedupedCustomers
    WHERE rn = 1
),
FinalTransformation AS (
    SELECT 
        id,
        clean_name as full_name,
        clean_email as email,
        CASE 
            WHEN LENGTH(raw_phone) >= 10 THEN '+90' || RIGHT(raw_phone, 10)
            ELSE 'INVALID_PHONE'
        END as phone_number,
        CASE 
            WHEN raw_date ~ '^\d{4}[/.\-]\d{2}[/.\-]\d{2}$' 
                THEN TO_DATE(REPLACE(REPLACE(raw_date, '/', '-'), '.', '-'), 'YYYY-MM-DD')
            WHEN raw_date ~ '^\d{2}[/.\-]\d{2}[/.\-]\d{4}$' 
                THEN TO_DATE(REPLACE(REPLACE(raw_date, '/', '-'), '.', '-'), 'DD-MM-YYYY')
            ELSE NULL 
        END as registration_date,
        
        clean_status as status
    FROM CleanedText
)
SELECT * FROM FinalTransformation;
