#!/usr/bin/perl

my @a, @b;

while(<>) {
    chomp;
    my ($x, $y) = split /\s+/;
    push(@a, $x);
    push(@b, $y);
}

my $s = 0;
@b = sort{ $a <=> $b } @b;

map{ $s += abs(shift(@b) - $_) } ( sort{ $a <=> $b } @a);

print $s
