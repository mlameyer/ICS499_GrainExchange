CREATE DATABASE  IF NOT EXISTS `mgex_margins` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `mgex_margins`;
-- MySQL dump 10.13  Distrib 5.6.17, for Win32 (x86)
--
-- Host: 192.168.130.213    Database: mgex_margins
-- ------------------------------------------------------
-- Server version	5.6.25-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping routines for database 'mgex_margins'
--
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_portfolio_margin_Calc` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mlameyer`@`%` PROCEDURE `sp_portfolio_margin_Calc`()
BEGIN

	DROP TABLE IF EXISTS port_tmp;
    CREATE TEMPORARY TABLE port_tmp
    (
		Portfolio INT,
	    Product varchar(16),
	    Product_Settle double,
        Product_Settle_previous double,
	    Product2 varchar(16),
	    Product2_Settle double,
        Product2_Settle_previous double,
	    Product_Flux double,
	    Product2_Flux double,
	    Spread_Flux double,
	    Flux_Extension double,
	    margin_requirement int(11),
	    Margin_Coverage double,
	    Settlement_Date date,
	    id int(11),
	    Product_OI varchar(16),
	    Product2_OI varchar(16),
	    Max_OI int(11),
	    Margin_Ext double,
	    Flux_Ext double,
	    Coverage_Ext double
    );
    
    INSERT INTO port_tmp (Portfolio, Product, Product_Settle, Settlement_Date, margin_requirement)
    SELECT Portfolio, Product, Product_Settle, Settlement_Date, margin_requirement FROM t_mgex_portfolio_spreads_settlements_wrk WHERE Leg = 1;
    
    UPDATE port_tmp AS a
    INNER JOIN t_mgex_portfolio_spreads_settlements_wrk AS b ON a.Portfolio = b.Portfolio
    SET a.Product2 = b.Product,
		a.Product2_Settle = b.Product_Settle
	WHERE b.Leg = 2;
    
    UPDATE port_tmp AS a
    INNER JOIN t_mgex_portfolio_spreads_settlements_history AS b ON a.Portfolio = b.Portfolio AND a.Product = b.Product
    SET a.Product_Settle_previous = b.Product_Settle
	WHERE b.Settlement_Date = (SELECT MAX(Settlement_Date) FROM t_mgex_portfolio_spreads_settlements_history);
    
    UPDATE port_tmp AS a
    INNER JOIN t_mgex_portfolio_spreads_settlements_history AS b ON a.Portfolio = b.Portfolio AND a.Product2 = b.Product2
    SET a.Product2_Settle_previous = b.Product2_Settle
	WHERE b.Settlement_Date = (SELECT MAX(Settlement_Date) FROM t_mgex_portfolio_spreads_settlements_history);
    
    UPDATE port_tmp 
    SET Product_Flux = Product_Settle - Product_Settle_previous,
		Product2_Flux = Product2_Settle - Product2_Settle_previous;
        
	UPDATE port_tmp 
    SET Spread_Flux = ABS(Product_Flux - Product2_Flux);
    
    UPDATE port_tmp
    SET FLUX_Extension = (Spread_Flux * 5000),
    Margin_Coverage = (margin_requirement - FLUX_Extension);
    
    INSERT INTO t_mgex_portfolio_spreads_settlements_history (Portfolio, Product, Product_Settle, Product2, Product2_Settle, Settlement_Date, Product_Flux, Product2_Flux, Spread_Flux, FLUX_Extension, margin_requirement, Margin_Coverage)
    SELECT Portfolio, Product, Product_Settle, Product2, Product2_Settle, Settlement_Date, Product_Flux, Product2_Flux, Spread_Flux, FLUX_Extension, margin_requirement, Margin_Coverage FROM port_tmp;
    
    TRUNCATE t_mgex_portfolio_spreads_settlements_wrk;
    SELECT * FROM port_tmp;
    SELECT * FROM t_mgex_portfolio_spreads_settlements_history;
END ;;

DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-06-29 10:29:01
