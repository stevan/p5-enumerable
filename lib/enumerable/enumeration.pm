package enumerable::enumeration;
# ABSTRACT: Yet Another Enum Generator

use strict;
use warnings;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

sub get_keys   {   keys %{ $_[0] } }
sub get_values { values %{ $_[0] } }

sub has_value_for { exists $_[0]->{ $_[1] } }
sub get_value_for {        $_[0]->{ $_[1] } }

1;

__END__

=pod

=head1 DESCRIPTION

=cut
