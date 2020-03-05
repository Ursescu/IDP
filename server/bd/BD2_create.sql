-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-01-05 14:48:32.66

-- tables
-- Table: movie_ecranisation_type
CREATE TABLE movie_ecranisation_type (
    id int NOT NULL AUTO_INCREMENT,
    name varchar(100) NOT NULL,
    CONSTRAINT movie_ecranisation_type_pk PRIMARY KEY (id)
);

-- Table: movies
CREATE TABLE movies (
    id int NOT NULL AUTO_INCREMENT,
    name varchar(100) NOT NULL,
    duration_seconds int NOT NULL,
    ecranisation_type int NOT NULL,
    CONSTRAINT movies_pk PRIMARY KEY (id)
);

-- Table: room_ecranisation_type
CREATE TABLE room_ecranisation_type (
    id int NOT NULL AUTO_INCREMENT,
    room_id int NOT NULL,
    ecranisation_type_id int NOT NULL,
    CONSTRAINT room_ecranisation_type_pk PRIMARY KEY (id)
);

-- Table: rooms
CREATE TABLE rooms (
    id int NOT NULL AUTO_INCREMENT,
    name varchar(100) NOT NULL,
    CONSTRAINT rooms_pk PRIMARY KEY (id)
);

-- Table: schedules
CREATE TABLE schedules (
    id int NOT NULL AUTO_INCREMENT,
    timestamp datetime NOT NULL,
    movie_id int NOT NULL,
    room_id int NOT NULL,
    CONSTRAINT schedules_pk PRIMARY KEY (id)
);

-- Table: seat_occupation_seat
CREATE TABLE seat_occupation_seat (
    id int NOT NULL AUTO_INCREMENT,
    seats_id int NOT NULL,
    occupied bool NOT NULL,
    schedule_id int NOT NULL,
    CONSTRAINT seat_occupation_seat_pk PRIMARY KEY (id)
);

-- Table: seats
CREATE TABLE seats (
    id int NOT NULL AUTO_INCREMENT,
    room_id int NOT NULL,
    seat_id int NOT NULL,
    CONSTRAINT seats_pk PRIMARY KEY (id)
);

-- foreign keys
-- Reference: movie_ecranisation_type_movies (table: movies)
ALTER TABLE movies ADD CONSTRAINT movie_ecranisation_type_movies FOREIGN KEY movie_ecranisation_type_movies (ecranisation_type)
    REFERENCES movie_ecranisation_type (id);

-- Reference: movies_schedules (table: schedules)
ALTER TABLE schedules ADD CONSTRAINT movies_schedules FOREIGN KEY movies_schedules (movie_id)
    REFERENCES movies (id);

-- Reference: rooms_ecranisations_movie_ecranisation_type (table: room_ecranisation_type)
ALTER TABLE room_ecranisation_type ADD CONSTRAINT rooms_ecranisations_movie_ecranisation_type FOREIGN KEY rooms_ecranisations_movie_ecranisation_type (ecranisation_type_id)
    REFERENCES movie_ecranisation_type (id);

-- Reference: rooms_ecranisations_rooms (table: room_ecranisation_type)
ALTER TABLE room_ecranisation_type ADD CONSTRAINT rooms_ecranisations_rooms FOREIGN KEY rooms_ecranisations_rooms (room_id)
    REFERENCES rooms (id);

-- Reference: rooms_schedules (table: schedules)
ALTER TABLE schedules ADD CONSTRAINT rooms_schedules FOREIGN KEY rooms_schedules (room_id)
    REFERENCES rooms (id);

-- Reference: seat_occupation_seat_schedules (table: seat_occupation_seat)
ALTER TABLE seat_occupation_seat ADD CONSTRAINT seat_occupation_seat_schedules FOREIGN KEY seat_occupation_seat_schedules (schedule_id)
    REFERENCES schedules (id);

-- Reference: seat_occupation_seat_seats (table: seat_occupation_seat)
ALTER TABLE seat_occupation_seat ADD CONSTRAINT seat_occupation_seat_seats FOREIGN KEY seat_occupation_seat_seats (seats_id)
    REFERENCES seats (id);

-- Reference: seats_rooms (table: seats)
ALTER TABLE seats ADD CONSTRAINT seats_rooms FOREIGN KEY seats_rooms (room_id)
    REFERENCES rooms (id);

-- End of file.

