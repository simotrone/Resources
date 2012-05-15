package Trone::Resources::Tuple;

use Carp;

use overload '""' => sub {
        my ($self) = @_;
        my $str = '['. join(',', $self->values) .']'
                .' '.(sprintf "μ: %5.2f", $self->avg)
                .' '.(sprintf "σ: %5.2f", $self->sigma)
        ;
        return $str;
};

 
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


1;
