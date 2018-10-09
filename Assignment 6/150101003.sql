	CREATE TABLE cc( 
		course_id varchar(6) PRIMARY KEY DEFAULT 'CS101', 
		number_of_credits tinyint DEFAULT 6 NOT NULL, 
		CHECK (credits <=  8)
	); 
-- COURSE ID UNIQUE SO IT IS KEY AND TINYINT ENOUGH FOR CREDITS

	CREATE TABLE ett( 
		line_number int NOT NULL AUTO_INCREMENT PRIMARY KEY,
		course_id varchar(6) NOT NULL DEFAULT 'CS101', 
		exam_date date NOT NULL, 
		start_time time NOT NULL, 
		end_time time NOT NULL
	); 
-- course id is <= 6 char, auto increment has to be the primary key

	CREATE TABLE cwsl( 
		course_id varchar(6) NOT NULL DEFAULT 'BT101',  
		serial_number int NOT NULL, 
		roll_number int NOT NULL DEFAULT 150101003, 
		name varchar(255) NOT NULL DEFAULT 'ABHISHEK KUMAR', 
		email varchar(255) NOT NULL DEFAULT 'abhk.cse',
		PRIMARY KEY(course_id, roll_number)
	); 
-- 255 characters enough for storing name and email serial number is unique and primary key

source /home/abhi/CS345/Assignment 6/150101003_cc.sql;
source /home/abhi/CS345/Assignment 6/150101003_cwsl.sql;
source /home/abhi/CS345/Assignment 6/150101003_ett.sql;

