#!/usr/bin/perl

my @a, %b;

while(<>) {
    chomp;
    my ($x, $y) = split /\s+/;
    push(@a, $x);
    $b{$y}++
}

my $s = 0;
map{ $s += $_ * $b{$_} } @a;

print $s
