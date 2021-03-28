SET SEARCH_PATH to wetworldschema;

INSERT INTO Monitor VALUES 
	(1, 'Maria', 'Maria@wetworld.com'), (2, 'John', null), (3, 'Ben', 'Ben@wetworld.com');

INSERT INTO Divesites VALUES 
	(1, 'Bloody Bay Marine Park', 'Little Cayman', 15, 0, 15, 10, 10, 0, 10),  
	(2, 'Widow Maker’s Cave', 'Montego Bay', 25, 10, 20, 10, 0, 0, 20), 
	(3, 'Crystal Bay', 'Crystal Bay', 15, 10, 15, 10, 15, 10, 15), 
	(4, 'Batu Bolong', 'Batu Bolong', 15, 5, 15, 5, 15, 5, 15);

INSERT INTO Monitorprice VALUES 
	(1, 1, 'cave', 'night', 25), (1, 2, 'open', 'morning', 10), (1, 2, 'cave', 'morning', 20),
	(1, 3, 'open', 'afternoon', 15), (1, 4, 'cave', 'morning', 30), 
	(2, 1, 'cave', 'morning', 15),
	(3, 2, 'cave', 'morning', 20);

INSERT INTO Monitorcapacity VALUES
	(1, 10, 5, 5), (2, 0, 15, 0), (3, 15, 5, 5);

INSERT INTO Privileges VALUES 
	(1, 1), (2, 1), (3, 1), (1, 2), (3, 2), (2, 3);

INSERT INTO Diveservices VALUES 
	(1, 'mask', 5), (1, 'fin', 10), (2, 'mask', 3), (2, 'fin', 5), (3, 'fin', 5),
	(3, 'dive computer', 20), (4, 'fin', 10), (4, 'dive computer', 30);

INSERT INTO Divers VALUES
	(1, 'Jim', 'Halpert', 'jim@dm.org', '1997-06-01', 'PADI'),
	(2, 'Pam', 'Beesly', 'Pam@dm.org', '1980-10-10', 'PADI'),
	(3, 'Dwight', 'Schrute', 'Dwight@dm.org', '1947-05-16', 'PADI'),
	(4, 'Andy', 'Bernard', 'Dwight@dm.org', '1973-10-10', 'PADI'),
	(5, 'Micheal', 'Armstrong', 'Micheal@dm.org', '1967-03-15', 'PADI'),
	(6, 'Oscars', 'Award', 'Oscars@dm.org', '1970-08-12', 'PADI'),
	(7, 'Phyllis', 'Jack', 'Phyliis@dm.org', '1970-12-12', 'PADI');

INSERT INTO Booking VALUES
	(1, 5, 1, 2, 'open', '176814321564-517-1022', '2019-07-20', 'morning'),
	(2, 5, 1, 2, 'cave', '129910021904-617-1021', '2019-07-21', 'morning'),
	(3, 5, 3, 1, 'cave', '100910931056-630-1029', '2019-07-22', 'morning'),
	(4, 5, 1, 1, 'cave', '111214321564-720-1122', '2019-07-22', 'night'),
	(5, 4, 1, 3, 'open', '100910931056-630-1029', '2019-07-22', 'afternoon'),
	(6, 4, 3, 1, 'cave', '111214321564-720-1122', '2019-07-23', 'morning'),
	(7, 4, 3, 1, 'cave', '100214321564-720-1122', '2019-07-24', 'morning');

INSERT INTO Bookingservices VALUES
	(1, 2, 'mask'), (2, 2, 'fin'), (2, 2, 'mask'), (3, 1, 'mask'), 
	(4, 1, 'mask'), (5, 3, 'dive computer'), (7, 1, 'fin'); 

INSERT INTO Bookinggroup VALUES
	(1, 5, 3), (1, 5, 1), (1, 5, 2),
	(1, 5, 4), (2, 5, 3), (2, 5, 1),
	(3, 5, 1), (5, 4, 3), (5, 4, 1),
	(5, 4, 2), (5, 4, 5), (5, 4, 7),
	(5, 4, 6);

INSERT INTO Ratesite VALUES
	(1, 1, 3), (1, 2, 2), (2, 2, 1),
	(3, 2, 1), (4, 2, 4), (2, 3, 5), 
	(5, 3, 2), (6, 3, 3);

INSERT INTO Ratemonitor VALUES
	(5, 1, 1, 2), (5, 2, 1, 0), (5, 3, 3, 5),
	(4, 5, 1, 1), (4, 6, 3, 0), (4, 7, 3, 2);





