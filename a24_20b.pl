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
my @jumps = jumps();

for my $i (0 .. @path/2 - 1) {
    my ($x,$y) = ($path[2*$i],$path[2*$i+1]);
    for (@jumps) {
        my ($leap, $jx, $jy) = @$_;
        my ($v,$w) = ($x + $jx, $y + $jy);
        next unless $path{"$v|$w"};
        my $k = $path{"$v|$w"};
        next unless $k - $i > $leap;
        push(@cheats, $k - $i - $leap);
    }
}

my $n = 0;
for(@cheats) {
    $n++ if $_ > 99
}

print $n;

sub jumps {
    my @jumps;
    for my $leap_size (2 .. 20) {
        for my $h_jump (0 .. $leap_size) {
            my $v_jump = $leap_size - $h_jump;
            if($h_jump && $v_jump) {
                push(@jumps,
                    [$leap_size, -$h_jump, -$v_jump],
                    [$leap_size, -$h_jump,  $v_jump],
                    [$leap_size,  $h_jump, -$v_jump],
                    [$leap_size,  $h_jump,  $v_jump])
            }
            unless($h_jump) {
                push(@jumps,
                    [$leap_size, 0, -$v_jump],
                    [$leap_size, 0,  $v_jump])
            }
            unless($v_jump) {
                push(@jumps,
                    [$leap_size, -$h_jump, 0],
                    [$leap_size,  $h_jump, 0])
            }
        }
    }
    return @jumps
}
