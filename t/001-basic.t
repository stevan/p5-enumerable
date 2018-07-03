#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok('enumerable');
}

package Foo {
    use strict;
    use warnings;

    use enumerable Gorch => qw[ BAR BAZ ];
}

subtest '... checking array version' => sub {
    can_ok('Foo', 'BAR');
    can_ok('Foo', 'BAZ');

    my $bar = Foo->BAR;
    my $baz = Foo->BAZ;

    is($bar+0, 1, '... got the expected numeric value for BAR');
    is($bar.'', 'BAR', '... got the expected string value for BAR');

    is($baz+0, 2, '... got the expected numeric value for BAZ');
    is($baz.'', 'BAZ', '... got the expected string value for BAZ');

    my %enum = enumerable::get_enum_for( Foo => 'Gorch' );
    is(scalar keys %enum, 2, '... got the expected number of keys in the enum');

    is($enum{BAR}, $bar, '... got the same value back');
    is($enum{BAZ}, $baz, '... got the same value back');

    ok(enumerable::has_value_for( Foo => 'Gorch', 'BAR' ), '... we have the value expected');
    ok(enumerable::has_value_for( Foo => 'Gorch', 'BAZ' ), '... we have the value expected');
    ok(!enumerable::has_value_for( Foo => 'Gorch', 'FOO' ), '... we do not have the value expected');

    is(enumerable::get_value_for( Foo => 'Gorch', 'BAR' ), $bar, '... got the same value back');
    is(enumerable::get_value_for( Foo => 'Gorch', 'BAZ' ), $baz, '... got the same value back');

    is_deeply(
        [ sort { $a cmp $b } enumerable::get_keys_for( Foo => 'Gorch' ) ],
        [qw[ BAR BAZ ]],
        '... got the keys expected'
    );

    is_deeply(
        [ sort { $a <=> $b } map 0+$_, enumerable::get_values_for( Foo => 'Gorch' ) ],
        [ 1, 2 ],
        '... got the values expected'
    );
};

package Foo::Bar {
    use strict;
    use warnings;

    use enumerable Gorch => { BAR => 10, BAZ => 20 };
}

subtest '... checking hash version' => sub {
    can_ok('Foo::Bar', 'BAR');
    can_ok('Foo::Bar', 'BAZ');

    my $bar = Foo::Bar->BAR;
    my $baz = Foo::Bar->BAZ;

    is($bar+0, 10, '... got the expected numeric value for BAR');
    is($bar.'', 'BAR', '... got the expected string value for BAR');

    is($baz+0, 20, '... got the expected numeric value for BAZ');
    is($baz.'', 'BAZ', '... got the expected string value for BAZ');
};

done_testing;
