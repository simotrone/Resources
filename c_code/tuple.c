#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <error.h>

#include "tuple.h"

enum newline { NONL, NL };
char separators[][2] = { "", "()", "[]", "{}" };

void new (Tuple * T, int * w, int slot) {
	int i;

	if (slot > MAXSLOT)
		error(1,0, "We can't have more than %d weights stored.", MAXSLOT);

	T->size = slot;

	for (i=0; i < slot; i++)
		T->weights[i] = *(w+i);
}

/* Vale la pena di passare lo slot? 
 * new() porta già in T->size il limite del loop */
void set_values (Tuple * T, int * v) {
	unsigned int i;
	for (i=0; i < T->size; i++)
		T->values[i] = *(v+i);
}

int _cmpvals (const void * val0, const void * val1) {
	int a = * (int *) val0;
	int b = * (int *) val1;
	if (a < b)
		return -1;
	if (a > b)
		return 1;
	return 0;
}

void sort_vals (Tuple * T) {
	unsigned int i;
	for (i=0; i < T->size; i++)
		T->sorted[i] = T->values[i];

	qsort(T->sorted, T->size, sizeof(T->sorted[0]), _cmpvals);
}

double _avg_calc (Tuple * T) {
	unsigned int i, sum = 0;
	for(i=0; i < T->size; i++)
		sum += T->values[i];

	return (float) sum / (float) T->size;
}

double _sigma_calc (Tuple * T) {
	unsigned int i;
	float sum = 0;
	double avg = _avg_calc(T);
	for (i=0; i < T->size; ++i)
		sum += pow( T->values[i] - avg , 2 );

	return sqrt( sum / T->size );
}

void set_calc (Tuple * T) {
	sort_vals(T);
	T->avg   = _avg_calc(T);
	T->sigma = _sigma_calc(T);
}

void _print_array (char * str, int * array, int size, char * label, short sep, short nl) {
	int i;
	char buff[64];
        *str = '\0';

	if (strlen(label) > 0) {
		sprintf(buff, "%s: ", label);
                strcat(str,buff);
        }

	if (sep > 0) {
		sprintf(buff, "%c", separators[sep][0]);
		strcat(str, buff);
	}

	for (i=0; i < size; i++) {
		sprintf(buff, "%d%s", array[i], (i+1 == size ? "":","));
		strcat(str, buff);
	}
	
	if (sep > 0) {
		sprintf(buff, "%c", separators[sep][1]);
		strcat(str, buff);
	}
	
	if (nl == NL) {
		sprintf(buff, "\n");
		strcat(str, buff);
	}
}

void print_tuple (Tuple *T) {
	char string[128];

	_print_array(string, T->values,  T->size, "", 2, NONL);

	printf("%s μ:%.2f σ:%.2f\n", string, T->avg, T->sigma);
}


