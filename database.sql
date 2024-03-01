
CREATE TABLE IF NOT EXISTS `election` (
  `name` varchar(50) DEFAULT NULL,
  `party` varchar(50) DEFAULT NULL,
  `votes` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--For QBCore Users--
ALTER TABLE `players` ADD COLUMN `hasvoted` TINYINT NULL DEFAULT '0';

--For ESX Users--
ALTER TABLE `players` ADD COLUMN `hasvoted` TINYINT NULL DEFAULT '0';



