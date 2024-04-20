DROP TABLE IF EXISTS contact;

CREATE TABLE contact (
  id int NOT NULL,
  channel varchar(255) DEFAULT NULL,
  lastupdate timestamp DEFAULT NULL,
  resolved int NOT NULL,
  ticket int NOT NULL,
  topic varchar(255) DEFAULT NULL,
  customer_id int DEFAULT NULL,
  order_id int DEFAULT NULL,
  product_id int DEFAULT NULL,
  PRIMARY KEY (id)
);


INSERT INTO contact VALUES (0,'phone','2022-03-31 08:19:00',1,1,'product information',2,NULL,1),
(1,'phone','2022-03-30 13:17:00',1,2,'product information',2,NULL,1),
(2,'form','2022-03-30 18:52:00',1,3,'product information',2,NULL,1),
(3,'phone','2022-03-31 13:28:00',0,4,'product information',2,NULL,1),
(4,'phone','2022-04-01 14:51:00',1,5,'product information',1,NULL,1),
(5,'mail','2022-03-31 23:54:00',1,6,'product information',1,NULL,1)
;

DROP TABLE IF EXISTS customer;

CREATE TABLE customer (
  id int NOT NULL,
  academicTitle varchar(255) DEFAULT NULL,
  address varchar(255) DEFAULT NULL,
  birthdate date DEFAULT NULL,
  city varchar(255) DEFAULT NULL,
  creditCard varchar(255) DEFAULT NULL,
  customerNo int NOT NULL,
  email varchar(255) DEFAULT NULL,
  gender varchar(255) DEFAULT NULL,
  lastupdate timestamp DEFAULT NULL,
  name varchar(255) DEFAULT NULL,
  phone varchar(255) DEFAULT NULL,
  postalCode varchar(255) DEFAULT NULL,
  salutation varchar(255) DEFAULT NULL,
  state varchar(255) DEFAULT NULL,
  PRIMARY KEY (id)
);

INSERT INTO customer VALUES (1,'','Mittelweg 43','1979-03-09','Oerlenbach','4392646449109014',20220019,'michael.loehr@alas.it','MALE','2022-04-01 12:00:00','M. Löhr','+49-9725-440457','97714','Herr','Bayern'),
(2,'','Schulstraße 46','1993-01-08','Großbardau','4325614223947969',20220028,'kerstin_liebig@kvm.us','FEMALE','2022-04-01 12:00:00','Kerstin Liebig','+49-3437-148208','4668','Frau','Sachsen'),
(3,'','Am Bahnhof 12','1998-10-12','Dambeck Altmark','4105804657042553',20220032,'roland_schneider@deltional.de','MALE','2022-04-01 12:00:00','Herr Schneider','+49-39035-02638','29416','Herr','Sachsen-Anhalt'),
(4,'','Feldstraße 3','1964-10-13','Forst Hunsrück','4711599409720250',20220048,'gerda_schiessl@glzbkmwcfzwo.de','FEMALE','2022-04-01 12:00:00','Frau Gerda Schießl','+49-6545-587375','56858','Frau','Rheinland-Pfalz')
;

DROP TABLE IF EXISTS item;

CREATE TABLE item (
  id int NOT NULL,
  pieces int NOT NULL DEFAULT 0,
  order_id int DEFAULT NULL,
  product_id int DEFAULT NULL,
  PRIMARY KEY (id)
);


INSERT INTO item VALUES (0,1,0,1)--,
                        --(1,1,0,2)--,
                        --(2,1,1,3),
                        --(3,1,2,1),
                        --(4,1,2,2)
;


DROP TABLE IF EXISTS product;

CREATE TABLE product (
  id int NOT NULL,
  AirPressure varchar(255) DEFAULT NULL,
  EAN bigint NOT NULL,
  ETRTO varchar(255) DEFAULT NULL,
  Operation varchar(255) DEFAULT NULL,
  Size varchar(255) DEFAULT NULL,
  customType int NOT NULL,
  description varchar(255) DEFAULT NULL,
  lastupdate timestamp DEFAULT NULL,
  price double precision NOT NULL,
  rubberCompound varchar(255) DEFAULT NULL,
  techVersion varchar(255) DEFAULT NULL,
  weight int NOT NULL,
  PRIMARY KEY (id)
) ;

INSERT INTO product VALUES (1,'2,4 - 4,1 bar',4717784026121,'58-559','AM','26x2.30',0,'Minion DHF, 26x2.30, EXO TR','2022-04-01 12:00:00',53.5,'Dual','EXO TR',845),
(2,'2,4 - 4,1 bar',4717784025940,'58-559','AM','26x2.30',0,'DHR II, 26x2.30, EXO TR','2022-04-01 12:00:00',53.5,'Dual','EXO TR',775)--,
--(3,'2,5 - 3,4 bar',4717784028026,'61-584','DH','27.5x2.40',0,'Minion DHR II, 27.5x2.40, DH, SuperTacky','2022-04-01 12:00:00',59.5,'SuperTacky','DH',1270)
;

DROP TABLE IF EXISTS purchase;

CREATE TABLE purchase (
  id int NOT NULL,
  deliveryDate timestamp DEFAULT NULL,
  lastupdate timestamp DEFAULT NULL,
  orderDate timestamp DEFAULT NULL,
  orderNo int NOT NULL,
  pieces int NOT NULL DEFAULT 0,
  shipDate timestamp DEFAULT NULL,
  customer_id int DEFAULT NULL,
  PRIMARY KEY (id)
);


INSERT INTO purchase VALUES (0,'2022-04-04 12:58:00','2022-04-04 13:23:00','2022-04-01 06:17:00',20229000,1,'2022-04-02 09:27:00',1)--,
                            --(1,'2022-04-04 13:12:00','2022-04-04 14:40:00','2022-04-01 07:10:00',20225003,2,'2022-04-02 09:54:00',1),
                           -- (2,'2022-04-04 14:53:00','2022-04-04 15:11:00','2022-04-01 08:19:00',20222006,2,'2022-04-02 10:22:00',2)
;

DROP TABLE IF EXISTS retour;

CREATE TABLE retour (
  id int NOT NULL,
  pieces int NOT NULL DEFAULT 0,
  reason varchar(255) DEFAULT NULL,
  refund int NOT NULL,
  returnDate timestamp DEFAULT NULL,
  order_id int DEFAULT NULL,
  product_id int DEFAULT NULL,
  PRIMARY KEY (id)
);


--INSERT INTO retour VALUES (0,1,'wrong size',1,'2022-04-07 15:12:00',0,50),(1,1,'not working',1,'2022-04-08 11:16:00',2,27),(2,1,'not working',1,'2022-04-08 11:16:00',2,80),(3,1,'not working',1,'2022-04-09 14:23:00',23,46),(4,1,'not working',1,'2022-04-09 14:51:00',30,21),(5,1,'wrong size',0,'2022-04-09 16:10:00',15,63),(6,1,'none given',1,'2022-04-09 16:10:00',15,3),(7,1,'wrong size',1,'2022-04-09 16:26:00',16,17),(8,1,'none given',1,'2022-04-09 16:26:00',16,40),(9,1,'not working',1,'2022-04-11 09:46:00',9,11),(10,1,'none given',1,'2022-04-11 09:46:00',9,75),(11,1,'none given',1,'2022-04-11 09:46:00',9,91),(12,1,'not working',1,'2022-04-11 09:46:00',9,84),(13,1,'not working',1,'2022-04-11 10:03:00',21,94),(14,1,'not working',1,'2022-04-11 10:03:00',21,91),(15,1,'none given',1,'2022-04-11 10:03:00',21,22),(16,1,'not working',0,'2022-04-11 10:03:00',21,47),(17,1,'none given',1,'2022-04-11 10:03:00',21,48),(18,1,'not working',1,'2022-04-11 10:25:00',31,77),(19,1,'wrong size',1,'2022-04-11 10:42:00',29,33),(20,1,'not working',1,'2022-04-11 10:42:00',29,28),(21,1,'none given',1,'2022-04-11 10:42:00',29,40),(22,1,'not working',1,'2022-04-11 11:14:00',8,52),(23,1,'not working',1,'2022-04-11 11:14:00',8,15),(24,1,'none given',1,'2022-04-11 11:19:00',28,58),(25,1,'wrong size',1,'2022-04-11 11:19:00',28,79),(26,1,'none given',1,'2022-04-11 11:19:00',28,89),(27,1,'not working',1,'2022-04-11 11:19:00',28,38),(28,1,'none given',1,'2022-04-11 12:54:00',11,54),(29,1,'none given',1,'2022-04-11 12:54:00',11,29),(30,1,'none given',0,'2022-04-11 13:15:00',13,30),(31,1,'not working',1,'2022-04-11 13:15:00',13,68),(32,1,'wrong size',1,'2022-04-11 13:15:00',13,94),(33,1,'none given',1,'2022-04-11 13:15:00',13,55),(34,1,'wrong size',1,'2022-04-11 13:24:00',36,84),(35,1,'none given',1,'2022-04-11 14:56:00',35,91),(36,1,'wrong size',1,'2022-04-11 14:56:00',35,16),(37,1,'wrong size',1,'2022-04-11 14:56:00',35,39),(38,1,'none given',1,'2022-04-11 14:56:00',35,89),(39,1,'not working',1,'2022-04-11 14:56:00',35,36),(40,1,'wrong size',1,'2022-04-11 14:56:00',35,25),(41,1,'not working',1,'2022-04-11 16:15:00',32,15),(42,1,'wrong size',1,'2022-04-11 16:15:00',32,14),(43,1,'none given',1,'2022-04-11 16:15:00',32,9),(44,1,'not working',1,'2022-04-12 10:04:00',38,98),(45,1,'not working',0,'2022-04-12 10:04:00',38,35),(46,1,'none given',1,'2022-04-12 10:04:00',38,71),(47,1,'none given',1,'2022-04-12 10:04:00',38,95),(48,1,'not working',1,'2022-04-12 11:07:00',39,57),(49,1,'none given',1,'2022-04-12 11:07:00',39,94),(50,1,'none given',1,'2022-04-12 11:47:00',63,47),(51,1,'not working',1,'2022-04-12 13:07:00',42,93),(52,1,'not working',1,'2022-04-12 13:41:00',51,19),(53,1,'none given',0,'2022-04-12 13:41:00',51,79),(54,1,'wrong size',1,'2022-04-12 13:41:00',51,29),(55,1,'none given',1,'2022-04-12 13:41:00',51,85),(56,1,'none given',1,'2022-04-12 15:40:00',41,41),(57,1,'wrong size',1,'2022-04-13 08:29:00',71,40),(58,1,'none given',1,'2022-04-13 08:29:00',71,2),(59,1,'wrong size',1,'2022-04-13 08:29:00',71,79),(60,1,'none given',0,'2022-04-13 08:29:00',71,83),(61,1,'not working',1,'2022-04-13 08:29:00',71,12),(62,1,'not working',1,'2022-04-13 08:29:00',71,69),(63,1,'none given',1,'2022-04-13 10:13:00',44,56),(64,1,'wrong size',1,'2022-04-13 10:18:00',48,38),(65,1,'not working',0,'2022-04-13 10:18:00',48,56),(66,1,'none given',1,'2022-04-13 10:18:00',48,78),(67,1,'none given',1,'2022-04-13 10:18:00',48,96),(68,1,'wrong size',1,'2022-04-13 10:38:00',64,71),(69,1,'not working',1,'2022-04-13 12:56:00',47,31),(70,1,'wrong size',1,'2022-04-13 12:56:00',47,62),(71,1,'not working',1,'2022-04-14 11:39:00',60,49),(72,1,'none given',1,'2022-04-14 13:20:00',65,23),(73,1,'none given',0,'2022-04-14 13:20:00',65,51),(74,1,'none given',1,'2022-04-14 13:50:00',76,83),(75,1,'not working',1,'2022-04-14 14:34:00',79,25),(76,1,'none given',1,'2022-04-14 14:34:00',79,25),(77,1,'wrong size',1,'2022-04-14 14:34:00',79,35),(78,1,'not working',1,'2022-04-14 15:06:00',80,45),(79,1,'none given',1,'2022-04-14 15:15:00',68,43),(80,1,'wrong size',1,'2022-04-14 15:15:00',68,90),(81,1,'none given',1,'2022-04-14 15:15:00',68,19),(82,1,'none given',1,'2022-04-14 16:39:00',73,40),(83,1,'wrong size',1,'2022-04-14 17:10:00',56,41),(84,1,'none given',1,'2022-04-14 17:10:00',56,75),(85,1,'none given',1,'2022-04-14 17:10:00',56,34),(86,1,'not working',1,'2022-04-14 17:10:00',56,64),(87,1,'wrong size',1,'2022-04-14 17:10:00',56,12),(88,1,'wrong size',0,'2022-04-15 09:10:00',69,44),(89,1,'not working',1,'2022-04-15 10:26:00',58,97),(90,1,'wrong size',0,'2022-04-15 10:26:00',58,31),(91,1,'wrong size',1,'2022-04-15 10:49:00',62,58),(92,1,'not working',1,'2022-04-15 10:49:00',62,16),(93,1,'wrong size',1,'2022-04-15 10:49:00',62,5),(94,1,'wrong size',1,'2022-04-15 10:49:00',62,5),(95,1,'none given',1,'2022-04-15 10:49:00',62,55),(96,1,'none given',1,'2022-04-15 11:31:00',67,48),(97,1,'wrong size',1,'2022-04-15 11:31:00',67,14),(98,1,'wrong size',0,'2022-04-15 11:47:00',84,65),(99,1,'wrong size',1,'2022-04-15 11:47:00',84,46),(100,1,'wrong size',1,'2022-04-15 11:47:00',84,71),(101,1,'wrong size',1,'2022-04-15 11:55:00',82,14),(102,1,'wrong size',1,'2022-04-15 11:55:00',82,10),(103,1,'wrong size',1,'2022-04-15 11:56:00',83,23),(104,1,'wrong size',1,'2022-04-15 11:56:00',83,12),(105,1,'wrong size',1,'2022-04-15 11:56:00',83,84),(106,1,'not working',1,'2022-04-15 12:37:00',77,11),(107,1,'none given',0,'2022-04-15 12:37:00',77,10),(108,1,'none given',1,'2022-04-15 12:37:00',77,38),(109,1,'not working',1,'2022-04-15 14:07:00',74,91),(110,1,'none given',1,'2022-04-16 09:33:00',103,73),(111,1,'wrong size',1,'2022-04-16 09:33:00',103,72),(112,1,'not working',1,'2022-04-16 16:17:00',95,91),(113,1,'not working',1,'2022-04-16 16:57:00',107,47),(114,1,'not working',1,'2022-04-16 16:57:00',107,10),(115,1,'none given',1,'2022-04-16 17:24:00',91,9),(116,1,'wrong size',0,'2022-04-16 17:48:00',99,78),(117,1,'wrong size',1,'2022-04-18 09:40:00',117,9),(118,1,'none given',1,'2022-04-18 09:40:00',117,32),(119,1,'not working',0,'2022-04-18 09:40:00',117,70),(120,1,'not working',0,'2022-04-18 09:40:00',117,95),(121,1,'none given',1,'2022-04-18 09:40:00',117,65),(122,1,'not working',1,'2022-04-18 10:22:00',98,33),(123,1,'not working',1,'2022-04-18 10:22:00',98,17),(124,1,'wrong size',1,'2022-04-18 12:35:00',87,90),(125,1,'wrong size',1,'2022-04-18 16:16:00',115,81),(126,1,'wrong size',1,'2022-04-18 16:16:00',115,40),(127,1,'none given',1,'2022-04-18 16:29:00',100,36),(128,1,'not working',0,'2022-04-18 16:29:00',100,4),(129,1,'none given',1,'2022-04-18 16:50:00',116,47),(130,1,'none given',1,'2022-04-18 16:50:00',116,22),(131,1,'none given',0,'2022-04-18 16:50:00',116,34),(132,1,'wrong size',1,'2022-04-18 16:50:00',116,39),(133,1,'not working',1,'2022-04-18 16:54:00',112,81),(134,1,'none given',1,'2022-04-18 16:54:00',112,81),(135,1,'wrong size',1,'2022-04-18 16:54:00',112,80),(136,1,'none given',1,'2022-04-18 17:14:00',123,80),(137,1,'not working',1,'2022-04-18 17:14:00',123,87),(138,1,'not working',1,'2022-04-18 17:14:00',123,57),(139,1,'wrong size',1,'2022-04-19 09:12:00',122,68),(140,1,'none given',1,'2022-04-19 09:12:00',122,100),(141,1,'not working',1,'2022-04-19 09:12:00',122,59),(142,1,'not working',0,'2022-04-19 09:12:00',122,73),(143,1,'not working',1,'2022-04-19 09:12:00',122,45),(144,1,'none given',1,'2022-04-19 09:15:00',121,27),(145,1,'not working',1,'2022-04-19 09:15:00',121,25),(146,1,'none given',1,'2022-04-19 09:15:00',121,19),(147,1,'wrong size',1,'2022-04-19 10:00:00',120,20),(148,1,'not working',1,'2022-04-19 10:23:00',134,27),(149,1,'wrong size',1,'2022-04-19 10:23:00',134,84),(150,1,'none given',1,'2022-04-19 10:28:00',118,56),(151,1,'not working',1,'2022-04-20 09:30:00',138,57),(152,1,'none given',0,'2022-04-20 09:30:00',138,19),(153,1,'wrong size',1,'2022-04-20 12:27:00',136,80),(154,1,'none given',1,'2022-04-20 12:27:00',136,69),(155,1,'not working',1,'2022-04-20 12:27:00',136,86),(156,1,'none given',1,'2022-04-20 12:27:00',136,38),(157,1,'wrong size',1,'2022-04-20 12:27:00',136,60),(158,1,'none given',1,'2022-04-20 13:30:00',129,76),(159,1,'wrong size',1,'2022-04-20 13:30:00',129,45),(160,1,'wrong size',1,'2022-04-21 14:10:00',153,41),(161,1,'not working',1,'2022-04-21 15:35:00',154,7),(162,1,'not working',1,'2022-04-21 15:41:00',128,98),(163,1,'not working',1,'2022-04-21 15:41:00',128,61),(164,1,'wrong size',1,'2022-04-21 15:41:00',128,93),(165,1,'not working',0,'2022-04-21 15:41:00',128,54),(166,1,'none given',1,'2022-04-21 15:56:00',145,4),(167,1,'not working',1,'2022-04-21 15:56:00',145,14),(168,1,'none given',1,'2022-04-21 15:56:00',145,35),(169,1,'not working',1,'2022-04-21 15:56:00',145,87),(170,1,'none given',1,'2022-04-21 16:21:00',141,15),(171,1,'wrong size',1,'2022-04-21 16:21:00',141,87),(172,1,'none given',1,'2022-04-22 09:00:00',152,37),(173,1,'wrong size',1,'2022-04-22 09:00:00',152,36),(174,1,'wrong size',1,'2022-04-22 09:10:00',142,47),(175,1,'none given',1,'2022-04-22 09:10:00',142,18),(176,1,'none given',1,'2022-04-22 09:10:00',142,58),(177,1,'wrong size',1,'2022-04-22 09:46:00',155,99),(178,1,'wrong size',1,'2022-04-22 09:57:00',157,42),(179,1,'not working',1,'2022-04-22 09:57:00',157,83),(180,1,'not working',1,'2022-04-22 09:57:00',157,29),(181,1,'not working',1,'2022-04-22 13:21:00',159,69),(182,1,'wrong size',1,'2022-04-23 09:38:00',185,48),(183,1,'not working',1,'2022-04-23 09:38:00',185,36),(184,1,'none given',1,'2022-04-23 14:26:00',172,98),(185,1,'none given',1,'2022-04-23 16:02:00',195,65),(186,1,'not working',1,'2022-04-23 16:09:00',183,82),(187,1,'wrong size',1,'2022-04-23 17:01:00',176,67),(188,1,'not working',1,'2022-04-23 17:49:00',179,71),(189,1,'wrong size',1,'2022-04-25 09:03:00',191,71),(190,1,'none given',1,'2022-04-25 09:03:00',191,86),(191,1,'not working',1,'2022-04-25 09:18:00',190,17),(192,1,'not working',0,'2022-04-25 09:18:00',190,29),(193,1,'not working',0,'2022-04-25 09:18:00',190,56),(194,1,'not working',1,'2022-04-25 09:18:00',190,87),(195,1,'none given',1,'2022-04-25 09:18:00',190,1),(196,1,'none given',1,'2022-04-25 09:31:00',199,92),(197,1,'none given',1,'2022-04-25 09:31:00',199,71),(198,1,'not working',1,'2022-04-25 09:52:00',181,67),(199,1,'wrong size',0,'2022-04-25 09:52:00',181,56),(200,1,'none given',1,'2022-04-25 09:52:00',181,82),(201,1,'wrong size',1,'2022-04-25 09:58:00',163,42),(202,1,'none given',1,'2022-04-25 09:58:00',163,44),(203,1,'none given',1,'2022-04-25 11:15:00',173,97),(204,1,'none given',1,'2022-04-25 11:15:00',173,94),(205,1,'wrong size',1,'2022-04-25 12:07:00',189,6),(206,1,'none given',1,'2022-04-25 12:07:00',189,3),(207,1,'not working',1,'2022-04-25 12:07:00',189,19),(208,1,'wrong size',1,'2022-04-25 12:13:00',200,92),(209,1,'none given',1,'2022-04-25 12:13:00',200,2),(210,1,'wrong size',1,'2022-04-25 12:20:00',164,76),(211,1,'not working',1,'2022-04-25 12:20:00',164,28),(212,1,'not working',1,'2022-04-25 12:20:00',164,20),(213,1,'not working',1,'2022-04-25 12:32:00',162,27),(214,1,'not working',1,'2022-04-25 12:32:00',162,46),(215,1,'not working',1,'2022-04-25 12:32:00',162,85),(216,1,'wrong size',1,'2022-04-25 12:39:00',194,1),(217,1,'wrong size',1,'2022-04-25 13:01:00',167,24),(218,1,'not working',0,'2022-04-25 13:01:00',167,94),(219,1,'wrong size',1,'2022-04-25 13:01:00',167,19),(220,1,'not working',1,'2022-04-25 15:48:00',187,63),(221,1,'wrong size',1,'2022-04-25 15:48:00',187,5),(222,1,'none given',1,'2022-04-25 16:56:00',210,82),(223,1,'not working',1,'2022-04-26 10:39:00',201,22),(224,1,'not working',1,'2022-04-26 10:39:00',201,100),(225,1,'not working',1,'2022-04-26 13:50:00',204,41),(226,1,'not working',1,'2022-04-26 13:50:00',204,91),(227,1,'wrong size',1,'2022-04-26 16:38:00',205,23),(228,1,'wrong size',1,'2022-04-26 17:55:00',211,7),(229,1,'not working',1,'2022-04-26 17:55:00',211,17),(230,1,'not working',1,'2022-04-26 17:55:00',217,16),(231,1,'none given',1,'2022-04-26 17:55:00',217,87),(232,1,'none given',0,'2022-04-28 12:03:00',216,58),(233,1,'not working',1,'2022-04-28 12:03:00',216,31),(234,1,'wrong size',1,'2022-04-28 12:03:00',216,100),(235,1,'not working',1,'2022-04-28 12:03:00',216,80),(236,1,'wrong size',1,'2022-04-28 12:03:00',216,76),(237,1,'not working',1,'2022-04-28 12:03:00',216,14),(238,1,'none given',1,'2022-04-28 14:48:00',218,23),(239,1,'none given',1,'2022-04-28 14:48:00',218,42),(240,1,'not working',1,'2022-04-28 14:48:00',218,91),(241,1,'not working',0,'2022-04-28 14:48:00',218,9),(242,1,'not working',1,'2022-04-28 14:48:00',218,37),(243,1,'wrong size',0,'2022-04-28 14:48:00',218,16),(244,1,'none given',1,'2022-04-28 17:41:00',212,57),(245,1,'none given',1,'2022-04-28 17:41:00',212,21),(246,1,'none given',0,'2022-04-28 17:41:00',212,4),(247,1,'not working',1,'2022-04-28 17:41:00',212,70),(248,1,'not working',1,'2022-04-28 17:41:00',212,71),(249,1,'none given',1,'2022-04-28 17:41:00',212,84);


DROP TABLE IF EXISTS crm_customer;

CREATE TABLE crm_customer (
  id int NOT NULL,
  customerNo int NOT NULL,
  email varchar(255) DEFAULT NULL,
	isKeyCustomer boolean DEFAULT false,
  PRIMARY KEY (id)
);

INSERT INTO crm_customer VALUES (2,20220019,'michael.loehr@alas.it',false)








