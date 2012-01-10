#include <error.h>
#include <stdlib.h>
#include <stdio.h>

#include "tuple.h"

long tuples_count_3w  (int tot);
long calc_loop_3w     (Tuple * T, int tot, int slot, int * weights);
void tuple_management (Tuple * T, int slot, int * w, int * v);

static int _cmpsortmin (const void * p0, const void * p1) {
        Tuple t[2] = {
                * (Tuple *) p0,
                * (Tuple *) p1
        };

        /* ordina per minimo */
        if (t[0].sorted[0] < t[1].sorted[0])
		return -1;
	if (t[0].sorted[0] > t[1].sorted[0])
		return 1;
        
        /* ordina per sigma a parità di minimo */
        if (t[0].sigma < t[1].sigma)
                return -1;
        if (t[0].sigma > t[1].sigma)
                return 1;

	return 0;
}



int main (int argc, char * argv[]) {
	int w[]  = {1,3,9};     /* Meglio che il primo peso sia 1 (evita i resti) */
	const int slot = sizeof(w)/sizeof(w[0]);
	int v[slot];            /* Era v[slot]; malloc? */
	int i, tot, min;
        long pre_c, count;
        char buffer[64];
        Tuple * tuples;

	if (argc -1 < slot)
		error(1,0, "We need %d values for tuple",slot);

        tot = 0;
	for (i=0; i < slot; i++) {
		v[i] = atoi(argv[i+1]);
		tot += (w[i] * v[i]);
	}

	printf("Tuple sizeof: %ld B\n", sizeof(Tuple));

        _print_array(buffer,w,slot,"Pesi",1,0); 
	printf("Tot risorse: %d\t %s\n", tot, buffer);

	pre_c = tuples_count_3w(tot);
	printf("Tuple pre-calcolate:  %ld\n", pre_c);

        count = sizeof(*tuples) * pre_c; /* Total bytes to allocate */
        if ((tuples = malloc(count)) == NULL)
                error(1,0, "Malloc problem [size: %ld]", count);
	printf("Tuples sizeof: %ld B\n", count);

	count = calc_loop_3w(tuples,tot,slot,w);
	printf("Tuple post-calcolate: %ld\n", count);
	
	/* Ordinamento */
	qsort(tuples, pre_c, sizeof(*tuples), _cmpsortmin);
	min = tuples[pre_c-1].sorted[0];
	printf("min: %d\n",min);
	
	for (i=0; i < pre_c; i++)
		if (tuples[i].sorted[0] == min)
			print_tuple(tuples+i);

        free(tuples);
	return 0;
}

void tuple_management (Tuple * T, int slot, int * w, int * v) {
	new(T, w, slot);
	set_values(T, v);
	set_calc(T);
	/* print_tuple(T); */
}

/* Loop di calcolo:
 * w[0]*v[0] + w[1]*v[1] + ... + w[n]*v[n] = tot
 * v[0] = 1/w[0] * (tot - w[1]*v[1] - w[2]*v[2] - ... - w[n]*v[n])
 */
long calc_loop_3w (Tuple * T, int tot, int slot, int * w) {
	int v[3]; /* alloc dinamico con slot? */
	long count = 0;

	for (v[2]=0; v[2] <= (tot / w[2]); v[2]++)
		for (v[1]=0; v[1] <= (tot / w[1]); v[1]++) {
			v[0] = (1/w[0]) * (tot - (w[1] * v[1]) - (w[2] * v[2]));
			if (v[0] < 0)
				continue;

			tuple_management(&T[count], slot, w, v);
			count++;
		}
	return count;
}

long calc_loop_2w (Tuple * T, int tot, int slot, int * w) {
	int v[2];
	long count = 0;

	for (v[1]=0; v[1] <= (tot / w[1]); v[1]++) {
		v[0] = (1/w[0]) * (tot - (w[1] * v[1]));
		if (v[0] < 0)
			continue;

		tuple_management(&T[count],slot, w, v);
		count++;
	}
	return count;
}

/* Questa funziona per 3 pesi (1,3,9) */
/*             n (n+1)
 * Gauss: Σ = ---------  (calcola la somma di n numeri consecutivi)
 *               2     
 * moltiplica * 1/3 per avere il numero di tuple.
 *
 *     totale
 * n = ------ + 2
 *       3
 */
long tuples_count_3w (int tot) {
	long n = (tot * 1/3) +2;
	long gauss = n * (n +1) * 1/2;
	return gauss * 1/3;
}

/* per 2 pesi */
long tuples_count_2w (int tot,int * w) {
	long n = (tot * w[0] / w[1]) +1;
	return n;
}

