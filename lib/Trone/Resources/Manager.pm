package Trone::Resources::Manager;

use strict;
use warnings;
use Carp;
use Trone::Resources::TuplesList;

sub new {
        my ($class, %attr) = @_;

        my @W = @{$attr{weights}};
        my $N = $attr{total};
        croak __PACKAGE__." need at least 2 weights." if (@W < 2);
        croak __PACKAGE__." need a total value > 0."  if ($N < 1);

        bless {
                W    => [@W],
                N    => $N,
                list => Trone::Resources::TuplesList->new()
        }, $class;
}

sub weights {
        my $self = shift;
        return @{$self->{W}};
}

sub total {
        my $self = shift;
        return $self->{N};
}

sub list {
        my $self = shift;
        return $self->{list};
}

1;
