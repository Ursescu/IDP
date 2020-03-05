DELIMITER //


DROP PROCEDURE IF EXISTS `debug_msg` //


CREATE PROCEDURE debug_msg(enabled INTEGER, msg VARCHAR(255))
BEGIN
    IF enabled THEN
        select concat('** ', msg) AS '** DEBUG:';
    END IF;
END //


DROP PROCEDURE IF EXISTS GetEcranisationTypes //

CREATE PROCEDURE GetEcranisationTypes()
BEGIN
    SELECT * FROM movie_ecranisation_type;
END; //


DROP PROCEDURE IF EXISTS GetRooms //
CREATE PROCEDURE GetRooms()
BEGIN
    SELECT 
        rooms.*,
        room_ecranisation_type.ecranisation_type_id as 'room_capabilities',
        movie_ecranisation_type.name as 'ecranisation_name'
    FROM rooms 
    LEFT JOIN room_ecranisation_type ON rooms.id = room_ecranisation_type.room_id
    LEFT JOIN  movie_ecranisation_type ON movie_ecranisation_type.id = room_ecranisation_type.ecranisation_type_id;
END; //


DROP PROCEDURE IF EXISTS GetAllMovies //

CREATE PROCEDURE GetAllMovies()
BEGIN 
    SELECT movies.*, movie_ecranisation_type.name as 'ecranisation_name' FROM movies LEFT JOIN movie_ecranisation_type ON movies.ecranisation_type = movie_ecranisation_type.id;
END; //

-- One function
DROP FUNCTION IF EXISTS GetFreeSeats //

CREATE FUNCTION GetFreeSeats (schedule_id INT)
RETURNS INT
BEGIN

    SELECT count(*) FROM schedules WHERE id = schedule_id INTO @no_schedules;

    IF @no_schedules = 1 THEN
        SELECT count(*) FROM seat_occupation_seat WHERE seat_occupation_seat.schedule_id = schedule_id AND seat_occupation_seat.occupied = FALSE INTO @no_free_seats;
        RETURN @no_free_seats;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No schedule found';
        RETURN 0;
    END IF; 

END; //

DROP PROCEDURE IF EXISTS InsertMovie //
CREATE PROCEDURE InsertMovie (IN movie_name VARCHAR(100), IN movie_duration INT, IN movie_ecranisation INT)

BEGIN
    INSERT INTO
            movies (name, duration_seconds, ecranisation_type)
    VALUES (movie_name, movie_duration, movie_ecranisation);
END; //

DROP PROCEDURE IF EXISTS GetMovie //

CREATE PROCEDURE GetMovie (IN movie_id INT) 
BEGIN
    SELECT movies.*, movie_ecranisation_type.name as 'ecranisation_name' FROM movies LEFT JOIN movie_ecranisation_type ON movies.ecranisation_type = movie_ecranisation_type.id WHERE movies.id = movie_id;
END; //


DROP PROCEDURE IF EXISTS GetScheaduleSeats //

CREATE PROCEDURE GetScheaduleSeats(IN schedule_id INT)
BEGIN

    SELECT count(*) FROM schedules WHERE id = schedule_id INTO @no_schedules;

    IF @no_schedules = 1 THEN
        SELECT seat_occupation_seat.*, seats.seat_id FROM seat_occupation_seat LEFT JOIN seats ON seat_occupation_seat.seats_id = seats.id WHERE seat_occupation_seat.schedule_id = schedule_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No schedule found';
    END IF; 

END; //

DROP PROCEDURE IF EXISTS BuyTickets //

CREATE PROCEDURE BuyTickets(IN schedule_id INT, IN seat_id INT)
BEGIN

    SELECT count(*) FROM schedules WHERE id = schedule_id INTO @no_schedules;

    IF @no_schedules = 1 THEN
        UPDATE seat_occupation_seat
        SET occupied = TRUE
        WHERE seat_occupation_seat.schedule_id = schedule_id AND seat_occupation_seat.seats_id = seat_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No schedule found';
    END IF; 

END; //

DROP PROCEDURE IF EXISTS GetAllTimeSchedules //
CREATE PROCEDURE GetAllTimeSchedules ()
BEGIN
    SELECT 
        schedules.*,
        rooms.name as 'room_name',
        movies.name as 'movie_name',
        movies.duration_seconds as 'movie_duration',
        movie_ecranisation_type.name as 'ecranisation_name',
        GetFreeSeats(schedules.id) as 'free_seats'
    FROM 
        schedules
    LEFT JOIN movies ON movies.id = schedules.movie_id
    LEFT JOIN rooms ON rooms.id = schedules.room_id
    LEFT JOIN movie_ecranisation_type ON movie_ecranisation_type.id = movies.ecranisation_type;

END; //

DROP PROCEDURE IF EXISTS GetSchedulesFromNow //

CREATE PROCEDURE GetSchedulesFromNow ()
BEGIN

    SET @timenow = CURRENT_TIMESTAMP();

    SELECT 
        schedules.*,
        rooms.name as 'room_name',
        movies.name as 'movie_name',
        movies.duration_seconds as 'movie_duration',
        movie_ecranisation_type.name as 'ecranisation_name',
        GetFreeSeats(schedules.id) as 'free_seats'
    FROM 
        schedules
    LEFT JOIN movies ON movies.id = schedules.movie_id
    LEFT JOIN rooms ON rooms.id = schedules.room_id
    LEFT JOIN movie_ecranisation_type ON movie_ecranisation_type.id = movies.ecranisation_type
    WHERE schedules.timestamp >= @timenow;

END; //


DROP PROCEDURE IF EXISTS InsertSchedule //
CREATE PROCEDURE InsertSchedule (IN timestamp VARCHAR(200), IN movie_id INT, IN room_id INT)
BEGIN
    INSERT INTO schedules (timestamp, movie_id, room_id)
    VALUES (CONVERT(timestamp, DATETIME), movie_id, room_id);
END; //

DROP PROCEDURE IF EXISTS GetSchedule //

CREATE PROCEDURE GetSchedule (IN schedule_id INT)
BEGIN

    SET @timenow = CURRENT_TIMESTAMP();

    SELECT 
        schedules.*,
        rooms.name as 'room_name',
        movies.name as 'movie_name',
        movies.duration_seconds as 'movie_duration',
        movie_ecranisation_type.name as 'ecranisation_name'
    FROM 
        schedules
    LEFT JOIN movies ON movies.id = schedules.movie_id
    LEFT JOIN rooms ON rooms.id = schedules.room_id
    LEFT JOIN movie_ecranisation_type ON movie_ecranisation_type.id = movies.ecranisation_type
    WHERE schedules.timestamp >= @timenow AND schedules.id = schedule_id;

END; //


DELIMITER ;

