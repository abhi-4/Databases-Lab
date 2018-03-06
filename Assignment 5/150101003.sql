/*a*/
SELECT 	DISTINCT course_id
FROM 	ScheduledIn AS S 
WHERE 	S.room_number = '2001';
/* distinct courses from the relation where room_number is 2001*/

/*b*/
SELECT  DISTINCT course_id 
FROM 	ScheduledIn AS S
WHERE 	S.letter = 'C';
/* distinct courses from the relation where slot number is C*/

/*c*/
SELECT 	DISTINCT 	division 
FROM 	ScheduledIn AS S
WHERE 	S.room_number = 'L2' 
	  	OR S.room_number='L3';
/* distinct division where room_number used is L2 or L3 */

/*d*/
SELECT 	DISTINCT 	S1.course_id
FROM	 	ScheduledIn AS S1
INNER  JOIN	ScheduledIn S2
ON 			S1.course_id = S2.course_id
WHERE 		NOT	S1.room_number = S2.room_number;
/* the table is joined to itself on common course_id, 
we obtain two columns of room_number
this way we can compare the two columns of room_number
to know if the course is scheduled in two different rooms*/

/*e*/
SELECT 	DISTINCT name 
FROM 	Department AS D
WHERE 	D.department_id 
		IN 	(	SELECT department_id 
	   	 		FROM 	ScheduledIn AS S
	     		WHERE  	S.room_number = 'L1'
			     		OR S.room_number = 'L2' 
					 	OR S.room_number='L3'
					 	OR S.room_number = 'L1');
/* department name is selected which does lie in the table containing
the departments who have courses in any of the lecture halls*/

/*f*/
SELECT 	DISTINCT name 
FROM 	Department AS D
WHERE 	NOT D.department_id 
		IN (	SELECT 	department_id 
	   	 		FROM 	ScheduledIn AS S
	     		WHERE  	S.room_number = 'L1'
	     				OR S.room_number = 'L2');
/*we obtain a list of departments who have classes in either L1 or L2
finally we return the department names whose name does not lie in this table*/

/*g*/

SELECT 	department_id 
FROM (	SELECT 	department_id, COUNT(department_id) AS frequency
		FROM 	(SELECT	DISTINCT 	department_id, letter
				FROM 	ScheduledIn) AS D /*distinct dept_id, letter list*/
		GROUP BY department_id
		) AS S /*this table contains the frequence of each department in 
				the last table*/
WHERE 	S.frequency = '17';
/*finally we check if the frequency to be 17 as it is the 
total number of slots available*/


/*h*/
SELECT 		letter as slot, 
			COUNT(course_id) AS course_count
FROM 	(	SELECT DISTINCT letter, course_id
			FROM ScheduledIn	) AS D /*distinct letter, course_id list*/
GROUP BY 	letter
ORDER BY 	course_count ASC;
/*we count the frequency of slot of each letter in the table
and arrange in ascending order of its frequency*/


/*i*/
SELECT 		room_number, 
			COUNT(course_id) AS course_count
FROM 	(	SELECT DISTINCT room_number, course_id
			FROM ScheduledIn	) AS D /*distinct room, course_id*/
GROUP BY 	room_number
ORDER BY 	course_count DESC;
/*we count the frequency of each room_number in the table 
and arrange in descending order of frequency*/

/*j*/
SELECT 	slot 
FROM	(SELECT 		letter as slot, 
					COUNT(course_id) AS course_count
		FROM 	(	SELECT DISTINCT letter, course_id
					FROM ScheduledIn	) AS S/*distinct letter, course_id*/
		GROUP BY 	letter
		ORDER BY 	course_count ASC	) AS D/*count the frequency of each slot
		in the table and arrange in ascending order*/	
LIMIT 	1;	
/*finally take the first entry in ascending order list as it will have 
smallest value*/

/*k*/
SELECT 	DISTINCT 	letter
FROM 	ScheduledIn
WHERE 	(course_id LIKE '%M');
/*we select the course_id ending in M which are minor courses a
then we select its letter*/


/*l*/
SELECT 	DISTINCT name, letter
FROM 	Department CROSS JOIN Slot /*this table all possible pairs of department and slot*/
WHERE 	(department_id, letter) NOT IN /*check for every possible pair to not be in the ScheduledIN*/
		(SELECT 	DISTINCT department_id, letter FROM 	ScheduledIn)
ORDER BY name,letter;
/*first we obtain all possible values of departmentid and letter and 
check if this pair exists in ScheduledIn or not i.e. if the department 
has any course in this slot or not and we return the value if it does not lie in it*/

LOAD DATA LOCAL INFILE '/home/abhi/CS345/Assignment 4/csv files/150101003_Department.csv' 
INTO TABLE Department 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
(department_id, name);

LOAD DATA LOCAL INFILE '/home/abhi/CS345/Assignment 4/csv files/150101003_Course.csv' 
INTO TABLE Course
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
(course_id, division);

LOAD DATA LOCAL INFILE '/home/abhi/CS345/Assignment 4/csv files/150101003_Room.csv' 
INTO TABLE Room
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
(room_number, location);

LOAD DATA LOCAL INFILE '/home/abhi/CS345/Assignment 4/csv files/150101003_Slot.csv' 
INTO TABLE Slot
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
(letter, day, start_time, end_time);

LOAD DATA LOCAL INFILE '/home/abhi/CS345/Assignment 4/csv files/150101003_ScheduledIn2.csv' 
INTO TABLE ScheduledIn
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
(course_id, division, department_id, letter, day, room_number);