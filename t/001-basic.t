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
    my $bar = Foo->Gorch->BAR;
    my $baz = Foo->Gorch->BAZ;

    my $gorch = Foo->Gorch;
    isa_ok($gorch, 'enumerable::enumeration');
    can_ok($gorch, 'BAR');
    can_ok($gorch, 'BAZ');

    is($gorch->get_name, 'Gorch', '... got the expected name');

    is($bar+0, 1, '... got the expected numeric value for BAR');
    is($bar.'', 'BAR', '... got the expected string value for BAR');

    is($baz+0, 2, '... got the expected numeric value for BAZ');
    is($baz.'', 'BAZ', '... got the expected string value for BAZ');

    my $enum = enumerable::get_enum_for( Foo => 'Gorch' );
    is($enum, $gorch, '... these are the same objects');

    ok($enum->has_value_for('BAR'), '... we have a BAR value');
    ok($enum->has_value_for('BAZ'), '... we have a BAZ value');
    ok(!$enum->has_value_for('BOO'), '... we do not have a BOO value');

    is($enum->get_value_for('BAR'), 'BAR', '... we have a BAR value');
    is($enum->get_value_for('BAZ'), 'BAZ', '... we have a BAZ value');
    is($enum->get_value_for('BAR')+0, 1, '... we have a BAR value');
    is($enum->get_value_for('BAZ')+0, 2, '... we have a BAZ value');
    is($enum->get_value_for('BOO'), undef, '... we do not have a BOO value');

    is_deeply(
        [ sort { $a cmp $b } $gorch->get_keys ],
        [qw[ BAR BAZ ]],
        '... got the keys expected'
    );

    is_deeply(
        [ sort { $a <=> $b } map 0+$_, $gorch->get_values ],
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
    my $bar = Foo::Bar->Gorch->BAR;
    my $baz = Foo::Bar->Gorch->BAZ;

    my $gorch = Foo::Bar->Gorch;
    can_ok($gorch, 'BAR');
    can_ok($gorch, 'BAZ');

    is($bar+0, 10, '... got the expected numeric value for BAR');
    is($bar.'', 'BAR', '... got the expected string value for BAR');

    is($baz+0, 20, '... got the expected numeric value for BAZ');
    is($baz.'', 'BAZ', '... got the expected string value for BAZ');
};

done_testing;
