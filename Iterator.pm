
package LinkedList::Iterator;

use 5.006;
use strict;
use warnings;
use warnings FATAL => 'all';

use overload '++'        => \&incr,
             '--'        => \&decr,
             'fallback'  => 1;

sub new {
    my $class    = shift;
    my $iter     = {
        PARENT   => shift,
        CURRENT  => shift,
    };
    bless $iter, $class;
    return $iter;
}
sub parent {                   
    my $self = shift;
    return $self->{PARENT};
}
sub current {                   
    my $self = shift;
    if ( @_ ) { $self->{CURRENT} = shift; }
    return $self->{CURRENT};
}
sub incr {
    my $self = shift;
    $self->{CURRENT} =
        LinkedList::Iterator->new(
            $self->{PARENT}, $self->next )->{CURRENT};
}
sub decr {
    my $self = shift;
    $self->{CURRENT} =
        LinkedList::Iterator->new(
            $self->{PARENT}, $self->prev )->{CURRENT};
}
sub next {
    my $self = shift;
    if ( $self->{CURRENT} == $self->{PARENT}{TAIL} )
        { die "Attempt to advance past end." }
    return $self->{CURRENT}{NEXT};
}
sub prev {
    my $self = shift;
    if ( $self->{CURRENT} == $self->{PARENT}{HEAD} )
        { die "Attempt to advance past begin." }
    my $targNode = $self->{CURRENT};
    my $current = $self->{PARENT}{HEAD};
    while ( $current->{NEXT} != $targNode ) {
        $current = $current->{NEXT};
    }
    return $current;
}

sub to_string {
    my $self = shift;
    return $self->{CURRENT}->{DATA};
}

1;
