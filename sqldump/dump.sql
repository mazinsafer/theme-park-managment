/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-12.0.2-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: park_database
-- ------------------------------------------------------
-- Server version	12.0.2-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Current Database: `park_database`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `park_database` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

USE `park_database`;

--
-- Table structure for table `daily_ride`
--

DROP TABLE IF EXISTS `daily_ride`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `daily_ride` (
  `ride_id` int(11) NOT NULL,
  `dat_date` date NOT NULL,
  `ride_count` int(10) unsigned DEFAULT 0,
  `run_count` int(10) unsigned DEFAULT 0,
  PRIMARY KEY (`ride_id`,`dat_date`),
  KEY `dat_date` (`dat_date`),
  CONSTRAINT `daily_ride_ibfk_1` FOREIGN KEY (`ride_id`) REFERENCES `rides` (`ride_id`),
  CONSTRAINT `daily_ride_ibfk_2` FOREIGN KEY (`dat_date`) REFERENCES `daily_stats` (`date_rec`),
  CONSTRAINT `chk_ride_count_positive` CHECK (`ride_count` >= 0),
  CONSTRAINT `chk_run_count_positive` CHECK (`run_count` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `daily_ride`
--

LOCK TABLES `daily_ride` WRITE;
/*!40000 ALTER TABLE `daily_ride` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `daily_ride` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `daily_stats`
--

DROP TABLE IF EXISTS `daily_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `daily_stats` (
  `date_rec` date NOT NULL,
  `visitor_count` int(11) DEFAULT NULL,
  PRIMARY KEY (`date_rec`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `daily_stats`
--

LOCK TABLES `daily_stats` WRITE;
/*!40000 ALTER TABLE `daily_stats` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `daily_stats` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `employee_demographics`
--

DROP TABLE IF EXISTS `employee_demographics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_demographics` (
  `employee_id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `gender` enum('Male','Female','Other') NOT NULL,
  `phone_number` varchar(10) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `birth_date` date NOT NULL,
  `hire_date` date NOT NULL,
  `termination_date` date DEFAULT NULL,
  `employee_type` varchar(10) NOT NULL,
  `location_id` int(11) DEFAULT NULL,
  `supervisor_id` int(11) DEFAULT NULL,
  `hourly_rate` decimal(10,2) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`employee_id`),
  UNIQUE KEY `email` (`email`),
  KEY `supervisor_id` (`supervisor_id`),
  KEY `location_id` (`location_id`),
  CONSTRAINT `employee_demographics_ibfk_1` FOREIGN KEY (`supervisor_id`) REFERENCES `employee_demographics` (`employee_id`),
  CONSTRAINT `employee_demographics_ibfk_2` FOREIGN KEY (`location_id`) REFERENCES `location` (`location_id`),
  CONSTRAINT `chk_dates` CHECK (`termination_date` is null or `termination_date` >= `hire_date`),
  CONSTRAINT `chk_hire_age` CHECK (`hire_date` >= `birth_date` + interval 16 year),
  CONSTRAINT `chk_rate_positive` CHECK (`hourly_rate` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_demographics`
--

LOCK TABLES `employee_demographics` WRITE;
/*!40000 ALTER TABLE `employee_demographics` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `employee_demographics` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `event_promotions`
--

DROP TABLE IF EXISTS `event_promotions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `event_promotions` (
  `event_id` int(11) NOT NULL,
  `event_name` varchar(20) DEFAULT NULL,
  `event_type` varchar(10) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `discount_percent` decimal(10,2) DEFAULT NULL,
  `summary` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event_promotions`
--

LOCK TABLES `event_promotions` WRITE;
/*!40000 ALTER TABLE `event_promotions` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `event_promotions` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory` (
  `item_id` int(11) NOT NULL,
  `vendor_id` int(11) NOT NULL,
  `count` int(11) DEFAULT NULL,
  PRIMARY KEY (`item_id`,`vendor_id`),
  KEY `vendor_id` (`vendor_id`),
  CONSTRAINT `inventory_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `item` (`item_id`),
  CONSTRAINT `inventory_ibfk_2` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`vendor_id`),
  CONSTRAINT `chk_count_positive` CHECK (`count` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `inventory` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `item`
--

DROP TABLE IF EXISTS `item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `item` (
  `item_id` int(11) NOT NULL,
  `item_type` varchar(20) DEFAULT NULL,
  `item_name` varchar(20) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `summary` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`item_id`),
  CONSTRAINT `chk_price_positive` CHECK (`price` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item`
--

LOCK TABLES `item` WRITE;
/*!40000 ALTER TABLE `item` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `item` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `location`
--

DROP TABLE IF EXISTS `location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `location` (
  `location_id` int(11) NOT NULL AUTO_INCREMENT,
  `location_name` varchar(50) NOT NULL,
  `summary` varchar(250) DEFAULT NULL,
  `manager_id` int(11) DEFAULT NULL,
  `manager_start` date DEFAULT NULL,
  PRIMARY KEY (`location_id`),
  UNIQUE KEY `location_name` (`location_name`),
  KEY `manager_id` (`manager_id`),
  CONSTRAINT `location_ibfk_1` FOREIGN KEY (`manager_id`) REFERENCES `employee_demographics` (`employee_id`),
  CONSTRAINT `chk_manager_logic` CHECK (`manager_id` is null and `manager_start` is null or `manager_id` is not null and `manager_start` is not null)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `location`
--

LOCK TABLES `location` WRITE;
/*!40000 ALTER TABLE `location` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `location` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `maintenance`
--

DROP TABLE IF EXISTS `maintenance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintenance` (
  `maintenance_id` int(11) NOT NULL,
  `ride_id` int(11) DEFAULT NULL,
  `report_date` date DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `summary` varchar(250) DEFAULT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `cost` decimal(10,2) DEFAULT NULL,
  `ride_status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`maintenance_id`),
  KEY `ride_id` (`ride_id`),
  KEY `employee_id` (`employee_id`),
  CONSTRAINT `maintenance_ibfk_1` FOREIGN KEY (`ride_id`) REFERENCES `rides` (`ride_id`),
  CONSTRAINT `maintenance_ibfk_2` FOREIGN KEY (`employee_id`) REFERENCES `employee_demographics` (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maintenance`
--

LOCK TABLES `maintenance` WRITE;
/*!40000 ALTER TABLE `maintenance` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `maintenance` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `membership`
--

DROP TABLE IF EXISTS `membership`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `membership` (
  `membership_id` int(11) NOT NULL,
  `first_name` varchar(10) DEFAULT NULL,
  `last_name` varchar(10) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `phone_number` varchar(10) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `member_type` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`membership_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `membership`
--

LOCK TABLES `membership` WRITE;
/*!40000 ALTER TABLE `membership` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `membership` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `rides`
--

DROP TABLE IF EXISTS `rides`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `rides` (
  `ride_id` int(11) NOT NULL,
  `ride_name` varchar(20) NOT NULL,
  `ride_type` varchar(10) DEFAULT NULL,
  `ride_status` enum('OPEN','CLOSED','BROKEN') DEFAULT NULL,
  `max_weight` int(11) DEFAULT NULL,
  `min_height` int(11) DEFAULT NULL,
  `capacity` int(11) DEFAULT NULL,
  `location_id` int(11) NOT NULL,
  PRIMARY KEY (`ride_id`),
  KEY `location_id` (`location_id`),
  CONSTRAINT `rides_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `location` (`location_id`),
  CONSTRAINT `chk_weight` CHECK (`max_weight` >= 0),
  CONSTRAINT `chk_height` CHECK (`min_height` >= 0),
  CONSTRAINT `chk_capacity` CHECK (`capacity` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rides`
--

LOCK TABLES `rides` WRITE;
/*!40000 ALTER TABLE `rides` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `rides` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `vendors`
--

DROP TABLE IF EXISTS `vendors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `vendors` (
  `vendor_id` int(11) NOT NULL AUTO_INCREMENT,
  `vendor_name` varchar(100) NOT NULL,
  `location_id` int(11) DEFAULT NULL,
  `manager_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`vendor_id`),
  UNIQUE KEY `vendor_name` (`vendor_name`),
  KEY `location_id` (`location_id`),
  KEY `manager_id` (`manager_id`),
  CONSTRAINT `vendors_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `location` (`location_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `vendors_ibfk_2` FOREIGN KEY (`manager_id`) REFERENCES `employee_demographics` (`employee_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vendors`
--

LOCK TABLES `vendors` WRITE;
/*!40000 ALTER TABLE `vendors` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `vendors` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `visits`
--

DROP TABLE IF EXISTS `visits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `visits` (
  `visit_id` int(11) NOT NULL,
  `membership_id` int(11) DEFAULT NULL,
  `visit_date` datetime DEFAULT NULL,
  `exit_time` time DEFAULT NULL,
  `ticket_type` varchar(10) DEFAULT NULL,
  `ticket_price` decimal(10,2) DEFAULT NULL,
  `discount_amount` decimal(10,2) DEFAULT NULL,
  `membership_type` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`visit_id`),
  KEY `membership_id` (`membership_id`),
  CONSTRAINT `visits_ibfk_1` FOREIGN KEY (`membership_id`) REFERENCES `membership` (`membership_id`),
  CONSTRAINT `chk_positive_prices` CHECK (`ticket_price` >= 0 and `discount_amount` >= 0),
  CONSTRAINT `chk_valid_discount` CHECK (`discount_amount` <= `ticket_price`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visits`
--

LOCK TABLES `visits` WRITE;
/*!40000 ALTER TABLE `visits` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `visits` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `weather_events`
--

DROP TABLE IF EXISTS `weather_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `weather_events` (
  `weather_id` int(11) NOT NULL,
  `event_date` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `weather_type` varchar(10) DEFAULT NULL,
  `park_closure` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`weather_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `weather_events`
--

LOCK TABLES `weather_events` WRITE;
/*!40000 ALTER TABLE `weather_events` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `weather_events` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-10-07 16:56:27
