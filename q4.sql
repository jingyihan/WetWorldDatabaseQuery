SET SEARCH_PATH TO wetworldschema;
DROP TABLE IF EXISTS q4 CASCADE;

CREATE TABLE q4 (
      site_id INT,
      highest_fee NUMERIC(2),
      lowest_fee NUMERIC(2),
      avg_fee NUMERIC(2)
);

DROP VIEW IF EXISTS booking_extra_fee CASCADE;
DROP VIEW IF EXISTS booking_monitor_fee CASCADE;
DROP VIEW IF EXISTS booking_site_fee CASCADE;
DROP VIEW IF EXISTS fee CASCADE;

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

INSERT INTO q4
(SELECT site_id, max(fee) as highest_fee, min(fee) as lowest_fee, avg(fee) as avg_fee
FROM fee
GROUP BY site_id)
UNION
(SELECT site_id, 0 as highest_fee, 0 as lowest_fee, 0 as avg_fee
FROM Divesites
WHERE NOT EXISTS (SELECT * FROM fee
				  WHERE Divesites.site_id = fee.site_id))
ORDER BY site_id;
