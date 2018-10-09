DROP TEMPORARY TABLE IF EXISTS exceeding_credit;
CREATE TEMPORARY TABLE exceeding_credit(roll int, name varchar(255), total_credits int);
DROP PROCEDURE IF EXISTS count_credits;

DELIMITER $$

CREATE PROCEDURE count_credits()
BEGIN

	DECLARE done INT DEFAULT 0;/*used for loop exit condition*/
	DECLARE roll1 INT;
	DECLARE course VARCHAR(255);
	DECLARE name VARCHAR(255);
	DECLARE credit INT;
	DECLARE roll2 INT;
	DECLARE total_credit INT;

	DECLARE cc CURSOR FOR SELECT DISTINCT c.roll_number AS roll, c.course_id AS course, e.number_of_credits AS credit
							 FROM cwsl AS c
							 INNER JOIN cc AS e
							 ON c.course_id = e.course_id
							 WHERE roll_number = roll1;/*contains roll, course_id, credits */
	DECLARE students CURSOR FOR SELECT DISTINCT c.roll_number AS roll, c.name AS name
								FROM cwsl AS c;/*list of all the registered students roll number*/

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done := '1';/*done set to 1 on nothing obtained in fetch operation*/

	OPEN students;

	outer_loop: LOOP 

		FETCH FROM students INTO roll1, name;/*traverses through roll number of students*/

		IF done = 1 THEN /*loop exit condition*/
			LEAVE outer_loop;
		END IF;

		SET total_credit := 0;/*total credit initialization*/
		OPEN cc;

		inner_loop: LOOP
			
			FETCH FROM cc INTO roll2, course, credit;/*stores roll number, course id and no of credits of the course*/

			IF done = 1 THEN /*loop exit condition*/
				SET done:= 0;/*takes care that outer loop not exited*/
				LEAVE inner_loop;
			END IF;

			IF roll1 = roll2 THEN/*finding courses of the roll1 roll number*/
				SET total_credit = credit + total_credit;/*credits added to total*/
			END IF;

		END LOOP inner_loop;
		CLOSE cc;

		IF total_credit > 40 THEN/*displaying the roll no of students violating total credit constraint*/
			INSERT INTO exceeding_credit VALUES(roll1, name, total_credit);
			/*dbms_output.put_line(roll1 || total_credit);*/
		END IF;
		

	END LOOP outer_loop;	
	SELECT * FROM exceeding_credit;

END$$
DELIMITER ;
