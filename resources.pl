#!/usr/bin/perl

# Rearrangement using objects
# Contribution from oha (many thanks)

use strict;
use warnings;
use feature "switch";

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
my $N = $total;

for($z = 0; $z <= ($N / 9); $z++) {
        for($y = 0; $y <= ($N / 3); $y++) {
                $x = $N - (3 * $y) - (9 * $z);
                next if ($x < 0);
		my $t = Tripleta->new(1,3,9);
		$t->values($x,$y,$z);
                push @triplete, $t;
        }
}

print "Total resources: $total\n";
print "Found Triplette: ", scalar(@triplete) ,"\n";

my $list = ListT->new();
$list->tuples(@triplete);

# Scelgo i primi 5 valori con deviazione standard più bassa
#my @better_sigma   = (sort { $a->sigma <=> $b->sigma } @triplete)[0..4];
my @better_sigma   = ($list->by_sigma)[0..4];

# Scelgo solo le triplette con il primo coefficiente minimo più alto rispetto
my @sorted_triplete = sort { ($b->sort)[0] <=> ($a->sort)[0] } @triplete;
my $higher_min      = ($sorted_triplete[0]->sort)[0];
my @better_fst_mins = sort { ($a->sort)[2] <=> ($b->sort)[2] } grep { ($_->sort)[0] == $higher_min } @triplete;


my $i;
my $num = ( @better_sigma > @better_fst_mins ) ? scalar(@better_sigma) : scalar(@better_fst_mins);
printf("%40s   %40s\n", 'per Sigma', "per 1° minimo [$higher_min]" );
for ($i = 0; $i < $num; ++$i) {
	printf("%40s   %40s\n", $better_sigma[$i] || '' , $better_fst_mins[$i] || '' );
}




package ListT;

sub new {
	my ($class) = @_;
	bless {
		T => [],
		C => {},
	}, $class;
}

sub tuples {
	my ($self, @tuples) = @_;
	if(@tuples) {
		$self->{T} = [@tuples];
		$self->{C} = {};
	}
	return @{$self->{T}};
}

sub by_sigma {
	my ($self) = @_;
	return $self->{C}->{sigma} //= do {
		my @sigma_sorted = sort { $a->sigma <=> $b->sigma } @{$self->{T}};
		return @sigma_sorted;
	}
}


################
package Tripleta;

use Carp;

use overload
	'""' => sub {
		my ($self) = @_;
		my $str = '['. join(',', $self->values) .']'
			.' '.(sprintf "σ: %5.2f", $self->sigma)
			.' '.(sprintf "μ: %5.2f", $self->avg)
		;
		return $str;
	};

# Constructor
# my $t = Triplete->new( weight0, weight1, weight2 );
sub new {
	my ($class, @weights) = @_;
	croak "We need weights at creation" unless scalar(@weights) > 0;
	bless {
		W => [@weights],		# Weights
		V => [map {0} @weights],	# Values
		C => {},			# Cache
	}, $class;
}

# set $t->values(1,2,3);
# get @values = $t->values()
sub values {
	my ($self, @values) = @_;
	if(@values) {
		croak "Wrong array length" unless scalar(@values) == $self->size;
		$self->{V} = [@values];
		$self->{C} = {};		# Change values => empty cache
	}
	return @{$self->{V}};
}

# get $size = $t->size() from weights (see new())
sub size {
	my ($self) = @_;
	return scalar @{$self->{W}};
}

# Average
# get $avg = $t->avg()
sub avg {
	my ($self) = @_;
	return $self->{C}->{avg} //= do {
		my $sum = 0;
		$sum += $_ for $self->values;
		$sum / $self->size;
	};
}

# Standard deviation
# http://mathworld.wolfram.com/StandardDeviation.html
# get $sigma = $t->sigma()
sub sigma {
	my ($self) = @_;
	return $self->{C}->{sigma} //= do {
		my $sum = 0;
		my $avg = $self->avg;
		$sum += ($_ - $avg)**2 for $self->values;
		sqrt($sum / $self->size);
	};
}

# Weight (total)
# get $weigth = $t->weigth()
sub weight {
	my ($self) = @_;
	return $self->{C}->{weight} //= do {
		my $sum = 0;
		my @weigths = @{$self->{W}};
		$sum += $_ * shift(@weigths) for $self->values;
		$sum;
	};
}

# Sort (ascending order)
# get @sorted = $t->sort()
sub sort {
	my ($self) = @_;
	return $self->{C}->{sort} //= do {
		my @sorted = sort { $a <=> $b } $self->values;
		return @sorted;
	};
}

# Clone
#
sub clone {
	my ($self) = @_;
	my $n = __PACKAGE__->new(@{$self->{W}});
	$n->values(@{$self->{V}});
	return $n;
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
