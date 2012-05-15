#!/usr/bin/perl

# Contribution from oha (feel the objects!)

use strict;
use warnings;
use feature "switch";
use FindBin;
use lib "$FindBin::Bin/lib";
use Trone::Resources::Manager::Equation3;

################
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

my @weights = (1,3,9);

my ($x, $y, $z, $total) = (0, 0, 0, 0);

given (scalar @ARGV) {
        when(1) {
                $total = $ARGV[0];
        }
        when(3) {
                ($x,$y,$z) = @ARGV;
                $total = ($weights[0] * $x) + ($weights[1] * $y) + ($weights[2] * $z);
        }
        default { usage(); }
}

my $m = Trone::Resources::Manager::Equation3->new(
        weights => [@weights],
        total   => $total
)->compute();


print "Total resources: ", $m->total,"\n";
print "Found Triplette: ", scalar $m->list->tuples ,"\n";

my $list = $m->list;

printf("min: %d\n", $list->maxmin);
my @selected = sort {$a->sigma <=> $b->sigma } grep { ($_->sort)[0] == $list->maxmin } $list->by_min;
print "$_\n" for @selected;




__END__

$ perl resources.pl 150 112 39

Total resources: 837
Found Triplette: 13207
                             per Sigma	                    per 1° minimo [64]
           [66,65,64] σ: 0.82 μ: 65.00	           [66,65,64] σ: 0.82 μ: 65.00
           [63,63,65] σ: 0.94 μ: 63.67	           [69,64,64] σ: 2.36 μ: 65.67
           [63,66,64] σ: 1.25 μ: 64.33	                                        
           [66,62,65] σ: 1.70 μ: 64.33	                                        
           [66,68,63] σ: 2.05 μ: 65.67	                                        
