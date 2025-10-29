USE park_database;

-- 1. LOCATION
-- Must be inserted first, as employees and vendors depend on it.
INSERT INTO location (location_name, summary, manager_id, manager_start) VALUES
('Frontierland', 'Wild West themed area', NULL, NULL),
('Tomorrowland', 'Futuristic sci-fi area', NULL, NULL),
('Fantasyland', 'Classic fairytale area', NULL, NULL),
('Park Entrance', 'Main entry plaza and guest services', NULL, NULL);

-- 2. EMPLOYEE_DEMOGRAPHICS
-- We insert employees, then we can update locations with manager_id
INSERT INTO employee_demographics 
(first_name, last_name, gender, phone_number, email, street_address, city, state, zip_code, birth_date, hire_date, employee_type, location_id, supervisor_id, hourly_rate, is_active)
VALUES
('Walt', 'Disney', 'Male', '(123) 456-7890', 'walt@park.com', '123 Main St', 'Orlando', 'FL', '32830', '1901-12-05', '2024-01-01', 'Admin', 4, NULL, 75.00, TRUE),
('Minnie', 'Mouse', 'Female', '(123) 456-7891', 'minnie@park.com', '124 Main St', 'Orlando', 'FL', '32830', '1928-11-18', '2024-01-15', 'Manager', 3, 1, 35.50, TRUE),
('Donald', 'Duck', 'Male', '(123) 456-7892', 'donald@park.com', '125 Main St', 'Orlando', 'FL', '32830', '1934-06-09', '2024-02-01', 'Staff', 1, 2, 18.00, TRUE),
('Daisy', 'Duck', 'Female', '(123) 456-7893', 'daisy@park.com', '126 Main St', 'Orlando', 'FL', '32830', '1940-01-07', '2024-02-15', 'Staff', 4, 1, 19.25, TRUE),
('Goofy', 'Goof', 'Male', '(123) 456-7894', 'goofy@park.com', '127 Main St', 'Orlando', 'FL', '32830', '1932-05-25', '2024-03-01', 'Maintenance', 2, 1, 28.00, TRUE);

-- Update locations with their new managers
UPDATE location SET manager_id = 2, manager_start = '2024-01-15' WHERE location_id = 3;
UPDATE location SET manager_id = 1, manager_start = '2024-01-01' WHERE location_id = 4;

-- 3. EMPLOYEE_AUTH
INSERT INTO employee_auth (employee_id, password_hash) VALUES
(1, '$2b$10$zKGpKcl0uHKA9Tg1GY8Jv.w8T0glQh/v7wFckZTjnyD0hSZJ/gkZu'),
(2, '$2b$10$zKGpKcl0uHKA9Tg1GY8Jv.w8T0glQh/v7wFckZTjnyD0hSZJ/gkZu'),
(3, '$2b$10$zKGpKcl0uHKA9Tg1GY8Jv.w8T0glQh/v7wFckZTjnyD0hSZJ/gkZu'),
(4, '$2b$10$zKGpKcl0uHKA9Tg1GY8Jv.w8T0glQh/v7wFckZTjnyD0hSZJ/gkZu'),
(5, '$2b$10$zKGpKcl0uHKA9Tg1GY8Jv.w8T0glQh/v7wFckZTjnyD0hSZJ/gkZu');

-- 4. RIDES
-- Depends on location
INSERT INTO rides (ride_name, ride_type, ride_status, max_weight, min_height, capacity, location_id) VALUES
('Space Mountain', 'Rollercoaster', 'OPEN', 300, 44, 12, 2),
('Jungle Cruise', 'Water Ride', 'OPEN', 1000, 0, 30, 1),
('Its a Small World', 'Water Ride', 'CLOSED', 1200, 0, 30, 3),
('Thunder Mountain', 'Rollercoaster', 'BROKEN', 300, 40, 30, 1);

-- 5. MAINTENANCE
-- Depends on rides and employees
INSERT INTO maintenance (ride_id, report_date, start_date, end_date, summary, employee_id, cost) VALUES
(4, '2025-10-20', '2025-10-21', NULL, 'Lift chain snapped on hill 2.', 5, NULL),
(3, '2025-10-15', '2025-10-16', '2025-10-18', 'Routine canal cleaning and audio check.', 5, 1500.00);

-- 6. MEMBERSHIP
INSERT INTO membership (first_name, last_name, email, phone_number, date_of_birth, member_type, start_date, end_date) VALUES
('Peter', 'Pan', 'peter@neverland.com', '(555) 123-4567', '1953-02-05', 'Platinum', '2024-05-01', '2025-05-01'),
('Alice', 'Wonder', 'alice@wonderland.com', '(555) 123-4568', '1951-07-26', 'Gold', '2024-06-15', '2025-06-15'),
('John', 'Doe', 'john@gmail.com', '(555) 123-4569', '1990-01-01', 'Individual', '2024-08-01', '2025-08-01');

-- 7. VISITS (HYPER-DETAILED SEASONAL DATA: ~10,000+ entries for Jan, Apr, Jul, Oct, Dec 2025)
-- ⚠️ WARNING: Running this block multiple times WILL duplicate data and break report accuracy.

-- Create a helper table to generate numbers 0 to 9999 for bulk date insertion
CREATE TEMPORARY TABLE IF NOT EXISTS helper_numbers (n INT);
INSERT INTO helper_numbers (n)
SELECT a.i + b.i * 10 + c.i * 100 + d.i * 1000
FROM 
    (SELECT 0 i UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a,
    (SELECT 0 i UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b,
    (SELECT 0 i UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c,
    (SELECT 0 i UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) d;

-- Low Season (Jan 2025 - Daily entries: 60-100)
INSERT INTO visits (membership_id, visit_date, exit_time, ticket_type, ticket_price, discount_amount)
SELECT 
    CASE WHEN FLOOR(RAND() * 10) < 4 THEN FLOOR(RAND() * 3) + 1 ELSE NULL END, 
    DATE_ADD(DATE_ADD('2025-01-01 09:00:00', INTERVAL FLOOR(n/75) DAY), INTERVAL (n % 75) * 8 MINUTE) AS calculated_entry_date,
    TIME(DATE_ADD(DATE_ADD(DATE_ADD('2025-01-01 09:00:00', INTERVAL FLOOR(n/75) DAY), INTERVAL (n % 75) * 8 MINUTE), INTERVAL (6 + FLOOR(RAND()*5)) HOUR)) AS calculated_exit_time, 
    CASE WHEN FLOOR(RAND() * 10) < 6 THEN 'Adult' WHEN FLOOR(RAND() * 10) < 9 THEN 'Child' ELSE 'Senior' END AS ticket_type,
    CASE WHEN FLOOR(RAND() * 10) < 6 THEN 109.00 WHEN FLOOR(RAND() * 10) < 9 THEN 99.00 ELSE 89.00 END AS ticket_price,
    0.00 AS discount_amount
FROM helper_numbers
WHERE n < (31 * 75) AND DATE(DATE_ADD('2025-01-01', INTERVAL FLOOR(n/75) DAY)) <= '2025-01-31';


-- Shoulder/Spike Season (Apr 2025 - Daily entries: 150-350)
INSERT INTO visits (membership_id, visit_date, exit_time, ticket_type, ticket_price, discount_amount)
SELECT 
    CASE WHEN FLOOR(RAND() * 10) < 5 THEN FLOOR(RAND() * 3) + 1 ELSE NULL END, -- 50% members
    DATE_ADD(DATE_ADD('2025-04-01 09:00:00', INTERVAL FLOOR(n/200) DAY), INTERVAL (n % 200) * 4 MINUTE) AS calculated_entry_date,
    TIME(DATE_ADD(DATE_ADD(DATE_ADD('2025-04-01 09:00:00', INTERVAL FLOOR(n/200) DAY), INTERVAL (n % 200) * 4 MINUTE), INTERVAL (7 + FLOOR(RAND()*4)) HOUR)) AS calculated_exit_time, 
    CASE WHEN FLOOR(RAND() * 10) < 6 THEN 'Adult' WHEN FLOOR(RAND() * 10) < 9 THEN 'Child' ELSE 'Senior' END AS ticket_type,
    119.00 AS ticket_price,
    0.00 AS discount_amount
FROM helper_numbers
WHERE n < (30 * 200) AND DATE(DATE_ADD('2025-04-01', INTERVAL FLOOR(n/200) DAY)) <= '2025-04-30';


-- Peak Season (Jul 2025 - Daily entries: 250-600)
INSERT INTO visits (membership_id, visit_date, exit_time, ticket_type, ticket_price, discount_amount)
SELECT 
    CASE WHEN FLOOR(RAND() * 10) < 3 THEN FLOOR(RAND() * 3) + 1 ELSE NULL END, -- 30% members
    DATE_ADD(DATE_ADD('2025-07-01 08:30:00', INTERVAL FLOOR(n/350) DAY), INTERVAL (n % 350) * 2 MINUTE) AS calculated_entry_date,
    TIME(DATE_ADD(DATE_ADD(DATE_ADD('2025-07-01 08:30:00', INTERVAL FLOOR(n/350) DAY), INTERVAL (n % 350) * 2 MINUTE), INTERVAL (7 + FLOOR(RAND()*4)) HOUR)) AS calculated_exit_time, 
    CASE WHEN FLOOR(RAND() * 10) < 7 THEN 'Adult' WHEN FLOOR(RAND() * 10) < 9 THEN 'Child' ELSE 'Senior' END AS ticket_type,
    129.00 AS ticket_price,
    0.00 AS discount_amount
FROM helper_numbers
WHERE n < (31 * 350) AND DATE(DATE_ADD('2025-07-01', INTERVAL FLOOR(n/350) DAY)) <= '2025-07-31';


-- Shoulder/Spike Season (Oct 2025 - Daily entries: 175-450)
INSERT INTO visits (membership_id, visit_date, exit_time, ticket_type, ticket_price, discount_amount)
SELECT 
    CASE WHEN FLOOR(RAND() * 10) < 5 THEN FLOOR(RAND() * 3) + 1 ELSE NULL END, -- 50% members
    DATE_ADD(DATE_ADD('2025-10-01 09:30:00', INTERVAL FLOOR(n/250) DAY), INTERVAL (n % 250) * 3 MINUTE) AS calculated_entry_date,
    TIME(DATE_ADD(DATE_ADD(DATE_ADD('2025-10-01 09:30:00', INTERVAL FLOOR(n/250) DAY), INTERVAL (n % 250) * 3 MINUTE), INTERVAL (5 + FLOOR(RAND()*6)) HOUR)) AS calculated_exit_time, 
    CASE WHEN FLOOR(RAND() * 10) < 6 THEN 'Adult' WHEN FLOOR(RAND() * 10) < 9 THEN 'Child' ELSE 'Senior' END AS ticket_type,
    119.00 AS ticket_price,
    0.00 AS discount_amount
FROM helper_numbers
WHERE n < (31 * 250) AND DATE(DATE_ADD('2025-10-01', INTERVAL FLOOR(n/250) DAY)) <= '2025-10-31';


-- Holiday Peak Season (Dec 2025 - Daily entries: 350-700)
INSERT INTO visits (membership_id, visit_date, exit_time, ticket_type, ticket_price, discount_amount)
SELECT 
    CASE WHEN FLOOR(RAND() * 10) < 4 THEN FLOOR(RAND() * 3) + 1 ELSE NULL END, 
    DATE_ADD(DATE_ADD('2025-12-01 09:00:00', INTERVAL FLOOR(n/400) DAY), INTERVAL (n % 400) * 2 MINUTE) AS calculated_entry_date,
    TIME(DATE_ADD(DATE_ADD(DATE_ADD('2025-12-01 09:00:00', INTERVAL FLOOR(n/400) DAY), INTERVAL (n % 400) * 2 MINUTE), INTERVAL (8 + FLOOR(RAND()*3)) HOUR)) AS calculated_exit_time, 
    CASE WHEN FLOOR(RAND() * 10) < 7 THEN 'Adult' WHEN FLOOR(RAND() * 10) < 9 THEN 'Child' ELSE 'Senior' END AS ticket_type,
    139.00 AS ticket_price,
    0.00 AS discount_amount
FROM helper_numbers
WHERE n < (31 * 400) AND DATE(DATE_ADD('2025-12-01', INTERVAL FLOOR(n/400) DAY)) <= '2025-12-31';


-- Clean up helper table
DROP TEMPORARY TABLE helper_numbers;


-- 10. DAILY_STATS (FULL YEAR DATA - Contains large variance for spike testing)
-- ⚠️ WARNING: Running this block multiple times WILL duplicate data.

INSERT INTO daily_stats (date_rec, visitor_count) VALUES
-- January 2025 (Low Season - Matches new low volume)
('2025-01-01', 3700), ('2025-01-02', 1850), ('2025-01-03', 1950), ('2025-01-04', 2800), ('2025-01-05', 2650), ('2025-01-06', 1800), ('2025-01-07', 1750), ('2025-01-08', 1700), ('2025-01-09', 1650), ('2025-01-10', 1850),
('2025-01-11', 2850), ('2025-01-12', 2750), ('2025-01-13', 1800), ('2025-01-14', 1750), ('2025-01-15', 1700), ('2025-01-16', 1650), ('2025-01-17', 1850), ('2025-01-18', 2900), ('2025-01-19', 2800),
('2025-01-20', 1850), ('2025-01-21', 1800), ('2025-01-22', 1750), ('2025-01-23', 1700), ('2025-01-24', 1900), ('2025-01-25', 2950), ('2025-01-26', 2850), ('2025-01-27', 1900), ('2025-01-28', 1850),
('2025-01-29', 1800), ('2025-01-30', 1750), ('2025-01-31', 1950),

-- February 2025 (Original Spikes Retained)
('2025-02-01', 2810), ('2025-02-02', 2720), ('2025-02-03', 1570), ('2025-02-04', 1530), ('2025-02-05', 1500), ('2025-02-06', 1470), ('2025-02-07', 1620), ('2025-02-08', 2950), ('2025-02-09', 2790),
('2025-02-10', 1600), ('2025-02-11', 1560), ('2025-02-12', 1510), ('2025-02-13', 1490), ('2025-02-14', 1850), 
('2025-02-15', 3000), ('2025-02-16', 2900), ('2025-02-17', 3100), 
('2025-02-18', 2000), ('2025-02-19', 1650), ('2025-02-20', 1620), ('2025-02-21', 1800), ('2025-02-22', 2980), ('2025-02-23', 2750), ('2025-02-24', 1630), ('2025-02-25', 1590), ('2025-02-26', 1540),
('2025-02-27', 1500), ('2025-02-28', 1670),

-- March 2025 (Shoulder Season Build-up)
('2025-03-01', 2820), ('2025-03-02', 2730), ('2025-03-03', 2000), ('2025-03-04', 1950), ('2025-03-05', 1900), ('2025-03-06', 1850), ('2025-03-07', 2100), ('2025-03-08', 3200), ('2025-03-09', 3100),
('2025-03-10', 2150), ('2025-03-11', 2100), ('2025-03-12', 2050), ('2025-03-13', 2000), ('2025-03-14', 2250), ('2025-03-15', 3600), ('2025-03-16', 3500), ('2025-03-17', 2800), 
('2025-03-18', 2700), ('2025-03-19', 2600), ('2025-03-20', 2550), ('2025-03-21', 2800), ('2025-03-22', 4000), ('2025-03-23', 3900), ('2025-03-24', 2900), ('2025-03-25', 2850), ('2025-03-26', 2800),
('2025-03-27', 2750), ('2025-03-28', 3000), ('2025-03-29', 4200), ('2025-03-30', 4100), ('2025-03-31', 3050),

-- April 2025 (Spring Break/Easter Peak)
('2025-04-01', 3500), ('2025-04-02', 3600), ('2025-04-03', 3700), ('2025-04-04', 5000), ('2025-04-05', 5200), ('2025-04-06', 5300), ('2025-04-07', 4500), ('2025-04-08', 4400), ('2025-04-09', 4300),
('2025-04-10', 4200), ('2025-04-11', 4500), ('2025-04-12', 5800), ('2025-04-13', 5900), ('2025-04-14', 4600), ('2025-04-15', 4500), ('2025-04-16', 4400), ('2025-04-17', 4300), ('2025-04-18', 6000), 
('2025-04-19', 6500), ('2025-04-20', 7000), -- Easter Peak
('2025-04-21', 5500), ('2025-04-22', 5400), ('2025-04-23', 5300), ('2025-04-24', 5200), ('2025-04-25', 5500), ('2025-04-26', 6800), ('2025-04-27', 6700), ('2025-04-28', 5600), ('2025-04-29', 5500),
('2025-04-30', 5400),

-- May 2025 (Transition to Peak)
('2025-05-01', 3900), ('2025-05-02', 4100), ('2025-05-03', 5200), ('2025-05-04', 5100), ('2025-05-05', 4000), ('2025-05-06', 3950), ('2025-05-07', 3900), ('2025-05-08', 3850), ('2025-05-09', 4050),
('2025-05-10', 5300), ('2025-05-11', 5600), 
('2025-05-12', 4300), ('2025-05-13', 4250), ('2025-05-14', 4200), ('2025-05-15', 4150), ('2025-05-16', 4400), ('2025-05-17', 5700), ('2025-05-18', 5600), ('2025-05-19', 4450), ('2025-05-20', 4400),
('2025-05-21', 4350), ('2025-05-22', 4300), ('2025-05-23', 4550), ('2025-05-24', 6000), ('2025-05-25', 6100), 
('2025-05-26', 6200), ('2025-05-27', 5000), ('2025-05-28', 4750), ('2025-05-29', 4700), ('2025-05-30', 4950), ('2025-05-31', 6500),

-- June 2025 (Peak Summer Season)
('2025-06-01', 6400), ('2025-06-02', 5500), ('2025-06-03', 5450), ('2025-06-04', 5400), ('2025-06-05', 5350), ('2025-06-06', 5600), ('2025-06-07', 7100), ('2025-06-08', 7000), ('2025-06-09', 5750),
('2025-06-10', 5700), ('2025-06-11', 5650), ('2025-06-12', 5600), ('2025-06-13', 5850), ('2025-06-14', 7300), ('2025-06-15', 7700), 
('2025-06-16', 6000), ('2025-06-17', 5950), ('2025-06-18', 5900), ('2025-06-19', 5850), ('2025-06-20', 6100), ('2025-06-21', 7500), ('2025-06-22', 7400), ('2025-06-23', 6050), ('2025-06-24', 6000),
('2025-06-25', 5950), ('2025-06-26', 5900), ('2025-06-27', 6150), ('2025-06-28', 7600), ('2025-06-29', 7500), ('2025-06-30', 6200),

-- July 2025 (Highest Peak Summer)
('2025-07-01', 6250), ('2025-07-02', 6300), ('2025-07-03', 7000), ('2025-07-04', 9500), 
('2025-07-05', 8500), ('2025-07-06', 8000), ('2025-07-07', 6500), ('2025-07-08', 6450), ('2025-07-09', 6400), ('2025-07-10', 6350), ('2025-07-11', 6600), ('2025-07-12', 7800), ('2025-07-13', 7700),
('2025-07-14', 6650), ('2025-07-15', 6600), ('2025-07-16', 6550), ('2025-07-17', 6500), ('2025-07-18', 6750), ('2025-07-19', 7900), ('2025-07-20', 7800), ('2025-07-21', 6700), ('2025-07-22', 6650),
('2025-07-23', 6600), ('2025-07-24', 6550), ('2025-07-25', 6800), ('2025-07-26', 8000), ('2025-07-27', 7900), ('2025-07-28', 6750), ('2025-07-29', 6700), ('2025-07-30', 6650), ('2025-07-31', 6600),

-- August 2025
('2025-08-01', 6850), ('2025-08-02', 8100), ('2025-08-03', 8000), ('2025-08-04', 6800), ('2025-08-05', 6750), ('2025-08-06', 6700), ('2025-08-07', 6650), ('2025-08-08', 6900), ('2025-08-09', 8200),
('2025-08-10', 8100), ('2025-08-11', 6850), ('2025-08-12', 6800), ('2025-08-13', 6750), ('2025-08-14', 6700), ('2025-08-15', 6950), ('2025-08-16', 8300), ('2025-08-17', 8200), ('2025-08-18', 6900),
('2025-08-19', 6850), ('2025-08-20', 6800), ('2025-08-21', 6750), ('2025-08-22', 7000), ('2025-08-23', 8400), ('2025-08-24', 8300), ('2025-08-25', 6950), ('2025-08-26', 6900), ('2025-08-27', 6850),
('2025-08-28', 6800), ('2025-08-29', 7050), ('2025-08-30', 8500), ('2025-08-31', 8400),

-- September 2025 (Shoulder Season)
('2025-09-01', 5500), 
('2025-09-02', 3500), ('2025-09-03', 3450), ('2025-09-04', 3400), ('2025-09-05', 3650), ('2025-09-06', 4900), ('2025-09-07', 4800), ('2025-09-08', 3700), ('2025-09-09', 3650), ('2025-09-10', 3600),
('2025-09-11', 3550), ('2025-09-12', 3800), ('2025-09-13', 5000), ('2025-09-14', 4900), ('2025-09-15', 3750), ('2025-09-16', 3700), ('2025-09-17', 3650), ('2025-09-18', 3600), ('2025-09-19', 3850),
('2025-09-20', 5100), ('2025-09-21', 5000), ('2025-09-22', 3800), ('2025-09-23', 3750), ('2025-09-24', 3700), ('2025-09-25', 3650), ('2025-09-26', 3900), ('2025-09-27', 5200), ('2025-09-28', 5100),
('2025-09-29', 3850), ('2025-09-30', 3800),

-- October 2025
('2025-10-01', 3750), ('2025-10-02', 3700), ('2025-10-03', 3950), ('2025-10-04', 5300), ('2025-10-05', 5200), ('2025-10-06', 4000), ('2025-10-07', 3950), ('2025-10-08', 3900), ('2025-10-09', 3850),
('2025-10-10', 4100), ('2025-10-11', 5400), ('2025-10-12', 5300), ('2025-10-13', 5000), 
('2025-10-14', 4200), ('2025-10-15', 4150), ('2025-10-16', 4100), ('2025-10-17', 4300), ('2025-10-18', 5600), ('2025-10-19', 5500), ('2025-10-20', 4500), 
('2025-10-21', 4350), ('2025-10-22', 4300), ('2025-10-23', 4250), ('2025-10-24', 4450), ('2025-10-25', 5800), ('2025-10-26', 5700), ('2025-10-27', 4550), ('2025-10-28', 4500), ('2025-10-29', 4450),
('2025-10-30', 4400), ('2025-10-31', 6500), 

-- November 2025 (Holiday Build-up)
('2025-11-01', 6400), ('2025-11-02', 6300), ('2025-11-03', 4700), ('2025-11-04', 4650), ('2025-11-05', 4600), ('2025-11-06', 4550), ('2025-11-07', 4800), ('2025-11-08', 6100), ('2025-11-09', 6000),
('2025-11-10', 4900), ('2025-11-11', 5100), 
('2025-11-12', 4850), ('2025-11-13', 4800), ('2025-11-14', 5050), ('2025-11-15', 6200), ('2025-11-16', 6100), ('2025-11-17', 5150), ('2025-11-18', 5100), ('2025-11-19', 5050), ('2025-11-20', 5300),
('2025-11-21', 5500), ('2025-11-22', 7000), ('2025-11-23', 7300), ('2025-11-24', 7500), ('2025-11-25', 7600), ('2025-11-26', 7700), ('2025-11-27', 3000), 
('2025-11-28', 8000), 
('2025-11-29', 7800), ('2025-11-30', 7500),

-- December 2025 (Peak Holiday Season)
('2025-12-01', 6000), ('2025-12-02', 5900), ('2025-12-03', 5800), ('2025-12-04', 5700), ('2025-12-05', 6000), ('2025-12-06', 7500), ('2025-12-07', 7400), ('2025-12-08', 6200), ('2025-12-09', 6100),
('2025-12-10', 6000), ('2025-12-11', 5900), ('2025-12-12', 6200), ('2025-12-13', 7600), ('2025-12-14', 7500), ('2025-12-15', 6300), ('2025-12-16', 6200), ('2025-12-17', 6100), ('2025-12-18', 6000),
('2025-12-19', 6300), ('2025-12-20', 7800), ('2025-12-21', 8200), ('2025-12-22', 8500), ('2025-12-23', 9000), ('2025-12-24', 8000), ('2025-12-25', 10500), 
('2025-12-26', 11000), ('2025-12-27', 11500), ('2025-12-28', 12000), ('2025-12-29', 12500), ('2025-12-30', 13000), ('2025-12-31', 14000);
-- 8. WEATHER_EVENTS
INSERT INTO weather_events (event_date, end_time, weather_type, park_closure) VALUES
('2025-07-15 14:30:00', '2025-07-15 15:15:00', 'Thunderstorm', TRUE),
('2025-10-19 12:00:00', '2025-10-19 14:00:00', 'Rain', FALSE);

-- 9. EVENT_PROMOTIONS
INSERT INTO event_promotions (event_name, event_type, start_date, end_date, discount_percent, summary) VALUES
('Halloween Spooktacular', 'Seasonal', '2025-10-01', '2025-10-31', 15.00, 'Discount on tickets after 4pm.'),
('Winter Wonderland', 'Holiday', '2025-12-01', '2026-01-05', 10.00, 'Holiday-themed event.');

-- 11. VENDORS
-- Depends on location and employees
INSERT INTO vendors (vendor_name, location_id, manager_id) VALUES
('Cosmic Rays Cafe', 2, 2),
('Pecos Bill Cantina', 1, 2),
('The Emporium', 4, 1);

-- 12. ITEM
INSERT INTO item (item_type, item_name, price, summary) VALUES
('Food', 'Cheeseburger', 12.99, '1/3 lb Angus Burger'),
('Food', 'Chicken Tenders', 11.99, '4 Tenders with Fries'),
('Apparel', 'Mickey T-Shirt', 29.99, '100% Cotton T-Shirt'),
('Souvenir', 'Mickey Ears', 24.99, 'Classic Mickey Mouse Ears');

-- 13. INVENTORY
-- Depends on item and vendors
INSERT INTO inventory (item_id, vendor_id, count) VALUES
(1, 1, 200),
(2, 1, 150),
(1, 2, 250),
(3, 3, 500),
(4, 3, 450);

-- 14. DAILY_RIDE
-- Depends on rides and daily_stats
INSERT INTO daily_ride (ride_id, dat_date, ride_count, run_count) VALUES
(1, '2025-10-20', 1200, 100),
(2, '2025-10-20', 900, 30),
(1, '2025-10-19', 1100, 95);

-- 15. EMPLOYEE_RIDE_ASSIGNMENTS
-- Depends on employees and rides
INSERT INTO employee_ride_assignments (employee_id, ride_id, assignment_date, role) VALUES
(3, 2, '2025-10-20', 'Operator'),
(4, 3, '2025-10-20', 'Attendant');
