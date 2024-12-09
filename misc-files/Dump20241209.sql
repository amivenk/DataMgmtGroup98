CREATE DATABASE  IF NOT EXISTS `trainsdb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `trainsdb`;
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: trainsdb
-- ------------------------------------------------------
-- Server version	8.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `email` varchar(50) DEFAULT NULL,
  `fname` varchar(20) DEFAULT NULL,
  `lname` varchar(30) DEFAULT NULL,
  `username` varchar(32) NOT NULL,
  `password` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES ('bcm129@rutgers.edu','Bryan','Mulholland','brymul','12345'),('js123@rutgers.edu','John','Smith','johnsmith','1234'),('mrbeasttt','Mister','Beast','mrbeast2','123');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee` (
  `ssn` int NOT NULL,
  `fname` varchar(20) DEFAULT NULL,
  `lname` varchar(30) DEFAULT NULL,
  `username` varchar(32) DEFAULT NULL,
  `password` varchar(30) DEFAULT NULL,
  `type` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`ssn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES (1010,'Jimmy','Beast','mrbeast','1234','customerRep'),(111111111,'admin','user','admin','1234','admin');
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `question`
--

DROP TABLE IF EXISTS `question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `question` (
  `username` varchar(32) DEFAULT NULL,
  `txt` varchar(250) DEFAULT NULL,
  `qid` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`qid`),
  KEY `username` (`username`),
  CONSTRAINT `question_ibfk_1` FOREIGN KEY (`username`) REFERENCES `customer` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `question`
--

LOCK TABLES `question` WRITE;
/*!40000 ALTER TABLE `question` DISABLE KEYS */;
/*!40000 ALTER TABLE `question` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reply`
--

DROP TABLE IF EXISTS `reply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reply` (
  `txt` varchar(250) DEFAULT NULL,
  `ssn` int DEFAULT NULL,
  `qid` int DEFAULT NULL,
  `rid` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`rid`),
  KEY `ssn` (`ssn`),
  KEY `qid` (`qid`),
  CONSTRAINT `reply_ibfk_3` FOREIGN KEY (`ssn`) REFERENCES `employee` (`ssn`),
  CONSTRAINT `reply_ibfk_4` FOREIGN KEY (`qid`) REFERENCES `question` (`qid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reply`
--

LOCK TABLES `reply` WRITE;
/*!40000 ALTER TABLE `reply` DISABLE KEYS */;
/*!40000 ALTER TABLE `reply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservation`
--

DROP TABLE IF EXISTS `reservation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservation` (
  `passenger` varchar(20) DEFAULT NULL,
  `total` float DEFAULT NULL,
  `type` varchar(10) DEFAULT NULL,
  `username` varchar(32) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `resnum` int NOT NULL AUTO_INCREMENT,
  `scid` int DEFAULT NULL,
  `originst` int DEFAULT NULL,
  `destst` int DEFAULT NULL,
  PRIMARY KEY (`resnum`),
  KEY `username` (`username`),
  KEY `scid` (`scid`),
  KEY `originst` (`originst`),
  KEY `destst` (`destst`),
  CONSTRAINT `reservation_ibfk_1` FOREIGN KEY (`username`) REFERENCES `customer` (`username`),
  CONSTRAINT `reservation_ibfk_2` FOREIGN KEY (`scid`) REFERENCES `stopsat` (`scid`),
  CONSTRAINT `reservation_ibfk_3` FOREIGN KEY (`originst`) REFERENCES `stopsat` (`sid`),
  CONSTRAINT `reservation_ibfk_4` FOREIGN KEY (`destst`) REFERENCES `stopsat` (`sid`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservation`
--

LOCK TABLES `reservation` WRITE;
/*!40000 ALTER TABLE `reservation` DISABLE KEYS */;
INSERT INTO `reservation` VALUES ('Bryan',106.67,'Round Trip','brymul','2024-12-03',7,2,4,1);
/*!40000 ALTER TABLE `reservation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedule`
--

DROP TABLE IF EXISTS `schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedule` (
  `linename` varchar(50) DEFAULT NULL,
  `departure` datetime DEFAULT NULL,
  `arrival` datetime DEFAULT NULL,
  `travel` int DEFAULT NULL,
  `origin` varchar(50) DEFAULT NULL,
  `dest` varchar(50) DEFAULT NULL,
  `scid` int NOT NULL AUTO_INCREMENT,
  `tid` int DEFAULT NULL,
  `fare` float DEFAULT NULL,
  PRIMARY KEY (`scid`),
  KEY `tid` (`tid`),
  CONSTRAINT `schedule_ibfk_1` FOREIGN KEY (`tid`) REFERENCES `train` (`tid`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule`
--

LOCK TABLES `schedule` WRITE;
/*!40000 ALTER TABLE `schedule` DISABLE KEYS */;
INSERT INTO `schedule` VALUES ('Northeast Corridor','2024-12-03 05:15:00','2024-12-03 06:35:00',90,'Trenton Station','Penn Station',2,1001,100),('Northeast Corridor','2024-12-07 08:28:00','2024-12-07 10:28:00',120,'Penn Station','Trenton Station',3,1001,150);
/*!40000 ALTER TABLE `schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `station`
--

DROP TABLE IF EXISTS `station`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `station` (
  `name` varchar(50) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `state` char(2) DEFAULT NULL,
  `sid` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sid`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `station`
--

LOCK TABLES `station` WRITE;
/*!40000 ALTER TABLE `station` DISABLE KEYS */;
INSERT INTO `station` VALUES ('Penn Station','New York City','NY',1),('New Brunswick Station','New Brunswick','NJ',2),('Trenton Station','Trenton','NJ',3),('Metuchen Station','Metuchen','NJ',4),('Edison Station','Edison','NJ',5);
/*!40000 ALTER TABLE `station` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stopsat`
--

DROP TABLE IF EXISTS `stopsat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stopsat` (
  `scid` int NOT NULL,
  `sid` int NOT NULL,
  `departure` datetime DEFAULT NULL,
  `arrival` datetime DEFAULT NULL,
  PRIMARY KEY (`scid`,`sid`),
  KEY `sid` (`sid`),
  CONSTRAINT `stopsat_ibfk_3` FOREIGN KEY (`scid`) REFERENCES `schedule` (`scid`),
  CONSTRAINT `stopsat_ibfk_4` FOREIGN KEY (`sid`) REFERENCES `station` (`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stopsat`
--

LOCK TABLES `stopsat` WRITE;
/*!40000 ALTER TABLE `stopsat` DISABLE KEYS */;
INSERT INTO `stopsat` VALUES (2,1,NULL,'2024-12-03 06:35:00'),(2,3,'2024-12-03 05:00:00',NULL),(2,4,'2024-12-03 05:45:00','2024-12-03 05:47:00'),(3,2,'2024-12-04 09:22:00','2024-12-04 09:20:00'),(3,3,NULL,'2024-12-04 10:58:00'),(3,4,'2024-12-04 09:00:00','2024-12-04 08:58:00');
/*!40000 ALTER TABLE `stopsat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `train`
--

DROP TABLE IF EXISTS `train`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `train` (
  `tid` int NOT NULL,
  `scid` int DEFAULT NULL,
  PRIMARY KEY (`tid`),
  KEY `scid` (`scid`),
  CONSTRAINT `train_ibfk_1` FOREIGN KEY (`scid`) REFERENCES `schedule` (`scid`),
  CONSTRAINT `train_chk_1` CHECK (((`tid` >= 1000) and (`tid` <= 9999)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `train`
--

LOCK TABLES `train` WRITE;
/*!40000 ALTER TABLE `train` DISABLE KEYS */;
INSERT INTO `train` VALUES (1000,NULL),(1001,2);
/*!40000 ALTER TABLE `train` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-09 16:38:16
