-- Q2

SET SEARCH_PATH TO wetworldschema;
DROP TABLE IF EXISTS q2 CASCADE;

CREATE TABLE q2 (
      monitor_id INT,
      avg_booking_fee NUMERIC(2),
      email VARCHAR(30)
);

DROP VIEW IF EXISTS monitor_avg CASCADE;
DROP VIEW IF EXISTS site_avg CASCADE;

CREATE VIEW monitor_avg AS
SELECT monitor_id, AVG(rating) as monitor_rating
FROM Ratemonitor
GROUP BY monitor_id;

CREATE VIEW site_avg AS
SELECT site_id, AVG(rating) as site_rating
FROM Ratesite
GROUP BY site_id;

INSERT INTO q2
SELECT monitor_id, AVG(price) as avg_booking_fee, monitor_email
FROM (monitor_avg NATURAL JOIN Monitor NATURAL JOIN Monitorprice) m
WHERE monitor_rating > ALL (SELECT site_rating 
                        FROM (site_avg NATURAL JOIN Privileges) s
                        WHERE m.monitor_id = s.monitor_id)
GROUP BY monitor_id, monitor_email;







