-- phpMyAdmin SQL Dump
-- version 4.4.15.5
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1:8889
-- Generation Time: Apr 20, 2017 at 11:58 AM
-- Server version: 5.6.34-log
-- PHP Version: 7.0.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `Company`
--

-- --------------------------------------------------------

--
-- Table structure for table `CUSTOMER`
--

CREATE TABLE IF NOT EXISTS `CUSTOMER` (
  `cusID` char(10) NOT NULL,
  `cusName` varchar(150) NOT NULL,
  `birthdate` date NOT NULL,
  `phoneNo` varchar(25) NOT NULL,
  `point` int(11) NOT NULL
);

--
-- Dumping data for table `CUSTOMER`
--

INSERT INTO `CUSTOMER` (`cusID`, `cusName`, `birthdate`, `phoneNo`, `point`) VALUES
('0325269812', 'Nichakhun john Dechsupa ', '1982-01-03', '08937252332', 103),
('0793427165', 'David Lomas Thompson', '1972-02-07', '098992732', 342),
('0842687342', 'Somchai Burinwattana', '1980-08-18', '088182732', 1001),
('0923516721', 'Adam Asshole Brown', '1977-04-01', '6690127712', 1245),
('8977263722', 'Ricardo Ramshaw', '1964-01-05', '0670293821', 9021),
('9731608282', 'Sarapee Srisoothikerdporn', '1985-07-14', '0814362232', 982);

-- --------------------------------------------------------

--
-- Table structure for table `EMPLOYEE`
--

CREATE TABLE IF NOT EXISTS `EMPLOYEE` (
  `empID` char(10) NOT NULL,
  `empName` varchar(150) NOT NULL,
  `birthdate` date NOT NULL,
  `startDate` date NOT NULL,
  `salary` int(11) NOT NULL,
  `status` char(1) NOT NULL
);

--
-- Dumping data for table `EMPLOYEE`
--

INSERT INTO `EMPLOYEE` (`empID`, `empName`, `birthdate`, `startDate`, `salary`, `status`) VALUES
('1000010001', 'Mazie Dent', '1976-04-27', '2010-04-01', 24000, 'A'),
('1000010002', 'Charlie Hirono', '1986-02-16', '2009-03-03', 24500, 'A'),
('1000010003', 'John Moore ', '1983-08-18', '2009-07-21', 26000, 'A'),
('1000010004', 'Shelley Conyers Capito', '1989-09-18', '2007-02-15', 30000, 'A');

-- --------------------------------------------------------

--
-- Table structure for table `INVOICE`
--

CREATE TABLE IF NOT EXISTS `INVOICE` (
  `invoiceID` char(10) NOT NULL,
  `empID` char(10) NOT NULL,
  `cusID` char(10) NOT NULL,
  `invoiceDate` date NOT NULL,
  `invoiceStatus` char(1) NOT NULL
);

--
-- Dumping data for table `INVOICE`
--

INSERT INTO `INVOICE` (`invoiceID`, `empID`, `cusID`, `invoiceDate`, `invoiceStatus`) VALUES
('1000000001', '1000010001', '9731608282', '2016-03-01', 'A'),
('1000000002', '1000010001', '8977263722', '2016-04-01', 'A'),
('1000000003', '1000010002', '0923516721', '2016-04-12', 'A'),
('1000000004', '1000010002', '0923516721', '2016-04-05', 'A'),
('1000000005', '1000010004', '0793427165', '2016-04-09', 'A'),
('1000000006', '1000010003', '9731608282', '2016-04-01', 'A'),
('1000000007', '1000010003', '8977263722', '2016-04-12', 'A');

-- --------------------------------------------------------

--
-- Table structure for table `INVOICE_ITEM`
--

CREATE TABLE IF NOT EXISTS `INVOICE_ITEM` (
  `invoiceID` char(10) NOT NULL,
  `itemNO` int(10) NOT NULL,
  `pID` char(13) NOT NULL,
  `salePrice` double NOT NULL,
  `discount` double NOT NULL,
  `itemStatus` char(1) NOT NULL
);

--
-- Dumping data for table `INVOICE_ITEM`
--

INSERT INTO `INVOICE_ITEM` (`invoiceID`, `itemNO`, `pID`, `salePrice`, `discount`, `itemStatus`) VALUES
('1000000001', 1, '7772932900001', 32500, 1500, 'A'),
('1000000001', 2, '8889096587542', 13000, 1200, 'A'),
('1000000002', 1, '7772932900001', 32500, 1500, 'A'),
('1000000002', 2, '1124543212345', 23000, 2200, 'A'),
('1000000002', 3, '9807781654321', 11000, 1000, 'A'),
('1000000003', 1, '1124543212345', 23500, 1700, 'A'),
('1000000003', 2, '4537676543212', 23000, 1200, 'A'),
('1000000003', 3, '8882932915624', 13000, 4000, 'A'),
('1000000004', 1, '8889096587542', 13900, 300, 'V'),
('1000000005', 1, '8882932900001', 32000, 1700, 'A'),
('1000000005', 2, '7772932900001', 22000, 12000, 'A'),
('1000000005', 3, '8882932900001', 32000, 1700, 'A'),
('1000000006', 1, '8882932900003', 35000, 2300, 'V'),
('1000000007', 1, '7772932900001', 22000, 1200, 'V'),
('1000000007', 2, '8882932900001', 33700, 0, 'A');

-- --------------------------------------------------------

--
-- Table structure for table `PRODUCT`
--

CREATE TABLE IF NOT EXISTS `PRODUCT` (
  `pID` char(13) NOT NULL,
  `name` varchar(300) NOT NULL,
  `cost` double NOT NULL,
  `inventory` int(11) NOT NULL,
  `lotNo` char(5) NOT NULL
);

--
-- Dumping data for table `PRODUCT`
--

INSERT INTO `PRODUCT` (`pID`, `name`, `cost`, `inventory`, `lotNo`) VALUES
('1110801234321', 'ACCOUSTIC GUITAR YAMAHA #F600DW NT', 10400, 9, '88829'),
('1124543212345', 'SONY Z5 PREMIUM BLACK E6853TH/B', 20000, 12, '90875'),
('4537676543212', 'IPAD MINI 4 WI-FI CELLULAR 128GB SILVER', 20000, 14, '77891'),
('7772932900001', 'HOME THEATER SET ONKYO #HT-S5805(B)\r\n', 24000, 6, '77890'),
('8882932900001', 'IPHONE 6S 64GB GOLD(MKQQ2TH/A)', 29000, 15, '88829'),
('8882932900002', 'IPHONE 6S 16GB ROSE GOLD MKQM2TH/A', 25000, 23, '88829'),
('8882932900003', 'IPHONE 6SPLUS 64GB ROSE GOLD (MKU92TH/A)', 32000, 23, '88829'),
('8882932915624', 'D-LED32" SAMSUNG UA32J4100AKXXT', 10960, 5, '88829'),
('8889096587542', 'D-LED TV 50" PANASONIC TH-50A410T', 10900, 7, '88829'),
('9807781654321', ' HUAWEI ASCEND P8-PREMIUM(PG)', 9990, 10, '77891');

-- --------------------------------------------------------

--
-- Table structure for table `SYSTEM_LOG`
--

CREATE TABLE IF NOT EXISTS `SYSTEM_LOG` (
  `log_id` int(10) unsigned NOT NULL,
  `remark` varchar(100) DEFAULT NULL,
  `system_date` datetime DEFAULT NULL
);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `CUSTOMER`
--
ALTER TABLE `CUSTOMER`
  ADD PRIMARY KEY (`cusID`);

--
-- Indexes for table `EMPLOYEE`
--
ALTER TABLE `EMPLOYEE`
  ADD PRIMARY KEY (`empID`);

--
-- Indexes for table `INVOICE`
--
ALTER TABLE `INVOICE`
  ADD PRIMARY KEY (`invoiceID`),
  ADD KEY `empID` (`empID`),
  ADD KEY `cusID` (`cusID`);

--
-- Indexes for table `INVOICE_ITEM`
--
ALTER TABLE `INVOICE_ITEM`
  ADD PRIMARY KEY (`invoiceID`,`itemNO`),
  ADD KEY `pID` (`pID`);

--
-- Indexes for table `PRODUCT`
--
ALTER TABLE `PRODUCT`
  ADD PRIMARY KEY (`pID`);

--
-- Indexes for table `SYSTEM_LOG`
--
ALTER TABLE `SYSTEM_LOG`
  ADD PRIMARY KEY (`log_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `SYSTEM_LOG`
--
ALTER TABLE `SYSTEM_LOG`
  MODIFY `log_id` int(10) unsigned NOT NULL AUTO_INCREMENT;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `INVOICE`
--
ALTER TABLE `INVOICE`
  ADD CONSTRAINT `invoice_ibfk_1` FOREIGN KEY (`empID`) REFERENCES `EMPLOYEE` (`empID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `invoice_ibfk_2` FOREIGN KEY (`cusID`) REFERENCES `CUSTOMER` (`cusID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `INVOICE_ITEM`
--
ALTER TABLE `INVOICE_ITEM`
  ADD CONSTRAINT `invoice_item_ibfk_1` FOREIGN KEY (`invoiceID`) REFERENCES `INVOICE` (`invoiceID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `invoice_item_ibfk_2` FOREIGN KEY (`pID`) REFERENCES `PRODUCT` (`pID`) ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
