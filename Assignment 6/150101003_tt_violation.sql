DROP TEMPORARY TABLE IF EXISTS violation;
CREATE TEMPORARY TABLE violation(roll int,name varchar(255), course1 varchar(10), course2 varchar(10));
DROP PROCEDURE IF EXISTS tt_violation;
DELIMITER $$

CREATE PROCEDURE tt_violation()
BEGIN

	DECLARE roll1 INT;
	DECLARE course1 VARCHAR(255);
	DECLARE roll5 INT;
	DECLARE course15 VARCHAR(255);
	DECLARE course25 VARCHAR(255);
	DECLARE name VARCHAR(255);
	DECLARE name5 VARCHAR(255);
	DECLARE date1 VARCHAR(255);
	DECLARE time1 VARCHAR(255);
	DECLARE roll2 INT;
	DECLARE course2 VARCHAR(255);
	DECLARE date2 VARCHAR(255);
	DECLARE time2 VARCHAR(255);
	DECLARE done INT DEFAULT 0;/*INITIALLY DONE SET TO 0 TO KEEP LOOP RUNNING*/
	DECLARE a INT DEFAULT 0;


	DECLARE cwsl1 CURSOR FOR SELECT DISTINCT c.roll_number AS roll, c.course_id AS course, e.exam_date AS date, e.start_time AS time, c.name as name
							 FROM cwsl AS c
							 INNER JOIN ett AS e
							 ON c.course_id = e.course_id;

							 /* BOTH THE CURSORS CONTAIN ROLL, COURSE_ID AND 
							 THE EXAM SCHEDULE OF THE COURSE */
	DECLARE cwsl2 CURSOR FOR SELECT DISTINCT c.roll_number AS roll, c.course_id AS course, e.exam_date AS date, e.start_time AS time
							 FROM cwsl AS c
							 INNER JOIN ett AS e
							 ON c.course_id = e.course_id
							 WHERE c.roll_number = roll1 
							 AND NOT c.course_id = course1;
	DECLARE viol CURSOR FOR  SELECT * 
							 FROM violation
							 WHERE roll  = roll1;
	
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done := '1';
	/*DONE TAKES CARE OF LOOP EXIT DONE IS SET TO 1 IF NO VALUE OBTAINED IN FETCH*/
	OPEN cwsl1;
	
	outer_loop : LOOP /*THIS TRAVERSES THE cwsl1 CURSOR*/
		
		FETCH FROM cwsl1 INTO roll1, course1, date1, time1, name;
		/*ASSIGNING ROLL TO ROLL1, COURSE TO COURSE1 AND SO ON*/

		IF done = 1 THEN/*LOOP EXIT CONDITION i.e. NO VALUE OBTAINED ON FETCH*/
			LEAVE outer_loop;
		END IF;

		OPEN cwsl2;

		inner_loop: LOOP/*THIS TRAVERSES THE cwsl2 CURSOR*/
			
			FETCH FROM cwsl2 INTO roll2, course2, date2, time2;

			IF done = 1 THEN/*loop exit condition*/
				SET done := 0;/*this ensures outer loop is not exited*/
				LEAVE inner_loop;
			END IF;

			IF date1 = date2 AND time1 = time2 THEN/*if exam schedule matches*/
				/*INSERT INTO violation VALUES(roll1, course2, course1);*/
				OPEN viol;
				insert_loop: LOOP/*checks if the entry already exists in the table*/
					FETCH FROM viol INTO roll5,name5, course15, course25;
						/*SELECT roll5, course15, course25;*/
					IF done = 1 THEN/*no more records*/
						SET done := 0;/*this ensures outer loop is not exited*/
						INSERT INTO violation VALUES(roll1,name, course1, course2);/*add this entry to the table*/
						LEAVE insert_loop;
					ELSEIF course1 = course15 AND course2 = course25 THEN/*the record already exists*/
						LEAVE insert_loop;/*repeated entry no need to check further exit loop*/
					ELSEIF course2 = course15 AND course1 = course25 THEN/*the record already exists in opposite pair form*/
						LEAVE insert_loop;/*repeated entry no need to check further exit loop*/
					ELSE 
						INSERT INTO violation VALUES(roll1, name, course1, course2);/*add this entry to the table*/
					END IF;
				END LOOP insert_loop;
				CLOSE viol;
			END IF;

		END LOOP inner_loop;

		CLOSE cwsl2;


	END LOOP outer_loop;

	SELECT DISTINCT * FROM violation ORDER BY roll;/*show table entries*/
END $$
DELIMITER ;