CREATE TABLE IF NOT EXISTS `election` (
  `name` varchar(50) DEFAULT NULL,
  `party` varchar(50) DEFAULT NULL,
  `votes` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

ALTER TABLE `players` ADD COLUMN `hasvoted` TINYINT NULL DEFAULT '0';

CREATE TABLE IF NOT EXISTS `electionstate` (
  `state` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `electionstate` (`state`) VALUES
	(1);


