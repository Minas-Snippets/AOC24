#!/usr/bin/perl

our @map;

push(@map, [ split // ]) while <>;

our $n = @map;

for my $part ( 0 .. 1 ) {
    my @trails = search(0);
    my %e;

    for my $e ( 1 .. 9 ) {
        my $k = @trails;
        my @e = search($e);
        my $i = 0;
        while($i < $k) {
            my ($x, $y, $p, $q) = (@{$trails[$i]})[-2,-1,0,1];
            for my $test (@e) {
                my ($v, $w) = @$test;
                next if !$part && $e{$p}->{$q}{$v}{$w};
                abs($x - $v) + abs($y - $w) == 1 or next;
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
