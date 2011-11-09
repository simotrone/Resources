#!/usr/bin/perl

# Rearrangement using objects
# Contribution from oha (many thanks)

use strict;
use warnings;
use feature "switch";

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

# Scelgo i primi 5 valori con deviazione standard più bassa
my @better_sigma   = (sort { $a->sigma <=> $b->sigma } @triplete)[0..4];

# Scelgo solo le triplette con il primo coefficiente minimo più alto rispetto
my @ordered_by_fst_min = sort { ($b->mins)[0] <=> ($a->mins)[0] } @triplete;
my $higher_min         = ($ordered_by_fst_min[0]->mins)[0];
my @better_fst_mins    = sort { ($a->mins)[2] <=> ($b->mins)[2] } grep { ($_->mins)[0] == $higher_min } @triplete;


my $i;
my $num = ( @better_sigma > @better_fst_mins ) ? scalar(@better_sigma) : scalar(@better_fst_mins);
printf("%40s\t%40s\n", 'per Sigma', "per 1° minimo [$higher_min]" );
for ($i = 0; $i < $num; ++$i) {
	printf("%40s\t%40s\n", $better_sigma[$i] || '' , $better_fst_mins[$i] || '' );
}



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


################
package Tripleta;

use Carp;

use overload
	'""' => sub {
		my ($self) = @_;
		my $str = '['. join(',', $self->values) .']'
			.' '.(sprintf "σ: %.2f", $self->sigma)
			.' '.(sprintf "μ: %.2f", $self->avg)
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

# Mins (minimal values)
# get @mins = $t->mins()
sub mins {
	my ($self) = @_;
	return $self->{C}->{mins} //= do {
		my @ordered = sort { $a <=> $b } $self->values;
		return @ordered;
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
