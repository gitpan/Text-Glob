#!perl -w
use strict;
use Test::More tests => 17;

BEGIN { use_ok('Text::Glob', qw( glob_to_regex match_glob ) ) }

my $regex = glob_to_regex( 'foo' );
is( ref $regex, 'Regexp', "glob_to_regex hands back a regex" );
ok( 'foo'    =~ $regex, "matched foo" );
ok( 'foobar' !~ $regex, "didn't match foobar" );

ok(  match_glob( 'foo', 'foo'      ), "absolute string" );
ok( !match_glob( 'foo', 'foobar'   ) );

ok(  match_glob( 'foo.*', 'foo.'     ), "* wildcard" );
ok(  match_glob( 'foo.*', 'foo.bar'  ) );
ok( !match_glob( 'foo.*', 'gfoo.bar' ) );

ok(  match_glob( 'foo.?p', 'foo.cp' ), "? wildcard" );
ok( !match_glob( 'foo.?p', 'foo.cd' ) );

ok(  match_glob( 'foo.{c,h}', 'foo.h' ), ".{alternation,or,something}" );
ok(  match_glob( 'foo.{c,h}', 'foo.c' ) );
ok( !match_glob( 'foo.{c,h}', 'foo.o' ) );

ok(  match_glob( 'foo.\\{c,h}\\*', 'foo.\\{c,h}\\*' ), "\\escaping" );
ok( !match_glob( 'foo.\\{c,h}\\*', 'foo.c' ) );

ok(  match_glob( 'foo.(bar)', 'foo.(bar)'), "escape ()" );
