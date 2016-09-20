#!/usr/bin/perl

# csv2json
#
# (c) 2016 Piotr Roszatycki <dexter@debian.org>, GPL

=head1 SYNOPSIS

B<cvs2json> -h|--help

B<csv2json>
[-s I<separator>|--separator=I<separator>]
[-t|--tsv]
[I<input-file>
[I<output-file>]]

=head1 README

B<csv2json> converts CSV stream to JSON.

=cut


use strict;
use warnings;

use utf8;
use open ':utf8', ':std';

use JSON::PP ();
use Getopt::Long qw(GetOptions);

our $VERSION = 0.01;

my %opt = (
    separator => ',',
);

GetOptions(\%opt,
    "separator|s=s",
    "tsv|t",
    "help|h",
);

if ($opt{help}) {
    die "Usage: csv2json [OPTIONS] [<input file> [<output file>]]\n" .
        "\n" .
        "  -s <separator>, --separator=<separator>\n" .
        "    Field separator to use (default to comma “,”).\n" .
        "\n" .
        "  -t, --tsv\n" .
        "    Use tab as separator, overrides separator flag.\n" .
        "\n" .
        "  <input file>\n" .
        "    CSV file to read data from.\n" .
        "    If unspecified or a dash (“-”), use the standard input.\n" .
        "\n" .
        "  <output file>\n" .
        "    JSON file to write data to.\n" .
        "    If unspecified or a dash (“-”), use the standard output.\n" .
        "\n" .
        "csv2json $VERSION\n"
};

my $input = shift @ARGV;
my $output = shift @ARGV;

my ($fhin, $fhout);

if (defined $input and $input ne '-') {
    open $fhin, '<', $input or die "Can't open '$input' for reading: $!";
} else {
    $fhin = \*STDIN;
}

if (defined $output and $output ne '-') {
    open $fhout, '>', $output or die "Can't open '$output' for writing: $!";
} else {
    $fhout = \*STDOUT;
}

print $fhout "[\n" or die "Can't print: $!";

my ($json, $l, @h);

while (<$fhin>) {
    my @f;
    $l ++;

    chomp;

    if ($opt{tsv}) {
        @f = split /\t/;
    } else {
        @f = split /$opt{separator}/;
    }

    if ($l == 1) {
        @h = @f;
        my $i = 0;
        my %order = map { $_ => $i++ } @h;
        $json = JSON::PP->new->sort_by(sub { $order{$JSON::PP::a} <=> $order{$JSON::PP::b} });
    } else {
        if ($l > 2) {
            print $fhout ",\n" or die "Can't print: $!";
        }
        my %data;
        @data{@h} = @f;
        my $string = $json->encode(\%data);
        print $fhout $string, "\n" or die "Can't print: $!";
    }
}

print $fhout "]\n" or die "Can't print: $!";


__END__

=head1 OPTIONS

=over

=item -s I<separator>|--separator=I<separator>

Specify a field separator. Comma "C<,>"" is the default.

=item -t|--tsv

Specify TAB as a field separator.

=item I<input-file>

The input file name. C<STDIN> stream is the default.

=item I<output-file>

The output file name. C<STDOUT> stream is the default.

=back

=head1 PREREQUISITES

=over 2

=item *

L<JSON>

=back

=head1 SCRIPT CATEGORIES

Text_Processing/Filters

=head1 AUTHORS

Piotr Roszatycki <dexter@debian.org>

=head1 LICENSE

Copyright 2016 by Piotr Roszatycki <dexter@debian.org>.

Inspired by https://www.npmjs.com/package/csv2json by Julien Fontanet.

All rights reserved.  This program is free software; you can redistribute it
and/or modify it under the terms of the GNU General Public License, the
latest version.
