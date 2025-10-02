drop database if exists park_database;
create database if not exists park_database;
use park_database;




CREATE table employee_demographics (
	employee_id INT NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(10),
    phone_number VARCHAR(10),
    email VARCHAR(50) unique,
    birth_date DATE,
    hire_date DATE,
    termination_date DATE,
    employee_type VARCHAR(10),
    location_id INT,
    supervisor_id INT,
    hourly_rate float,
    is_active Bool,
    primary key (employee_id)
    );
    
create table location(
location_id int not null,
location_name varchar(20),
summary varchar(250),
manager_id int,
manager_start date,
primary key (location_id),
foreign key (manager_id) references employee_demographics(employee_id)
); 



CREATE table rides (
ride_id INT NOT NULL,
ride_name VARCHAR(20),
ride_type VARCHAR(10),
ride_status VARCHAR(10),
max_weight INT,
min_height INT,
capacity INT,
location_id int,
-- daily_ride_count Gonna have to figure out the data type on this one. Might have to be its own table that uses a super key
primary key (ride_id),
foreign key (location_id) references location (location_id)
);   
    
    
CREATE table maintenance (
maintenance_id INT NOT NULL,
ride_id INT,
report_date DATE,
start_date DATE,
end_date DATE,
summary VARCHAR(250),
employee_id INT,
cost float,
ride_status VARCHAR(10),
primary key (maintenance_id),
foreign key (ride_id) references rides(ride_id),
foreign key (employee_id) references employee_demographics(employee_id)
);






create table membership (
	membership_id int not null,
	first_name varchar(10),
	last_name varchar(10),
	email varchar(50) unique,
    phone_number varchar(10),
	date_of_birth DATE,
	member_type varchar(10),
	primary key (membership_id)
);




Create table visits (
	visit_id int not null,
    membership_id int,
    visit_date DATETIME,
    exit_time TIME,
    ticket_type VARCHAR(10),
    ticket_price float,
    discount_amount float,
    membership_type varchar(10),
    primary key (visit_id),
    foreign key (membership_id) references membership (membership_id)
    );
    
    
    
    
    
create table weather_events (
weather_id int not null,
event_date DATETIME,
end_time DATETIME,
weather_type varchar(10),
park_closure bool,
primary key (weather_id)
);








create table event_promotions(
	event_id int not null,
    event_name varchar(20),
    event_type varchar(10),
    start_date date,
    end_date date,
    discount_percent float,
    summary varchar(250),
    primary key (event_id)
);








create table daily_stats(
	-- gotta figure out how to break this one down
    date_rec date not null,
    visitor_count int,
    primary key (date_rec)
    
);





create table vendors(
vendor_id int not null,
vendor_name varchar(20),
location_id int,
manager_id int,
-- inventory
primary key (vendor_id),
foreign key (location_id) references location(location_id),
foreign key (manager_id) references employee_demographics(employee_id)
);




create table item(
	item_id int not null,
    item_type varchar(20),
    item_name varchar(20),
    price float,
    summary varchar(250),
    primary key (item_id)
);



create table inventory(
	item_id int not null,
    vendor_id int not null,
    count int,
    primary key (item_id,vendor_id),
    foreign key (item_id) references item(item_id),
    foreign key (vendor_id) references vendors(vendor_id)
);

create table daily_ride(
	ride_id int not null,
    dat_date date not null,
    ride_count int,
    run_count int,
    primary key (ride_id,dat_date),
    foreign key (ride_id) references rides(ride_id),
    foreign key (dat_date) references daily_stats(date_rec)
);
    
    













