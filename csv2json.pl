#!/usr/bin/perl

use strict;
use warnings;

use JSON::PP ();
use Getopt::Long;

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
        $json = JSON::PP->new->ascii->sort_by(sub { $order{$JSON::PP::a} <=> $order{$JSON::PP::b} });
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
