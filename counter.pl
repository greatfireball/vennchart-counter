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

print STDERR "Working on files: ", join(",", @input), "\n";

my $count = 1;
foreach my $file (@input)
{
    print STDERR "Starting with '$file'\n";

    open(FH, "<", $file) || die "$!\n";
    while (<FH>)
    {
	chomp;
	my @fields = split("\t", $_);
	for (my $i=$fields[1]; $i<$fields[2]; $i++)
	{
	    my $key = join("-|-", ($fields[0], $fields[5], $i));
	    if ((exists $overlapper{$key}) && ($overlapper{$key} & $count))
	    {
		print STDERR "Bit already set for line '$_'\n";
	    }
	    $overlapper{$key} = $overlapper{$key} | $count;
	}
    }
    close(FH);
    $count = $count*2;

    print STDERR "Finished '$file'\n";
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
