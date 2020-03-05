DELIMITER //

DROP TRIGGER IF EXISTS ScheduleInsertUpdateSeats //

CREATE TRIGGER ScheduleInsertUpdateSeats
    AFTER INSERT ON schedules FOR EACH ROW
BEGIN
    DECLARE msg VARCHAR(256);

    SET @sched_id = new.id;
    SET @sched_room_id = new.room_id;

    -- Check if the room support it

    SELECT ecranisation_type FROM movies WHERE movies.id = new.movie_id INTO @movie_type;

    SELECT count(*) FROM room_ecranisation_type WHERE room_id = @sched_room_id AND ecranisation_type_id = @movie_type INTO @room_ecranisation;

    IF @room_ecranisation > 0 THEN 
        INSERT INTO
            seat_occupation_seat (seats_id, occupied, schedule_id)
        SELECT
            id as seats_id,
            FALSE as occupied,
            @sched_id as schedule_id
        FROM
            seats
        WHERE
            seats.room_id = @sched_room_id;
    ELSE
        set msg = 'ScheduleTriggerError: Trying to insert seats of a room that does not have proper ecranisation type';
        signal sqlstate '45000' set message_text = msg;
    END IF;

END //


DELIMITER ;