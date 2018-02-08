#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//--------------------This solution is easier to understand ----------------------------------

void OutputFile(char * roll, int present, int classes, FILE * less, FILE * more);

int main(){

	FILE * fp = fopen("database_12jan2017.csv", "r");
	FILE * less = fopen("L75.txt", "w");
	FILE * more = fopen("G75.txt", "w");

	char roll1[10];
	fscanf(fp, "%[^,]s", roll1);//taking input roll1
	char roll2[10];
	fseek(fp, 0, SEEK_SET);//moving to the start of the file

	int present = 0;
	int classes = 0;
	char temp[100];
	char c;

	while(1){

		if(fscanf(fp, "%[^,]s", roll2) == EOF)
			break;

		if(strcmp(roll1, roll2)){

			OutputFile(roll1, present, classes, less, more);//print output to file
			strcpy(roll1, roll2);//setting new roll number
			classes = 0;//resetting data
			present = 0;
		}

		fscanf(fp, "%[^\n]s", temp);//taking input rest of the line

		if(temp[14] == 'P')//if present
			present ++;
		classes ++; // one class per line

		fscanf(fp, "%c", &c);//skipping newline character
	}

	OutputFile(roll1, present, classes, less, more);
	fclose(fp);
	fclose(more);
	fclose(less);

	return 0;
}

void OutputFile(char * roll, int present, int classes, FILE * less, FILE * more){

	float percent = ((float)present/(float)classes)*100;
	FILE * tmp;

	if(percent < 75)
		tmp = less;
	else
		tmp = more;

	fprintf(tmp, "%s,\t%d,\t%.3f\n", roll, present, percent);

	return;
}