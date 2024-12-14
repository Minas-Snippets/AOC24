#!/usr/bin/perl

# Call this program with command line parameters in this order:
# InputFileName NumberOfColumns NumberOfRows NumberOfIterations

our ($f, $m, $n, $k) = @ARGV;

my @q = (0,0,0,0);

open(my $infile,'<',$f);
while(<$infile>){
    m/p=(\d+),(\d+)\s+v=(-?\d+),(-?\d+)/ or next;
    my ($x,$y,$v,$w) = ($1,$2,$3,$4);
    $x = ($x + $k*$v) % $m;
    $y = ($y + $k*$w) % $n;
    ($x == ($m-1)/2) || ($y == ($n-1)/2) and next;
    my $q = 0;
    $x > ($m-1)/2 and $q++;
    $y > ($n-1)/2 and $q += 2;
    $q[$q]++;
}
close($infile);

my $prod = $q[0];
$prod *= $q[$_] for 1..3;
print "part 1: $prod\n";
