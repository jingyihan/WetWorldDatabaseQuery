-- Q3.

SET SEARCH_PATH TO wetworldschema;
DROP TABLE IF EXISTS q3 CASCADE;

CREATE TABLE q3 (
      avg_site_capacity VARCHAR(30),
      avg_fee NUMERIC(2)
);

DROP VIEW IF EXISTS book_volume CASCADE;
DROP VIEW IF EXISTS capacity_day_open CASCADE;
DROP VIEW IF EXISTS capacity_night_open CASCADE;
DROP VIEW IF EXISTS capacity_day_cave CASCADE;
DROP VIEW IF EXISTS capacity_night_cave CASCADE;
DROP VIEW IF EXISTS capacity_day_deep CASCADE;
DROP VIEW IF EXISTS capacity_night_deep CASCADE;
DROP VIEW IF EXISTS capacity_all CASCADE;
DROP VIEW IF EXISTS booking_extra_fee CASCADE;
DROP VIEW IF EXISTS booking_monitor_fee CASCADE;
DROP VIEW IF EXISTS booking_site_fee CASCADE;
DROP VIEW IF EXISTS fee CASCADE;

CREATE VIEW book_volume AS
SELECT Booking.Book_id, site_id, dive_type, book_timeslot, count(Bookinggroup.book_id) + 2 as volume
FROM Booking LEFT JOIN Bookinggroup ON Booking.book_id = Bookinggroup.book_id
GROUP BY Booking.Book_id, site_id, dive_type, book_timeslot;

CREATE VIEW capacity_day_open AS
SELECT Divesites.site_id, sum(volume) as volume, day_open_cap as capacity
FROM Divesites JOIN book_volume ON book_volume.site_id = Divesites.site_id
WHERE book_volume.book_timeslot IN ('morning', 'afternoon') AND book_volume.dive_type = 'open'
GROUP BY Divesites.site_id, Book_id, day_open_cap;

CREATE VIEW capacity_night_open AS
SELECT Divesites.site_id, sum(volume) as volume, night_open_cap as capacity
FROM Divesites JOIN book_volume ON book_volume.site_id = Divesites.site_id
WHERE book_volume.book_timeslot IN ('night') AND book_volume.dive_type = 'open'
GROUP BY Divesites.site_id, night_open_cap;

CREATE VIEW capacity_day_cave AS
SELECT Divesites.site_id, sum(volume) as volume, day_cave_cap as capacity
FROM Divesites JOIN book_volume ON book_volume.site_id = Divesites.site_id
WHERE book_volume.book_timeslot IN ('morning', 'afternoon') AND book_volume.dive_type = 'cave'
GROUP BY Divesites.site_id, day_cave_cap;

CREATE VIEW capacity_night_cave AS
SELECT Divesites.site_id, sum(volume) as volume, day_cave_cap as capacity
FROM Divesites JOIN book_volume ON book_volume.site_id = Divesites.site_id
WHERE book_volume.book_timeslot IN ('night') AND book_volume.dive_type = 'cave'
GROUP BY Divesites.site_id, day_cave_cap;

CREATE VIEW capacity_day_deep AS
SELECT Divesites.site_id, sum(volume) as volume, day_deep_cap as capacity
FROM Divesites JOIN book_volume ON book_volume.site_id = Divesites.site_id
WHERE book_volume.book_timeslot IN ('morning', 'afternoon') AND book_volume.dive_type = 'deep'
GROUP BY Divesites.site_id, day_deep_cap;

CREATE VIEW capacity_night_deep AS
SELECT Divesites.site_id, sum(volume) as volume, night_deep_cap as capacity
FROM Divesites JOIN book_volume ON book_volume.site_id = Divesites.site_id
WHERE book_volume.book_timeslot IN ('night') AND book_volume.dive_type = 'deep'
GROUP BY Divesites.site_id, night_deep_cap;

CREATE VIEW capacity_all AS
(SELECT site_id, 'more than half' as fullness 
FROM ((SELECT * FROM capacity_day_open) UNION
	(SELECT * FROM capacity_night_open) UNION
	(SELECT * FROM capacity_day_cave) UNION
	(SELECT * FROM capacity_night_cave) UNION
	(SELECT * FROM capacity_day_deep) UNION
	(SELECT * FROM capacity_night_deep)) a
GROUP BY site_id HAVING AVG(volume/capacity) > 0.5) 
UNION
(SELECT site_id, 'less than half' as fullness 
FROM ((SELECT * FROM capacity_day_open) UNION
	(SELECT * FROM capacity_night_open) UNION
	(SELECT * FROM capacity_day_cave) UNION
	(SELECT * FROM capacity_night_cave) UNION
	(SELECT * FROM capacity_day_deep) UNION
	(SELECT * FROM capacity_night_deep)) a
GROUP BY site_id HAVING AVG(volume/capacity) <= 0.5);

CREATE VIEW booking_extra_fee AS
(SELECT distinct Bookingservices.book_id, Bookingservices.site_id, sum(Diveservices.price) as extra_fee
FROM Bookingservices LEFT JOIN Diveservices 
	 ON Bookingservices.site_id = Diveservices.site_id AND Bookingservices.book_service = Diveservices.service
GROUP BY Bookingservices.book_id, Bookingservices.site_id)
UNION
(SELECT Booking.book_id, Booking.site_id, 0 as extra_fee
FROM Booking
WHERE NOT EXISTS (SELECT * FROM Bookingservices
				  WHERE Booking.book_id = Bookingservices.book_id));

CREATE VIEW booking_monitor_fee AS
SELECT distinct Booking.book_id, Booking.site_id, Booking.book_timeslot, Monitorprice.time_slot, price as monitor_fee
FROM Booking LEFT JOIN Monitorprice 
	 ON Booking.site_id = Monitorprice.site_id AND Booking.book_timeslot = Monitorprice.time_slot
	 AND Booking.dive_type = Monitorprice.dive_type;

CREATE VIEW booking_site_fee AS
SELECT distinct Booking.book_id, Booking.site_id, price as site_fee
FROM Booking LEFT JOIN Divesites 
	 ON Booking.site_id = Divesites.site_id;

CREATE VIEW fee AS
SELECT booking_site_fee.site_id, booking_site_fee.book_id, (extra_fee + monitor_fee + site_fee + 0.0) as fee
FROM booking_site_fee LEFT JOIN booking_monitor_fee ON booking_site_fee.book_id = booking_monitor_fee.book_id
				  LEFT JOIN booking_extra_fee ON booking_extra_fee.book_id = booking_site_fee.book_id;

INSERT INTO q3
SELECT fullness, avg(fee) as avg_fee
FROM capacity_all NATURAL JOIN fee 
GROUP BY fullness;







