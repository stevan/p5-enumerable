package enumerable;
# ABSTRACT: Yet Another Enum Generator

use strict;
use warnings;

use Scalar::Util ();

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

# ...

our %PACKAGE_TO_ENUM;

sub import {
    my ($class, $type, @args) = @_;

    return unless $type && @args;

    die 'You must specify a name AND the values to enumerate'
        if $type && not @args;

    # get the caller ...
    my $caller = caller;
    # and call import_into ...
    $class->import_into( $caller, $type, @args );
}

sub import_into {
    my ($class, $caller, $type, @args) = @_;

    my %enum;
    if ( scalar @args == 1 && ref $args[0] eq 'HASH' ) {
        %enum = %{ $args[0] };
    }
    else {
        my $idx = 0;
        %enum = map { $_ => ++$idx } @args;
    }

    foreach my $key ( keys %enum ) {
        no strict 'refs';
        $enum{ $key } = Scalar::Util::dualvar( $enum{ $key }, $key );
        *{$caller.'::'.$key} = sub { $enum{ $key } };
    }

    $PACKAGE_TO_ENUM{ $caller } //= {};
    $PACKAGE_TO_ENUM{ $caller }->{ $type } = \%enum;
}

## ...

sub get_enum_for {
    my ($pkg, $type) = @_;
    return unless exists $PACKAGE_TO_ENUM{ $pkg }
               && exists $PACKAGE_TO_ENUM{ $pkg }->{ $type };
    return $PACKAGE_TO_ENUM{ $pkg }->{ $type }->%*;
}

sub get_value_for {
    my ($pkg, $type, $name) = @_;
    my %enum = get_enum_for( $pkg, $type );
    return $enum{ $name };
}

sub has_value_for {
    my ($pkg, $type, $name) = @_;
    my %enum = get_enum_for( $pkg, $type );
    return exists $enum{ $name };
}

sub get_keys_for   { my %enum = get_enum_for( $_[0], $_[1] ); keys   %enum }
sub get_values_for { my %enum = get_enum_for( $_[0], $_[1] ); values %enum }

1;

__END__

=pod

=head1 DESCRIPTION

=cut
