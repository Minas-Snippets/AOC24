#!/usr/bin/perl

our @a;

while(<>) {
    chomp;
    push @a, $_
}

our $n = @a;

my $sum = 0;
$sum += search_xmas($_) for (0..7);

print $sum;

sub search_xmas {
    my $rot = shift;
    my $s = 0;
    for my $i (0 .. $n - 1) {
        for (0 .. $n - 1) {
            $s++ if get_str($i, $_, $rot) eq 'XMAS'
        }
    }
    return $s
}

sub a_get {
    substr($a[$_[0]],$_[1],1)
}

sub rot_ind {
    my ($i, $j, $rot) = @_;
    return ( [$i, $j], [$i,   $j+1], [$i,   $j+2], [$i,   $j+3] ) if $rot == 0 && $j < $n - 3;
    return ( [$i, $j], [$i+1, $j+1], [$i+2, $j+2], [$i+3, $j+3] ) if $rot == 1 && $j < $n - 3 && $i < $n - 3;
    return ( [$i, $j], [$i+1, $j  ], [$i+2, $j  ], [$i+3, $j  ] ) if $rot == 2 && $i < $n - 3;
    return ( [$i, $j], [$i+1, $j-1], [$i+2, $j-2], [$i+3, $j-3] ) if $rot == 3 && $j > 2      && $i < $n - 3;
    return ( [$i, $j], [$i,   $j-1], [$i,   $j-2], [$i,   $j-3] ) if $rot == 4 && $j > 2;
    return ( [$i, $j], [$i-1, $j-1], [$i-2, $j-2], [$i-3, $j-3] ) if $rot == 5 && $i > 2      && $j > 2;
    return ( [$i, $j], [$i-1, $j  ], [$i-2, $j  ], [$i-3, $j  ] ) if $rot == 6 && $i > 2;
    return ( [$i, $j], [$i-1, $j+1], [$i-2, $j+2], [$i-3, $j+3] ) if $rot == 7 && $j < $n - 3 && $i > 2;
    return ( )
}

sub get_str {
    my $s = '';
    $s .= a_get($_->[0],$_->[1]) for rot_ind(@_);
    return $s
}
