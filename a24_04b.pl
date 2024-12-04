#!/usr/bin/perl

our @a;

while(<>) {
    chomp;
    push @a, $_
}

our $n = @a;

my $sum = 0;

for my $rot (1,3, 5, 7) {
    for my $i (0 .. $n - 1) {
        for (0 .. $n - 1) {
            $sum++ if get_str($i, $_, $rot) eq 'MAS' && get_str(alt_c($i, $_, $rot)) eq 'MAS'
        }
    }
}

print $sum;

sub a_get {
    substr($a[$_[0]],$_[1],1)
}

sub rot_ind {
    my ($i, $j, $rot) = @_;
    return ($j > $n - 3 || $i > $n - 3 ) ? ( ) : ( [$i, $j], [$i+1, $j+1], [$i+2, $j+2] ) if $rot == 1;
    return ($j < 2      || $i > $n - 3 ) ? ( ) : ( [$i, $j], [$i+1, $j-1], [$i+2, $j-2] ) if $rot == 3;
    return ($i < 2      || $j < 2      ) ? ( ) : ( [$i, $j], [$i-1, $j-1], [$i-2, $j-2] ) if $rot == 5;
    return ($j > $n - 3 || $i < 2      ) ? ( ) : ( [$i, $j], [$i-1, $j+1], [$i-2, $j+2] ) if $rot == 7;
}

sub alt_c {
    my ($i, $j, $rot) = @_;
    return ( $i    , $j + 2, 3 ) if $rot == 1;
    return ( $i + 2, $j    , 5 ) if $rot == 3;
    return ( $i    , $j - 2, 7 ) if $rot == 5;
    return ( $i - 2, $j   , 1  ) if $rot == 7;
}

sub get_str {
    my $s = '';
    $s .= a_get($_->[0],$_->[1]) for rot_ind(@_);
    return $s
}
