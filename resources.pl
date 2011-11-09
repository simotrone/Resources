#!/usr/bin/perl

# First version 

use strict;
use warnings;
use feature "switch";
use List::Util qw/min max/;
use List::MoreUtils qw/indexes/;

sub usage {
        print
                "Usage: $0 {<total>|<q1> <q2> <q3>}\n"
                ."Arguments:\n"
                ."\t<total>\n"
                ."\t\tor\n"
                ."\t<q1> <q2> <q3> are the 3 quantity that add up give total\n"
        ;

        exit(0);
}

my ($x, $y, $z, $total) = (0, 0, 0, 0);

given (scalar @ARGV) {
        when(1) {
                $total = $ARGV[0];
        }
        when(3) {
                ($x,$y,$z) = @ARGV;
                $total = ($x + (3*$y) + (9*$z));
        }
        default { usage(); }
}


my @triplete = ();      # contiene le triplette
my @mins = ();          # contiene i minimi di ogni tripletta (stesso index)
my $N = $total;

for($z = 0; $z <= ($N / 9); $z++) {
        for($y = 0; $y <= ($N / 3); $y++) {
                $x = $N - (3 * $y) - (9 * $z);
                next if ($x < 0);
                push @triplete, [$x,$y,$z];
                push @mins, min($x,$y,$z);
        }
}

# print triplete. :-P
# cut with N > 100 to avoid useless print flood
if( $N < 100 ) {
	for($z = 0; $z <= ($N / 9); $z++) {
	       map { print_tripleta($_); print " " } grep { $_->[2] eq $z } @triplete;
	       print "\n";
	}
}

print "Total resources: $total\n";
print "Triplette trovate: ", scalar(@triplete) ,"\n";

my $max_index = max(@mins);
my @better_indexes = indexes { $_ == $max_index } @mins;
my @better_triplete = @triplete[@better_indexes];

print "Indice migliore: $max_index\n";
foreach(@better_triplete) {
        print_tripleta($_);
        print "\n";
}

sub print_tripleta {
        my ($tripleta) = @_;
        my ($i,$j,$k) = @$tripleta;
        printf("[%2s,%2s,%2s]", $i, $j, $k);
}

__END__

Output:

$ perl resources.pl 837
$ perl resources.pl 150 112 39

Total resources: 837
Triplette trovate: 13207
Indice migliore: 64
[69,64,64]
[66,65,64]
