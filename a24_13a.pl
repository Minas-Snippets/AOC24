#!/usr/bin/perl

my @equations;

while(<>) {
    m/A:\D+(\d+)\D+(\d+)/ and push @equations,[ $1, $2 ];
    m/B:\D+(\d+)\D+(\d+)/ and push @{$equations[-1]}, $1, $2;
    m/P\D+(\d+)\D+(\d+)/ and push @{$equations[-1]}, $1, $2;
}

my $sum = 0;

for my $e ( @equations ) {
    my ($a1,$a2,$b1,$b2,$c1,$c2) = @$e;
    my ($p, $q) = ($b2*$c1 - $b1*$c2, $a1*$b2 - $b1*$a2);
    next unless $q;
    next if $p % $q;
    my $a = $p/$q;
    next unless $b2;
    $c2 -= $a*$a2;
    next if $c2 % $b2;
    my $b = $c2/$b2;
    next if $a > 100 || $b > 100;
    $sum += 3*$a + $b;
}

print "$sum\n";
