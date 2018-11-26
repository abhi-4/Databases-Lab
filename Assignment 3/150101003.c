#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <dirent.h>
#include <unistd.h>


void printcswl();
void printett();
void printcc();

int main(){

	printett();
	printcc();
	printcswl();

	return 0;
}

void printcswl(){

	DIR * directory;//it stores course-wise-student-list
	DIR * department;//it stores department
	struct dirent *entry;
	char * base = "database-19-jan-2018/course-wise-students-list/";
	char filepath[100];
	strcpy(filepath, base);
	char dirpath[100];
	strcpy(dirpath, base);
	FILE * cswl = fopen("150101003_cwsl.sql", "w");
	int serial = 1;

	if(!(directory=opendir("database-19-jan-2018/course-wise-students-list"))){//opening directory course-wise-student-list
		
		printf("Can't open directory\n");
		return ;
	}

	while ((entry = readdir(directory)) != NULL){//reading directory till null
	 	
	 	if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) // checking for directory to be parent or the same directory
        	continue;

       	strcpy(dirpath, base);//resetting filepath of directory
       	strcat(dirpath, entry->d_name);//setting filepath to the directory of department


        if(!(department=opendir(dirpath))){//opening directory corresponding to department

        	printf("Can't open department\n");
        	return ;
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
        	char email[100];
        	//FILE * output = fopen("output.csv", "w+");


        	while(fscanf(fp, "%[^,]s", temp)!= EOF){//taking id till the end of file

        		fscanf(fp, "%c", &temp[0]);//escaping comma

        		fscanf(fp, "%[^,]s", rolln); // taking roll number

        		fscanf(fp, "%c", &temp[0]);//escaping space
        		fscanf(fp, "%[^,]s", name);//taking input name
        		fscanf(fp, "%c", &temp[0]);//escaping space
        		fscanf(fp, "%[^\n]s", email);

        		
        		fprintf(cswl, "INSERT INTO cwsl VALUES('%s', '%d', '%s', '%s', '%s');\n", filename, serial, rolln, name, email);
        		serial ++;
        		
        		
        		fscanf(fp, "%c", &temp[0]);//escaping newline

        	}
        	fclose(fp);
        }	
	}
}

void printett(){


	FILE * fp = fopen("database-19-jan-2018/exam-time-table.csv", "r");
	char  temporary[100]="a";
	char subject[10];
	char  date[20] = "a";
	char  time[10] = "d";
	char time2[10] = "e";

	FILE * ett = fopen("150101003_ett.sql", "w");

	while(fscanf(fp, "%[^,]s", subject)!=EOF){//find the subject in the file

		fscanf(fp, "%c", temporary);//skip the space

		fscanf(fp, "%[^,]s", date);//get the date of exam
		fscanf(fp, "%c", temporary);//skip the space
		fscanf(fp, "%[^,]s", time);//start time of the exam
		fscanf(fp, "%c", temporary);//skip the space
		fscanf(fp, "%[^\n]s", time2);//start time of the exam
		
		fprintf(ett, "INSERT INTO ett VALUES('%s', '%s', '%s:00', '%s:00');\n", subject, date, time, time2);
				
		//fscanf(fp, "%[^\n]s", temporary);//move to the end of the line
		fscanf(fp, "%c", temporary);//skip newline
	}
}

void printcc(){

	int value = 0;
	char temporary[10]= "a";
	char subject[10] = "b";
	FILE * cc = fopen("150101003_cc.sql", "w");
	FILE * fp = fopen("database-19-jan-2018/course-credits.csv", "r");

	while(fscanf(fp, "%[^,]s", subject)!=EOF){//find the subject in the course-credits.csv file
		//printf("%s ", temporary);
		fscanf(fp, "%c", temporary);

		fscanf(fp, "%d", &value);//get the credit value of the course
		
		fprintf(cc, "INSERT INTO cc VALUES('%s', '%d');\n", subject, value);
		fscanf(fp, "%c", temporary);
	}

}