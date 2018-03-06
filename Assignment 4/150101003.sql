	
	CREATE TABLE Course( 
		course_id varchar(10) NOT NULL DEFAULT 'CS101' , 
		division ENUM('I', 'II', 'III', 'IV', 'NA') NOT NULL DEFAULT 'NA', 
		PRIMARY KEY(course_id, division)
	);
/*course id is <= 6 char and is the unique identifier, division contains at most two characters*/


	CREATE TABLE Department( 
		department_id varchar(6) PRIMARY KEY NOT NULL DEFAULT 'CSE', 
		name varchar(100) NOT NULL DEFAULT 'Computer Science and Engineering'
	);
/*department id is <= 3 char and is the unique identifier */ 



	CREATE TABLE Slot( 
		letter ENUM('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'A1', 'B1', 'C1', 'D1', 'E1') NOT NULL DEFAULT 'A' , 
		day ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'), 
		start_time time NOT NULL, 
		end_time time NOT NULL, 
		PRIMARY KEY (letter, day)
	);
/*letter contains at most 2 characters and letter and day together makes primary key*/

	CREATE TABLE Room( 
		room_number varchar(20) PRIMARY KEY NOT NULL DEFAULT '1001', 
		location ENUM('Core-I', 'Core-II', 'Core-III', 'Core-IV', 'LH', 'Local') NOT NULL DEFAULT 'CORE-I'
	); 
/*room number is not always number so varchar used and location given in the set are < 10 characters*/

	CREATE TABLE ScheduledIn(
		course_id varchar(10) NOT NULL DEFAULT 'CS101',
		division ENUM('I', 'II', 'III', 'IV', 'NA') NOT NULL DEFAULT 'NA',
		department_id varchar(6) NOT NULL DEFAULT 'CSE',
		letter ENUM('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'A1', 'B1', 'C1', 'D1', 'E1') NOT NULL DEFAULT 'A' , 
		day ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'), 
		room_number varchar(20) NOT NULL DEFAULT '1001' , 
		PRIMARY KEY ( room_number, letter, day),
		FOREIGN KEY (room_number) REFERENCES Room (room_number)  ON DELETE RESTRICT ON UPDATE CASCADE,
		FOREIGN KEY (letter, day) REFERENCES Slot (letter, day) ON DELETE RESTRICT ON UPDATE CASCADE,
		FOREIGN KEY (course_id, division) REFERENCES Course (course_id, division) ON DELETE RESTRICT ON UPDATE CASCADE,
		FOREIGN KEY (department_id) REFERENCES Department (department_id)  ON DELETE RESTRICT ON UPDATE CASCADE
	);
/* in one room in one slot in one day only one schedule possible so it is taken as primary key
all the values are referenced in other tables and updation will update it there too*/
