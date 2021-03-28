-- Q1

SET SEARCH_PATH TO wetworldschema;
DROP TABLE IF EXISTS q1 CASCADE;

CREATE TABLE q1 (
    site_type CHAR(4),
    num_sites INT
);

DROP VIEW IF EXISTS Divesites_open CASCADE;
DROP VIEW IF EXISTS Divesites_cave CASCADE;
DROP VIEW IF EXISTS Divesites_deep CASCADE;

-- Define views for intermediate steps here:
CREATE VIEW Divesites_open AS
SELECT 'open' as site_type, count(site_id) as num_sites
FROM Divesites site
WHERE (day_open_cap > 0 AND EXISTS (SELECT * 
  FROM (Monitorcapacity NATURAL JOIN Monitorprice) monitor
  WHERE site.site_id = monitor.site_id AND time_slot IN ('morning', 'afternoon')
  AND dive_type = 'open' AND open_cap > 0))
  OR (night_open_cap > 0 AND EXISTS (SELECT * 
  FROM (Monitorcapacity NATURAL JOIN Monitorprice) monitor
  WHERE site.site_id = monitor.site_id AND time_slot IN ('night')
  AND dive_type = 'open' AND open_cap > 0));

CREATE VIEW Divesites_cave AS
SELECT 'cave' as site_type, count(site_id) as num_sites
FROM Divesites site
WHERE (day_open_cap > 0 AND EXISTS (SELECT * 
  FROM (Monitorcapacity NATURAL JOIN Monitorprice) monitor
  WHERE site.site_id = monitor.site_id AND time_slot IN ('morning', 'afternoon')
  AND dive_type = 'cave' AND cave_cap > 0))
  OR (night_open_cap > 0 AND EXISTS (SELECT * 
  FROM (Monitorcapacity NATURAL JOIN Monitorprice) monitor
  WHERE site.site_id = monitor.site_id AND time_slot IN ('night')
  AND dive_type = 'cave' AND cave_cap > 0));


CREATE VIEW Divesites_deep AS
SELECT 'deep' as site_type, count(site_id) as num_sites
FROM Divesites site
WHERE (day_open_cap > 0 AND EXISTS (SELECT * 
  FROM (Monitorcapacity NATURAL JOIN Monitorprice) monitor
  WHERE site.site_id = monitor.site_id AND time_slot IN ('morning', 'afternoon')
  AND dive_type = 'deep' AND deep_cap > 0))
  OR (night_open_cap > 0 AND EXISTS (SELECT * 
  FROM (Monitorcapacity NATURAL JOIN Monitorprice) monitor
  WHERE site.site_id = monitor.site_id AND time_slot IN ('night')
  AND dive_type = 'deep' AND deep_cap > 0));

-- for debuging only
CREATE VIEW Divesites_open_t AS
SELECT site_id, day_open_cap, night_open_cap 
FROM Divesites site
WHERE (day_open_cap > 0 AND EXISTS (SELECT * 
  FROM (Monitorcapacity NATURAL JOIN Monitorprice) monitor
  WHERE site.site_id = monitor.site_id AND time_slot IN ('morning', 'afternoon')
  AND dive_type = 'open' AND open_cap > 0))
  OR (night_open_cap > 0 AND EXISTS (SELECT * 
  FROM (Monitorcapacity NATURAL JOIN Monitorprice) monitor
  WHERE site.site_id = monitor.site_id AND time_slot IN ('night')
  AND dive_type = 'open' AND open_cap > 0));

CREATE VIEW Divesites_cave_t AS
SELECT site_id, day_cave_cap, night_cave_cap
FROM Divesites site
WHERE (day_open_cap > 0 AND EXISTS (SELECT * 
  FROM (Monitorcapacity NATURAL JOIN Monitorprice) monitor
  WHERE site.site_id = monitor.site_id AND time_slot IN ('morning', 'afternoon')
  AND dive_type = 'cave' AND cave_cap > 0))
  OR (night_open_cap > 0 AND EXISTS (SELECT * 
  FROM (Monitorcapacity NATURAL JOIN Monitorprice) monitor
  WHERE site.site_id = monitor.site_id AND time_slot IN ('night')
  AND dive_type = 'cave' AND cave_cap > 0));


CREATE VIEW Divesites_deep_t AS
SELECT site_id, day_deep_cap, night_deep_cap
FROM Divesites site
WHERE (day_open_cap > 0 AND EXISTS (SELECT * 
  FROM (Monitorcapacity NATURAL JOIN Monitorprice) monitor
  WHERE site.site_id = monitor.site_id AND time_slot IN ('morning', 'afternoon')
  AND dive_type = 'deep' AND deep_cap > 0))
  OR (night_open_cap > 0 AND EXISTS (SELECT * 
  FROM (Monitorcapacity NATURAL JOIN Monitorprice) monitor
  WHERE site.site_id = monitor.site_id AND time_slot IN ('night')
  AND dive_type = 'deep' AND deep_cap > 0));

-- final output summarized the sites avaible with at lease one monitor
INSERT INTO q1
(SELECT * FROM Divesites_open) UNION (SELECT * FROM Divesites_cave) UNION (SELECT * FROM Divesites_deep);

