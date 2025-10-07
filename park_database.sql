drop database if exists park_database;
create database if not exists park_database;
use park_database;


CREATE TABLE employee_demographics (
    employee_id INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    phone_number VARCHAR(10),
    email VARCHAR(50) UNIQUE,
    birth_date DATE NOT NULL,
    hire_date DATE NOT NULL,
    termination_date DATE,
    employee_type VARCHAR(10) NOT NULL,
    location_id INT,
    supervisor_id INT,
    hourly_rate DECIMAL(10, 2), -- Force rounding to 2 decimals
    is_active BOOL DEFAULT TRUE,
    -- Keys
    PRIMARY KEY (employee_id),
    FOREIGN KEY (location_id) REFERENCES location(location_id),
    FOREIGN KEY (supervisor_id) REFERENCES employee_demographics(employee_id),
    -- Constraints
    CONSTRAINT chk_dates CHECK (termination_date IS NULL OR termination_date >= hire_date), -- force termination date to be not null for active employees, OR if terminated, the termination date must be after hire date
    CONSTRAINT chk_hire_age CHECK (hire_date >= DATE_ADD(birth_date, INTERVAL 16 YEAR)), -- force employeees to be at least 16 years old (no child labor allowed)
    CONSTRAINT chk_rate_positive CHECK (hourly_rate >= 0) -- force pay to not be negative 
);

    
CREATE TABLE location (
    location_id INT NOT NULL AUTO_INCREMENT,
    location_name VARCHAR(50) NOT NULL UNIQUE,
    summary VARCHAR(250),
    manager_id INT,
    manager_start DATE,
    -- keys
    PRIMARY KEY (location_id),
    FOREIGN KEY (manager_id)
        REFERENCES employee_demographics (employee_id)
        ON DELETE SET NULL -- if a manager is deleted, the manager id for the location is Null
    -- constraints
    CONSTRAINT chk_manager_logic CHECK (
        (manager_id IS NULL AND manager_start IS NULL) -- manager id cannot be null if there is a maanger start date
        OR 
        (manager_id IS NOT NULL AND manager_start IS NOT NULL) -- vice versa
    )
);


CREATE TABLE rides (
    ride_id INT NOT NULL,
    ride_name VARCHAR(20) NOT NULL,
    ride_type VARCHAR(10),
    ride_status VARCHAR(10),
    max_weight INT,
    min_height INT,
    capacity INT,
    location_id INT,
    PRIMARY KEY (ride_id),
    FOREIGN KEY (location_id)
        REFERENCES location (location_id)
);
    
    
CREATE TABLE maintenance (
    maintenance_id INT NOT NULL,
    ride_id INT,
    report_date DATE,
    start_date DATE,
    end_date DATE,
    summary VARCHAR(250),
    employee_id INT,
    cost FLOAT,
    ride_status VARCHAR(10),
    PRIMARY KEY (maintenance_id),
    FOREIGN KEY (ride_id)
        REFERENCES rides (ride_id),
    FOREIGN KEY (employee_id)
        REFERENCES employee_demographics (employee_id)
);


CREATE TABLE membership (
    membership_id INT NOT NULL,
    first_name VARCHAR(10),
    last_name VARCHAR(10),
    email VARCHAR(50) UNIQUE,
    phone_number VARCHAR(10),
    date_of_birth DATE,
    member_type VARCHAR(10),
    PRIMARY KEY (membership_id)
);


CREATE TABLE visits (
    visit_id INT NOT NULL,
    membership_id INT,
    visit_date DATETIME,
    exit_time TIME,
    ticket_type VARCHAR(10),
    ticket_price FLOAT,
    discount_amount FLOAT,
    membership_type VARCHAR(10),
    PRIMARY KEY (visit_id),
    FOREIGN KEY (membership_id)
        REFERENCES membership (membership_id)
);


CREATE TABLE weather_events (
    weather_id INT NOT NULL,
    event_date DATETIME,
    end_time DATETIME,
    weather_type VARCHAR(10),
    park_closure BOOL,
    PRIMARY KEY (weather_id)
);


CREATE TABLE event_promotions (
    event_id INT NOT NULL,
    event_name VARCHAR(20),
    event_type VARCHAR(10),
    start_date DATE,
    end_date DATE,
    discount_percent FLOAT,
    summary VARCHAR(250),
    PRIMARY KEY (event_id)
);


CREATE TABLE daily_stats (
    date_rec DATE NOT NULL,
    visitor_count INT,
    PRIMARY KEY (date_rec)
);


CREATE TABLE vendors (
    vendor_id INT NOT NULL,
    vendor_name VARCHAR(20),
    location_id INT,
    manager_id INT,
    PRIMARY KEY (vendor_id),
    FOREIGN KEY (location_id)
        REFERENCES location (location_id),
    FOREIGN KEY (manager_id)
        REFERENCES employee_demographics (employee_id)
);


CREATE TABLE item (
    item_id INT NOT NULL,
    item_type VARCHAR(20),
    item_name VARCHAR(20),
    price FLOAT,
    summary VARCHAR(250),
    PRIMARY KEY (item_id),
    CONSTRAINT chk_price_positive CHECK (price >= 0)
);


CREATE TABLE inventory (
    item_id INT NOT NULL,
    vendor_id INT NOT NULL,
    count INT,
    PRIMARY KEY (item_id , vendor_id),
    FOREIGN KEY (item_id)
        REFERENCES item (item_id),
    FOREIGN KEY (vendor_id)
        REFERENCES vendors (vendor_id),
    CONSTRAINT chk_count_positive CHECK (count >= 0)
);

CREATE TABLE daily_ride (
    ride_id INT NOT NULL,
    dat_date DATE NOT NULL,
    ride_count INT UNSIGNED DEFAULT 0,
    run_count INT UNSIGNED DEFAULT 0,
    --- keys
    PRIMARY KEY (ride_id , dat_date),
    FOREIGN KEY (ride_id) REFERENCES rides (ride_id),
    FOREIGN KEY (dat_date) REFERENCES daily_stats (date_rec)
    --- constraints
    CONSTRAINT chk_ride_count_positive CHECK (ride_count >= 0),
    CONSTRAINT chk_run_count_positive CHECK (run_count >= 0)
);


