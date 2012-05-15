package Trone::Resources::TuplesList;

use Carp;


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
	my ($self) = shift;
	return $self->{C}->{sigma} //= do {
		my @sigma_sorted = sort { $a->sigma <=> $b->sigma } $self->tuples;
		return @sigma_sorted;
	}
}

sub by_min {
        my ($self) = shift;
        return $self->{C}->{minsort} //= do {
                my @min_sorted = sort { ($b->sort)[0] <=> ($a->sort)[0] } $self->tuples;
                $self->{C}->{maxmin} = ($min_sorted[0]->sort)[0];
                return @min_sorted;
        }
}

sub maxmin {
        my ($self) = shift;
        return $self->{C}->{maxmin} //= do {
                $self->by_min;
                return $self->{C}->{maxmin};
        }
}

1;
