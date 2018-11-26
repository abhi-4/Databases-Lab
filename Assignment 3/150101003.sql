	CREATE TABLE ett( 
		course_id varchar(6) NOT NULL DEFAULT 'CS101', 
		exam_date date NOT NULL, 
		start_time time NOT NULL, 
		end_time time NOT NULL, 
		PRIMARY KEY( course_id, exam_date, start_time ) 
	); 
-- course id is <= 6 char exam date course id and start time make primary key

	CREATE TABLE cc( 
		course_id varchar(6) PRIMARY KEY DEFAULT 'CS101', 
		number_of_credits tinyint DEFAULT 6 NOT NULL, 
		check (credits <=  8)
	); 
-- COURSE ID UNIQUE SO IT IS KEY AND TINYINT ENOUGH FOR CREDITS

	CREATE TABLE cwsl( 
		cid varchar(6) NOT NULL DEFAULT 'BT101',  
		serial_number int PRIMARY KEY, 
		roll_number int NOT NULL DEFAULT 150101003, 
		name varchar(255) NOT NULL DEFAULT 'ABHISHEK KUMAR', 
		email varchar(255) NOT NULL DEFAULT 'abhk.cse' 
	); 
-- 255 characters enough for storing name and email serial number is unique and primary key

	CREATE TEMPORARY TABLE ett_temp( course_id varchar(6) NOT NULL DEFAULT 'CS101', 
		exam_date date NOT NULL, 
		start_time time NOT NULL, 
		end_time time NOT NULL, 
		PRIMARY KEY( course_id, exam_date, start_time ) 
	); 
-- course id is <= 6 char exam date course id and start time make primary key

	CREATE TEMPORARY TABLE cc_temp( 
		course_id varchar(6) PRIMARY KEY DEFAULT 'CS101', 
		number_of_credits tinyint DEFAULT 6 NOT NULL, 
		check (credits <=  8)
	); 
-- COURSE ID UNIQUE SO IT IS KEY AND TINYINT ENOUGH FOR CREDITS

	CREATE TEMPORARY TABLE cwsl_temp( 
		cid varchar(6) NOT NULL DEFAULT 'BT101',  
		serial_number int PRIMARY KEY, 
		roll_number int NOT NULL DEFAULT 150101003, 
		name varchar(255) NOT NULL DEFAULT 'ABHISHEK KUMAR', 
		email varchar(255) NOT NULL DEFAULT 'abhk.cse' 
	); 
-- 255 characters enough for storing name and email serial number is unique and primary key

	CREATE TABLE ett_clone LIKE ett; -- make new table ett_clone from ett
	CREATE TABLE cc_clone LIKE cc;
	CREATE TABLE cswl_clone LIKE cswl;
	SOURCE 150101003_cc.sql;
	SOURCE 150101003_ett.sql;
	SOURCE 150101003_cwsl.sql;

