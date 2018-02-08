#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <dirent.h>
#include <unistd.h>


typedef struct node1{//student structure
	char roll[10];
	char name[100];
	struct node1* nextStudent;
	struct node2* subject;

}student;

typedef struct node2{//subject structure
	char code[6];
	struct node2 * nextsubject;
	struct node3 * exam;
}course;

typedef struct node3{//exam dates
	char date[15];
	char time[10];
	struct node3 * nextdate;

}timetable;


struct node1 * newStudent();
struct node2 * newSubject();
struct node3 * newTimetable();
void makeEntry(student * root, char * studentname, char * rollnumber, char * coursecode);
void store_schedule(course * root, char * date, char * time);
void checkExceedingCredit(student * root);
void checkExamTimeClash(student * root);
void fixExamTime(student * root);



int main(){

	student * root = newStudent();//root of the student list
	DIR * directory;//it stores course-wise-student-list
	DIR * department;//it stores department
	struct dirent *entry;
	char * base = "database-19-jan-2018/course-wise-students-list/";
	char filepath[100];
	strcpy(filepath, base);
	char dirpath[100];
	strcpy(dirpath, base);

	if(!(directory=opendir("database-19-jan-2018/course-wise-students-list"))){//opening directory course-wise-student-list
		
		printf("Can't open directory\n");
		return 0;
	}

	while ((entry = readdir(directory)) != NULL){//reading directory till null
	 	
	 	if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) // checking for directory to be parent or the same directory
        	continue;

       	strcpy(dirpath, base);//resetting filepath of directory
       	strcat(dirpath, entry->d_name);//setting filepath to the directory of department


        if(!(department=opendir(dirpath))){//opening directory corresponding to department

        	printf("Can't open department\n");
        	return 0;
        }

        struct dirent * file;//stores courses in department
        while((file = readdir(department)) != NULL){//reading files

        	if (strcmp(file->d_name, ".") == 0 || strcmp(file->d_name, "..") == 0) // checking for directory to be parent or the same directory
        		continue;

        	strcpy(filepath, dirpath);
        	strcat(filepath, "/");
        	strcat(filepath, file->d_name);//setting file path to the course file
        	char filename[10];// stores the course code
        	strcpy(filename,file->d_name);
        	
        	int i;
        	for(i=0; i<7; i++)//removing .csv from the end to get filename
        		if(filename[i]=='.')
        			filename[i] = '\0';

        	FILE * fp = fopen(filepath, "r");//open the file corresponding to course filename
        	char rolln[10];
        	char temp[100];
        	char name[100];
        	//FILE * output = fopen("output.csv", "w+");


        	while(fscanf(fp, "%[^,]s", temp)!= EOF){//taking id till the end of file

        		fscanf(fp, "%c", &temp[0]);//escaping comma

        		fscanf(fp, "%[^,]s", rolln); // taking roll number

        		fscanf(fp, "%c", &temp[0]);//escaping space
        		fscanf(fp, "%[^,]s", name);//taking input name

        		makeEntry(root, name, rolln, filename);//it stores the details of student with courses in the linked list
        		fscanf(fp, "%[^\n]s", temp);
        		fscanf(fp, "%c", &temp[0]);//escaping newline

        	}
        	fclose(fp);

        }	
	}

	printf("All files read\n");//confirmation message of reading all files and storing in data structure

	checkExceedingCredit(root);
	fixExamTime(root);
	checkExamTimeClash(root);

	printf("All processing done\n");

	return 0;	
}

struct node1 * newStudent(){//defining a new student
	
	student * new = (student *)malloc(sizeof(student));
	new->roll[10] = '0';
	new->name[100] = '*';
	new->nextStudent = NULL;
	new->subject = NULL;
	return new;
}

struct node2 * newSubject(){//defining a new course

	course * new = (course *)malloc(sizeof(course));
	new->code[6] = '*';
	new->nextsubject = NULL;
	return new;
}

struct node3 * newTimetable(){//defining new time of exam

	timetable * new = (timetable *)malloc(sizeof(timetable));
	new->date[15] = '0';
	new->time[10] = '0';
	new->nextdate = NULL;
	return new;
}

void makeEntry(student * root, char * studentname, char * rollnumber, char * coursecode){

	//printf("%s\t%s\n", rollnumber, coursecode);

	while(root->nextStudent!= NULL && strcmp(root->roll,rollnumber))
		root= root->nextStudent;

	if(!strcmp(root->roll,rollnumber)){

		course * temp = root->subject;

		while(temp->nextsubject!=NULL)
			temp = temp->nextsubject;

		temp->nextsubject = newSubject();
		temp = temp->nextsubject;
		strcpy(temp->code, coursecode);

		return;
	}

	root->nextStudent = newStudent();
	root = root->nextStudent;
	strcpy(root->name, studentname);
	strcpy(root->roll, rollnumber);
	root->subject = newSubject();
	strcpy(root->subject->code, coursecode);

	return;
	
}

void checkExceedingCredit(student * root){

	course * temp;
	int credits = 0;
	int value;
	char temporary[10]= "a";

	FILE * g40 = fopen("g40.csv", "w");//output file for students having greater than 40 credits
	FILE * fp = fopen("database-19-jan-2018/course-credits.csv", "r");
	
	while(root->nextStudent!=NULL){//for all students
		
		credits = 0;
		root= root->nextStudent;
		//printf( "%s, %s, ", root->name, root->roll);

		temp = root->subject;

		while(temp!=NULL){//for all subjects of the student

			//printf("%s, ", temp->code);
			fseek(fp, 0, SEEK_SET);
			while(fscanf(fp, "%[^,]s", temporary)!=EOF){//find the subject in the course-credits.csv file
				//printf("%s ", temporary);
				if(!strcmp(temporary, temp->code)){
					fscanf(fp, "%c", temporary);

					fscanf(fp, "%d", &value);//get the credit value of the course
					credits +=value;//update total credits
					break;
					
				}
				else{//else move to next line
					fscanf(fp, "%[^\n]s", temporary);
					fscanf(fp, "%c", temporary);

				}
				
			}

			temp = temp->nextsubject;//move to next subject
		}
		if(credits > 40){
			fprintf(g40, "%s, %s, %d\n", root->roll, root->name, credits);
		}
		//printf( "%d\n", credits);
	}
}

void fixExamTime(student * root){

	FILE * fp = fopen("database-19-jan-2018/exam-time-table.csv", "r");
	course * temp;
	char  temporary[100]="a";
	char  date[20] = "a";
	char  time[10] = "d";

	while(root->nextStudent!=NULL){

		root = root->nextStudent;
		temp = root->subject;
		//printf("%s\n", root->roll);

		while(temp!= NULL){

			fseek(fp, 0, SEEK_SET);//move to start of the file
			

			while(fscanf(fp, "%[^,]s", temporary)!=EOF){//find the subject in the file

				if(!strcmp(temporary, temp->code)){
					fscanf(fp, "%c", temporary);//skip the space

					fscanf(fp, "%[^,]s", date);//get the date of exam
					fscanf(fp, "%c", temporary);//skip the space
					fscanf(fp, "%[^,]s", time);//start time of the exam
					//printf("\t%s, %s, %s\n", temp->code, date, time);

					store_schedule(temp, date, time);
				
					
				}
				
				fscanf(fp, "%[^\n]s", temporary);//move to the end of the line
				fscanf(fp, "%c", temporary);//skip newline
			}

			temp = temp->nextsubject;
		}
		//printf("\n\n");
	}
}

void checkExamTimeClash(student * root){

	course * temp1;
	course * temp2;

	FILE * clash = fopen("exam-time-table-clash.csv", "w");

	while(root->nextStudent!=NULL){

		root = root->nextStudent;
		temp1 = root->subject;

		while(temp1!=NULL){

			temp2 = temp1->nextsubject;
			while(temp2!=NULL){

				timetable * day1 = temp1->exam;
				timetable * day2 = temp2->exam;

				while(day1 != NULL){

					while(day2!= NULL){

						if(!strcmp(day1->date, day2->date) && !strcmp(day1->time, day2->time)){

							fprintf(clash, "%s, %s, %s, %s\n", root->roll, root->name, temp1->code, temp2->code);
						}

						day2 = day2->nextdate;
					}
					day1 = day1->nextdate;
				}

				temp2 = temp2->nextsubject;
			}

			temp1 = temp1->nextsubject;
		}
	}
	return;
}

void store_schedule(course * root, char * date, char * time){

	timetable * temp;
	if(root->exam == NULL){
		root->exam = newTimetable();
		temp = root->exam;

		strcpy(temp->date, date);
		strcpy(temp->time, time);
		return;
	}

	while(temp->nextdate!= NULL)
		temp=temp->nextdate;

	temp->nextdate = newTimetable();
	temp = temp->nextdate;
	strcpy(temp->date, date);
	strcpy(temp->time, time);



}
