#!/usr/bin/perl

my $time = time;
our @map;

push(@map, [ split // ]) while <>;

our $n = @map;

for my $part ( 0 .. 1 ) {
    my @trails = search(0);
    my %e;

    for my $e ( 1 .. 9 ) {
        my $k = @trails;
        my $i = 0;
        while($i < $k) {
            my ($x, $y, $p, $q) = (@{$trails[$i]})[-2,-1,0,1];
            for my $t (neighbours($e,$x,$y)) {
                my ($v, $w) = @$t;
                next if !$part && $e{$p}->{$q}{$v}{$w};
                $i++;
                $k++;
                unshift(@trails, []);
                push @{$trails[0]}, @{$trails[$i]};
                push(@{$trails[0]}, $v, $w);
                $e{$p}->{$q}{$v}{$w} = 1 unless $part
            }
            splice(@trails, $i, 1);
            $k--;
        }
    }

    print "part ".($part + 1).": ".@trails."\n";
}

sub search {
    my $k = shift;
    my @p;
    for my $i (0 .. $n-1) {
        $map[$i]->[$_] == $k and push(@p, [ $i, $_ ] ) for 0 .. $n-1
    }
    return @p
}

sub neighbours {
    my ($v, $x, $y) = @_;
    my @p;
    for my $t ( [ $x+1, $y ], [ $x-1, $y ], [ $x, $y+1 ], [ $x, $y-1 ] ) {
        my ($p, $q) = @$t;
        next if $p < 0;
        next if $p >= $n;
        next if $q >= $n;
        next if $q >= $n;
        next if $map[$p]->[$q] != $v;
        push(@p, [$p,$q])
    }
    return @p
}
