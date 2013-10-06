
package LinkedList::Single;

use 5.006;
use strict;
use warnings FATAL => 'all';

sub new {
    my ( $class, $ref_list ) = @_;
    my $list  = {
        HEAD => undef,
        TAIL => undef,
        SIZE => 0,
    };
    bless $list, $class;
    $list->_init($ref_list) if $ref_list;
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

sub _init {
    my ( $self, $list ) = @_;
    $self->push_back($_) for @$list;
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

sub to_string {
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

sub to_string_refs {
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
1;    # End of LinkedList::Single

=head1 NAME

LinkedList::Single - The great new LinkedList::Single!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use LinkedList::Single;

    my $foo = LinkedList::Single->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 function1

=cut

sub function1 {
}

=head2 function2

=cut

sub function2 {
}

=head1 AUTHOR

Scorpion, C<< <myScorpCode at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-linkedlist-single at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=LinkedList-Single>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc LinkedList::Single


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=LinkedList-Single>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/LinkedList-Single>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/LinkedList-Single>

=item * Search CPAN

L<http://search.cpan.org/dist/LinkedList-Single/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2013 3dfxScorpion.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

