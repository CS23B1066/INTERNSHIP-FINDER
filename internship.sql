-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: internship
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `applications`
--

DROP TABLE IF EXISTS `applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `applications` (
  `application_id` int NOT NULL AUTO_INCREMENT,
  `internship_id` int DEFAULT NULL,
  `student_id` int DEFAULT NULL,
  `applied_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`application_id`),
  KEY `new_forn` (`internship_id`),
  KEY `app_frng` (`student_id`),
  CONSTRAINT `app_frng` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `new_forn` FOREIGN KEY (`internship_id`) REFERENCES `internships` (`internship_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications`
--

LOCK TABLES `applications` WRITE;
/*!40000 ALTER TABLE `applications` DISABLE KEYS */;
INSERT INTO `applications` VALUES (1,1,1,'2025-03-26 17:50:16'),(2,2,2,'2025-03-26 17:50:16'),(3,3,1,'2025-03-26 17:50:16'),(5,7,8,'2025-04-05 15:10:58');
/*!40000 ALTER TABLE `applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company_skills`
--

DROP TABLE IF EXISTS `company_skills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company_skills` (
  `NUMBER` int NOT NULL AUTO_INCREMENT,
  `skill_id` int DEFAULT NULL,
  `internship_id` int DEFAULT NULL,
  PRIMARY KEY (`NUMBER`),
  KEY `skill_id` (`skill_id`),
  KEY `internship_id` (`internship_id`),
  CONSTRAINT `company_skills_ibfk_1` FOREIGN KEY (`skill_id`) REFERENCES `skills` (`skill_id`),
  CONSTRAINT `company_skills_ibfk_2` FOREIGN KEY (`internship_id`) REFERENCES `internships` (`internship_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_skills`
--

LOCK TABLES `company_skills` WRITE;
/*!40000 ALTER TABLE `company_skills` DISABLE KEYS */;
INSERT INTO `company_skills` VALUES (1,7,7);
/*!40000 ALTER TABLE `company_skills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `education`
--

DROP TABLE IF EXISTS `education`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `education` (
  `education_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `degree` varchar(100) DEFAULT NULL,
  `university` varchar(255) DEFAULT NULL,
  `graduation_year` int DEFAULT NULL,
  PRIMARY KEY (`education_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `education_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `education`
--

LOCK TABLES `education` WRITE;
/*!40000 ALTER TABLE `education` DISABLE KEYS */;
INSERT INTO `education` VALUES (1,1,'B.Tech Computer Science','ABC University',2025),(2,2,'B.Sc Data Science','XYZ University',2024),(15,8,'btech','xyza',2028);
/*!40000 ALTER TABLE `education` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `internships`
--

DROP TABLE IF EXISTS `internships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `internships` (
  `internship_id` int NOT NULL AUTO_INCREMENT,
  `company_id` int DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text,
  `skill_required` varchar(255) DEFAULT NULL,
  `stipend` decimal(10,2) DEFAULT NULL,
  `duration` int DEFAULT NULL,
  `posted_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`internship_id`),
  KEY `company_id` (`company_id`),
  CONSTRAINT `internships_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `internships`
--

LOCK TABLES `internships` WRITE;
/*!40000 ALTER TABLE `internships` DISABLE KEYS */;
INSERT INTO `internships` VALUES (1,3,'Software Developer Intern','Work on exciting projects','Python, Flask, MySQL',5000.00,6,'2025-03-26 17:49:30'),(2,4,'Data Science Intern','Analyze real-world data','Python, Machine Learning, SQL',7000.00,3,'2025-03-26 17:49:30'),(3,3,'Web Developer Intern','Build front-end interfaces','HTML, CSS, JavaScript',4500.00,4,'2025-03-26 17:49:30'),(4,2,'ml Intern','ml expert','Ml',7000.00,2,'2025-03-26 19:05:29'),(7,10,'ml Intern','new','CSS',3000.00,5,'2025-04-04 07:06:31');
/*!40000 ALTER TABLE `internships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `skills`
--

DROP TABLE IF EXISTS `skills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `skills` (
  `skill_id` int NOT NULL AUTO_INCREMENT,
  `skill_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`skill_id`),
  UNIQUE KEY `skill_name` (`skill_name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skills`
--

LOCK TABLES `skills` WRITE;
/*!40000 ALTER TABLE `skills` DISABLE KEYS */;
INSERT INTO `skills` VALUES (7,'CSS'),(2,'Flask'),(6,'HTML'),(5,'JavaScript'),(4,'Machine Learning'),(1,'Python'),(3,'SQL');
/*!40000 ALTER TABLE `skills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_skills`
--

DROP TABLE IF EXISTS `user_skills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_skills` (
  `user_id` int NOT NULL,
  `skill_id` int NOT NULL,
  PRIMARY KEY (`user_id`,`skill_id`),
  KEY `skill_id` (`skill_id`),
  CONSTRAINT `user_skills_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `user_skills_ibfk_2` FOREIGN KEY (`skill_id`) REFERENCES `skills` (`skill_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_skills`
--

LOCK TABLES `user_skills` WRITE;
/*!40000 ALTER TABLE `user_skills` DISABLE KEYS */;
INSERT INTO `user_skills` VALUES (8,1),(8,2),(8,3),(8,4),(8,6),(8,7);
/*!40000 ALTER TABLE `user_skills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `user_type` enum('student','company') DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Alice Johnson','alice@example.com','password123','student','2025-03-26 17:48:50'),(2,'Bob Smith','bob@example.com','password456','student','2025-03-26 17:48:50'),(3,'TechCorp Ltd.','hr@techcorp.com','securepass','company','2025-03-26 17:48:50'),(4,'Innovate Solutions','careers@innovate.com','innovate123','company','2025-03-26 17:48:50'),(5,'aqeel','aqeel@gmail.com','123@','student','2025-03-27 09:00:31'),(8,'test','test@gmail.com','scrypt:32768:8:1$Ee8Fnbk4mGAQRuWh$f08d1834e8ceaea9cdf35e3247eb2435cc64e81947e8e61c172d30f8e0a60dc97a8f979c80c538a570f2f6827684476153a1f4eb2d7627b509fe7ed63dac857a','student','2025-03-27 09:22:14'),(9,'company','company@gmail.com','scrypt:32768:8:1$KjtSkvvpkbSrJBSZ$a29be7d8197ad4e44a59ae09ab29099ceeed09daf5acbba668bb8b5ab2d160be2d81b57ab0a9123128a0c769ddeebdd89d84eb5d4197c28026c7469944c1a70a','company','2025-03-28 18:50:08'),(10,'c1','c1@gmail.com','scrypt:32768:8:1$JXxWNIBD0h4EQ4i6$fce2cecc324d8349bca38f03dfdea533d3ba8fc3209510070f90f787540a8ec1434b16c680fbeefe386045bdd6e42f5406900f16f819f5f570fbe134de883c51','company','2025-03-28 19:48:15');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-10  9:25:27
