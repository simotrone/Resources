#define MAXSLOT 10
/* E' possibile definire MAXSLOT dinamicamente? */

typedef struct tuple_s {
	int weights[MAXSLOT];
	int values[MAXSLOT];

	unsigned int size;
	double avg;
	double sigma;
	int sorted[MAXSLOT];
} Tuple;

void new        (Tuple *, int * weights, int size);
void set_values (Tuple *, int * values);

void sort_vals  (Tuple *);
void set_calc   (Tuple *);

void print_tuple (Tuple *);
void _print_array (char *, int *, int, char *, short, short);
