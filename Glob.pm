package Text::Glob;
use strict;
use Exporter;
use vars qw/$VERSION @ISA @EXPORT_OK/;
$VERSION = '0.02';
@ISA = 'Exporter';
@EXPORT_OK = qw( glob_to_regex match_glob );

sub glob_to_regex {
    my $glob = shift;
    my ($regex, $in_curlies, $escaping);
    local $_;
    for ($glob =~ m/(.)/g) {
        if    ($_ eq '.') {
            $regex .= "\\.";
        }
        elsif ($_ eq '(') {
            $regex .= "\\(";
        }
        elsif ($_ eq '*') {
            $regex .= $escaping ? "\\*" :  ".*";
        }
        elsif ($_ eq '?') {
            $regex .= $escaping ? "\\?" :  ".";
        }
        elsif ($_ eq '{') {
            $regex .= $escaping ? "\\{" : "(";
            $in_curlies = 1 if !$escaping;
        }
        elsif ($_ eq '}' && $in_curlies) {
            $regex .= $escaping ? "}" : ")";
            $in_curlies = 0 if !$escaping;
        }
        elsif ($_ eq ',' && $in_curlies) {
            $regex .= $escaping ? "," : "|";
        }
        elsif ($_ eq '\\') {
            $regex .= "\\\\";
            $escaping = 1;
            next;
        }
        else {
            $regex .= $_;
        }
        $escaping = 0;
    }
    #print "# $glob $regex\n";
    qr/^$regex$/;
}

sub match_glob {
    my $glob = shift;
    my $regex = glob_to_regex $glob;
    local $_;
    grep { $_ =~ $regex } @_;
}

1;
__END__

=head1 NAME

Text::Glob - match globbing patterns against text

=head1 SYNOPSIS

 use Text::Glob qw( match_glob glob_to_regex );

 print "matched\n" if match_glob( "foo.*", "foo.bar" );

 # prints foo.bar and foo.baz
 my $regex = glob_to_regex( "foo.*" );
 for ( qw( foo.bar foo.baz foo bar ) ) {
     print "matched: $_\n" if /$regex/;
 }

=head1 DESCRIPTION

Text::Glob implements glob(3) style matching that can be used to match
against text, rather than fetching names from a filesystem.  If you
want to do full file globbing use the File::Glob module instead.

=head2 Routines

=over

=item match_glob( $glob, @things_to_test )

Returns the list of things which match the glob from the source list.

=item glob_to_regex( $glob )

Returns a compiled regex which is the equiavlent of the globbing
pattern.

=back

=head1 BUGS

The code uses qr// to produce compiled regexes, therefore this module
requires perl version 5.005_03 or newer.

=head1 AUTHOR

Richard Clamp <richardc@unixbeard.net>

=head1 COPYRIGHT

Copyright (C) 2002 Richard Clamp.  All Rights Reserved.

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 SEE ALSO

L<File::Glob>, glob(3)

=cut
