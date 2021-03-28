-- Wet World Schema.

DROP SCHEMA IF EXISTS wetworldschema CASCADE;
CREATE SCHEMA wetworldschema;
SET SEARCH_PATH to wetworldschema;

CREATE TABLE Monitor (
  -- the unique identifier of the monitor
  monitor_id INT PRIMARY KEY,
  monitor_name VARCHAR(50) NOT NULL,
  monitor_email VARCHAR(50)
);

CREATE TYPE site_time AS ENUM ('daylight', 'night');
CREATE TABLE Divesites (
  site_id INT PRIMARY KEY,
  site_name VARCHAR(50) NOT NULL,
  location VARCHAR(50) NOT NULL,
  day_open_cap INT NOT NULL check (day_open_cap >= 0),
  night_open_cap INT NOT NULL check (night_open_cap >= 0),
  day_cave_cap INT NOT NULL check (day_cave_cap >= 0),
  night_cave_cap INT NOT NULL check (night_cave_cap >= 0),
  day_deep_cap INT NOT NULL check (day_deep_cap >= 0),
  night_deep_cap INT NOT NULL check (night_deep_cap >= 0),
  price INT NOT NULL check (price >= 0)
);

CREATE TYPE dive_type AS ENUM ('open', 'cave', 'deep');
CREATE TYPE time_slot AS ENUM ('morning', 'afternoon', 'night');
CREATE TABLE Monitorprice (
  -- the unique identifier of the monitor, dive type, and session
  monitor_id INT REFERENCES Monitor ON UPDATE CASCADE ON DELETE CASCADE,
  site_id INT REFERENCES Divesites ON UPDATE CASCADE ON DELETE CASCADE,
  dive_type dive_type check(dive_type in ('open', 'cave', 'deep')),
  time_slot time_slot check(time_slot in ('morning', 'afternoon', 'night')),
  -- monitor price
  price INT NOT NULL,
  PRIMARY KEY (monitor_id, site_id, dive_type, time_slot)
);

CREATE TABLE Monitorcapacity (
  -- the unique identifier of the monitor, dive type, and session
  monitor_id INT REFERENCES Monitor ON UPDATE CASCADE ON DELETE CASCADE,
  -- monitor capacity
  open_cap INT NOT NULL,
  cave_cap INT NOT NULL,
  deep_cap INT NOT NULL,
  PRIMARY KEY (monitor_id)
);

CREATE TABLE Privileges (
  site_id INT REFERENCES Divesites ON UPDATE CASCADE ON DELETE CASCADE,
  monitor_id INT REFERENCES Monitor ON UPDATE CASCADE ON DELETE CASCADE,
  PRIMARY KEY (site_id, monitor_id)
);

CREATE TYPE services AS ENUM ('mask', 'regulator', 'fin','dive computer', 'buoyancy','weightbelts',
                              '12 aluminum tank', 'video dives', 'snack', 'towel', 'hot shower');
CREATE TABLE Diveservices (
  site_id INT REFERENCES Divesites ON UPDATE CASCADE ON DELETE CASCADE,
  service services,
  price INT NOT NULL,
  check ((service IN ('12 aluminum tank', 'buoyancy', 'weightbelts') AND price = 0)
        OR (service IN ('mask', 'regulator', 'fin','dive computer','video dives', 'snack', 'towel', 'hot shower') 
          AND price >= 0)),
  PRIMARY KEY (site_id, service)
);

CREATE TYPE certification AS ENUM ('NAUI', 'CMAS', 'PADI');
CREATE TABLE Divers (
  diver_id INT PRIMARY KEY,
  -- The name of the diver.
  firstname VARCHAR(50) NOT NULL,
  lastname VARCHAR(50) NOT NULL,
  -- The email of the passenger.
  email VARCHAR(30),
  -- The age of the passenger.
  birthday DATE NOT NULL check (birthday <= now() - interval '16 year'),
  -- The certification of the passenger.
  certification certification NOT NULL
);

CREATE TABLE Booking (
  book_id INT,
  -- diver info
  diver_id INT REFERENCES Divers ON UPDATE CASCADE ON DELETE CASCADE,
  -- dive monitor of the booking
  monitor_id INT REFERENCES Monitor ON UPDATE CASCADE ON DELETE CASCADE,
  -- dive site of the booking
  site_id INT REFERENCES Divesites ON UPDATE CASCADE ON DELETE CASCADE,
  -- dive type of the booking
  dive_type dive_type NOT NULL,
  -- lead diver credit_card_info
  credit_card VARCHAR(30) NOT NULL,
  -- timestamp of booking
  book_date date NOT NULL,
  book_timeslot time_slot NOT NULL,
  unique (diver_id, book_date, book_timeslot),
  unique (monitor_id, book_date, book_timeslot),
  unique (monitor_id, book_date, book_timeslot),
  PRIMARY KEY (book_id)
);

CREATE TABLE Bookinggroup (
  book_id INT REFERENCES Booking ON UPDATE CASCADE ON DELETE CASCADE,
  -- The id of the lead.
  lead_diver_id INT REFERENCES Divers(diver_id) ON UPDATE CASCADE ON DELETE CASCADE,
  -- The id of the diver.
  diver_id INT REFERENCES Divers ON UPDATE CASCADE ON DELETE CASCADE,
  PRIMARY KEY (book_id, lead_diver_id, diver_id)
);

CREATE TABLE Bookingservices (
  book_id INT REFERENCES Booking ON UPDATE CASCADE ON DELETE CASCADE,
  site_id INT,
  book_service services,
  PRIMARY KEY (book_id, site_id, book_service),
  FOREIGN KEY (site_id, book_service) REFERENCES Diveservices(site_id, service) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Ratesite (
  diver_id INT REFERENCES Divers(diver_id) ON UPDATE CASCADE ON DELETE CASCADE,
  site_id INT REFERENCES Divesites(site_id) ON UPDATE CASCADE ON DELETE CASCADE,
  rating INT check (rating >= 0 and rating <= 5),
  PRIMARY KEY (diver_id, site_id)
);

CREATE TABLE Ratemonitor (
  lead_diver_id INT REFERENCES Divers(diver_id) ON UPDATE CASCADE ON DELETE CASCADE,
  book_id INT REFERENCES Booking(book_id) ON UPDATE CASCADE ON DELETE CASCADE,
  monitor_id INT REFERENCES Monitor(monitor_id) ON UPDATE CASCADE ON DELETE CASCADE,
  rating INT check (rating >= 0 and rating <= 5),
  PRIMARY KEY (lead_diver_id, book_id, monitor_id)
);





