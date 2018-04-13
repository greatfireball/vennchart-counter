#!/usr/bin/env perl

use strict;
use warnings;

use Getopt::Long;

my @input = ();
my %overlapper = ();

GetOptions(
    'i=s@' => \@input
    );

@input = split(",", (join(",", @input)));

my $count = 1;
foreach my $file (@input)
{
    open(FH, "<", $file) || die "$!\n";
    chomp;
    my @fields = split("\t", $_);
    for (my $i=$fields[1]; $i<$fields[2]; $i++)
    {
	my $key = join("-|-", ($fields[0], $i));
	$overlapper{$key}+=$count;
    }
    close(FH);
    $count = $count*2;
}

my %counts = ();
foreach my $key (keys %overlapper)
{
    $counts{$overlapper{$key}}++;
}

foreach my $count (sort {$a <=> $b} (keys %counts))
{
    printf "%0".(int(@input))."b\t%d\n", $count, $counts{$count}; 
}
