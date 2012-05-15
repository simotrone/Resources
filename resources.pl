#!/usr/bin/perl

# Contribution from oha (feel the objects!)

use strict;
use warnings;
use feature "switch";
use Getopt::Long;
use FindBin;
use lib "$FindBin::Bin/lib";
use Trone::Resources::Manager::Equation3;

my $help = 0;
my $weights = '';
my $values = '';
my $res = GetOptions(
        'help'      => \$help,
        'weights=s' => \$weights,
        'values=s'  => \$values,
);

my @weights = split /,/, $weights;
usage() if (!$res or $help or @weights < 2);
# continue if @weights > 1

my $total = 0;
if ($values) {
        # if values are setted
        my @values = split /,/, $values;
        usage() if (@values != @weights);
        map { $total += $values[$_] * $weights[$_] } 0 .. $#values;
} elsif (@ARGV == 1) {
        # if argv holds just one total
        $total = $ARGV[0];
} elsif (@ARGV > 1) {
        # if argv holds the right number of args
        usage() if (@ARGV != @weights);
        map { $total += $ARGV[$_] * $weights[$_] } 0 .. $#ARGV;
} else {
        usage();
}

# compute!

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

exit 0;

sub usage {
        print <<EOH;
Usage: $0 -w 1,3,9 [options] {<total>|<q1> <q2> <q3>}

        -w | --weights a,b,..,n   weights for every coefficient

        <total>                   one integer as sum of quantities
        <q1> .. <qn>              single quantities

        Options:
        -v | --values a,b,..,n    quantities as <q1> .. <qn>
        -h | --help               show this help
EOH
        exit(0);
}

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
