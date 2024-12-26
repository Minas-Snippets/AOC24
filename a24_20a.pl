#!/usr/bin/perl

our @a;
my ($s,$t,$e,$f); # start and finish positions
our $an = -1;

while(<>) {
    $an++;
    push(@a,[ ( 0 ) x length($_) ]);
    s/S/#/ and ($s,$t) = ( $an, $-[0] );
    s/E/#/ and ($e,$f) = ( $an, $-[0] );
    while(s/\./#/) {
        $a[$an]->[$-[0]] = -1
    }
}

# step 1 find the regular track.

my @path = ($s,$t);
my %path = ( "$s|$t" => 1 );

$a[$e]->[$f] = -1;
$a[$s]->[$t] =  0;

while($s != $e || $t != $f) {
    if($a[$s-1]->[$t] < 0) {
        $s--
    } elsif($a[$s+1]->[$t] < 0) {
        $s++
    } elsif($a[$s]->[$t-1] < 0) {
        $t--
    } else {
        $t++
    }
    push(@path,$s,$t);
    $path{"$s|$t"} = @path/2 - 1;
    $a[$s]->[$t]   = @path/2 - 1;
}

# step 2 find cheat points

my @cheats;

for my $i (0 .. @path/2 - 1) {
    my ($x,$y) = ($path[2*$i],$path[2*$i+1]);
    for my $j ([-2,0],[2,0],[0,-2],[0,2]) {
        my ($v,$w) = ($x + $j->[0], $y + $j->[1]);
        next unless $path{"$v|$w"};
        my $k = $path{"$v|$w"};
        next unless $k - $i > 2;
        push(@cheats, $k-$i -2);
        $cheats{$i} = $k - $i -2
    }
}

my $n = 0;
for(@cheats) {
    $n++ if $_ > 99
}

print $n;

sub ac {
    # array compare
    my ($a, $b) = @_;
    for(0 .. $#$a) {
        $a->[$_] != $b->[$_] and return 0
    }
    return 1
}
