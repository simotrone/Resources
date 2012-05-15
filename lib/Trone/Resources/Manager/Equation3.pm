package Trone::Resources::Manager::Equation3;

use base 'Trone::Resources::Manager';
use Carp;
use Trone::Resources::Tuple;

sub new {
        my ($class, %attr) = @_;

        my $self = $class->SUPER::new(%attr);
        return $self;
}

sub compute {
        my $self = shift;

        my ($x,$y,$z,@tuples);

        my @weights = $self->weights;
        my $N       = $self->total;

        croak "First weight can't be 0." if ($weights[0] == 0);
        
        for($z = 0; $z <= ($N / $weights[2]); $z++) {
        for($y = 0; $y <= ($N / $weights[1]); $y++) {
                # Equation: x * Wx + y * Wy + z * Wz = N
                $x = (1 / $weights[0]) * ($N - ($weights[1] * $y) - ($weights[2] * $z));
                next if ($x < 0);

                my $t = Trone::Resources::Tuple->new(@weights);
                $t->values($x,$y,$z);
                push @tuples, $t;
        }
        }

        my $list = $self->list;
        $list->tuples(@tuples);

        return $self;
}


3;
