CREATE TABLE `hardware` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `description` varchar(255) NOT NULL,
  `meta-data` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;

CREATE TABLE `room` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;

CREATE TABLE `room_access` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_profileID` int NOT NULL,
  `roomid` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_profileid_idx` (`user_profileID`),
  KEY `roomid_idx` (`roomid`),
  CONSTRAINT `roomid` FOREIGN KEY (`roomid`) REFERENCES `room` (`id`),
  CONSTRAINT `user_profileid_` FOREIGN KEY (`user_profileID`) REFERENCES `user_profile` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb3;

CREATE TABLE `room_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `roomID` int NOT NULL,
  `date` datetime NOT NULL,
  `data` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `roomid___idx` (`roomID`),
  CONSTRAINT `roomid__` FOREIGN KEY (`roomID`) REFERENCES `room` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb3;

CREATE TABLE `room_provider_hardware` (
  `id` int NOT NULL AUTO_INCREMENT,
  `roomID` int NOT NULL,
  `hardwareID` int NOT NULL,
  `hardware_modeID` int NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `roomid__idx` (`roomID`),
  KEY `hardwareID_idx` (`hardwareID`),
  CONSTRAINT `hardwareID` FOREIGN KEY (`hardwareID`) REFERENCES `hardware` (`id`),
  CONSTRAINT `roomid_` FOREIGN KEY (`roomID`) REFERENCES `room` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3;

CREATE TABLE `system_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date_created` datetime NOT NULL,
  `text` varchar(255) NOT NULL,
  `initiatorID` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `initiatorID_idx` (`initiatorID`),
  CONSTRAINT `initiatorID` FOREIGN KEY (`initiatorID`) REFERENCES `user_profile` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;

CREATE TABLE `system_role` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `description` varchar(255) NOT NULL,
  `key` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;

CREATE TABLE `system_role_provider` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_profileID` int NOT NULL,
  `system_roleID` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_profileid_idx` (`user_profileID`),
  KEY `system_roleID_idx` (`system_roleID`),
  CONSTRAINT `system_roleID` FOREIGN KEY (`system_roleID`) REFERENCES `system_role` (`id`),
  CONSTRAINT `user_profileid` FOREIGN KEY (`user_profileID`) REFERENCES `user_profile` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;

CREATE TABLE `type_mode_harware` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `description` varchar(255) NOT NULL,
  `harwareID` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `hardwareid_idx` (`harwareID`),
  CONSTRAINT `hardwareid_` FOREIGN KEY (`harwareID`) REFERENCES `hardware` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3;

CREATE TABLE `user_profile` (
  `id` int NOT NULL AUTO_INCREMENT,
  `f_name` varchar(45) NOT NULL,
  `s_name` varchar(45) NOT NULL,
  `m_name` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `password` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;

INSERT INTO user_profile (f_name, s_name, m_name, email, password) VALUES 
	('Александр', 'Камов', 'Аркадьевич', 'mashrooms2013@yandex.ru', MD5('mashroom')),
	('Артём', 'Николаев', 'Семенович', 'tealiviva2013@yandex.ru', MD5('singnaste23')),
	('Евгений', 'Петров', 'Григорьевич', 'Griga123@gmail.com', MD5('grigamaster12345432')),
	('Наталья', 'Каулич', 'Сергеевна', 'Natali1972@yandex.ru', MD5('austerlic1812')),
	('Андрей', 'Терехов', 'Викторович', 'Bytyaga1994@mail.com', MD5('askjrtvnye')),
	('Александр', 'Чубаков', 'Радеонович', 'Radeon2000@yandex.ru', MD5('sigmasqrt222'));

INSERT INTO room (name, description) VALUES 
	('Холодильный цех', 'описание'),
	('Цех выращивания 1', 'описание'),
	('Цех выращивания 2', 'описание'),
	('Компостный цех', 'описание');

INSERT INTO system_role (name, description, `key`) VALUES 
	('Администратор', 'описание', 'admin'),
	('Технолог', 'описание', 'tech'),
	('Инжинер', 'описание', 'engineer');

INSERT INTO system_role_provider (user_profileID, system_roleID) VALUES 
	(1, 2),
    (2, 2),
	(3, 3),
	(4, 1),
	(5, 2),
	(6, 1);

INSERT INTO `system_log` (date_created, text, initiatorID) VALUES 
	('2023-05-20 12:30:00', 'событие', 1),
    ('2023-05-20 16:30:00', 'событие', 2),
	('2023-05-22 12:30:00', 'событие', 3),
	('2023-05-22 18:30:00', 'событие', 4),
	('2023-05-24 12:30:00', 'событие', 5),
	('2023-05-24 17:30:00', 'событие', 6);

INSERT INTO `room_logs` (roomID, date, data) VALUES 
	(1, '2023-05-20 12:30:00', 'T=3;H=85;P=450;'),
    (2, '2023-05-20 12:30:00', 'T=14;H=85;P=450;'),
    (3, '2023-05-20 12:30:00', 'T=14.2;H=85.1;P=450.2;'),      
    (4, '2023-05-20 12:30:00', 'T=65;H=85;P=1000;'),
    
	(1, '2023-05-21 12:30:00', 'T=3;H=85;P=450;'),
    (2, '2023-05-21 12:30:00', 'T=14;H=85;P=450;'),
    (3, '2023-05-21 12:30:00', 'T=14.2;H=85.1;P=450.2;'),      
    (4, '2023-05-21 12:30:00', 'T=65;H=85;P=1000;'),
    
	(1, '2023-05-20 12:40:00', 'T=3.3;H=85.7;P=450.8;'),
    (2, '2023-05-20 12:40:00', 'T=14.3;H=85.7;P=450.8;'),    
	(3, '2023-05-20 12:40:00', 'T=14.5;H=5.7;P=450.8;'), 
    (4, '2023-05-20 12:40:00', 'T=65.3;H=85.7;P=1000.8;'),
    
	(1, '2023-05-20 12:50:00', 'T=3.3;H=85.7;P=467.8;'),
    (2, '2023-05-20 12:50:00', 'T=14.3;H=85.7;P=467.8;'),
	(3, '2023-05-20 12:50:00', 'T=14.5;H=85.7;P=450.8;'), 
    (4, '2023-05-20 12:50:00', 'T=65.5;H=85.7;P=1000.8;'),
    
	(1, '2023-05-20 13:00:00', 'T=3.3;H=86.8;P=467.8;'),
    (2, '2023-05-20 13:00:00', 'T=14.5;H=86.8;P=467.8;'),
	(3, '2023-05-20 13:00:00', 'T=14.3;H=86.1;P=467.8;'),
    (4, '2023-05-20 13:00:00', 'T=66;H=86.8;P=1002.8;'),
    
	(1, '2023-05-20 13:10:00', 'T=3.3;H=86.9;P=480.8;'),
    (2, '2023-05-20 13:10:00', 'T=14.3;H=86.9;P=480.8;'),
	(3, '2023-05-20 13:10:00', 'T=14.5;H=86.9;P=467.8;'),
	(4, '2023-05-20 13:10:00', 'T=66.1;H=86.9;P=1005.8;'),
    
	(1, '2023-05-20 13:20:00', 'T=3.3;H=86.9;P=480.8;'),
    (2, '2023-05-20 13:20:00', 'T=14.6;H=86.9;P=480.8;'),
	(3, '2023-05-20 13:20:00', 'T=14.6;H=86.4;P=480.8;'),
	(4, '2023-05-20 13:20:00', 'T=66.2;H=86.9;P=1005.8;'),
    
	(1, '2023-05-20 13:30:00', 'T=3.3;H=86.9;P=450.8;'),
    (2, '2023-05-20 13:30:00', 'T=14.3;H=86.9;P=450.8;'),
	(3, '2023-05-20 13:30:00', 'T=14.5;H=86.9;P=450.8;'),
	(4, '2023-05-20 13:30:00', 'T=66.3;H=86.9;P=1006.8;'),
    
	(1, '2023-05-20 13:40:00', 'T=3.4;H=86.9;P=450.8;'),
    (2, '2023-05-20 13:40:00', 'T=14.3;H=86.9;P=450.8;'),
	(3, '2023-05-20 13:40:00', 'T=14.8;H=86.3;P=450.8;'),
	(4, '2023-05-20 13:40:00', 'T=66.3;H=86.9;P=1000.8;'),
    
	(1, '2023-05-20 13:50:00', 'T=3.3;H=88.3;P=445.8;'),
    (2, '2023-05-20 13:50:00', 'T=14.9;H=88.3;P=445.7;'),
	(3, '2023-05-20 13:50:00', 'T=14.5;H=88.3;P=450.8;'),
	(4, '2023-05-20 13:50:00', 'T=66.5;H=88.3;P=999.8;'),
    
    (1, '2023-05-20 14:00:00', 'T=3.3;H=88.5;P=446.8;'),
    (2, '2023-05-20 14:00:00', 'T=14.3;H=88.5;P=446.8;'),
	(3, '2023-05-20 14:00:00', 'T=14.4;H=88.3;P=446.8;'),
	(4, '2023-05-20 14:00:00', 'T=66.3;H=88.5;P=1000.8;'),
    
	(1, '2023-05-20 14:10:00', 'T=3.3;H=88.7;P=450.8;'),    
	(2, '2023-05-20 14:10:00', 'T=14.4;H=88.7;P=450.8;'),
	(3, '2023-05-20 14:10:00', 'T=14.5;H=88.7;P=446.8;'),  	 
	(4, '2023-05-20 14:10:00', 'T=68;H=88.7;P=1000.8;');  

INSERT INTO `hardware` (name, description, `meta-data`) VALUES 
	('Temp','Датчик температуры','мета-данные'),
    ('Hum','Датчик влажности','мета-данные'),
    ('Ppm','Датчик углекислого газа','мета-данные'),
    ('Light','Управление светом','мета-данные'),
    ('Vent','Управление вентиляцией','мета-данные'),
    ('Water','Управление поливом','мета-данные');

INSERT INTO `type_mode_harware` (name, description, harwareID) VALUES 
	('TempON', 'Включен датчик температуры', 1),
    ('TempOFF','Выключен датчик температуры', 1),
	('HumON', 'Включен датчик влажности', 2),
    ('HumOFF','Выключен датчик влажности', 2),
	('PpmON', 'Включен датчик качества воздуха', 3),
    ('PpmOFF','Выключен датчик качества воздуха', 3),
	('LightON', 'Включено освещение', 4),
    ('LightOFF','Выключено освещение', 4),
	('VentFULL', 'Полностью открыта', 5),
	('VentHALF', 'Наполовину открыта', 5),
    ('VentOFF','Полностью закрыта', 5),
	('WaterMAX', 'Максимальный полив', 6),
    ('WaterMED','Средний полив', 6),
    ('WaterMIN','Минимальный полив', 6),
    ('WaterOFF','Полив выключен', 6);

INSERT INTO `room_provider_hardware` (roomID, hardwareID, hardware_modeID, date) VALUES 
	(1, 1, 1, '2023-05-20 7:00:00'),
    (1, 2, 3, '2023-05-20 7:00:00'),
    (1, 3, 5, '2023-05-20 7:00:00'),
    
	(2, 1, 1, '2023-05-20 7:00:00'),
    (2, 2, 3, '2023-05-20 7:00:00'),
    (2, 3, 5, '2023-05-20 7:00:00'),
	(2, 4, 7, '2023-05-20 7:00:00'),
    (2, 5, 9, '2023-05-20 7:00:00'),
    (2, 6, 11, '2023-05-20 7:00:00'),
    
	(3, 1, 1, '2023-05-20 7:00:00'),
    (3, 2, 3, '2023-05-20 7:00:00'),
    (3, 3, 5, '2023-05-20 7:00:00'),
	(3, 4, 7, '2023-05-20 7:00:00'),
    (3, 5, 9, '2023-05-20 7:00:00'),
    (3, 6, 11, '2023-05-20 7:00:00'),
    
	(4, 1, 1, '2023-05-20 7:00:00'),
    (4, 2, 3, '2023-05-20 7:00:00'),
    (4, 3, 5, '2023-05-20 7:00:00'),
	(4, 4, 7, '2023-05-20 7:00:00');
    
COMMIT;





