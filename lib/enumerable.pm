package enumerable;
# ABSTRACT: Yet Another Enum Generator

use strict;
use warnings;

use Scalar::Util ();
use Sub::Util    ();
use MOP          ();

use enumerable::enumeration;

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
    my ($class, $caller, $name, @args) = @_;

    my $enum;
    if ( scalar @args == 1 && ref $args[0] eq 'HASH' ) {
        $enum = +{ %{ $args[0] } };
    }
    else {
        my $idx = 0;
        $enum = +{ map { $_ => ++$idx } @args };
    }

    my $enumeration = MOP::Class->new( join '::' => __PACKAGE__, $caller, $name );
    $enumeration->set_superclasses('enumerable::enumeration');
    $enumeration->add_method( get_name => sub { $name } );

    foreach my $key ( keys %$enum ) {
        $enum->{ $key } = Scalar::Util::dualvar( $enum->{ $key }, $key );
        $enumeration->add_method( $key, sub { $enum->{ $key } });
    }

    bless $enum => $enumeration->name;

    {
        no strict 'refs';
        *{$caller.'::'.$name} = sub { $enum };
    }

    $PACKAGE_TO_ENUM{ $caller } //= {};
    $PACKAGE_TO_ENUM{ $caller }->{ $name } = $enum;
}

## ...

sub get_enum_for {
    my ($pkg, $type) = @_;
    return unless exists $PACKAGE_TO_ENUM{ $pkg }
               && exists $PACKAGE_TO_ENUM{ $pkg }->{ $type };
    return $PACKAGE_TO_ENUM{ $pkg }->{ $type };
}

1;

__END__

=pod

=head1 DESCRIPTION

=cut
