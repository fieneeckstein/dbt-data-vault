INSERT INTO crm_customer VALUES ((SELECT max(id)+1 FROM crm_customer),999, 'k.peters@ostfalia.de', false );

UPDATE product SET price = 70.0, lastupdate = '2024-01-04 12:00:00' WHERE ean ='4717784026121';

INSERT INTO product VALUES ((SELECT max(id)+1 FROM product) ,'2,4 - 4,1 bar',12345,'58-559','AM','26x2.30',0,'Minion DHF, 26x2.30, EXO TR','2022-04-01 12:00:00',99,'Dual','EXO TR',845);


INSERT INTO purchase VALUES ((SELECT max(id)+1 FROM purchase),'2024-01-05 13:23:00','2024-01-05 13:23:00','2024-01-05 03:23:00',11111,2,'2024-01-05 04:23:00',1);

INSERT INTO item VALUES ((SELECT max(id)+1 FROM item),1,(SELECT max(id) FROM purchase),(SELECT id FROM product where ean = '12345'));

INSERT INTO item VALUES ((SELECT max(id)+1 FROM item),1,(SELECT max(id) FROM purchase),(SELECT id FROM product where ean = '4717784026121'));


