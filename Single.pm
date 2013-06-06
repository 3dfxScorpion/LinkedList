
package LinkedList::Single;

use 5.008008;
use strict;
use warnings;

sub new {
    my $class = shift;
    my $list  = {
        HEAD => undef,
        TAIL => undef,
        SIZE => 0,
    };
    bless $list, $class;
    return $list;

    package LinkedList::Single::Node;

    sub new {
        my $class = shift;
        my $node  = {
            DATA => shift,
            NEXT => undef,
        };
        bless $node, $class;
        return $node;
    }

    sub data {
        my $self = shift;
        if (@_) { $self->{DATA} = shift; }
        return $self->{DATA};
    }

    sub next {
        my $self = shift;
        if (@_) { $self->{NEXT} = shift; }
        return $self->{NEXT};
    }
}

sub size {
    my $self = shift;
    return $self->{SIZE};
}

sub front {
    my $self = shift;
    return $self->{HEAD}{DATA};
}

sub back {
    my $self = shift;
    return $self->{TAIL}{DATA};
}

sub begin {
    my $self = shift;
    return $self->{HEAD};
}

sub end {
    my $self = shift;
    return $self->{TAIL};
}

sub empty {
    my $self = shift;
    return ( $self->{SIZE} == 0 );
}

sub push_front {
    my ( $self, $data ) = @_;
    my $newNode = LinkedList::Single::Node->new($data);
    if ( $self->{SIZE} == 0 ) {
        $newNode->{NEXT} = undef;
        $self->{HEAD}    = $newNode;
        $self->{TAIL}    = $newNode;
        ++$self->{SIZE};
        return;
    }
    $newNode->{NEXT} = $self->{HEAD};
    $self->{HEAD}    = $newNode;
    ++$self->{SIZE};
    return;
}

sub push_back {
    my ( $self, $data ) = @_;
    if ( $self->{SIZE} == 0 ) {
        $self->push_front($data);
        return;
    }
    my $newNode = LinkedList::Single::Node->new($data);
    $newNode->{NEXT}    = undef;
    $self->{TAIL}{NEXT} = $newNode;
    $self->{TAIL}       = $newNode;
    ++$self->{SIZE};
    return;
}

sub pop_front {
    my $self = shift;
    if ( $self->{SIZE} == 0 ) { return; }
    if ( $self->{HEAD}{NEXT} == undef ) {
        $self->{HEAD} = undef;
        $self->{TAIL} = undef;
        --$self->{SIZE};
        return;
    }
    my $currNode = $self->{HEAD};
    $self->{HEAD} = $currNode->{NEXT};
    $currNode = undef;
    --$self->{SIZE};
    return;
}

sub pop_back {
    my $self = shift;
    if ( $self->{SIZE} == 0 ) { return; }
    if ( $self->{HEAD}{NEXT} == undef ) {
        $self->pop_front();
        return;
    }
    my $currNode = $self->{HEAD};
    while ( $currNode->{NEXT}{NEXT} != undef ) {
        $currNode = $currNode->{NEXT};
    }
    $currNode->{NEXT} = undef;
    $self->{TAIL}     = $currNode;
    --$self->{SIZE};
    return;
}

sub insert {
    my ( $self, $idx, $data ) = @_;
    my $pos = 1;
    if ( $idx < 0 ) { return; }
    if ( ( $idx == 0 ) || ( $self->{SIZE} == 0 ) ) {
        $self->push_front($data);
        return;
    }
    if ( $idx >= $self->{SIZE} ) {
        $self->push_back($data);
        return;
    }
    my $currNode = $self->{HEAD};
    while ( ( $pos < $idx ) && ( $currNode->{NEXT} ) ) {
        $currNode = $currNode->{NEXT};
        ++$pos;
    }
    my $newNode = LinkedList::Single::Node->new($data);
    $newNode->{NEXT}  = $currNode->{NEXT};
    $currNode->{NEXT} = $newNode;
    ++$self->{SIZE};
    return;
}

sub remove {
    my ( $self, $idx ) = @_;
    my $pos = 1;
    if ( $idx < 0 ) { return; }
    if ( $idx == 0 ) {
        $self->pop_front;
        return;
    }
    if ( $idx >= $self->{SIZE} ) {
        $self->pop_back;
        return;
    }
    my $currNode = $self->{HEAD};
    while ( ( $pos < $idx ) && ( $currNode->{NEXT} ) ) {
        $currNode = $currNode->{NEXT};
        ++$pos;
    }
    my $tempNode = $currNode->{NEXT};
    $currNode->{NEXT} = $currNode->{NEXT}{NEXT};
    $tempNode = undef;
    --$self->{SIZE};
    return;
}

sub find {
    my ( $self, $data ) = @_;
    if ( $self->{SIZE} == 0 ) {
        print "Empty\n";
        return;
    }
    my $pos      = 0;
    my $currNode = $self->{HEAD};
    if ( $currNode->{DATA} == $data ) { return $pos; }
    while ($currNode) {
        if ( $currNode->{DATA} == $data ) {
            return $pos;
        }
        $currNode = $currNode->{NEXT};
        ++$pos;
    }
    return -1;
}

sub displayList {
    my $self = shift;
    my @string;
    if ( $self->{SIZE} == 0 ) {
        return "Empty";
    }
    my $currNode = $self->{HEAD};
    while ($currNode) {
        push @string, $currNode->{DATA};
        $currNode = $currNode->{NEXT};
    }
    return "@string";
}

sub displayRefs {
    my $self = shift;
    my @string;
    if ( $self->{SIZE} == 0 ) {
        return "Empty";
    }
    my $currNode = $self->{HEAD};
    while ($currNode) {
        push @string, $currNode, "data:", $currNode->{DATA}, "\n";
        $currNode = $currNode->{NEXT};
    }
    return "@string";
}

sub DESTROY {
    my $self = shift;
    while ( $self->{HEAD} ) {
        my $currNode = $self->{HEAD};
        $self->{HEAD} = $self->{HEAD}{NEXT};
        $currNode = undef;
    }
    $self->{TAIL} = undef;
}
1;
