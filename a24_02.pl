#!/usr/bin/perl

my @s = (0, 0);

while(<>) {
    chomp;
    my @l = split /\s+/;
    $s[0] += f(@l);
    my ($r, $n) = (0, @l);
    $r |= f( (@l)[0..$_-1, $_+1..@l-1] ) for 0..@l-1;
    $s[1] += $r
}

print "without dampener: ".$s[0]." with dampener: ".$s[1];

sub f {
    my $d = $_[0] < $_[1] ? 1 : -1;
    for(1 .. @_-1) {
            my $c = $_[$_] - $_[$_-1];
            $c*$d <= 0 || abs($c) > 3 and return 0
    }
    return 1
}
